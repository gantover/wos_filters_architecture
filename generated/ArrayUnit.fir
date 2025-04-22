circuit ArrayUnit :
  module RankUpdateUnit :
    input clock : Clock
    input reset : Reset
    output io : { flip s : UInt<3>, flip u : UInt<1>, flip df : SInt<5>[2], flip fp0 : UInt<4>, flip fpkm1 : UInt<4>, flip r_old : UInt<4>, r_new : UInt<4>}

    node _Df_T = bits(io.s, 0, 0) @[array.scala 20:23]
    node _Df_T_1 = eq(_Df_T, UInt<1>("h1")) @[array.scala 20:27]
    node _Df_T_2 = mux(_Df_T_1, io.df[0], asSInt(UInt<1>("h0"))) @[array.scala 20:18]
    node _Df_T_3 = add(asSInt(UInt<4>("h0")), _Df_T_2) @[array.scala 20:13]
    node _Df_T_4 = tail(_Df_T_3, 1) @[array.scala 20:13]
    node _Df_T_5 = asSInt(_Df_T_4) @[array.scala 20:13]
    node _Df_T_6 = bits(io.s, 1, 1) @[array.scala 20:23]
    node _Df_T_7 = eq(_Df_T_6, UInt<1>("h1")) @[array.scala 20:27]
    node _Df_T_8 = mux(_Df_T_7, io.df[1], asSInt(UInt<1>("h0"))) @[array.scala 20:18]
    node _Df_T_9 = add(_Df_T_5, _Df_T_8) @[array.scala 20:13]
    node _Df_T_10 = tail(_Df_T_9, 1) @[array.scala 20:13]
    node Df = asSInt(_Df_T_10) @[array.scala 20:13]
    node _io_r_new_T = eq(io.u, UInt<1>("h1")) @[array.scala 24:39]
    node _io_r_new_T_1 = mux(_io_r_new_T, io.fp0, UInt<1>("h0")) @[array.scala 24:33]
    node _io_r_new_T_2 = add(io.r_old, _io_r_new_T_1) @[array.scala 24:28]
    node _io_r_new_T_3 = tail(_io_r_new_T_2, 1) @[array.scala 24:28]
    node _io_r_new_T_4 = bits(io.s, 2, 2) @[array.scala 24:71]
    node _io_r_new_T_5 = eq(_io_r_new_T_4, UInt<1>("h1")) @[array.scala 24:77]
    node _io_r_new_T_6 = mux(_io_r_new_T_5, io.fpkm1, UInt<1>("h0")) @[array.scala 24:66]
    node _io_r_new_T_7 = sub(_io_r_new_T_3, _io_r_new_T_6) @[array.scala 24:61]
    node _io_r_new_T_8 = tail(_io_r_new_T_7, 1) @[array.scala 24:61]
    node _io_r_new_T_9 = asSInt(_io_r_new_T_8) @[array.scala 24:102]
    node _io_r_new_T_10 = add(_io_r_new_T_9, Df) @[array.scala 24:109]
    node _io_r_new_T_11 = tail(_io_r_new_T_10, 1) @[array.scala 24:109]
    node _io_r_new_T_12 = asSInt(_io_r_new_T_11) @[array.scala 24:109]
    node _io_r_new_T_13 = asUInt(_io_r_new_T_12) @[array.scala 24:115]
    io.r_new <= _io_r_new_T_13 @[array.scala 24:14]

  module Processor :
    input clock : Clock
    input reset : Reset
    output io : { flip R : UInt<4>, flip x_new : UInt<4>, flip r_in : UInt<4>, flip s_in : UInt<3>, flip a_in : UInt<4>, r_out : UInt<4>, s_out : UInt<3>, a_out : UInt<4>, u : UInt<1>, res : UInt<1>}

    reg r : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 97:20]
    reg s : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[array.scala 98:20]
    reg a : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 99:20]
    a <= io.a_in @[array.scala 101:7]
    inst ruu of RankUpdateUnit @[array.scala 103:21]
    ruu.clock <= clock
    ruu.reset <= reset
    node _T = sub(asSInt(UInt<5>("h4")), asSInt(UInt<5>("h4"))) @[array.scala 108:44]
    node _T_1 = tail(_T, 1) @[array.scala 108:44]
    node _T_2 = asSInt(_T_1) @[array.scala 108:44]
    node _T_3 = sub(asSInt(UInt<5>("h2")), asSInt(UInt<5>("h4"))) @[array.scala 108:44]
    node _T_4 = tail(_T_3, 1) @[array.scala 108:44]
    node _T_5 = asSInt(_T_4) @[array.scala 108:44]
    wire _df_WIRE : SInt<5>[2] @[array.scala 111:29]
    _df_WIRE[0] <= _T_2 @[array.scala 111:29]
    _df_WIRE[1] <= _T_5 @[array.scala 111:29]
    reg df : SInt<5>[2], clock with :
      reset => (reset, _df_WIRE) @[array.scala 111:21]
    reg f : UInt<4>, clock with :
      reset => (reset, UInt<4>("h4")) @[array.scala 113:20]
    reg fp0 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h4")) @[array.scala 114:22]
    reg fpkm1 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h2")) @[array.scala 115:24]
    wire u : UInt<1> @[array.scala 119:17]
    node _u_T = geq(io.a_in, io.x_new) @[array.scala 120:22]
    node _u_T_1 = mux(_u_T, UInt<1>("h1"), UInt<1>("h0")) @[array.scala 120:13]
    u <= _u_T_1 @[array.scala 120:7]
    io.u <= u @[array.scala 121:10]
    ruu.io.s <= io.s_in @[array.scala 124:14]
    ruu.io.u <= u @[array.scala 125:14]
    ruu.io.df[0] <= df[0] @[array.scala 128:15]
    ruu.io.df[1] <= df[1] @[array.scala 128:15]
    ruu.io.fp0 <= fp0 @[array.scala 129:16]
    ruu.io.fpkm1 <= fpkm1 @[array.scala 130:18]
    ruu.io.r_old <= io.r_in @[array.scala 133:18]
    r <= ruu.io.r_new @[array.scala 135:7]
    node _s_T = bits(io.s_in, 1, 0) @[array.scala 139:21]
    node _s_T_1 = cat(_s_T, u) @[Cat.scala 31:58]
    s <= _s_T_1 @[array.scala 139:7]
    wire rmr : SInt<5> @[array.scala 142:19]
    node _rmr_T = asSInt(io.R) @[array.scala 143:17]
    node _rmr_T_1 = asSInt(r) @[array.scala 143:28]
    node _rmr_T_2 = sub(_rmr_T, _rmr_T_1) @[array.scala 143:24]
    node _rmr_T_3 = tail(_rmr_T_2, 1) @[array.scala 143:24]
    node _rmr_T_4 = asSInt(_rmr_T_3) @[array.scala 143:24]
    rmr <= _rmr_T_4 @[array.scala 143:9]
    node _io_res_T = geq(rmr, asSInt(UInt<1>("h0"))) @[array.scala 144:20]
    node _io_res_T_1 = asSInt(f) @[array.scala 144:38]
    node _io_res_T_2 = lt(rmr, _io_res_T_1) @[array.scala 144:34]
    node _io_res_T_3 = and(_io_res_T, _io_res_T_2) @[array.scala 144:27]
    io.res <= _io_res_T_3 @[array.scala 144:12]
    io.r_out <= r @[array.scala 147:14]
    io.s_out <= s @[array.scala 148:14]
    io.a_out <= a @[array.scala 149:14]

  module RankUpdateUnit_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip s : UInt<3>, flip u : UInt<1>, flip df : SInt<5>[2], flip fp0 : UInt<4>, flip fpkm1 : UInt<4>, flip r_old : UInt<4>, r_new : UInt<4>}

    node _Df_T = bits(io.s, 0, 0) @[array.scala 20:23]
    node _Df_T_1 = eq(_Df_T, UInt<1>("h1")) @[array.scala 20:27]
    node _Df_T_2 = mux(_Df_T_1, io.df[0], asSInt(UInt<1>("h0"))) @[array.scala 20:18]
    node _Df_T_3 = add(asSInt(UInt<4>("h0")), _Df_T_2) @[array.scala 20:13]
    node _Df_T_4 = tail(_Df_T_3, 1) @[array.scala 20:13]
    node _Df_T_5 = asSInt(_Df_T_4) @[array.scala 20:13]
    node _Df_T_6 = bits(io.s, 1, 1) @[array.scala 20:23]
    node _Df_T_7 = eq(_Df_T_6, UInt<1>("h1")) @[array.scala 20:27]
    node _Df_T_8 = mux(_Df_T_7, io.df[1], asSInt(UInt<1>("h0"))) @[array.scala 20:18]
    node _Df_T_9 = add(_Df_T_5, _Df_T_8) @[array.scala 20:13]
    node _Df_T_10 = tail(_Df_T_9, 1) @[array.scala 20:13]
    node Df = asSInt(_Df_T_10) @[array.scala 20:13]
    node _io_r_new_T = eq(io.u, UInt<1>("h1")) @[array.scala 24:39]
    node _io_r_new_T_1 = mux(_io_r_new_T, io.fp0, UInt<1>("h0")) @[array.scala 24:33]
    node _io_r_new_T_2 = add(io.r_old, _io_r_new_T_1) @[array.scala 24:28]
    node _io_r_new_T_3 = tail(_io_r_new_T_2, 1) @[array.scala 24:28]
    node _io_r_new_T_4 = bits(io.s, 2, 2) @[array.scala 24:71]
    node _io_r_new_T_5 = eq(_io_r_new_T_4, UInt<1>("h1")) @[array.scala 24:77]
    node _io_r_new_T_6 = mux(_io_r_new_T_5, io.fpkm1, UInt<1>("h0")) @[array.scala 24:66]
    node _io_r_new_T_7 = sub(_io_r_new_T_3, _io_r_new_T_6) @[array.scala 24:61]
    node _io_r_new_T_8 = tail(_io_r_new_T_7, 1) @[array.scala 24:61]
    node _io_r_new_T_9 = asSInt(_io_r_new_T_8) @[array.scala 24:102]
    node _io_r_new_T_10 = add(_io_r_new_T_9, Df) @[array.scala 24:109]
    node _io_r_new_T_11 = tail(_io_r_new_T_10, 1) @[array.scala 24:109]
    node _io_r_new_T_12 = asSInt(_io_r_new_T_11) @[array.scala 24:109]
    node _io_r_new_T_13 = asUInt(_io_r_new_T_12) @[array.scala 24:115]
    io.r_new <= _io_r_new_T_13 @[array.scala 24:14]

  module Processor_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip R : UInt<4>, flip x_new : UInt<4>, flip r_in : UInt<4>, flip s_in : UInt<3>, flip a_in : UInt<4>, r_out : UInt<4>, s_out : UInt<3>, a_out : UInt<4>, u : UInt<1>, res : UInt<1>}

    reg r : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 97:20]
    reg s : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[array.scala 98:20]
    reg a : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 99:20]
    a <= io.a_in @[array.scala 101:7]
    inst ruu of RankUpdateUnit_1 @[array.scala 103:21]
    ruu.clock <= clock
    ruu.reset <= reset
    node _T = sub(asSInt(UInt<5>("h4")), asSInt(UInt<5>("h4"))) @[array.scala 108:44]
    node _T_1 = tail(_T, 1) @[array.scala 108:44]
    node _T_2 = asSInt(_T_1) @[array.scala 108:44]
    node _T_3 = sub(asSInt(UInt<5>("h2")), asSInt(UInt<5>("h4"))) @[array.scala 108:44]
    node _T_4 = tail(_T_3, 1) @[array.scala 108:44]
    node _T_5 = asSInt(_T_4) @[array.scala 108:44]
    wire _df_WIRE : SInt<5>[2] @[array.scala 111:29]
    _df_WIRE[0] <= _T_2 @[array.scala 111:29]
    _df_WIRE[1] <= _T_5 @[array.scala 111:29]
    reg df : SInt<5>[2], clock with :
      reset => (reset, _df_WIRE) @[array.scala 111:21]
    reg f : UInt<4>, clock with :
      reset => (reset, UInt<4>("h2")) @[array.scala 113:20]
    reg fp0 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h4")) @[array.scala 114:22]
    reg fpkm1 : UInt<4>, clock with :
      reset => (reset, UInt<4>("h2")) @[array.scala 115:24]
    wire u : UInt<1> @[array.scala 119:17]
    node _u_T = geq(io.a_in, io.x_new) @[array.scala 120:22]
    node _u_T_1 = mux(_u_T, UInt<1>("h1"), UInt<1>("h0")) @[array.scala 120:13]
    u <= _u_T_1 @[array.scala 120:7]
    io.u <= u @[array.scala 121:10]
    ruu.io.s <= io.s_in @[array.scala 124:14]
    ruu.io.u <= u @[array.scala 125:14]
    ruu.io.df[0] <= df[0] @[array.scala 128:15]
    ruu.io.df[1] <= df[1] @[array.scala 128:15]
    ruu.io.fp0 <= fp0 @[array.scala 129:16]
    ruu.io.fpkm1 <= fpkm1 @[array.scala 130:18]
    ruu.io.r_old <= io.r_in @[array.scala 133:18]
    r <= ruu.io.r_new @[array.scala 135:7]
    node _s_T = bits(io.s_in, 1, 0) @[array.scala 139:21]
    node _s_T_1 = cat(_s_T, u) @[Cat.scala 31:58]
    s <= _s_T_1 @[array.scala 139:7]
    wire rmr : SInt<5> @[array.scala 142:19]
    node _rmr_T = asSInt(io.R) @[array.scala 143:17]
    node _rmr_T_1 = asSInt(r) @[array.scala 143:28]
    node _rmr_T_2 = sub(_rmr_T, _rmr_T_1) @[array.scala 143:24]
    node _rmr_T_3 = tail(_rmr_T_2, 1) @[array.scala 143:24]
    node _rmr_T_4 = asSInt(_rmr_T_3) @[array.scala 143:24]
    rmr <= _rmr_T_4 @[array.scala 143:9]
    node _io_res_T = geq(rmr, asSInt(UInt<1>("h0"))) @[array.scala 144:20]
    node _io_res_T_1 = asSInt(f) @[array.scala 144:38]
    node _io_res_T_2 = lt(rmr, _io_res_T_1) @[array.scala 144:34]
    node _io_res_T_3 = and(_io_res_T, _io_res_T_2) @[array.scala 144:27]
    io.res <= _io_res_T_3 @[array.scala 144:12]
    io.r_out <= r @[array.scala 147:14]
    io.s_out <= s @[array.scala 148:14]
    io.a_out <= a @[array.scala 149:14]

  module Processor0 :
    input clock : Clock
    input reset : Reset
    output io : { flip x_new : UInt<4>, flip x_old : UInt<4>, flip R : UInt<4>, flip u : UInt<2>, r_out : UInt<4>, s_out : UInt<3>, a_out : UInt<4>, res : UInt<1>}

    reg r : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 42:20]
    reg s : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[array.scala 43:20]
    reg a : UInt<4>, clock with :
      reset => (reset, UInt<4>("h0")) @[array.scala 44:20]
    a <= io.x_new @[array.scala 46:7]
    node _acc_T = bits(io.u, 0, 0) @[array.scala 52:23]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[array.scala 52:27]
    node _acc_T_2 = mux(_acc_T_1, UInt<4>("h4"), UInt<4>("h0")) @[array.scala 52:18]
    node _acc_T_3 = add(UInt<4>("h0"), _acc_T_2) @[array.scala 52:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[array.scala 52:13]
    node _acc_T_5 = bits(io.u, 1, 1) @[array.scala 52:23]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[array.scala 52:27]
    node _acc_T_7 = mux(_acc_T_6, UInt<4>("h2"), UInt<4>("h0")) @[array.scala 52:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[array.scala 52:13]
    node acc = tail(_acc_T_8, 1) @[array.scala 52:13]
    node _r_T = add(UInt<1>("h1"), acc) @[array.scala 54:14]
    node _r_T_1 = tail(_r_T, 1) @[array.scala 54:14]
    r <= _r_T_1 @[array.scala 54:7]
    node _s_new_T = bits(io.u, 0, 0) @[array.scala 57:53]
    node _s_new_T_1 = eq(_s_new_T, UInt<1>("h0")) @[array.scala 57:48]
    node _s_new_T_2 = bits(io.u, 1, 1) @[array.scala 57:53]
    node _s_new_T_3 = eq(_s_new_T_2, UInt<1>("h0")) @[array.scala 57:48]
    wire s_new : UInt<1>[2] @[array.scala 57:24]
    s_new[0] <= _s_new_T_1 @[array.scala 57:24]
    s_new[1] <= _s_new_T_3 @[array.scala 57:24]
    node _s_T = cat(s_new[1], s_new[0]) @[array.scala 60:16]
    node _s_T_1 = cat(_s_T, UInt<1>("h0")) @[array.scala 60:23]
    s <= _s_T_1 @[array.scala 60:7]
    wire rmr : SInt<5> @[array.scala 63:19]
    node _rmr_T = asSInt(io.R) @[array.scala 64:17]
    node _rmr_T_1 = asSInt(r) @[array.scala 64:28]
    node _rmr_T_2 = sub(_rmr_T, _rmr_T_1) @[array.scala 64:24]
    node _rmr_T_3 = tail(_rmr_T_2, 1) @[array.scala 64:24]
    node _rmr_T_4 = asSInt(_rmr_T_3) @[array.scala 64:24]
    rmr <= _rmr_T_4 @[array.scala 64:9]
    node _io_res_T = geq(rmr, asSInt(UInt<1>("h0"))) @[array.scala 65:20]
    node _io_res_T_1 = lt(rmr, asSInt(UInt<4>("h4"))) @[array.scala 65:34]
    node _io_res_T_2 = and(_io_res_T, _io_res_T_1) @[array.scala 65:27]
    io.res <= _io_res_T_2 @[array.scala 65:12]
    io.r_out <= r @[array.scala 68:14]
    io.s_out <= s @[array.scala 69:14]
    io.a_out <= a @[array.scala 70:14]

  module ArrayUnit :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip x : UInt<4>, y : UInt<4>, flip R : UInt<4>}

    inst Processor of Processor @[array.scala 159:50]
    Processor.clock <= clock
    Processor.reset <= reset
    inst Processor_1 of Processor_1 @[array.scala 159:50]
    Processor_1.clock <= clock
    Processor_1.reset <= reset
    inst p_0 of Processor0 @[array.scala 160:21]
    p_0.clock <= clock
    p_0.reset <= reset
    p_0.io.x_new <= io.x @[array.scala 162:18]
    p_0.io.R <= io.R @[array.scala 163:14]
    Processor.io.x_new <= io.x @[array.scala 169:25]
    Processor.io.r_in <= p_0.io.r_out @[array.scala 170:24]
    Processor.io.s_in <= p_0.io.s_out @[array.scala 171:24]
    Processor.io.a_in <= p_0.io.a_out @[array.scala 172:24]
    Processor.io.R <= io.R @[array.scala 179:21]
    Processor_1.io.x_new <= io.x @[array.scala 182:31]
    Processor_1.io.a_in <= Processor.io.a_out @[array.scala 183:30]
    Processor_1.io.s_in <= Processor.io.s_out @[array.scala 184:30]
    Processor_1.io.r_in <= Processor.io.r_out @[array.scala 185:30]
    Processor_1.io.R <= io.R @[array.scala 193:27]
    p_0.io.x_old <= Processor_1.io.a_out @[array.scala 196:18]
    wire u : UInt<2> @[array.scala 199:17]
    node _u_T = cat(Processor_1.io.u, Processor.io.u) @[Cat.scala 31:58]
    u <= _u_T @[array.scala 202:7]
    p_0.io.u <= u @[array.scala 203:14]
    node _T = bits(reset, 0, 0) @[array.scala 206:11]
    node _T_1 = eq(_T, UInt<1>("h0")) @[array.scala 206:11]
    when _T_1 : @[array.scala 206:11]
      printf(clock, UInt<1>("h1"), "u: %b\n", u) : printf @[array.scala 206:11]
    io.y <= UInt<1>("h0") @[array.scala 213:10]
    node _T_2 = eq(p_0.io.res, UInt<1>("h1")) @[array.scala 216:22]
    when _T_2 : @[array.scala 216:31]
      io.y <= p_0.io.a_out @[array.scala 217:14]
    else :
      node _T_3 = eq(Processor.io.res, UInt<1>("h1")) @[array.scala 221:37]
      when _T_3 : @[array.scala 221:46]
        io.y <= Processor.io.a_out @[array.scala 222:22]
      node _T_4 = eq(Processor_1.io.res, UInt<1>("h1")) @[array.scala 221:37]
      when _T_4 : @[array.scala 221:46]
        io.y <= Processor_1.io.a_out @[array.scala 222:22]

