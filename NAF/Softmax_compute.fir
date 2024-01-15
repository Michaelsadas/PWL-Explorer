circuit Softmax_compute :
  module lut :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<1>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module lut_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<10>, dpo : SInt<4>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module lut_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<12>, dpo : SInt<4>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module lut_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<1>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module lut_4 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<10>, dpo : SInt<4>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module lut_5 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<12>, dpo : SInt<4>}

    io.dpo <= asSInt(UInt<1>("h0")) @[lut.scala 11:12]

  module Softmax_compute :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : SInt<12>, flip select : UInt<1>, out : SInt<12>}

    node _T = bits(io.in, 7, 0) @[softmax_compute.scala 27:37]
    reg r : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T @[Reg.scala 16:23]
    reg r_1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= r @[Reg.scala 16:23]
    reg digits : UInt<8>, clock with :
      reset => (UInt<1>("h0"), digits) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      digits <= r_1 @[Reg.scala 16:23]
    node coarse_address = bits(io.in, 10, 7) @[softmax_compute.scala 28:31]
    wire fine_address1 : UInt<2> @[softmax_compute.scala 31:29]
    node _T_1 = bits(io.in, 6, 5) @[softmax_compute.scala 35:31]
    fine_address1 <= _T_1 @[softmax_compute.scala 35:23]
    inst lut_a1 of lut @[softmax_compute.scala 39:24]
    lut_a1.clock <= clock
    lut_a1.reset <= reset
    lut_a1.io.dpra <= coarse_address @[softmax_compute.scala 40:20]
    node slice_signal1 = bits(lut_a1.io.dpo, 0, 0) @[softmax_compute.scala 42:35]
    reg kb_address1 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[softmax_compute.scala 43:30]
    inst lut_k1 of lut_1 @[softmax_compute.scala 49:24]
    lut_k1.clock <= clock
    lut_k1.reset <= reset
    lut_k1.io.dpra <= kb_address1 @[softmax_compute.scala 50:20]
    inst lut_b1 of lut_2 @[softmax_compute.scala 51:24]
    lut_b1.clock <= clock
    lut_b1.reset <= reset
    lut_b1.io.dpra <= kb_address1 @[softmax_compute.scala 52:20]
    wire fine_address2 : UInt<2> @[softmax_compute.scala 54:29]
    node _T_2 = bits(io.in, 6, 5) @[softmax_compute.scala 58:31]
    fine_address2 <= _T_2 @[softmax_compute.scala 58:23]
    inst lut_a2 of lut_3 @[softmax_compute.scala 62:24]
    lut_a2.clock <= clock
    lut_a2.reset <= reset
    lut_a2.io.dpra <= coarse_address @[softmax_compute.scala 63:20]
    node slice_signal2 = bits(lut_a2.io.dpo, 0, 0) @[softmax_compute.scala 65:35]
    reg kb_address2 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[softmax_compute.scala 66:30]
    inst lut_k2 of lut_4 @[softmax_compute.scala 72:24]
    lut_k2.clock <= clock
    lut_k2.reset <= reset
    lut_k2.io.dpra <= kb_address2 @[softmax_compute.scala 73:20]
    inst lut_b2 of lut_5 @[softmax_compute.scala 74:24]
    lut_b2.clock <= clock
    lut_b2.reset <= reset
    lut_b2.io.dpra <= kb_address2 @[softmax_compute.scala 75:20]
    wire k : SInt<10> @[softmax_compute.scala 78:17]
    wire b : SInt<12> @[softmax_compute.scala 79:17]
    node _T_3 = bits(io.select, 0, 0) @[softmax_compute.scala 80:24]
    node _T_4 = mux(_T_3, lut_k1.io.dpo, lut_k2.io.dpo) @[softmax_compute.scala 80:13]
    k <= _T_4 @[softmax_compute.scala 80:7]
    wire multiply : SInt<20> @[softmax_compute.scala 82:24]
    node _T_5 = asSInt(digits) @[softmax_compute.scala 87:46]
    node _T_6 = mul(k, _T_5) @[softmax_compute.scala 87:37]
    reg r_2 : SInt<18>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= _T_6 @[Reg.scala 16:23]
    multiply <= r_2 @[softmax_compute.scala 87:18]
    node _T_7 = bits(io.select, 0, 0) @[softmax_compute.scala 88:42]
    node _T_8 = mux(_T_7, lut_b1.io.dpo, lut_b2.io.dpo) @[softmax_compute.scala 88:31]
    reg r_3 : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= _T_8 @[Reg.scala 16:23]
    b <= r_3 @[softmax_compute.scala 88:11]
    node _T_9 = shr(multiply, 8) @[softmax_compute.scala 91:25]
    node _T_10 = bits(_T_9, 7, 0) @[softmax_compute.scala 91:71]
    node _T_11 = asSInt(_T_10) @[softmax_compute.scala 91:93]
    node _T_12 = add(_T_11, b) @[softmax_compute.scala 91:100]
    node _T_13 = tail(_T_12, 1) @[softmax_compute.scala 91:100]
    node _T_14 = asSInt(_T_13) @[softmax_compute.scala 91:100]
    io.out <= _T_14 @[softmax_compute.scala 91:12]

