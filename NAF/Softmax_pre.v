module Softmax_pre(
  input         clock,
  input         reset,
  input  [11:0] io_in,
  input  [2:0]  io_state,
  input  [15:0] io_add_res,
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
`endif // RANDOMIZE_REG_INIT
  reg [11:0] max_reg; // @[softmax_pre.scala 22:22]
  reg [15:0] ln_reg; // @[softmax_pre.scala 23:21]
  wire  _T_1 = ~io_in[11]; // @[softmax_pre.scala 29:47]
  wire [11:0] _T_4 = _T_1 ? 12'hfff : 12'h0; // @[softmax_pre.scala 29:71]
  wire [11:0] io_out_norm = $signed(io_in) ^ $signed(_T_4); // @[softmax_pre.scala 29:26]
  wire [11:0] _T_10 = $signed(io_in) - $signed(max_reg); // @[softmax_pre.scala 30:46]
  wire  _T_11 = io_state == 3'h3; // @[softmax_pre.scala 30:70]
  wire [15:0] _GEN_5 = {{4{_T_10[11]}},_T_10}; // @[softmax_pre.scala 30:129]
  wire [15:0] _T_18 = $signed(_GEN_5) - $signed(ln_reg); // @[softmax_pre.scala 30:129]
  wire [15:0] _T_19 = io_state == 3'h4 ? $signed(_T_18) : $signed({{4{io_out_norm[11]}},io_out_norm}); // @[softmax_pre.scala 30:91]
  wire [15:0] _T_20 = io_state == 3'h3 ? $signed(ln_reg) : $signed(_T_19); // @[softmax_pre.scala 30:60]
  wire [15:0] _T_21 = io_state == 3'h2 ? $signed({{4{_T_10[11]}},_T_10}) : $signed(_T_20); // @[softmax_pre.scala 30:18]
  reg  r; // @[Reg.scala 15:16]
  reg  r_1; // @[Reg.scala 15:16]
  assign io_out = _T_21[11:0]; // @[softmax_pre.scala 25:22 softmax_pre.scala 30:12]
  assign io_last_out = _T_11 ? r_1 : io_last_in; // @[softmax_pre.scala 44:27]
  always @(posedge clock) begin
    if (io_max_first) begin // @[softmax_pre.scala 33:30]
      max_reg <= io_in; // @[softmax_pre.scala 34:17]
    end else if (io_max_en) begin // @[softmax_pre.scala 35:33]
      if ($signed(max_reg) < $signed(io_in)) begin // @[softmax_pre.scala 36:23]
        max_reg <= io_in;
      end
    end
    if (io_rd_sum | io_rd_ln) begin // @[softmax_pre.scala 38:46]
      ln_reg <= io_add_res; // @[softmax_pre.scala 39:16]
    end
    r <= io_state == 3'h3; // @[softmax_pre.scala 31:59]
    r_1 <= ~r & _T_11; // @[softmax_pre.scala 31:73]
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
  ln_reg = _RAND_1[15:0];
  _RAND_2 = {1{`RANDOM}};
  r = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  r_1 = _RAND_3[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
