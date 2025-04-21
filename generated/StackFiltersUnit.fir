circuit StackFiltersUnit :
  module ThresholdDecomposition :
    input clock : Clock
    input reset : Reset
    output io : { flip x : UInt<3>, out : UInt<7>}

    node _io_out_T = leq(UInt<1>("h1"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_1 = leq(UInt<2>("h2"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_2 = leq(UInt<2>("h3"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_3 = leq(UInt<3>("h4"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_4 = leq(UInt<3>("h5"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_5 = leq(UInt<3>("h6"), io.x) @[stack_filters.scala 13:57]
    node _io_out_T_6 = leq(UInt<3>("h7"), io.x) @[stack_filters.scala 13:57]
    wire _io_out_WIRE : UInt<1>[7] @[stack_filters.scala 13:20]
    _io_out_WIRE[0] <= _io_out_T @[stack_filters.scala 13:20]
    _io_out_WIRE[1] <= _io_out_T_1 @[stack_filters.scala 13:20]
    _io_out_WIRE[2] <= _io_out_T_2 @[stack_filters.scala 13:20]
    _io_out_WIRE[3] <= _io_out_T_3 @[stack_filters.scala 13:20]
    _io_out_WIRE[4] <= _io_out_T_4 @[stack_filters.scala 13:20]
    _io_out_WIRE[5] <= _io_out_T_5 @[stack_filters.scala 13:20]
    _io_out_WIRE[6] <= _io_out_T_6 @[stack_filters.scala 13:20]
    node io_out_lo_hi = cat(_io_out_WIRE[2], _io_out_WIRE[1]) @[stack_filters.scala 13:75]
    node io_out_lo = cat(io_out_lo_hi, _io_out_WIRE[0]) @[stack_filters.scala 13:75]
    node io_out_hi_lo = cat(_io_out_WIRE[4], _io_out_WIRE[3]) @[stack_filters.scala 13:75]
    node io_out_hi_hi = cat(_io_out_WIRE[6], _io_out_WIRE[5]) @[stack_filters.scala 13:75]
    node io_out_hi = cat(io_out_hi_hi, io_out_hi_lo) @[stack_filters.scala 13:75]
    node _io_out_T_7 = cat(io_out_hi, io_out_lo) @[stack_filters.scala 13:75]
    io.out <= _io_out_T_7 @[stack_filters.scala 13:10]

  module Regs :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_4 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_5 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module Regs_6 :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<1>, out : UInt<3>}

    reg regs : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[stack_filters.scala 39:23]
    node _regs_T = bits(regs, 2, 1) @[stack_filters.scala 42:28]
    node _regs_T_1 = cat(io.in, _regs_T) @[Cat.scala 31:58]
    regs <= _regs_T_1 @[stack_filters.scala 42:10]
    io.out <= regs @[stack_filters.scala 43:12]

  module BLL :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_4 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_5 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module BLL_6 :
    input clock : Clock
    input reset : Reset
    output io : { flip regs_in : UInt<3>, out : UInt<1>}

    wire acc : UInt<3> @[stack_filters.scala 52:19]
    acc <= UInt<1>("h0") @[stack_filters.scala 53:9]
    node _acc_T = bits(io.regs_in, 2, 2) @[stack_filters.scala 58:29]
    node _acc_T_1 = eq(_acc_T, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_2 = mux(_acc_T_1, UInt<3>("h1"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_3 = add(UInt<3>("h0"), _acc_T_2) @[stack_filters.scala 58:13]
    node _acc_T_4 = tail(_acc_T_3, 1) @[stack_filters.scala 58:13]
    node _acc_T_5 = bits(io.regs_in, 1, 1) @[stack_filters.scala 58:29]
    node _acc_T_6 = eq(_acc_T_5, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_7 = mux(_acc_T_6, UInt<3>("h2"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_8 = add(_acc_T_4, _acc_T_7) @[stack_filters.scala 58:13]
    node _acc_T_9 = tail(_acc_T_8, 1) @[stack_filters.scala 58:13]
    node _acc_T_10 = bits(io.regs_in, 0, 0) @[stack_filters.scala 58:29]
    node _acc_T_11 = eq(_acc_T_10, UInt<1>("h0")) @[stack_filters.scala 58:41]
    node _acc_T_12 = mux(_acc_T_11, UInt<3>("h3"), UInt<3>("h0")) @[stack_filters.scala 58:18]
    node _acc_T_13 = add(_acc_T_9, _acc_T_12) @[stack_filters.scala 58:13]
    node _acc_T_14 = tail(_acc_T_13, 1) @[stack_filters.scala 58:13]
    acc <= _acc_T_14 @[stack_filters.scala 57:9]
    node _io_out_T = lt(acc, UInt<3>("h4")) @[stack_filters.scala 60:20]
    io.out <= _io_out_T @[stack_filters.scala 60:12]

  module ThresholdRecomposition :
    input clock : Clock
    input reset : Reset
    output io : { flip in : UInt<7>, out : UInt<3>}

    node _T = bits(io.in, 6, 6) @[stack_filters.scala 69:15]
    node _T_1 = eq(_T, UInt<1>("h1")) @[stack_filters.scala 69:26]
    when _T_1 : @[stack_filters.scala 69:35]
      io.out <= UInt<3>("h7") @[stack_filters.scala 70:16]
    else :
      node _io_out_T = not(io.in) @[stack_filters.scala 72:35]
      node _io_out_T_1 = bits(_io_out_T, 0, 0) @[OneHot.scala 47:45]
      node _io_out_T_2 = bits(_io_out_T, 1, 1) @[OneHot.scala 47:45]
      node _io_out_T_3 = bits(_io_out_T, 2, 2) @[OneHot.scala 47:45]
      node _io_out_T_4 = bits(_io_out_T, 3, 3) @[OneHot.scala 47:45]
      node _io_out_T_5 = bits(_io_out_T, 4, 4) @[OneHot.scala 47:45]
      node _io_out_T_6 = bits(_io_out_T, 5, 5) @[OneHot.scala 47:45]
      node _io_out_T_7 = bits(_io_out_T, 6, 6) @[OneHot.scala 47:45]
      node _io_out_T_8 = mux(_io_out_T_6, UInt<3>("h5"), UInt<3>("h6")) @[Mux.scala 47:70]
      node _io_out_T_9 = mux(_io_out_T_5, UInt<3>("h4"), _io_out_T_8) @[Mux.scala 47:70]
      node _io_out_T_10 = mux(_io_out_T_4, UInt<2>("h3"), _io_out_T_9) @[Mux.scala 47:70]
      node _io_out_T_11 = mux(_io_out_T_3, UInt<2>("h2"), _io_out_T_10) @[Mux.scala 47:70]
      node _io_out_T_12 = mux(_io_out_T_2, UInt<1>("h1"), _io_out_T_11) @[Mux.scala 47:70]
      node _io_out_T_13 = mux(_io_out_T_1, UInt<1>("h0"), _io_out_T_12) @[Mux.scala 47:70]
      io.out <= _io_out_T_13 @[stack_filters.scala 72:16]

  module StackFiltersUnit :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip x : UInt<3>, y : UInt<3>}

    inst tdu of ThresholdDecomposition @[stack_filters.scala 89:21]
    tdu.clock <= clock
    tdu.reset <= reset
    inst Regs of Regs @[stack_filters.scala 90:48]
    Regs.clock <= clock
    Regs.reset <= reset
    inst Regs_1 of Regs_1 @[stack_filters.scala 90:48]
    Regs_1.clock <= clock
    Regs_1.reset <= reset
    inst Regs_2 of Regs_2 @[stack_filters.scala 90:48]
    Regs_2.clock <= clock
    Regs_2.reset <= reset
    inst Regs_3 of Regs_3 @[stack_filters.scala 90:48]
    Regs_3.clock <= clock
    Regs_3.reset <= reset
    inst Regs_4 of Regs_4 @[stack_filters.scala 90:48]
    Regs_4.clock <= clock
    Regs_4.reset <= reset
    inst Regs_5 of Regs_5 @[stack_filters.scala 90:48]
    Regs_5.clock <= clock
    Regs_5.reset <= reset
    inst Regs_6 of Regs_6 @[stack_filters.scala 90:48]
    Regs_6.clock <= clock
    Regs_6.reset <= reset
    inst BLL of BLL @[stack_filters.scala 91:47]
    BLL.clock <= clock
    BLL.reset <= reset
    inst BLL_1 of BLL_1 @[stack_filters.scala 91:47]
    BLL_1.clock <= clock
    BLL_1.reset <= reset
    inst BLL_2 of BLL_2 @[stack_filters.scala 91:47]
    BLL_2.clock <= clock
    BLL_2.reset <= reset
    inst BLL_3 of BLL_3 @[stack_filters.scala 91:47]
    BLL_3.clock <= clock
    BLL_3.reset <= reset
    inst BLL_4 of BLL_4 @[stack_filters.scala 91:47]
    BLL_4.clock <= clock
    BLL_4.reset <= reset
    inst BLL_5 of BLL_5 @[stack_filters.scala 91:47]
    BLL_5.clock <= clock
    BLL_5.reset <= reset
    inst BLL_6 of BLL_6 @[stack_filters.scala 91:47]
    BLL_6.clock <= clock
    BLL_6.reset <= reset
    inst tru of ThresholdRecomposition @[stack_filters.scala 92:21]
    tru.clock <= clock
    tru.reset <= reset
    tdu.io.x <= io.x @[stack_filters.scala 93:14]
    node _T = bits(tdu.io.out, 0, 0) @[stack_filters.scala 95:42]
    Regs.io.in <= _T @[stack_filters.scala 95:29]
    BLL.io.regs_in <= Regs.io.out @[stack_filters.scala 96:33]
    node _T_1 = bits(tdu.io.out, 1, 1) @[stack_filters.scala 95:42]
    Regs_1.io.in <= _T_1 @[stack_filters.scala 95:29]
    BLL_1.io.regs_in <= Regs_1.io.out @[stack_filters.scala 96:33]
    node _T_2 = bits(tdu.io.out, 2, 2) @[stack_filters.scala 95:42]
    Regs_2.io.in <= _T_2 @[stack_filters.scala 95:29]
    BLL_2.io.regs_in <= Regs_2.io.out @[stack_filters.scala 96:33]
    node _T_3 = bits(tdu.io.out, 3, 3) @[stack_filters.scala 95:42]
    Regs_3.io.in <= _T_3 @[stack_filters.scala 95:29]
    BLL_3.io.regs_in <= Regs_3.io.out @[stack_filters.scala 96:33]
    node _T_4 = bits(tdu.io.out, 4, 4) @[stack_filters.scala 95:42]
    Regs_4.io.in <= _T_4 @[stack_filters.scala 95:29]
    BLL_4.io.regs_in <= Regs_4.io.out @[stack_filters.scala 96:33]
    node _T_5 = bits(tdu.io.out, 5, 5) @[stack_filters.scala 95:42]
    Regs_5.io.in <= _T_5 @[stack_filters.scala 95:29]
    BLL_5.io.regs_in <= Regs_5.io.out @[stack_filters.scala 96:33]
    node _T_6 = bits(tdu.io.out, 6, 6) @[stack_filters.scala 95:42]
    Regs_6.io.in <= _T_6 @[stack_filters.scala 95:29]
    BLL_6.io.regs_in <= Regs_6.io.out @[stack_filters.scala 96:33]
    node bll_outputs_lo_hi = cat(BLL_2.io.out, BLL_1.io.out) @[Cat.scala 31:58]
    node bll_outputs_lo = cat(bll_outputs_lo_hi, BLL.io.out) @[Cat.scala 31:58]
    node bll_outputs_hi_lo = cat(BLL_4.io.out, BLL_3.io.out) @[Cat.scala 31:58]
    node bll_outputs_hi_hi = cat(BLL_6.io.out, BLL_5.io.out) @[Cat.scala 31:58]
    node bll_outputs_hi = cat(bll_outputs_hi_hi, bll_outputs_hi_lo) @[Cat.scala 31:58]
    node bll_outputs = cat(bll_outputs_hi, bll_outputs_lo) @[Cat.scala 31:58]
    tru.io.in <= bll_outputs @[stack_filters.scala 106:15]
    io.y <= tru.io.out @[stack_filters.scala 107:10]

