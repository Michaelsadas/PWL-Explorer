module Softmax_compute(
  input         clock,
  input         reset,
  input  [11:0] io_in,
  input         io_select,
  output [11:0] io_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] r; // @[Reg.scala 15:16]
  reg [7:0] r_1; // @[Reg.scala 15:16]
  reg [7:0] digits; // @[Reg.scala 15:16]
  reg [17:0] r_2; // @[Reg.scala 15:16]
  wire [19:0] multiply = {{2{r_2[17]}},r_2}; // @[softmax_compute.scala 82:24 softmax_compute.scala 87:18]
  wire [11:0] _T_9 = multiply[19:8]; // @[softmax_compute.scala 91:25]
  wire [7:0] _T_11 = _T_9[7:0]; // @[softmax_compute.scala 91:93]
  wire [12:0] _T_12 = {{5{_T_11[7]}},_T_11}; // @[softmax_compute.scala 91:100]
  assign io_out = _T_12[11:0]; // @[softmax_compute.scala 91:100]
  always @(posedge clock) begin
    r <= io_in[7:0]; // @[softmax_compute.scala 27:37]
    r_1 <= r; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    digits <= r_1; // @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    r_2 <= 10'sh0 * $signed(digits); // @[softmax_compute.scala 87:37]
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
  r_2 = _RAND_3[17:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
