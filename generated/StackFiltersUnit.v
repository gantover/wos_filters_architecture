module ThresholdDecomposition(
  input  [2:0] io_x,
  output [6:0] io_out
);
  wire [2:0] io_out_lo = {3'h3 <= io_x,3'h2 <= io_x,3'h1 <= io_x}; // @[stack_filters.scala 13:75]
  wire [3:0] io_out_hi = {3'h7 <= io_x,3'h6 <= io_x,3'h5 <= io_x,3'h4 <= io_x}; // @[stack_filters.scala 13:75]
  assign io_out = {io_out_hi,io_out_lo}; // @[stack_filters.scala 13:75]
endmodule
module Regs(
  input        clock,
  input        reset,
  input        io_in,
  output [2:0] io_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] regs; // @[stack_filters.scala 39:23]
  wire [2:0] _regs_T_1 = {io_in,regs[2:1]}; // @[Cat.scala 31:58]
  assign io_out = regs; // @[stack_filters.scala 43:12]
  always @(posedge clock) begin
    if (reset) begin // @[stack_filters.scala 39:23]
      regs <= 3'h0; // @[stack_filters.scala 39:23]
    end else begin
      regs <= _regs_T_1; // @[stack_filters.scala 42:10]
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
  regs = _RAND_0[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BLL(
  input  [2:0] io_regs_in,
  output       io_out
);
  wire [2:0] _acc_T_2 = ~io_regs_in[2] ? 3'h1 : 3'h0; // @[stack_filters.scala 58:18]
  wire [3:0] _acc_T_3 = {{1'd0}, _acc_T_2}; // @[stack_filters.scala 58:13]
  wire [2:0] _acc_T_7 = ~io_regs_in[1] ? 3'h2 : 3'h0; // @[stack_filters.scala 58:18]
  wire [2:0] _acc_T_9 = _acc_T_3[2:0] + _acc_T_7; // @[stack_filters.scala 58:13]
  wire [2:0] _acc_T_12 = ~io_regs_in[0] ? 3'h3 : 3'h0; // @[stack_filters.scala 58:18]
  wire [2:0] acc = _acc_T_9 + _acc_T_12; // @[stack_filters.scala 58:13]
  assign io_out = acc < 3'h4; // @[stack_filters.scala 60:20]
endmodule
module ThresholdRecomposition(
  input  [6:0] io_in,
  output [2:0] io_out
);
  wire [6:0] _io_out_T = ~io_in; // @[stack_filters.scala 72:35]
  wire [2:0] _io_out_T_8 = _io_out_T[5] ? 3'h5 : 3'h6; // @[Mux.scala 47:70]
  wire [2:0] _io_out_T_9 = _io_out_T[4] ? 3'h4 : _io_out_T_8; // @[Mux.scala 47:70]
  wire [2:0] _io_out_T_10 = _io_out_T[3] ? 3'h3 : _io_out_T_9; // @[Mux.scala 47:70]
  wire [2:0] _io_out_T_11 = _io_out_T[2] ? 3'h2 : _io_out_T_10; // @[Mux.scala 47:70]
  wire [2:0] _io_out_T_12 = _io_out_T[1] ? 3'h1 : _io_out_T_11; // @[Mux.scala 47:70]
  wire [2:0] _io_out_T_13 = _io_out_T[0] ? 3'h0 : _io_out_T_12; // @[Mux.scala 47:70]
  assign io_out = io_in[6] ? 3'h7 : _io_out_T_13; // @[stack_filters.scala 69:35 70:16 72:16]
endmodule
module StackFiltersUnit(
  input        clock,
  input        reset,
  input  [2:0] io_x,
  output [2:0] io_y
);
  wire [2:0] tdu_io_x; // @[stack_filters.scala 89:21]
  wire [6:0] tdu_io_out; // @[stack_filters.scala 89:21]
  wire  Regs_clock; // @[stack_filters.scala 90:48]
  wire  Regs_reset; // @[stack_filters.scala 90:48]
  wire  Regs_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_1_clock; // @[stack_filters.scala 90:48]
  wire  Regs_1_reset; // @[stack_filters.scala 90:48]
  wire  Regs_1_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_1_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_2_clock; // @[stack_filters.scala 90:48]
  wire  Regs_2_reset; // @[stack_filters.scala 90:48]
  wire  Regs_2_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_2_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_3_clock; // @[stack_filters.scala 90:48]
  wire  Regs_3_reset; // @[stack_filters.scala 90:48]
  wire  Regs_3_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_3_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_4_clock; // @[stack_filters.scala 90:48]
  wire  Regs_4_reset; // @[stack_filters.scala 90:48]
  wire  Regs_4_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_4_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_5_clock; // @[stack_filters.scala 90:48]
  wire  Regs_5_reset; // @[stack_filters.scala 90:48]
  wire  Regs_5_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_5_io_out; // @[stack_filters.scala 90:48]
  wire  Regs_6_clock; // @[stack_filters.scala 90:48]
  wire  Regs_6_reset; // @[stack_filters.scala 90:48]
  wire  Regs_6_io_in; // @[stack_filters.scala 90:48]
  wire [2:0] Regs_6_io_out; // @[stack_filters.scala 90:48]
  wire [2:0] BLL_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_1_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_1_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_2_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_2_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_3_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_3_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_4_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_4_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_5_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_5_io_out; // @[stack_filters.scala 91:47]
  wire [2:0] BLL_6_io_regs_in; // @[stack_filters.scala 91:47]
  wire  BLL_6_io_out; // @[stack_filters.scala 91:47]
  wire [6:0] tru_io_in; // @[stack_filters.scala 92:21]
  wire [2:0] tru_io_out; // @[stack_filters.scala 92:21]
  wire [2:0] bll_outputs_lo = {BLL_2_io_out,BLL_1_io_out,BLL_io_out}; // @[Cat.scala 31:58]
  wire [3:0] bll_outputs_hi = {BLL_6_io_out,BLL_5_io_out,BLL_4_io_out,BLL_3_io_out}; // @[Cat.scala 31:58]
  ThresholdDecomposition tdu ( // @[stack_filters.scala 89:21]
    .io_x(tdu_io_x),
    .io_out(tdu_io_out)
  );
  Regs Regs ( // @[stack_filters.scala 90:48]
    .clock(Regs_clock),
    .reset(Regs_reset),
    .io_in(Regs_io_in),
    .io_out(Regs_io_out)
  );
  Regs Regs_1 ( // @[stack_filters.scala 90:48]
    .clock(Regs_1_clock),
    .reset(Regs_1_reset),
    .io_in(Regs_1_io_in),
    .io_out(Regs_1_io_out)
  );
  Regs Regs_2 ( // @[stack_filters.scala 90:48]
    .clock(Regs_2_clock),
    .reset(Regs_2_reset),
    .io_in(Regs_2_io_in),
    .io_out(Regs_2_io_out)
  );
  Regs Regs_3 ( // @[stack_filters.scala 90:48]
    .clock(Regs_3_clock),
    .reset(Regs_3_reset),
    .io_in(Regs_3_io_in),
    .io_out(Regs_3_io_out)
  );
  Regs Regs_4 ( // @[stack_filters.scala 90:48]
    .clock(Regs_4_clock),
    .reset(Regs_4_reset),
    .io_in(Regs_4_io_in),
    .io_out(Regs_4_io_out)
  );
  Regs Regs_5 ( // @[stack_filters.scala 90:48]
    .clock(Regs_5_clock),
    .reset(Regs_5_reset),
    .io_in(Regs_5_io_in),
    .io_out(Regs_5_io_out)
  );
  Regs Regs_6 ( // @[stack_filters.scala 90:48]
    .clock(Regs_6_clock),
    .reset(Regs_6_reset),
    .io_in(Regs_6_io_in),
    .io_out(Regs_6_io_out)
  );
  BLL BLL ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_io_regs_in),
    .io_out(BLL_io_out)
  );
  BLL BLL_1 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_1_io_regs_in),
    .io_out(BLL_1_io_out)
  );
  BLL BLL_2 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_2_io_regs_in),
    .io_out(BLL_2_io_out)
  );
  BLL BLL_3 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_3_io_regs_in),
    .io_out(BLL_3_io_out)
  );
  BLL BLL_4 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_4_io_regs_in),
    .io_out(BLL_4_io_out)
  );
  BLL BLL_5 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_5_io_regs_in),
    .io_out(BLL_5_io_out)
  );
  BLL BLL_6 ( // @[stack_filters.scala 91:47]
    .io_regs_in(BLL_6_io_regs_in),
    .io_out(BLL_6_io_out)
  );
  ThresholdRecomposition tru ( // @[stack_filters.scala 92:21]
    .io_in(tru_io_in),
    .io_out(tru_io_out)
  );
  assign io_y = tru_io_out; // @[stack_filters.scala 107:10]
  assign tdu_io_x = io_x; // @[stack_filters.scala 93:14]
  assign Regs_clock = clock;
  assign Regs_reset = reset;
  assign Regs_io_in = tdu_io_out[0]; // @[stack_filters.scala 95:42]
  assign Regs_1_clock = clock;
  assign Regs_1_reset = reset;
  assign Regs_1_io_in = tdu_io_out[1]; // @[stack_filters.scala 95:42]
  assign Regs_2_clock = clock;
  assign Regs_2_reset = reset;
  assign Regs_2_io_in = tdu_io_out[2]; // @[stack_filters.scala 95:42]
  assign Regs_3_clock = clock;
  assign Regs_3_reset = reset;
  assign Regs_3_io_in = tdu_io_out[3]; // @[stack_filters.scala 95:42]
  assign Regs_4_clock = clock;
  assign Regs_4_reset = reset;
  assign Regs_4_io_in = tdu_io_out[4]; // @[stack_filters.scala 95:42]
  assign Regs_5_clock = clock;
  assign Regs_5_reset = reset;
  assign Regs_5_io_in = tdu_io_out[5]; // @[stack_filters.scala 95:42]
  assign Regs_6_clock = clock;
  assign Regs_6_reset = reset;
  assign Regs_6_io_in = tdu_io_out[6]; // @[stack_filters.scala 95:42]
  assign BLL_io_regs_in = Regs_io_out; // @[stack_filters.scala 96:33]
  assign BLL_1_io_regs_in = Regs_1_io_out; // @[stack_filters.scala 96:33]
  assign BLL_2_io_regs_in = Regs_2_io_out; // @[stack_filters.scala 96:33]
  assign BLL_3_io_regs_in = Regs_3_io_out; // @[stack_filters.scala 96:33]
  assign BLL_4_io_regs_in = Regs_4_io_out; // @[stack_filters.scala 96:33]
  assign BLL_5_io_regs_in = Regs_5_io_out; // @[stack_filters.scala 96:33]
  assign BLL_6_io_regs_in = Regs_6_io_out; // @[stack_filters.scala 96:33]
  assign tru_io_in = {bll_outputs_hi,bll_outputs_lo}; // @[Cat.scala 31:58]
endmodule
