import csv
import subprocess
from typing import Any


class SWSession:
    def __init__(self, config, csv_path, func_type):
        self.config = config
        self.csv_path = csv_path
        self.func_type = func_type
        self.acc_record = None
        self.writer = None
        self.ref_acc = 0.0

        self._get_ref_acc()

    def _get_ref_acc(self):
        if self.func_type == 'Softmax':
            self.ref_acc = 0.00248932
        elif self.func_type == 'Tanh':
            self.ref_acc = 0.00547606
        elif self.func_type == 'Sigmoid':
            self.ref_acc = 0.00551215
        elif self.func_type == 'Swish':
            self.ref_acc = 0.00449607
        elif self.func_type == 'Elu':
            self.ref_acc = 0.00642902
        # elif self.func_type == 'Relu':
        #     self.ref_acc = 0.00390625  # 2^(-8)
        elif self.func_type == 'Gelu':
            self.ref_acc = 0.0051441
        elif self.func_type == 'Softplus':
            self.ref_acc = 0.0053893

    def reset(self) -> None:
        if self.acc_record:
            self.acc_record.close()
        self.acc_record = open(self.csv_path, 'w')
        self.writer = csv.writer(self.acc_record)
        self.writer.writerow(['iter_num', 'mae', 'aae', 'mse'])
        self.acc_record.flush()

    def finish(self) -> None:
        self.acc_record.close()

    def run(self, params: Any, iter_num: Any) -> Any:
        command = [self.config['sw_binary'], self.func_type]
        command.extend([str(params.bit_length), str(params.mini_length1), str(params.range_num1),
                        str(params.mini_length2), str(params.range_num2), str(params.k_bit_length),
                        str(params.b_bit_length)])
        proc = subprocess.check_output(command)
        line = proc.decode("utf-8").split('\n')[-2]
        mae = float(line.split(' ')[0])
        aae = float(line.split(' ')[1])
        mse = float(line.split(' ')[2])
        # check the mae
        # mae = max([mae, pow(2, -params.bit_length)])
        self.writer.writerow([iter_num, mae, aae, mse])
        self.acc_record.flush()
        return mae
