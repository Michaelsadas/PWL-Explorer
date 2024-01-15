module Muxs(
  input         io_signal,
  input  [11:0] io_in1,
  input  [11:0] io_in2,
  output [11:0] io_out
);
  assign io_out = io_signal ? $signed(io_in1) : $signed(io_in2); // @[IP.scala 59:18]
endmodule
module unused2(
  input         clock,
  input  [11:0] io_adder_A,
  input  [11:0] io_adder_B,
  output [11:0] io_adder_S
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [11:0] out; // @[IP.scala 13:18]
  assign io_adder_S = out; // @[IP.scala 15:16]
  always @(posedge clock) begin
    out <= $signed(io_adder_A) + $signed(io_adder_B); // @[IP.scala 14:23]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  out = _RAND_0[11:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module unused3(
  input         clock,
  input  [11:0] io_suber_A,
  input  [11:0] io_suber_B,
  output [11:0] io_suber_S
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [11:0] out; // @[IP.scala 25:18]
  assign io_suber_S = out; // @[IP.scala 27:16]
  always @(posedge clock) begin
    out <= $signed(io_suber_A) - $signed(io_suber_B); // @[IP.scala 26:23]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  out = _RAND_0[11:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Softmax_pre(
  input         clock,
  input  [11:0] io_in,
  input  [2:0]  io_state,
  input  [11:0] io_add_res,
  input         io_last_in,
  input         io_max_first,
  input         io_max_en,
  input         io_rd_sum,
  input         io_rd_ln,
  output [11:0] io_out,
  output        io_last_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire  mux_io_signal; // @[softmax_pre.scala 31:21]
  wire [11:0] mux_io_in1; // @[softmax_pre.scala 31:21]
  wire [11:0] mux_io_in2; // @[softmax_pre.scala 31:21]
  wire [11:0] mux_io_out; // @[softmax_pre.scala 31:21]
  wire  add_clock; // @[softmax_pre.scala 37:21]
  wire [11:0] add_io_adder_A; // @[softmax_pre.scala 37:21]
  wire [11:0] add_io_adder_B; // @[softmax_pre.scala 37:21]
  wire [11:0] add_io_adder_S; // @[softmax_pre.scala 37:21]
  wire  sub_clock; // @[softmax_pre.scala 42:21]
  wire [11:0] sub_io_suber_A; // @[softmax_pre.scala 42:21]
  wire [11:0] sub_io_suber_B; // @[softmax_pre.scala 42:21]
  wire [11:0] sub_io_suber_S; // @[softmax_pre.scala 42:21]
  reg [11:0] max_reg; // @[softmax_pre.scala 22:22]
  reg [11:0] ln_reg; // @[softmax_pre.scala 23:21]
  wire [11:0] sub_res = sub_io_suber_S; // @[softmax_pre.scala 28:23 softmax_pre.scala 45:13]
  wire  _T_3 = ~io_in[11]; // @[softmax_pre.scala 47:47]
  wire [11:0] _T_6 = _T_3 ? 12'hfff : 12'h0; // @[softmax_pre.scala 47:71]
  wire [11:0] io_out_norm = $signed(io_in) ^ $signed(_T_6); // @[softmax_pre.scala 47:26]
  wire  _T_10 = io_state == 3'h3; // @[softmax_pre.scala 48:62]
  wire [11:0] _T_14 = $signed(io_in) - $signed(add_io_adder_S); // @[softmax_pre.scala 48:111]
  reg  r; // @[Reg.scala 15:16]
  reg  r_1; // @[Reg.scala 15:16]
  wire [11:0] max_pre = mux_io_out; // @[softmax_pre.scala 29:23 softmax_pre.scala 35:13]
  reg [11:0] r_2; // @[Reg.scala 15:16]
  reg  r_3; // @[Reg.scala 15:16]
  Muxs mux ( // @[softmax_pre.scala 31:21]
    .io_signal(mux_io_signal),
    .io_in1(mux_io_in1),
    .io_in2(mux_io_in2),
    .io_out(mux_io_out)
  );
  ADD add ( // @[softmax_pre.scala 37:21]
    .CLK(add_clock),
    .A(add_io_adder_A),
    .B(add_io_adder_B),
    .S(add_io_adder_S)
  );
  SUB sub ( // @[softmax_pre.scala 42:21]
    .CLK(sub_clock),
    .A(sub_io_suber_A),
    .B(sub_io_suber_B),
    .S(sub_io_suber_S)
  );
  assign io_out = r_2; // @[softmax_pre.scala 66:16]
  assign io_last_out = r_3; // @[softmax_pre.scala 67:21]
  assign mux_io_signal = ~sub_res[11]; // @[softmax_pre.scala 34:22]
  assign mux_io_in1 = io_in; // @[softmax_pre.scala 32:16]
  assign mux_io_in2 = max_reg; // @[softmax_pre.scala 33:16]
  assign add_clock = clock;
  assign add_io_adder_A = max_reg; // @[softmax_pre.scala 38:20]
  assign add_io_adder_B = ln_reg; // @[softmax_pre.scala 39:20]
  assign sub_clock = clock;
  assign sub_io_suber_A = io_in; // @[softmax_pre.scala 43:20]
  assign sub_io_suber_B = max_reg; // @[softmax_pre.scala 44:20]
  always @(posedge clock) begin
    if (io_max_en) begin // @[softmax_pre.scala 54:27]
      max_reg <= max_pre; // @[softmax_pre.scala 55:17]
    end else if (io_max_first) begin // @[softmax_pre.scala 51:30]
      max_reg <= io_in; // @[softmax_pre.scala 52:17]
    end
    if (io_rd_sum | io_rd_ln) begin // @[softmax_pre.scala 57:46]
      ln_reg <= io_add_res; // @[softmax_pre.scala 58:16]
    end
    r <= io_state == 3'h3; // @[softmax_pre.scala 49:59]
    r_1 <= ~r & _T_10; // @[softmax_pre.scala 49:73]
    if (io_state == 3'h2) begin // @[softmax_pre.scala 48:18]
      r_2 <= sub_res;
    end else if (io_state == 3'h3) begin // @[softmax_pre.scala 48:52]
      r_2 <= ln_reg;
    end else if (io_state == 3'h4) begin // @[softmax_pre.scala 48:83]
      r_2 <= _T_14;
    end else begin
      r_2 <= io_out_norm;
    end
    if (_T_10) begin // @[softmax_pre.scala 67:41]
      r_3 <= r_1;
    end else begin
      r_3 <= io_last_in;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  max_reg = _RAND_0[11:0];
  _RAND_1 = {1{`RANDOM}};
  ln_reg = _RAND_1[11:0];
  _RAND_2 = {1{`RANDOM}};
  r = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  r_1 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  r_2 = _RAND_4[11:0];
  _RAND_5 = {1{`RANDOM}};
  r_3 = _RAND_5[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Softmax_control(
  input        clock,
  input        reset,
  input        io_softmax,
  input        io_start,
  input        io_src_last,
  input        io_cpt_last,
  output [2:0] io_state,
  output       io_max_first,
  output       io_max_en,
  output       io_rd_sum,
  output       io_rd_ln,
  output       io_accum,
  output       io_compute_select
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg  max_first; // @[softamx_control.scala 21:24]
  reg  max_en; // @[softamx_control.scala 22:21]
  reg  rd_sum; // @[softamx_control.scala 23:21]
  reg [2:0] state; // @[softamx_control.scala 26:24]
  reg  compute_select; // @[softamx_control.scala 27:29]
  wire  _T = 3'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_3 = io_softmax & io_start; // @[softamx_control.scala 43:36]
  wire  _T_4 = 3'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_6 = 3'h2 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_3 = io_cpt_last ? 3'h3 : state; // @[softamx_control.scala 57:37 softamx_control.scala 58:23 softamx_control.scala 26:24]
  wire  _GEN_4 = io_cpt_last | rd_sum; // @[softamx_control.scala 57:37 softamx_control.scala 59:24 softamx_control.scala 23:21]
  wire  _GEN_5 = io_cpt_last | compute_select; // @[softamx_control.scala 57:37 softamx_control.scala 60:32 softamx_control.scala 27:29]
  wire  _T_8 = 3'h3 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_6 = io_cpt_last ? 3'h4 : state; // @[softamx_control.scala 65:37 softamx_control.scala 66:23 softamx_control.scala 26:24]
  wire  _GEN_8 = io_cpt_last ? 1'h0 : compute_select; // @[softamx_control.scala 65:37 softamx_control.scala 68:32 softamx_control.scala 27:29]
  wire  _T_10 = 3'h4 == state; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_9 = io_cpt_last ? 3'h0 : state; // @[softamx_control.scala 73:37 softamx_control.scala 74:23 softamx_control.scala 26:24]
  wire [2:0] _GEN_11 = _T_10 ? _GEN_9 : state; // @[Conditional.scala 39:67 softamx_control.scala 26:24]
  wire [2:0] _GEN_13 = _T_8 ? _GEN_6 : _GEN_11; // @[Conditional.scala 39:67]
  wire  _GEN_17 = _T_6 ? 1'h0 : max_en; // @[Conditional.scala 39:67 softamx_control.scala 56:20 softamx_control.scala 22:21]
  wire  _GEN_21 = _T_6 ? 1'h0 : _T_8 & io_cpt_last; // @[Conditional.scala 39:67 softamx_control.scala 31:14]
  wire  _GEN_24 = _T_4 | _GEN_17; // @[Conditional.scala 39:67 softamx_control.scala 50:20]
  wire  _GEN_28 = _T_4 ? 1'h0 : _GEN_21; // @[Conditional.scala 39:67 softamx_control.scala 31:14]
  reg  r; // @[Reg.scala 15:16]
  reg  r_1; // @[Reg.scala 15:16]
  reg  r_2; // @[Reg.scala 15:16]
  reg  r_3; // @[Reg.scala 15:16]
  assign io_state = state; // @[softamx_control.scala 34:14]
  assign io_max_first = max_first; // @[softamx_control.scala 29:18]
  assign io_max_en = max_en; // @[softamx_control.scala 30:15]
  assign io_rd_sum = rd_sum; // @[softamx_control.scala 32:15]
  assign io_rd_ln = _T ? 1'h0 : _GEN_28; // @[Conditional.scala 40:58 softamx_control.scala 31:14]
  assign io_accum = r_3 & state == 3'h2; // @[softamx_control.scala 78:56]
  assign io_compute_select = compute_select; // @[softamx_control.scala 79:23]
  always @(posedge clock) begin
    if (_T) begin // @[Conditional.scala 40:58]
      max_first <= _T_3;
    end else if (_T_4) begin // @[Conditional.scala 39:67]
      max_first <= 1'h0; // @[softamx_control.scala 49:23]
    end
    if (_T) begin // @[Conditional.scala 40:58]
      max_en <= 1'h0; // @[softamx_control.scala 39:20]
    end else begin
      max_en <= _GEN_24;
    end
    if (_T) begin // @[Conditional.scala 40:58]
      rd_sum <= 1'h0; // @[softamx_control.scala 41:20]
    end else if (!(_T_4)) begin // @[Conditional.scala 39:67]
      if (_T_6) begin // @[Conditional.scala 39:67]
        rd_sum <= _GEN_4;
      end else if (_T_8) begin // @[Conditional.scala 39:67]
        rd_sum <= 1'h0; // @[softamx_control.scala 64:20]
      end
    end
    if (reset) begin // @[softamx_control.scala 26:24]
      state <= 3'h0; // @[softamx_control.scala 26:24]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_softmax & io_start) begin // @[softamx_control.scala 43:55]
        state <= 3'h1; // @[softamx_control.scala 44:23]
      end
    end else if (_T_4) begin // @[Conditional.scala 39:67]
      if (io_src_last) begin // @[softamx_control.scala 51:37]
        state <= 3'h2; // @[softamx_control.scala 52:23]
      end
    end else if (_T_6) begin // @[Conditional.scala 39:67]
      state <= _GEN_3;
    end else begin
      state <= _GEN_13;
    end
    if (!(_T)) begin // @[Conditional.scala 40:58]
      if (!(_T_4)) begin // @[Conditional.scala 39:67]
        if (_T_6) begin // @[Conditional.scala 39:67]
          compute_select <= _GEN_5;
        end else if (_T_8) begin // @[Conditional.scala 39:67]
          compute_select <= _GEN_8;
        end
      end
    end
    r <= state == 3'h2; // @[softamx_control.scala 78:37]
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_2 <= r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_3 <= r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  max_first = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  max_en = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  rd_sum = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  state = _RAND_3[2:0];
  _RAND_4 = {1{`RANDOM}};
  compute_select = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  r = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  r_1 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  r_2 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  r_3 = _RAND_8[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Sym(
  input         clock,
  input  [11:0] io_in,
  input         io_select1,
  input         io_select2,
  input         io_sign,
  output [11:0] io_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg [11:0] r; // @[Reg.scala 15:16]
  reg [11:0] r_1; // @[Reg.scala 15:16]
  reg [11:0] r_2; // @[Reg.scala 15:16]
  reg [11:0] r_3; // @[Reg.scala 15:16]
  reg [11:0] r_4; // @[Reg.scala 15:16]
  assign io_out = r_4; // @[sym.scala 21:16]
  always @(posedge clock) begin
    if (io_sign | io_select2) begin // @[sym.scala 20:26]
      r <= 12'sh0;
    end else if (io_select1) begin // @[sym.scala 20:66]
      r <= io_in;
    end else begin
      r <= 12'sh1;
    end
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_2 <= r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_3 <= r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_4 <= r_3; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[11:0];
  _RAND_1 = {1{`RANDOM}};
  r_1 = _RAND_1[11:0];
  _RAND_2 = {1{`RANDOM}};
  r_2 = _RAND_2[11:0];
  _RAND_3 = {1{`RANDOM}};
  r_3 = _RAND_3[11:0];
  _RAND_4 = {1{`RANDOM}};
  r_4 = _RAND_4[11:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module unused(
  input         clock,
  input  [3:0]  io_dpra,
  output [12:0] io_dpo
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[Reg.scala 15:16]
  assign io_dpo = {{9{r[3]}},r}; // @[IP.scala 36:12]
  always @(posedge clock) begin
    if (io_dpra == 4'h0) begin // @[IP.scala 36:32]
      r <= 4'sh1;
    end else begin
      r <= io_dpra;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module unused_1(
  input        clock,
  input  [3:0] io_dpra,
  output [9:0] io_dpo
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[Reg.scala 15:16]
  assign io_dpo = {{6{r[3]}},r}; // @[IP.scala 36:12]
  always @(posedge clock) begin
    if (io_dpra == 4'h0) begin // @[IP.scala 36:32]
      r <= 4'sh1;
    end else begin
      r <= io_dpra;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module unused_2(
  input         clock,
  input  [3:0]  io_dpra,
  output [11:0] io_dpo
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[Reg.scala 15:16]
  assign io_dpo = {{8{r[3]}},r}; // @[IP.scala 36:12]
  always @(posedge clock) begin
    if (io_dpra == 4'h0) begin // @[IP.scala 36:32]
      r <= 4'sh1;
    end else begin
      r <= io_dpra;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module unused1(
  input         clock,
  input  [9:0]  io_dsp_A,
  input  [7:0]  io_dsp_B,
  input  [17:0] io_dsp_C,
  output [17:0] io_dsp_P
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [17:0] out; // @[IP.scala 47:18]
  wire [17:0] _T = $signed(io_dsp_A) * $signed(io_dsp_B); // @[IP.scala 48:21]
  assign io_dsp_P = out; // @[IP.scala 49:14]
  always @(posedge clock) begin
    out <= $signed(_T) + $signed(io_dsp_C); // @[IP.scala 48:32]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  out = _RAND_0[17:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Softmax_compute(
  input         clock,
  input         reset,
  input  [11:0] io_in,
  input         io_select,
  input         io_last_in,
  output [11:0] io_out,
  output        io_last_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  wire  lut_a1_clock; // @[softmax_compute.scala 41:24]
  wire [3:0] lut_a1_io_dpra; // @[softmax_compute.scala 41:24]
  wire [12:0] lut_a1_io_dpo; // @[softmax_compute.scala 41:24]
  wire  lut_k1_clock; // @[softmax_compute.scala 50:24]
  wire [3:0] lut_k1_io_dpra; // @[softmax_compute.scala 50:24]
  wire [9:0] lut_k1_io_dpo; // @[softmax_compute.scala 50:24]
  wire  lut_b1_clock; // @[softmax_compute.scala 52:24]
  wire [3:0] lut_b1_io_dpra; // @[softmax_compute.scala 52:24]
  wire [11:0] lut_b1_io_dpo; // @[softmax_compute.scala 52:24]
  wire  lut_a2_clock; // @[softmax_compute.scala 63:24]
  wire [3:0] lut_a2_io_dpra; // @[softmax_compute.scala 63:24]
  wire [12:0] lut_a2_io_dpo; // @[softmax_compute.scala 63:24]
  wire  lut_k2_clock; // @[softmax_compute.scala 72:24]
  wire [3:0] lut_k2_io_dpra; // @[softmax_compute.scala 72:24]
  wire [9:0] lut_k2_io_dpo; // @[softmax_compute.scala 72:24]
  wire  lut_b2_clock; // @[softmax_compute.scala 74:24]
  wire [3:0] lut_b2_io_dpra; // @[softmax_compute.scala 74:24]
  wire [11:0] lut_b2_io_dpo; // @[softmax_compute.scala 74:24]
  wire  dsp_clock; // @[softmax_compute.scala 78:21]
  wire [9:0] dsp_io_dsp_A; // @[softmax_compute.scala 78:21]
  wire [7:0] dsp_io_dsp_B; // @[softmax_compute.scala 78:21]
  wire [17:0] dsp_io_dsp_C; // @[softmax_compute.scala 78:21]
  wire [17:0] dsp_io_dsp_P; // @[softmax_compute.scala 78:21]
  reg [7:0] r; // @[Reg.scala 15:16]
  reg [7:0] r_1; // @[Reg.scala 15:16]
  reg [7:0] digits; // @[Reg.scala 15:16]
  wire  fine_address1 = io_in[6]; // @[softmax_compute.scala 37:31]
  reg [3:0] kb_address1; // @[softmax_compute.scala 44:30]
  wire  _T_2 = ~fine_address1; // @[softmax_compute.scala 46:29]
  reg [3:0] kb_address2; // @[softmax_compute.scala 66:30]
  wire [11:0] _T_15 = io_select ? $signed(lut_b1_io_dpo) : $signed(lut_b2_io_dpo); // @[softmax_compute.scala 81:24]
  reg  r_2; // @[Reg.scala 15:16]
  reg  r_3; // @[Reg.scala 15:16]
  reg  r_4; // @[Reg.scala 15:16]
  lut lut_a1 ( // @[softmax_compute.scala 41:24]
    .clk(lut_a1_clock),
    .dpra(lut_a1_io_dpra),
    .qdpo(lut_a1_io_dpo)
  );
  lut_1 lut_k1 ( // @[softmax_compute.scala 50:24]
    .clk(lut_k1_clock),
    .dpra(lut_k1_io_dpra),
    .qdpo(lut_k1_io_dpo)
  );
  lut_2 lut_b1 ( // @[softmax_compute.scala 52:24]
    .clk(lut_b1_clock),
    .dpra(lut_b1_io_dpra),
    .qdpo(lut_b1_io_dpo)
  );
  lut lut_a2 ( // @[softmax_compute.scala 63:24]
    .clk(lut_a2_clock),
    .dpra(lut_a2_io_dpra),
    .qdpo(lut_a2_io_dpo)
  );
  lut_1 lut_k2 ( // @[softmax_compute.scala 72:24]
    .clk(lut_k2_clock),
    .dpra(lut_k2_io_dpra),
    .qdpo(lut_k2_io_dpo)
  );
  lut_2 lut_b2 ( // @[softmax_compute.scala 74:24]
    .clk(lut_b2_clock),
    .dpra(lut_b2_io_dpra),
    .qdpo(lut_b2_io_dpo)
  );
  DSP dsp ( // @[softmax_compute.scala 78:21]
    .CLK(dsp_clock),
    .A(dsp_io_dsp_A),
    .B(dsp_io_dsp_B),
    .C(dsp_io_dsp_C),
    .P(dsp_io_dsp_P)
  );
  assign io_out = dsp_io_dsp_P[17:6]; // @[softmax_compute.scala 84:32]
  assign io_last_out = r_4; // @[softmax_compute.scala 88:17]
  assign lut_a1_clock = clock;
  assign lut_a1_io_dpra = io_in[10:7]; // @[softmax_compute.scala 30:31]
  assign lut_k1_clock = clock;
  assign lut_k1_io_dpra = kb_address1; // @[softmax_compute.scala 51:20]
  assign lut_b1_clock = clock;
  assign lut_b1_io_dpra = kb_address1; // @[softmax_compute.scala 53:20]
  assign lut_a2_clock = clock;
  assign lut_a2_io_dpra = io_in[10:7]; // @[softmax_compute.scala 30:31]
  assign lut_k2_clock = clock;
  assign lut_k2_io_dpra = kb_address2; // @[softmax_compute.scala 73:20]
  assign lut_b2_clock = clock;
  assign lut_b2_io_dpra = kb_address2; // @[softmax_compute.scala 75:20]
  assign dsp_clock = clock;
  assign dsp_io_dsp_A = io_select ? $signed(lut_k1_io_dpo) : $signed(lut_k2_io_dpo); // @[softmax_compute.scala 79:24]
  assign dsp_io_dsp_B = digits; // @[softmax_compute.scala 80:28]
  assign dsp_io_dsp_C = {$signed(_T_15), 6'h0}; // @[softmax_compute.scala 81:73]
  always @(posedge clock) begin
    r <= io_in[7:0]; // @[softmax_compute.scala 29:37]
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    digits <= r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    if (reset) begin // @[softmax_compute.scala 44:30]
      kb_address1 <= 4'h0; // @[softmax_compute.scala 44:30]
    end else if (fine_address1) begin // @[softmax_compute.scala 46:44]
      kb_address1 <= lut_a1_io_dpo[7:4]; // @[softmax_compute.scala 47:25]
    end else if (~fine_address1) begin // @[softmax_compute.scala 46:44]
      kb_address1 <= lut_a1_io_dpo[3:0]; // @[softmax_compute.scala 47:25]
    end
    if (reset) begin // @[softmax_compute.scala 66:30]
      kb_address2 <= 4'h0; // @[softmax_compute.scala 66:30]
    end else if (fine_address1) begin // @[softmax_compute.scala 68:44]
      kb_address2 <= lut_a2_io_dpo[7:4]; // @[softmax_compute.scala 69:25]
    end else if (_T_2) begin // @[softmax_compute.scala 68:44]
      kb_address2 <= lut_a2_io_dpo[3:0]; // @[softmax_compute.scala 69:25]
    end
    r_2 <= io_last_in; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_3 <= r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_4 <= r_3; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[7:0];
  _RAND_1 = {1{`RANDOM}};
  r_1 = _RAND_1[7:0];
  _RAND_2 = {1{`RANDOM}};
  digits = _RAND_2[7:0];
  _RAND_3 = {1{`RANDOM}};
  kb_address1 = _RAND_3[3:0];
  _RAND_4 = {1{`RANDOM}};
  kb_address2 = _RAND_4[3:0];
  _RAND_5 = {1{`RANDOM}};
  r_2 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  r_3 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  r_4 = _RAND_7[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Softmax_axis(
  input         clock,
  input  [11:0] io_in,
  input         io_sign,
  input         io_select1,
  input         io_last_in,
  output [11:0] io_out,
  output        io_last_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire [11:0] _T_1 = ~io_in; // @[softmax_axis.scala 17:16]
  wire [11:0] oppo = $signed(_T_1) + 12'sh1; // @[softmax_axis.scala 17:23]
  reg [11:0] r; // @[Reg.scala 15:16]
  reg  r_1; // @[Reg.scala 15:16]
  assign io_out = r; // @[softmax_axis.scala 24:16]
  assign io_last_out = r_1; // @[softmax_axis.scala 25:21]
  always @(posedge clock) begin
    if (~io_sign & ~io_select1) begin // @[softmax_axis.scala 24:36]
      r <= oppo;
    end else begin
      r <= io_in;
    end
    r_1 <= io_last_in; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[11:0];
  _RAND_1 = {1{`RANDOM}};
  r_1 = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Softmax_addr(
  input         clock,
  input  [11:0] io_in1,
  input  [11:0] io_in2,
  input         io_accum,
  input         io_last_in,
  output [11:0] io_out,
  output        io_last_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [11:0] out_reg; // @[softmax_addr.scala 19:22]
  wire [11:0] _T_3 = $signed(io_in1) + $signed(out_reg); // @[softmax_addr.scala 20:44]
  wire [11:0] _T_6 = $signed(io_in1) + $signed(io_in2); // @[softmax_addr.scala 20:62]
  reg  r; // @[Reg.scala 15:16]
  assign io_out = out_reg; // @[softmax_addr.scala 21:12]
  assign io_last_out = r; // @[softmax_addr.scala 22:17]
  always @(posedge clock) begin
    if (io_accum) begin // @[softmax_addr.scala 20:19]
      out_reg <= _T_3;
    end else begin
      out_reg <= _T_6;
    end
    r <= io_last_in; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  out_reg = _RAND_0[11:0];
  _RAND_1 = {1{`RANDOM}};
  r = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module softmax_top(
  input         clock,
  input         reset,
  input  [11:0] io_in,
  input         io_select1,
  input         io_select2,
  input         io_softmax,
  input         io_start,
  input         io_last,
  output [11:0] io_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
`endif // RANDOMIZE_REG_INIT
  wire  pre_module_clock; // @[softmax_top.scala 22:28]
  wire [11:0] pre_module_io_in; // @[softmax_top.scala 22:28]
  wire [2:0] pre_module_io_state; // @[softmax_top.scala 22:28]
  wire [11:0] pre_module_io_add_res; // @[softmax_top.scala 22:28]
  wire  pre_module_io_last_in; // @[softmax_top.scala 22:28]
  wire  pre_module_io_max_first; // @[softmax_top.scala 22:28]
  wire  pre_module_io_max_en; // @[softmax_top.scala 22:28]
  wire  pre_module_io_rd_sum; // @[softmax_top.scala 22:28]
  wire  pre_module_io_rd_ln; // @[softmax_top.scala 22:28]
  wire [11:0] pre_module_io_out; // @[softmax_top.scala 22:28]
  wire  pre_module_io_last_out; // @[softmax_top.scala 22:28]
  wire  control_module_clock; // @[softmax_top.scala 23:32]
  wire  control_module_reset; // @[softmax_top.scala 23:32]
  wire  control_module_io_softmax; // @[softmax_top.scala 23:32]
  wire  control_module_io_start; // @[softmax_top.scala 23:32]
  wire  control_module_io_src_last; // @[softmax_top.scala 23:32]
  wire  control_module_io_cpt_last; // @[softmax_top.scala 23:32]
  wire [2:0] control_module_io_state; // @[softmax_top.scala 23:32]
  wire  control_module_io_max_first; // @[softmax_top.scala 23:32]
  wire  control_module_io_max_en; // @[softmax_top.scala 23:32]
  wire  control_module_io_rd_sum; // @[softmax_top.scala 23:32]
  wire  control_module_io_rd_ln; // @[softmax_top.scala 23:32]
  wire  control_module_io_accum; // @[softmax_top.scala 23:32]
  wire  control_module_io_compute_select; // @[softmax_top.scala 23:32]
  wire  sym_module_clock; // @[softmax_top.scala 24:28]
  wire [11:0] sym_module_io_in; // @[softmax_top.scala 24:28]
  wire  sym_module_io_select1; // @[softmax_top.scala 24:28]
  wire  sym_module_io_select2; // @[softmax_top.scala 24:28]
  wire  sym_module_io_sign; // @[softmax_top.scala 24:28]
  wire [11:0] sym_module_io_out; // @[softmax_top.scala 24:28]
  wire  compute_module_clock; // @[softmax_top.scala 25:32]
  wire  compute_module_reset; // @[softmax_top.scala 25:32]
  wire [11:0] compute_module_io_in; // @[softmax_top.scala 25:32]
  wire  compute_module_io_select; // @[softmax_top.scala 25:32]
  wire  compute_module_io_last_in; // @[softmax_top.scala 25:32]
  wire [11:0] compute_module_io_out; // @[softmax_top.scala 25:32]
  wire  compute_module_io_last_out; // @[softmax_top.scala 25:32]
  wire  axis_module_clock; // @[softmax_top.scala 26:29]
  wire [11:0] axis_module_io_in; // @[softmax_top.scala 26:29]
  wire  axis_module_io_sign; // @[softmax_top.scala 26:29]
  wire  axis_module_io_select1; // @[softmax_top.scala 26:29]
  wire  axis_module_io_last_in; // @[softmax_top.scala 26:29]
  wire [11:0] axis_module_io_out; // @[softmax_top.scala 26:29]
  wire  axis_module_io_last_out; // @[softmax_top.scala 26:29]
  wire  addr_module_clock; // @[softmax_top.scala 27:29]
  wire [11:0] addr_module_io_in1; // @[softmax_top.scala 27:29]
  wire [11:0] addr_module_io_in2; // @[softmax_top.scala 27:29]
  wire  addr_module_io_accum; // @[softmax_top.scala 27:29]
  wire  addr_module_io_last_in; // @[softmax_top.scala 27:29]
  wire [11:0] addr_module_io_out; // @[softmax_top.scala 27:29]
  wire  addr_module_io_last_out; // @[softmax_top.scala 27:29]
  reg  r; // @[Reg.scala 15:16]
  reg  r_1; // @[Reg.scala 15:16]
  reg  r_2; // @[Reg.scala 15:16]
  reg  r_3; // @[Reg.scala 15:16]
  reg  r_4; // @[Reg.scala 15:16]
  reg  r_5; // @[Reg.scala 15:16]
  reg  r_6; // @[Reg.scala 15:16]
  reg  r_7; // @[Reg.scala 15:16]
  Softmax_pre pre_module ( // @[softmax_top.scala 22:28]
    .clock(pre_module_clock),
    .io_in(pre_module_io_in),
    .io_state(pre_module_io_state),
    .io_add_res(pre_module_io_add_res),
    .io_last_in(pre_module_io_last_in),
    .io_max_first(pre_module_io_max_first),
    .io_max_en(pre_module_io_max_en),
    .io_rd_sum(pre_module_io_rd_sum),
    .io_rd_ln(pre_module_io_rd_ln),
    .io_out(pre_module_io_out),
    .io_last_out(pre_module_io_last_out)
  );
  Softmax_control control_module ( // @[softmax_top.scala 23:32]
    .clock(control_module_clock),
    .reset(control_module_reset),
    .io_softmax(control_module_io_softmax),
    .io_start(control_module_io_start),
    .io_src_last(control_module_io_src_last),
    .io_cpt_last(control_module_io_cpt_last),
    .io_state(control_module_io_state),
    .io_max_first(control_module_io_max_first),
    .io_max_en(control_module_io_max_en),
    .io_rd_sum(control_module_io_rd_sum),
    .io_rd_ln(control_module_io_rd_ln),
    .io_accum(control_module_io_accum),
    .io_compute_select(control_module_io_compute_select)
  );
  Sym sym_module ( // @[softmax_top.scala 24:28]
    .clock(sym_module_clock),
    .io_in(sym_module_io_in),
    .io_select1(sym_module_io_select1),
    .io_select2(sym_module_io_select2),
    .io_sign(sym_module_io_sign),
    .io_out(sym_module_io_out)
  );
  Softmax_compute compute_module ( // @[softmax_top.scala 25:32]
    .clock(compute_module_clock),
    .reset(compute_module_reset),
    .io_in(compute_module_io_in),
    .io_select(compute_module_io_select),
    .io_last_in(compute_module_io_last_in),
    .io_out(compute_module_io_out),
    .io_last_out(compute_module_io_last_out)
  );
  Softmax_axis axis_module ( // @[softmax_top.scala 26:29]
    .clock(axis_module_clock),
    .io_in(axis_module_io_in),
    .io_sign(axis_module_io_sign),
    .io_select1(axis_module_io_select1),
    .io_last_in(axis_module_io_last_in),
    .io_out(axis_module_io_out),
    .io_last_out(axis_module_io_last_out)
  );
  Softmax_addr addr_module ( // @[softmax_top.scala 27:29]
    .clock(addr_module_clock),
    .io_in1(addr_module_io_in1),
    .io_in2(addr_module_io_in2),
    .io_accum(addr_module_io_accum),
    .io_last_in(addr_module_io_last_in),
    .io_out(addr_module_io_out),
    .io_last_out(addr_module_io_last_out)
  );
  assign io_out = addr_module_io_out; // @[softmax_top.scala 62:12]
  assign pre_module_clock = clock;
  assign pre_module_io_in = io_in; // @[softmax_top.scala 34:22]
  assign pre_module_io_state = control_module_io_state; // @[softmax_top.scala 35:25]
  assign pre_module_io_add_res = addr_module_io_out; // @[softmax_top.scala 36:27]
  assign pre_module_io_last_in = io_last; // @[softmax_top.scala 37:27]
  assign pre_module_io_max_first = control_module_io_max_first; // @[softmax_top.scala 38:29]
  assign pre_module_io_max_en = control_module_io_max_en; // @[softmax_top.scala 39:26]
  assign pre_module_io_rd_sum = control_module_io_rd_sum; // @[softmax_top.scala 40:26]
  assign pre_module_io_rd_ln = control_module_io_rd_ln; // @[softmax_top.scala 41:25]
  assign control_module_clock = clock;
  assign control_module_reset = reset;
  assign control_module_io_softmax = io_softmax; // @[softmax_top.scala 29:31]
  assign control_module_io_start = io_start; // @[softmax_top.scala 30:29]
  assign control_module_io_src_last = io_last; // @[softmax_top.scala 31:32]
  assign control_module_io_cpt_last = addr_module_io_last_out; // @[softmax_top.scala 32:32]
  assign sym_module_clock = clock;
  assign sym_module_io_in = io_in; // @[softmax_top.scala 43:22]
  assign sym_module_io_select1 = io_select1; // @[softmax_top.scala 44:27]
  assign sym_module_io_select2 = io_select2; // @[softmax_top.scala 45:27]
  assign sym_module_io_sign = io_in[11]; // @[softmax_top.scala 46:32]
  assign compute_module_clock = clock;
  assign compute_module_reset = reset;
  assign compute_module_io_in = pre_module_io_out; // @[softmax_top.scala 48:26]
  assign compute_module_io_select = control_module_io_compute_select; // @[softmax_top.scala 49:30]
  assign compute_module_io_last_in = pre_module_io_last_out; // @[softmax_top.scala 50:31]
  assign axis_module_clock = clock;
  assign axis_module_io_in = compute_module_io_out; // @[softmax_top.scala 52:23]
  assign axis_module_io_sign = r_3; // @[softmax_top.scala 54:25]
  assign axis_module_io_select1 = r_7; // @[softmax_top.scala 55:28]
  assign axis_module_io_last_in = compute_module_io_last_out; // @[softmax_top.scala 53:28]
  assign addr_module_clock = clock;
  assign addr_module_io_in1 = sym_module_io_out; // @[softmax_top.scala 57:24]
  assign addr_module_io_in2 = axis_module_io_out; // @[softmax_top.scala 58:24]
  assign addr_module_io_accum = control_module_io_accum; // @[softmax_top.scala 59:26]
  assign addr_module_io_last_in = axis_module_io_last_out; // @[softmax_top.scala 60:28]
  always @(posedge clock) begin
    r <= io_in[11]; // @[softmax_top.scala 54:47]
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_2 <= r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_3 <= r_2; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_4 <= io_select1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_5 <= r_4; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_6 <= r_5; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_7 <= r_6; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  r_2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  r_3 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  r_4 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  r_5 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  r_6 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  r_7 = _RAND_7[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
