circuit softmax_top :
  module Muxs :
    input clock : Clock
    input reset : Reset
    output io : { flip signal : UInt<1>, flip in1 : SInt<12>, flip in2 : SInt<12>, out : SInt<12>}

    node _T = bits(io.signal, 0, 0) @[IP.scala 59:29]
    node _T_1 = mux(_T, io.in1, io.in2) @[IP.scala 59:18]
    io.out <= _T_1 @[IP.scala 59:12]

  module ADD :
    input clock : Clock
    input reset : Reset
    output io : { flip adder_A : SInt<12>, flip adder_B : SInt<12>, adder_S : SInt<12>}

    reg out : SInt<12>, clock with :
      reset => (UInt<1>("h0"), out) @[IP.scala 13:18]
    node _T = add(io.adder_A, io.adder_B) @[IP.scala 14:23]
    node _T_1 = tail(_T, 1) @[IP.scala 14:23]
    node _T_2 = asSInt(_T_1) @[IP.scala 14:23]
    out <= _T_2 @[IP.scala 14:9]
    io.adder_S <= out @[IP.scala 15:16]

  module SUB :
    input clock : Clock
    input reset : Reset
    output io : { flip suber_A : SInt<12>, flip suber_B : SInt<12>, suber_S : SInt<12>}

    reg out : SInt<12>, clock with :
      reset => (UInt<1>("h0"), out) @[IP.scala 25:18]
    node _T = sub(io.suber_A, io.suber_B) @[IP.scala 26:23]
    node _T_1 = tail(_T, 1) @[IP.scala 26:23]
    node _T_2 = asSInt(_T_1) @[IP.scala 26:23]
    out <= _T_2 @[IP.scala 26:9]
    io.suber_S <= out @[IP.scala 27:16]

  module Softmax_pre :
    input clock : Clock
    input reset : Reset
    output io : { flip in : SInt<12>, flip state : UInt<3>, flip add_res : SInt<12>, flip last_in : UInt<1>, flip max_first : UInt<1>, flip max_en : UInt<1>, flip rd_sum : UInt<1>, flip rd_ln : UInt<1>, out : SInt<12>, last_out : UInt<1>}

    reg max_reg : SInt<12>, clock with :
      reset => (UInt<1>("h0"), max_reg) @[softmax_pre.scala 22:22]
    reg ln_reg : SInt<12>, clock with :
      reset => (UInt<1>("h0"), ln_reg) @[softmax_pre.scala 23:21]
    wire io_out : SInt<12> @[softmax_pre.scala 25:22]
    wire io_out_norm : SInt<12> @[softmax_pre.scala 26:27]
    wire io_ln_valid : UInt<1> @[softmax_pre.scala 27:27]
    wire sub_res : SInt<12> @[softmax_pre.scala 28:23]
    wire max_pre : SInt<12> @[softmax_pre.scala 29:23]
    inst mux of Muxs @[softmax_pre.scala 31:21]
    mux.clock <= clock
    mux.reset <= reset
    mux.io.in1 <= io.in @[softmax_pre.scala 32:16]
    mux.io.in2 <= max_reg @[softmax_pre.scala 33:16]
    node _T = bits(sub_res, 11, 11) @[softmax_pre.scala 34:31]
    node _T_1 = not(_T) @[softmax_pre.scala 34:22]
    mux.io.signal <= _T_1 @[softmax_pre.scala 34:19]
    max_pre <= mux.io.out @[softmax_pre.scala 35:13]
    inst add of ADD @[softmax_pre.scala 37:21]
    add.clock <= clock
    add.reset <= reset
    add.io.adder_A <= max_reg @[softmax_pre.scala 38:20]
    add.io.adder_B <= ln_reg @[softmax_pre.scala 39:20]
    inst sub of SUB @[softmax_pre.scala 42:21]
    sub.clock <= clock
    sub.reset <= reset
    sub.io.suber_A <= io.in @[softmax_pre.scala 43:20]
    sub.io.suber_B <= max_reg @[softmax_pre.scala 44:20]
    sub_res <= sub.io.suber_S @[softmax_pre.scala 45:13]
    node _T_2 = bits(io.in, 11, 11) @[softmax_pre.scala 47:53]
    node _T_3 = eq(_T_2, UInt<1>("h0")) @[softmax_pre.scala 47:47]
    node _T_4 = bits(_T_3, 0, 0) @[Bitwise.scala 72:15]
    node _T_5 = mux(_T_4, UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _T_6 = asSInt(_T_5) @[softmax_pre.scala 47:71]
    node _T_7 = xor(io.in, _T_6) @[softmax_pre.scala 47:26]
    node _T_8 = asSInt(_T_7) @[softmax_pre.scala 47:26]
    io_out_norm <= _T_8 @[softmax_pre.scala 47:17]
    node _T_9 = eq(io.state, UInt<3>("h2")) @[softmax_pre.scala 48:28]
    node _T_10 = eq(io.state, UInt<3>("h3")) @[softmax_pre.scala 48:62]
    node _T_11 = eq(io.state, UInt<3>("h4")) @[softmax_pre.scala 48:93]
    node _T_12 = sub(io.in, add.io.adder_S) @[softmax_pre.scala 48:111]
    node _T_13 = tail(_T_12, 1) @[softmax_pre.scala 48:111]
    node _T_14 = asSInt(_T_13) @[softmax_pre.scala 48:111]
    node _T_15 = mux(_T_11, _T_14, io_out_norm) @[softmax_pre.scala 48:83]
    node _T_16 = mux(_T_10, ln_reg, _T_15) @[softmax_pre.scala 48:52]
    node _T_17 = mux(_T_9, sub_res, _T_16) @[softmax_pre.scala 48:18]
    io_out <= _T_17 @[softmax_pre.scala 48:12]
    node _T_18 = eq(io.state, UInt<3>("h3")) @[softmax_pre.scala 49:59]
    reg r : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_18 @[Reg.scala 16:23]
    node _T_19 = not(r) @[softmax_pre.scala 49:35]
    node _T_20 = eq(io.state, UInt<3>("h3")) @[softmax_pre.scala 49:85]
    node _T_21 = and(_T_19, _T_20) @[softmax_pre.scala 49:73]
    reg r_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= _T_21 @[Reg.scala 16:23]
    io_ln_valid <= r_1 @[softmax_pre.scala 49:17]
    node _T_22 = bits(io.max_first, 0, 0) @[softmax_pre.scala 51:23]
    when _T_22 : @[softmax_pre.scala 51:30]
      max_reg <= io.in @[softmax_pre.scala 52:17]
    node _T_23 = bits(io.max_en, 0, 0) @[softmax_pre.scala 54:20]
    when _T_23 : @[softmax_pre.scala 54:27]
      max_reg <= max_pre @[softmax_pre.scala 55:17]
    node _T_24 = bits(io.rd_sum, 0, 0) @[softmax_pre.scala 57:20]
    node _T_25 = bits(io.rd_ln, 0, 0) @[softmax_pre.scala 57:39]
    node _T_26 = or(_T_24, _T_25) @[softmax_pre.scala 57:27]
    when _T_26 : @[softmax_pre.scala 57:46]
      ln_reg <= io.add_res @[softmax_pre.scala 58:16]
    reg r_2 : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= io_out @[Reg.scala 16:23]
    io.out <= r_2 @[softmax_pre.scala 66:16]
    node _T_27 = eq(io.state, UInt<3>("h3")) @[softmax_pre.scala 67:51]
    node _T_28 = mux(_T_27, io_ln_valid, io.last_in) @[softmax_pre.scala 67:41]
    reg r_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= _T_28 @[Reg.scala 16:23]
    io.last_out <= r_3 @[softmax_pre.scala 67:21]

  module Softmax_control :
    input clock : Clock
    input reset : Reset
    output io : { flip softmax : UInt<1>, flip start : UInt<1>, flip src_last : UInt<1>, flip cpt_last : UInt<1>, state : UInt<3>, max_first : UInt<1>, max_en : UInt<1>, rd_sum : UInt<1>, rd_ln : UInt<1>, accum : UInt<1>, compute_select : UInt<1>}

    reg max_first : UInt<1>, clock with :
      reset => (UInt<1>("h0"), max_first) @[softamx_control.scala 21:24]
    reg max_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), max_en) @[softamx_control.scala 22:21]
    reg rd_sum : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rd_sum) @[softamx_control.scala 23:21]
    reg rd_ln : UInt<1>, clock with :
      reset => (UInt<1>("h0"), rd_ln) @[softamx_control.scala 24:20]
    reg accum : UInt<1>, clock with :
      reset => (UInt<1>("h0"), accum) @[softamx_control.scala 25:20]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[softamx_control.scala 26:24]
    reg compute_select : UInt<1>, clock with :
      reset => (UInt<1>("h0"), compute_select) @[softamx_control.scala 27:29]
    io.max_first <= max_first @[softamx_control.scala 29:18]
    io.max_en <= max_en @[softamx_control.scala 30:15]
    io.rd_ln <= rd_ln @[softamx_control.scala 31:14]
    io.rd_sum <= rd_sum @[softamx_control.scala 32:15]
    io.accum <= accum @[softamx_control.scala 33:14]
    io.state <= state @[softamx_control.scala 34:14]
    node _T = eq(UInt<3>("h0"), state) @[Conditional.scala 37:30]
    when _T : @[Conditional.scala 40:58]
      max_first <= UInt<1>("h0") @[softamx_control.scala 38:23]
      max_en <= UInt<1>("h0") @[softamx_control.scala 39:20]
      rd_ln <= UInt<1>("h0") @[softamx_control.scala 40:19]
      rd_sum <= UInt<1>("h0") @[softamx_control.scala 41:20]
      accum <= UInt<1>("h0") @[softamx_control.scala 42:19]
      node _T_1 = bits(io.softmax, 0, 0) @[softamx_control.scala 43:29]
      node _T_2 = bits(io.start, 0, 0) @[softamx_control.scala 43:48]
      node _T_3 = and(_T_1, _T_2) @[softamx_control.scala 43:36]
      when _T_3 : @[softamx_control.scala 43:55]
        state <= UInt<3>("h1") @[softamx_control.scala 44:23]
        max_first <= UInt<1>("h1") @[softamx_control.scala 45:27]
    else :
      node _T_4 = eq(UInt<3>("h1"), state) @[Conditional.scala 37:30]
      when _T_4 : @[Conditional.scala 39:67]
        max_first <= UInt<1>("h0") @[softamx_control.scala 49:23]
        max_en <= UInt<1>("h1") @[softamx_control.scala 50:20]
        node _T_5 = bits(io.src_last, 0, 0) @[softamx_control.scala 51:30]
        when _T_5 : @[softamx_control.scala 51:37]
          state <= UInt<3>("h2") @[softamx_control.scala 52:23]
      else :
        node _T_6 = eq(UInt<3>("h2"), state) @[Conditional.scala 37:30]
        when _T_6 : @[Conditional.scala 39:67]
          max_en <= UInt<1>("h0") @[softamx_control.scala 56:20]
          node _T_7 = bits(io.cpt_last, 0, 0) @[softamx_control.scala 57:30]
          when _T_7 : @[softamx_control.scala 57:37]
            state <= UInt<3>("h3") @[softamx_control.scala 58:23]
            rd_sum <= UInt<1>("h1") @[softamx_control.scala 59:24]
            compute_select <= UInt<1>("h1") @[softamx_control.scala 60:32]
        else :
          node _T_8 = eq(UInt<3>("h3"), state) @[Conditional.scala 37:30]
          when _T_8 : @[Conditional.scala 39:67]
            rd_sum <= UInt<1>("h0") @[softamx_control.scala 64:20]
            node _T_9 = bits(io.cpt_last, 0, 0) @[softamx_control.scala 65:30]
            when _T_9 : @[softamx_control.scala 65:37]
              state <= UInt<3>("h4") @[softamx_control.scala 66:23]
              io.rd_ln <= UInt<1>("h1") @[softamx_control.scala 67:26]
              compute_select <= UInt<1>("h0") @[softamx_control.scala 68:32]
          else :
            node _T_10 = eq(UInt<3>("h4"), state) @[Conditional.scala 37:30]
            when _T_10 : @[Conditional.scala 39:67]
              rd_ln <= UInt<1>("h0") @[softamx_control.scala 72:19]
              node _T_11 = bits(io.cpt_last, 0, 0) @[softamx_control.scala 73:30]
              when _T_11 : @[softamx_control.scala 73:37]
                state <= UInt<3>("h0") @[softamx_control.scala 74:23]
    node _T_12 = eq(state, UInt<3>("h2")) @[softamx_control.scala 78:37]
    reg r : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_12 @[Reg.scala 16:23]
    reg r_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= r @[Reg.scala 16:23]
    reg r_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= r_1 @[Reg.scala 16:23]
    reg r_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= r_2 @[Reg.scala 16:23]
    node _T_13 = eq(state, UInt<3>("h2")) @[softamx_control.scala 78:66]
    node _T_14 = and(r_3, _T_13) @[softamx_control.scala 78:56]
    io.accum <= _T_14 @[softamx_control.scala 78:14]
    io.compute_select <= compute_select @[softamx_control.scala 79:23]

  module Sym :
    input clock : Clock
    input reset : Reset
    output io : { flip in : SInt<12>, flip select1 : UInt<1>, flip select2 : UInt<1>, flip sign : UInt<1>, out : SInt<12>}

    node _T = or(io.sign, io.select2) @[sym.scala 20:36]
    node _T_1 = bits(_T, 0, 0) @[sym.scala 20:50]
    node _T_2 = bits(io.select1, 0, 0) @[sym.scala 20:78]
    node _T_3 = mux(_T_2, io.in, asSInt(UInt<2>("h1"))) @[sym.scala 20:66]
    node _T_4 = mux(_T_1, asSInt(UInt<1>("h0")), _T_3) @[sym.scala 20:26]
    reg r : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_4 @[Reg.scala 16:23]
    reg r_1 : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= r @[Reg.scala 16:23]
    reg r_2 : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= r_1 @[Reg.scala 16:23]
    reg r_3 : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= r_2 @[Reg.scala 16:23]
    reg r_4 : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r_4) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_4 <= r_3 @[Reg.scala 16:23]
    io.out <= r_4 @[sym.scala 21:16]

  module lut :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<13>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module lut_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<10>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module lut_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<12>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module lut_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<13>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module lut_4 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<10>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module lut_5 :
    input clock : Clock
    input reset : Reset
    output io : { flip dpra : UInt<4>, dpo : SInt<12>}

    node _T = eq(io.dpra, UInt<1>("h0")) @[IP.scala 36:41]
    node _T_1 = asSInt(io.dpra) @[IP.scala 36:63]
    node _T_2 = mux(_T, asSInt(UInt<2>("h1")), _T_1) @[IP.scala 36:32]
    reg r : SInt<4>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_2 @[Reg.scala 16:23]
    io.dpo <= r @[IP.scala 36:12]

  module DSP :
    input clock : Clock
    input reset : Reset
    output io : { flip dsp_A : SInt<10>, flip dsp_B : SInt<8>, flip dsp_C : SInt<18>, dsp_P : SInt<18>}

    reg out : SInt<18>, clock with :
      reset => (UInt<1>("h0"), out) @[IP.scala 47:18]
    node _T = mul(io.dsp_A, io.dsp_B) @[IP.scala 48:21]
    node _T_1 = add(_T, io.dsp_C) @[IP.scala 48:32]
    node _T_2 = tail(_T_1, 1) @[IP.scala 48:32]
    node _T_3 = asSInt(_T_2) @[IP.scala 48:32]
    out <= _T_3 @[IP.scala 48:9]
    io.dsp_P <= out @[IP.scala 49:14]

  module Softmax_compute :
    input clock : Clock
    input reset : Reset
    output io : { flip in : SInt<12>, flip select : UInt<1>, flip last_in : UInt<1>, out : SInt<12>, last_out : UInt<1>}

    node _T = bits(io.in, 7, 0) @[softmax_compute.scala 29:37]
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
    node coarse_address = bits(io.in, 10, 7) @[softmax_compute.scala 30:31]
    wire fine_address1 : UInt<1> @[softmax_compute.scala 33:29]
    node _T_1 = bits(io.in, 6, 6) @[softmax_compute.scala 37:31]
    fine_address1 <= _T_1 @[softmax_compute.scala 37:23]
    inst lut_a1 of lut @[softmax_compute.scala 41:24]
    lut_a1.clock <= clock
    lut_a1.reset <= reset
    lut_a1.io.dpra <= coarse_address @[softmax_compute.scala 42:20]
    reg kb_address1 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[softmax_compute.scala 44:30]
    node _T_2 = eq(fine_address1, UInt<1>("h0")) @[softmax_compute.scala 46:29]
    when _T_2 : @[softmax_compute.scala 46:44]
      node _T_3 = bits(lut_a1.io.dpo, 3, 0) @[softmax_compute.scala 47:38]
      kb_address1 <= _T_3 @[softmax_compute.scala 47:25]
    node _T_4 = eq(fine_address1, UInt<1>("h1")) @[softmax_compute.scala 46:29]
    when _T_4 : @[softmax_compute.scala 46:44]
      node _T_5 = bits(lut_a1.io.dpo, 7, 4) @[softmax_compute.scala 47:38]
      kb_address1 <= _T_5 @[softmax_compute.scala 47:25]
    inst lut_k1 of lut_1 @[softmax_compute.scala 50:24]
    lut_k1.clock <= clock
    lut_k1.reset <= reset
    lut_k1.io.dpra <= kb_address1 @[softmax_compute.scala 51:20]
    inst lut_b1 of lut_2 @[softmax_compute.scala 52:24]
    lut_b1.clock <= clock
    lut_b1.reset <= reset
    lut_b1.io.dpra <= kb_address1 @[softmax_compute.scala 53:20]
    wire fine_address2 : UInt<1> @[softmax_compute.scala 55:29]
    node _T_6 = bits(io.in, 6, 6) @[softmax_compute.scala 59:31]
    fine_address2 <= _T_6 @[softmax_compute.scala 59:23]
    inst lut_a2 of lut_3 @[softmax_compute.scala 63:24]
    lut_a2.clock <= clock
    lut_a2.reset <= reset
    lut_a2.io.dpra <= coarse_address @[softmax_compute.scala 64:20]
    reg kb_address2 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[softmax_compute.scala 66:30]
    node _T_7 = eq(fine_address2, UInt<1>("h0")) @[softmax_compute.scala 68:29]
    when _T_7 : @[softmax_compute.scala 68:44]
      node _T_8 = bits(lut_a2.io.dpo, 3, 0) @[softmax_compute.scala 69:38]
      kb_address2 <= _T_8 @[softmax_compute.scala 69:25]
    node _T_9 = eq(fine_address2, UInt<1>("h1")) @[softmax_compute.scala 68:29]
    when _T_9 : @[softmax_compute.scala 68:44]
      node _T_10 = bits(lut_a2.io.dpo, 7, 4) @[softmax_compute.scala 69:38]
      kb_address2 <= _T_10 @[softmax_compute.scala 69:25]
    inst lut_k2 of lut_4 @[softmax_compute.scala 72:24]
    lut_k2.clock <= clock
    lut_k2.reset <= reset
    lut_k2.io.dpra <= kb_address2 @[softmax_compute.scala 73:20]
    inst lut_b2 of lut_5 @[softmax_compute.scala 74:24]
    lut_b2.clock <= clock
    lut_b2.reset <= reset
    lut_b2.io.dpra <= kb_address2 @[softmax_compute.scala 75:20]
    inst dsp of DSP @[softmax_compute.scala 78:21]
    dsp.clock <= clock
    dsp.reset <= reset
    node _T_11 = bits(io.select, 0, 0) @[softmax_compute.scala 79:35]
    node _T_12 = mux(_T_11, lut_k1.io.dpo, lut_k2.io.dpo) @[softmax_compute.scala 79:24]
    dsp.io.dsp_A <= _T_12 @[softmax_compute.scala 79:18]
    node _T_13 = asSInt(digits) @[softmax_compute.scala 80:28]
    dsp.io.dsp_B <= _T_13 @[softmax_compute.scala 80:18]
    node _T_14 = bits(io.select, 0, 0) @[softmax_compute.scala 81:35]
    node _T_15 = mux(_T_14, lut_b1.io.dpo, lut_b2.io.dpo) @[softmax_compute.scala 81:24]
    node _T_16 = shl(_T_15, 6) @[softmax_compute.scala 81:73]
    dsp.io.dsp_C <= _T_16 @[softmax_compute.scala 81:18]
    node _T_17 = shr(dsp.io.dsp_P, 6) @[softmax_compute.scala 84:32]
    io.out <= _T_17 @[softmax_compute.scala 84:16]
    reg r_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= io.last_in @[Reg.scala 16:23]
    reg r_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= r_2 @[Reg.scala 16:23]
    reg r_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_4) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_4 <= r_3 @[Reg.scala 16:23]
    io.last_out <= r_4 @[softmax_compute.scala 88:17]

  module Softmax_axis :
    input clock : Clock
    input reset : Reset
    output io : { flip in : SInt<12>, flip sign : UInt<1>, flip select1 : UInt<1>, flip last_in : UInt<1>, out : SInt<12>, last_out : UInt<1>}

    node _T = not(io.in) @[softmax_axis.scala 17:16]
    node _T_1 = asSInt(_T) @[softmax_axis.scala 17:16]
    node _T_2 = add(_T_1, asSInt(UInt<2>("h1"))) @[softmax_axis.scala 17:23]
    node _T_3 = tail(_T_2, 1) @[softmax_axis.scala 17:23]
    node oppo = asSInt(_T_3) @[softmax_axis.scala 17:23]
    node _T_4 = eq(io.sign, UInt<1>("h0")) @[softmax_axis.scala 24:38]
    node _T_5 = eq(io.select1, UInt<1>("h0")) @[softmax_axis.scala 24:49]
    node _T_6 = and(_T_4, _T_5) @[softmax_axis.scala 24:47]
    node _T_7 = bits(_T_6, 0, 0) @[softmax_axis.scala 24:62]
    node _T_8 = mux(_T_7, oppo, io.in) @[softmax_axis.scala 24:36]
    reg r : SInt<12>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_8 @[Reg.scala 16:23]
    io.out <= r @[softmax_axis.scala 24:16]
    reg r_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= io.last_in @[Reg.scala 16:23]
    io.last_out <= r_1 @[softmax_axis.scala 25:21]

  module Softmax_addr :
    input clock : Clock
    input reset : Reset
    output io : { flip in1 : SInt<12>, flip in2 : SInt<12>, flip accum : UInt<1>, flip last_in : UInt<1>, out : SInt<12>, last_out : UInt<1>}

    reg out_reg : SInt<12>, clock with :
      reset => (UInt<1>("h0"), out_reg) @[softmax_addr.scala 19:22]
    node _T = bits(io.accum, 0, 0) @[softmax_addr.scala 20:29]
    node _T_1 = add(io.in1, out_reg) @[softmax_addr.scala 20:44]
    node _T_2 = tail(_T_1, 1) @[softmax_addr.scala 20:44]
    node _T_3 = asSInt(_T_2) @[softmax_addr.scala 20:44]
    node _T_4 = add(io.in1, io.in2) @[softmax_addr.scala 20:62]
    node _T_5 = tail(_T_4, 1) @[softmax_addr.scala 20:62]
    node _T_6 = asSInt(_T_5) @[softmax_addr.scala 20:62]
    node _T_7 = mux(_T, _T_3, _T_6) @[softmax_addr.scala 20:19]
    out_reg <= _T_7 @[softmax_addr.scala 20:13]
    io.out <= out_reg @[softmax_addr.scala 21:12]
    reg r : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= io.last_in @[Reg.scala 16:23]
    io.last_out <= r @[softmax_addr.scala 22:17]

  module softmax_top :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip in : SInt<12>, flip select1 : UInt<1>, flip select2 : UInt<1>, flip softmax : UInt<1>, flip start : UInt<1>, flip last : UInt<1>, out : SInt<12>}

    inst pre_module of Softmax_pre @[softmax_top.scala 22:28]
    pre_module.clock <= clock
    pre_module.reset <= reset
    inst control_module of Softmax_control @[softmax_top.scala 23:32]
    control_module.clock <= clock
    control_module.reset <= reset
    inst sym_module of Sym @[softmax_top.scala 24:28]
    sym_module.clock <= clock
    sym_module.reset <= reset
    inst compute_module of Softmax_compute @[softmax_top.scala 25:32]
    compute_module.clock <= clock
    compute_module.reset <= reset
    inst axis_module of Softmax_axis @[softmax_top.scala 26:29]
    axis_module.clock <= clock
    axis_module.reset <= reset
    inst addr_module of Softmax_addr @[softmax_top.scala 27:29]
    addr_module.clock <= clock
    addr_module.reset <= reset
    control_module.io.softmax <= io.softmax @[softmax_top.scala 29:31]
    control_module.io.start <= io.start @[softmax_top.scala 30:29]
    control_module.io.src_last <= io.last @[softmax_top.scala 31:32]
    control_module.io.cpt_last <= addr_module.io.last_out @[softmax_top.scala 32:32]
    pre_module.io.in <= io.in @[softmax_top.scala 34:22]
    pre_module.io.state <= control_module.io.state @[softmax_top.scala 35:25]
    pre_module.io.add_res <= addr_module.io.out @[softmax_top.scala 36:27]
    pre_module.io.last_in <= io.last @[softmax_top.scala 37:27]
    pre_module.io.max_first <= control_module.io.max_first @[softmax_top.scala 38:29]
    pre_module.io.max_en <= control_module.io.max_en @[softmax_top.scala 39:26]
    pre_module.io.rd_sum <= control_module.io.rd_sum @[softmax_top.scala 40:26]
    pre_module.io.rd_ln <= control_module.io.rd_ln @[softmax_top.scala 41:25]
    sym_module.io.in <= io.in @[softmax_top.scala 43:22]
    sym_module.io.select1 <= io.select1 @[softmax_top.scala 44:27]
    sym_module.io.select2 <= io.select2 @[softmax_top.scala 45:27]
    node _T = bits(io.in, 11, 11) @[softmax_top.scala 46:32]
    sym_module.io.sign <= _T @[softmax_top.scala 46:24]
    compute_module.io.in <= pre_module.io.out @[softmax_top.scala 48:26]
    compute_module.io.select <= control_module.io.compute_select @[softmax_top.scala 49:30]
    compute_module.io.last_in <= pre_module.io.last_out @[softmax_top.scala 50:31]
    axis_module.io.in <= compute_module.io.out @[softmax_top.scala 52:23]
    axis_module.io.last_in <= compute_module.io.last_out @[softmax_top.scala 53:28]
    node _T_1 = bits(io.in, 11, 11) @[softmax_top.scala 54:47]
    reg r : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= _T_1 @[Reg.scala 16:23]
    reg r_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_1) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_1 <= r @[Reg.scala 16:23]
    reg r_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_2) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_2 <= r_1 @[Reg.scala 16:23]
    reg r_3 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_3) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_3 <= r_2 @[Reg.scala 16:23]
    axis_module.io.sign <= r_3 @[softmax_top.scala 54:25]
    reg r_4 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_4) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_4 <= io.select1 @[Reg.scala 16:23]
    reg r_5 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_5) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_5 <= r_4 @[Reg.scala 16:23]
    reg r_6 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_6) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_6 <= r_5 @[Reg.scala 16:23]
    reg r_7 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), r_7) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r_7 <= r_6 @[Reg.scala 16:23]
    axis_module.io.select1 <= r_7 @[softmax_top.scala 55:28]
    addr_module.io.in1 <= sym_module.io.out @[softmax_top.scala 57:24]
    addr_module.io.in2 <= axis_module.io.out @[softmax_top.scala 58:24]
    addr_module.io.accum <= control_module.io.accum @[softmax_top.scala 59:26]
    addr_module.io.last_in <= axis_module.io.last_out @[softmax_top.scala 60:28]
    io.out <= addr_module.io.out @[softmax_top.scala 62:12]

