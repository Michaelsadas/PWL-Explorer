import csv
import subprocess
from math import ceil, log2
from typing import Any, List


# LUT/FF ratio
P = 30.0

# Long string
L = '0000000000000000'


class HWSession:
    def __init__(self, config, csv_path, func_type):
        self.config = config
        self.csv_path = csv_path
        self.func_type = func_type
        self.scala_path = None
        self.v_path = None
        self.clk_path = None
        self.tcl_path = None
        self.temp_path = None
        self.area = 0
        self.delay = 0
        self.pwr = 0
        self.lut = 0
        self.ff = 0
        self.dsp = 0
        self.bram = 0
        self.key_ori_list = []
        self.key_new_list = []
        self.ppa_record = None
        self.writer = None
        self.ref_delay = 0
        self.ref_area = 0
        self.prj_path = None
        self.xpr_path = None

        self._get_scala_path()
        self._get_v_path()
        self._get_clk_path()
        self._get_tcl_path()
        self._get_key()
        self._get_ref_ppa()
        self._update_clk()
        self._get_prj_path()
        self._get_xpr_path()

    def reset(self) -> None:
        if self.ppa_record:
            self.ppa_record.close()
        self.ppa_record = open(self.csv_path, 'w')
        self.writer = csv.writer(self.ppa_record)
        self.writer.writerow(['iter_num', 'delay', 'lut', 'ff', 'dsp', 'bram', 'pwr'])
        self.ppa_record.flush()

    def finish(self) -> None:
        self.ppa_record.close()

    def _get_ref_ppa(self) -> None:
        if self.func_type == 'Softmax':
            self.ref_delay = 2.866
            self.ref_area = 203 + 329 / P
        else:
            self.ref_delay = 2.355
            self.ref_area = 80 + 199 / P

    def _get_scala_path(self) -> None:
        self.scala_path = self.config['scala_path']

    def _get_v_path(self) -> None:
        self.v_path = self.config['v_path']

    def _get_clk_path(self) -> None:
        self.clk_path = self.config['clk_path']

    def _get_tcl_path(self) -> None:
        self.tcl_path = self.config['tcl_path']
        self.temp_path = self.config['temp_path']

    def _get_prj_path(self):
        self.prj_path = self.config['prj_path']

    def _get_xpr_path(self):
        self.xpr_path = self.config['xpr_path']

    def _get_key(self) -> None:
        self.key_ori_list = self.config['key_ori_list']
        self.key_new_list = self.config['key_new_list']

    def _update_scala(self, params: Any) -> None:
        # line_ori = linecache.getline(self.scala_path, 71)
        if self.func_type == 'Softmax':
            softmax_en = 'true'
        else:
            softmax_en = 'false'
        params_concat = ', '.join([softmax_en, str(params.pre_delay), str(params.compute_delay),
                                   str(params.axis_delay), str(params.add_delay), str(params.bit_length),
                                   str(params.mini_length1), str(params.range_num1), str(params.mini_length2),
                                   str(params.range_num2), str(params.k_bit_length), str(params.b_bit_length)])
        line_new = '  (new chisel3.stage.ChiselStage).emitVerilog(new top(' + params_concat + '), args)\n'
        fr = open(self.scala_path, 'r')
        lines = fr.readlines()
        lines[-2] = line_new
        fr.close()
        fw = open(self.scala_path, 'w')
        fw.writelines(lines)
        fw.close()

    def _update_ip(self) -> None:
        fv = open(self.v_path, 'r')
        v_content = fv.read()
        fv.close()
        for idx in range(len(self.key_ori_list)):
            v_content = v_content.replace(self.key_ori_list[idx], self.key_new_list[idx])

        fv = open(self.v_path, 'w')
        fv.write(v_content)
        fv.close()

    def _update_clk(self):
        f = open(self.clk_path, 'w')
        if self.func_type == 'Softmax':
            content = 'create_clock -period 2.900 -waveform {0.000 1.450} ' \
                      '[get_ports -filter { NAME =~ "*clock*" && DIRECTION == "IN" }]'
        else:
            content = 'create_clock -period 2.500 -waveform {0.000 1.250} ' \
                      '[get_ports -filter { NAME =~ "*clock*" && DIRECTION == "IN" }]'
        f.write(content)
        f.close()

    def _update_tcl(self, params: Any) -> None:
        # hardware params
        add_length = 4 + params.bit_length
        sub_length = 4 + params.bit_length
        add_constant = L[: add_length]
        sub_constant = L[: sub_length]
        k_total_length = 2 + params.k_bit_length
        b_total_length = 4 + params.b_bit_length
        bit_length = params.bit_length
        out_total_length = k_total_length + bit_length

        lut_depth = 16
        range_length1 = ceil(log2(params.range_num1))
        lut_width = 1 + range_length1 * pow(2, params.mini_length1 - 1)
        lut_1_depth = ceil(params.range_num1 / 16) * 16
        lut_1_width = k_total_length
        lut_2_depth = ceil(params.range_num1 / 16) * 16
        lut_2_width = b_total_length

        lut_3_depth = 16
        range_length2 = ceil(log2(params.range_num2))
        lut_3_width = 1 + range_length2 * pow(2, params.mini_length2 - 1)
        lut_4_depth = ceil(params.range_num2 / 16) * 16
        lut_4_width = k_total_length
        lut_5_depth = ceil(params.range_num2 / 16) * 16
        lut_5_width = b_total_length

        tcl = open(self.tcl_path, 'w')
        tcl.write('cd {}\n'.format(self.prj_path))
        tcl.write('open_project {}\n'.format(self.xpr_path))
        tcl.write('set_property -dict [list CONFIG.A_Width {{{}}} CONFIG.B_Width {{{}}} CONFIG.Out_Width {{{}}} '
                  'CONFIG.Latency {{{}}} CONFIG.B_Value {{{}}}] [get_ips ADD]\n'
                  .format(str(add_length), str(add_length), str(add_length), '1', add_constant))
        tcl.write('set_property -dict [list CONFIG.A_Width {{{}}} CONFIG.B_Width {{{}}} CONFIG.Out_Width {{{}}} '
                  'CONFIG.Latency {{{}}} CONFIG.B_Value {{{}}}] [get_ips SUB]\n'
                  .format(str(sub_length), str(sub_length), str(sub_length), '1', sub_constant))
        tcl.write('set_property -dict [list CONFIG.a_width {{{}}} CONFIG.b_width {{{}}} CONFIG.c_width {{{}}} '
                  'CONFIG.a_binarywidth {{{}}} CONFIG.b_binarywidth {{{}}} CONFIG.c_binarywidth {{{}}} '
                  'CONFIG.p_full_width {{{}}} CONFIG.p_width {{{}}} CONFIG.p_binarywidth {{{}}}] [get_ips DSP]\n'
                  .format(str(k_total_length), str(bit_length), str(out_total_length), '0', '0', '0',
                          str(out_total_length), str(out_total_length), str(out_total_length)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut]\n'
                  .format(str(lut_depth), str(lut_width)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut_1]\n'
                  .format(str(lut_1_depth), str(lut_1_width)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut_2]\n'
                  .format(str(lut_2_depth), str(lut_2_width)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut_3]\n'
                  .format(str(lut_3_depth), str(lut_3_width)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut_4]\n'
                  .format(str(lut_4_depth), str(lut_4_width)))
        tcl.write('set_property -dict [list CONFIG.depth {{{}}} CONFIG.data_width {{{}}}] [get_ips lut_5]\n'
                  .format(str(lut_5_depth), str(lut_5_width)))
        tp = open(self.temp_path, 'r')
        template = tp.read()
        tp.close()
        tcl.write(template)
        tcl.close()

    def _parse_timing_rpt(self) -> None:
        rpt = open(self.config['timing_rpt'], 'r')
        for line in rpt.readlines():
            if line.startswith('Slack'):
                slack = float(line.split(':')[-1].strip().split('ns')[0])
                if self.func_type == 'Softmax':
                    self.delay = 2.9 - slack
                else:
                    self.delay = 2.5 - slack
                break

    def _parse_util_rpt(self) -> None:
        rpt = open(self.config['util_rpt'], 'r')
        cnt = 0
        for line in rpt.readlines():
            if line.startswith('| Slice LUTs'):
                self.lut = int(line.split()[4])
                cnt += 1
            elif line.startswith('| Slice Registers            |'):
                self.ff = int(line.split()[4])
                cnt += 1
            elif line.startswith('| DSPs'):
                self.dsp = int(line.split()[3])
                cnt += 1
            elif line.startswith('| Block RAM Tile'):
                self.bram = int(line.split()[5])
                cnt += 1
            if cnt == 4:
                break

    def _parse_pwr_rpt(self) -> None:
        rpt = open(self.config['pwr_rpt'], 'r')
        for line in rpt.readlines():
            if line.startswith('| Total On-Chip Power (W)'):
                res = [i for i in line.split()]
                self.pwr = float(res[-2])
                break

    def run(self, params: Any, iter_num: Any) -> List[Any]:
        # update top.scala
        self._update_scala(params)
        # run sbt to generate new top.v
        # p1 = subprocess.Popen('cd ../NAF && ' + self.config['hw_execute'], shell=True)
        # p1.wait()
        p1 = subprocess.run('cd ../NAF && ' + self.config['hw_execute'], shell=True)
        if p1.returncode != 0:
            with open('./chisel.log', 'a') as tlog:
                tlog.write('Func: {}, Iteration: {}, Failed!\n'.format(self.func_type, str(iter_num)))
        # update top.v
        self._update_ip()
        # update vivado.tcl
        self._update_tcl(params)
        # run vivado to obtain timing and area
        p2 = subprocess.Popen('vivado -mode tcl -source ' + self.config['tcl_path'], shell=True)
        try:
            p2.wait(3600)
        except subprocess.TimeoutExpired:
            p2.terminate()
            print("[INFO] Subprocess timeout !")
            with open('./timeout.log', 'a') as tlog:
                tlog.write('Func: {}, Iteration: {}, Timeout!\n'.format(self.func_type, str(iter_num)))
        # parse ppa from timing/util/pwr.rpt
        self._parse_timing_rpt()
        self._parse_util_rpt()
        self._parse_pwr_rpt()
        # record ppa
        self.writer.writerow([iter_num, self.delay, self.lut, self.ff, self.dsp, self.bram, self.pwr])
        self.ppa_record.flush()
        self.area = self.lut + self.ff / P
        return [self.area, self.delay]
