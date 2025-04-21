module RankUpdateUnit(
  input  [2:0] io_s,
  input        io_u,
  input  [4:0] io_df_0,
  input  [4:0] io_df_1,
  input  [3:0] io_r_old,
  output [3:0] io_r_new
);
  wire [4:0] _Df_T_2 = io_s[0] ? $signed(io_df_0) : $signed(5'sh0); // @[array.scala 20:18]
  wire [5:0] _Df_T_3 = {{1{_Df_T_2[4]}},_Df_T_2}; // @[array.scala 20:13]
  wire [4:0] _Df_T_5 = _Df_T_3[4:0]; // @[array.scala 20:13]
  wire [4:0] _Df_T_8 = io_s[1] ? $signed(io_df_1) : $signed(5'sh0); // @[array.scala 20:18]
  wire [4:0] Df = $signed(_Df_T_5) + $signed(_Df_T_8); // @[array.scala 20:13]
  wire [3:0] _io_r_new_T_1 = io_u ? 4'h1 : 4'h0; // @[array.scala 24:33]
  wire [3:0] _io_r_new_T_3 = io_r_old + _io_r_new_T_1; // @[array.scala 24:28]
  wire [3:0] _io_r_new_T_6 = io_s[2] ? 4'h3 : 4'h0; // @[array.scala 24:66]
  wire [3:0] _io_r_new_T_9 = _io_r_new_T_3 - _io_r_new_T_6; // @[array.scala 24:102]
  wire [4:0] _GEN_0 = {{1{_io_r_new_T_9[3]}},_io_r_new_T_9}; // @[array.scala 24:109]
  wire [4:0] _io_r_new_T_13 = $signed(_GEN_0) + $signed(Df); // @[array.scala 24:115]
  assign io_r_new = _io_r_new_T_13[3:0]; // @[array.scala 24:14]
endmodule
module Processor(
  input        clock,
  input        reset,
  input  [3:0] io_R,
  input  [3:0] io_x_new,
  input  [3:0] io_r_in,
  input  [2:0] io_s_in,
  input  [3:0] io_a_in,
  output [3:0] io_r_out,
  output [2:0] io_s_out,
  output [3:0] io_a_out,
  output       io_u,
  output       io_res
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  wire [2:0] ruu_io_s; // @[array.scala 103:21]
  wire  ruu_io_u; // @[array.scala 103:21]
  wire [4:0] ruu_io_df_0; // @[array.scala 103:21]
  wire [4:0] ruu_io_df_1; // @[array.scala 103:21]
  wire [3:0] ruu_io_r_old; // @[array.scala 103:21]
  wire [3:0] ruu_io_r_new; // @[array.scala 103:21]
  reg [3:0] r; // @[array.scala 97:20]
  reg [2:0] s; // @[array.scala 98:20]
  reg [3:0] a; // @[array.scala 99:20]
  wire [4:0] _T_2 = 5'sh2 - 5'sh1; // @[array.scala 108:44]
  wire [4:0] _T_5 = 5'sh3 - 5'sh2; // @[array.scala 108:44]
  reg [4:0] df_0; // @[array.scala 111:21]
  reg [4:0] df_1; // @[array.scala 111:21]
  wire  u = io_a_in >= io_x_new; // @[array.scala 120:22]
  wire [2:0] _s_T_1 = {io_s_in[1:0],u}; // @[Cat.scala 31:58]
  wire [3:0] _rmr_T_4 = $signed(io_R) - $signed(r); // @[array.scala 143:24]
  wire [4:0] rmr = {{1{_rmr_T_4[3]}},_rmr_T_4}; // @[array.scala 142:19 143:9]
  RankUpdateUnit ruu ( // @[array.scala 103:21]
    .io_s(ruu_io_s),
    .io_u(ruu_io_u),
    .io_df_0(ruu_io_df_0),
    .io_df_1(ruu_io_df_1),
    .io_r_old(ruu_io_r_old),
    .io_r_new(ruu_io_r_new)
  );
  assign io_r_out = r; // @[array.scala 147:14]
  assign io_s_out = s; // @[array.scala 148:14]
  assign io_a_out = a; // @[array.scala 149:14]
  assign io_u = io_a_in >= io_x_new; // @[array.scala 120:22]
  assign io_res = $signed(rmr) >= 5'sh0 & $signed(rmr) < 5'sh2; // @[array.scala 144:27]
  assign ruu_io_s = io_s_in; // @[array.scala 124:14]
  assign ruu_io_u = io_a_in >= io_x_new; // @[array.scala 120:22]
  assign ruu_io_df_0 = df_0; // @[array.scala 128:15]
  assign ruu_io_df_1 = df_1; // @[array.scala 128:15]
  assign ruu_io_r_old = io_r_in; // @[array.scala 133:18]
  always @(posedge clock) begin
    if (reset) begin // @[array.scala 97:20]
      r <= 4'h0; // @[array.scala 97:20]
    end else begin
      r <= ruu_io_r_new; // @[array.scala 135:7]
    end
    if (reset) begin // @[array.scala 98:20]
      s <= 3'h0; // @[array.scala 98:20]
    end else begin
      s <= _s_T_1; // @[array.scala 139:7]
    end
    if (reset) begin // @[array.scala 99:20]
      a <= 4'h0; // @[array.scala 99:20]
    end else begin
      a <= io_a_in; // @[array.scala 101:7]
    end
    if (reset) begin // @[array.scala 111:21]
      df_0 <= _T_2; // @[array.scala 111:21]
    end
    if (reset) begin // @[array.scala 111:21]
      df_1 <= _T_5; // @[array.scala 111:21]
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
  _RAND_1 = {1{`RANDOM}};
  s = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  a = _RAND_2[3:0];
  _RAND_3 = {1{`RANDOM}};
  df_0 = _RAND_3[4:0];
  _RAND_4 = {1{`RANDOM}};
  df_1 = _RAND_4[4:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Processor_1(
  input        clock,
  input        reset,
  input  [3:0] io_R,
  input  [3:0] io_x_new,
  input  [3:0] io_r_in,
  input  [2:0] io_s_in,
  input  [3:0] io_a_in,
  output [3:0] io_a_out,
  output       io_u,
  output       io_res
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire [2:0] ruu_io_s; // @[array.scala 103:21]
  wire  ruu_io_u; // @[array.scala 103:21]
  wire [4:0] ruu_io_df_0; // @[array.scala 103:21]
  wire [4:0] ruu_io_df_1; // @[array.scala 103:21]
  wire [3:0] ruu_io_r_old; // @[array.scala 103:21]
  wire [3:0] ruu_io_r_new; // @[array.scala 103:21]
  reg [3:0] r; // @[array.scala 97:20]
  reg [3:0] a; // @[array.scala 99:20]
  wire [4:0] _T_2 = 5'sh2 - 5'sh1; // @[array.scala 108:44]
  wire [4:0] _T_5 = 5'sh3 - 5'sh2; // @[array.scala 108:44]
  reg [4:0] df_0; // @[array.scala 111:21]
  reg [4:0] df_1; // @[array.scala 111:21]
  wire [3:0] _rmr_T_4 = $signed(io_R) - $signed(r); // @[array.scala 143:24]
  wire [4:0] rmr = {{1{_rmr_T_4[3]}},_rmr_T_4}; // @[array.scala 142:19 143:9]
  RankUpdateUnit ruu ( // @[array.scala 103:21]
    .io_s(ruu_io_s),
    .io_u(ruu_io_u),
    .io_df_0(ruu_io_df_0),
    .io_df_1(ruu_io_df_1),
    .io_r_old(ruu_io_r_old),
    .io_r_new(ruu_io_r_new)
  );
  assign io_a_out = a; // @[array.scala 149:14]
  assign io_u = io_a_in >= io_x_new; // @[array.scala 120:22]
  assign io_res = $signed(rmr) >= 5'sh0 & $signed(rmr) < 5'sh3; // @[array.scala 144:27]
  assign ruu_io_s = io_s_in; // @[array.scala 124:14]
  assign ruu_io_u = io_a_in >= io_x_new; // @[array.scala 120:22]
  assign ruu_io_df_0 = df_0; // @[array.scala 128:15]
  assign ruu_io_df_1 = df_1; // @[array.scala 128:15]
  assign ruu_io_r_old = io_r_in; // @[array.scala 133:18]
  always @(posedge clock) begin
    if (reset) begin // @[array.scala 97:20]
      r <= 4'h0; // @[array.scala 97:20]
    end else begin
      r <= ruu_io_r_new; // @[array.scala 135:7]
    end
    if (reset) begin // @[array.scala 99:20]
      a <= 4'h0; // @[array.scala 99:20]
    end else begin
      a <= io_a_in; // @[array.scala 101:7]
    end
    if (reset) begin // @[array.scala 111:21]
      df_0 <= _T_2; // @[array.scala 111:21]
    end
    if (reset) begin // @[array.scala 111:21]
      df_1 <= _T_5; // @[array.scala 111:21]
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
  _RAND_1 = {1{`RANDOM}};
  a = _RAND_1[3:0];
  _RAND_2 = {1{`RANDOM}};
  df_0 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  df_1 = _RAND_3[4:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Processor0(
  input        clock,
  input        reset,
  input  [3:0] io_x_new,
  input  [3:0] io_R,
  input  [1:0] io_u,
  output [3:0] io_r_out,
  output [2:0] io_s_out,
  output [3:0] io_a_out,
  output       io_res
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [3:0] r; // @[array.scala 42:20]
  reg [2:0] s; // @[array.scala 43:20]
  reg [3:0] a; // @[array.scala 44:20]
  wire  _acc_T_1 = ~io_u[0]; // @[array.scala 52:27]
  wire [3:0] _acc_T_2 = ~io_u[0] ? 4'h2 : 4'h0; // @[array.scala 52:18]
  wire [4:0] _acc_T_3 = {{1'd0}, _acc_T_2}; // @[array.scala 52:13]
  wire  _acc_T_6 = ~io_u[1]; // @[array.scala 52:27]
  wire [3:0] _acc_T_7 = ~io_u[1] ? 4'h3 : 4'h0; // @[array.scala 52:18]
  wire [3:0] acc = _acc_T_3[3:0] + _acc_T_7; // @[array.scala 52:13]
  wire [3:0] _r_T_1 = 4'h1 + acc; // @[array.scala 54:14]
  wire [2:0] _s_T_1 = {_acc_T_6,_acc_T_1,1'h0}; // @[array.scala 60:23]
  wire [3:0] _rmr_T_4 = $signed(io_R) - $signed(r); // @[array.scala 64:24]
  wire [4:0] rmr = {{1{_rmr_T_4[3]}},_rmr_T_4}; // @[array.scala 63:19 64:9]
  assign io_r_out = r; // @[array.scala 68:14]
  assign io_s_out = s; // @[array.scala 69:14]
  assign io_a_out = a; // @[array.scala 70:14]
  assign io_res = $signed(rmr) >= 5'sh0 & $signed(rmr) < 5'sh1; // @[array.scala 65:27]
  always @(posedge clock) begin
    if (reset) begin // @[array.scala 42:20]
      r <= 4'h0; // @[array.scala 42:20]
    end else begin
      r <= _r_T_1; // @[array.scala 54:7]
    end
    if (reset) begin // @[array.scala 43:20]
      s <= 3'h0; // @[array.scala 43:20]
    end else begin
      s <= _s_T_1; // @[array.scala 60:7]
    end
    if (reset) begin // @[array.scala 44:20]
      a <= 4'h0; // @[array.scala 44:20]
    end else begin
      a <= io_x_new; // @[array.scala 46:7]
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
  _RAND_1 = {1{`RANDOM}};
  s = _RAND_1[2:0];
  _RAND_2 = {1{`RANDOM}};
  a = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ArrayUnit(
  input        clock,
  input        reset,
  input  [3:0] io_x,
  output [3:0] io_y,
  input  [3:0] io_R
);
  wire  Processor_clock; // @[array.scala 159:50]
  wire  Processor_reset; // @[array.scala 159:50]
  wire [3:0] Processor_io_R; // @[array.scala 159:50]
  wire [3:0] Processor_io_x_new; // @[array.scala 159:50]
  wire [3:0] Processor_io_r_in; // @[array.scala 159:50]
  wire [2:0] Processor_io_s_in; // @[array.scala 159:50]
  wire [3:0] Processor_io_a_in; // @[array.scala 159:50]
  wire [3:0] Processor_io_r_out; // @[array.scala 159:50]
  wire [2:0] Processor_io_s_out; // @[array.scala 159:50]
  wire [3:0] Processor_io_a_out; // @[array.scala 159:50]
  wire  Processor_io_u; // @[array.scala 159:50]
  wire  Processor_io_res; // @[array.scala 159:50]
  wire  Processor_1_clock; // @[array.scala 159:50]
  wire  Processor_1_reset; // @[array.scala 159:50]
  wire [3:0] Processor_1_io_R; // @[array.scala 159:50]
  wire [3:0] Processor_1_io_x_new; // @[array.scala 159:50]
  wire [3:0] Processor_1_io_r_in; // @[array.scala 159:50]
  wire [2:0] Processor_1_io_s_in; // @[array.scala 159:50]
  wire [3:0] Processor_1_io_a_in; // @[array.scala 159:50]
  wire [3:0] Processor_1_io_a_out; // @[array.scala 159:50]
  wire  Processor_1_io_u; // @[array.scala 159:50]
  wire  Processor_1_io_res; // @[array.scala 159:50]
  wire  p_0_clock; // @[array.scala 160:21]
  wire  p_0_reset; // @[array.scala 160:21]
  wire [3:0] p_0_io_x_new; // @[array.scala 160:21]
  wire [3:0] p_0_io_R; // @[array.scala 160:21]
  wire [1:0] p_0_io_u; // @[array.scala 160:21]
  wire [3:0] p_0_io_r_out; // @[array.scala 160:21]
  wire [2:0] p_0_io_s_out; // @[array.scala 160:21]
  wire [3:0] p_0_io_a_out; // @[array.scala 160:21]
  wire  p_0_io_res; // @[array.scala 160:21]
  wire [1:0] u = {Processor_1_io_u,Processor_io_u}; // @[Cat.scala 31:58]
  wire [3:0] _GEN_0 = Processor_io_res ? Processor_io_a_out : 4'h0; // @[array.scala 213:10 221:46 222:22]
  wire [3:0] _GEN_1 = Processor_1_io_res ? Processor_1_io_a_out : _GEN_0; // @[array.scala 221:46 222:22]
  Processor Processor ( // @[array.scala 159:50]
    .clock(Processor_clock),
    .reset(Processor_reset),
    .io_R(Processor_io_R),
    .io_x_new(Processor_io_x_new),
    .io_r_in(Processor_io_r_in),
    .io_s_in(Processor_io_s_in),
    .io_a_in(Processor_io_a_in),
    .io_r_out(Processor_io_r_out),
    .io_s_out(Processor_io_s_out),
    .io_a_out(Processor_io_a_out),
    .io_u(Processor_io_u),
    .io_res(Processor_io_res)
  );
  Processor_1 Processor_1 ( // @[array.scala 159:50]
    .clock(Processor_1_clock),
    .reset(Processor_1_reset),
    .io_R(Processor_1_io_R),
    .io_x_new(Processor_1_io_x_new),
    .io_r_in(Processor_1_io_r_in),
    .io_s_in(Processor_1_io_s_in),
    .io_a_in(Processor_1_io_a_in),
    .io_a_out(Processor_1_io_a_out),
    .io_u(Processor_1_io_u),
    .io_res(Processor_1_io_res)
  );
  Processor0 p_0 ( // @[array.scala 160:21]
    .clock(p_0_clock),
    .reset(p_0_reset),
    .io_x_new(p_0_io_x_new),
    .io_R(p_0_io_R),
    .io_u(p_0_io_u),
    .io_r_out(p_0_io_r_out),
    .io_s_out(p_0_io_s_out),
    .io_a_out(p_0_io_a_out),
    .io_res(p_0_io_res)
  );
  assign io_y = p_0_io_res ? p_0_io_a_out : _GEN_1; // @[array.scala 216:31 217:14]
  assign Processor_clock = clock;
  assign Processor_reset = reset;
  assign Processor_io_R = io_R; // @[array.scala 179:21]
  assign Processor_io_x_new = io_x; // @[array.scala 169:25]
  assign Processor_io_r_in = p_0_io_r_out; // @[array.scala 170:24]
  assign Processor_io_s_in = p_0_io_s_out; // @[array.scala 171:24]
  assign Processor_io_a_in = p_0_io_a_out; // @[array.scala 172:24]
  assign Processor_1_clock = clock;
  assign Processor_1_reset = reset;
  assign Processor_1_io_R = io_R; // @[array.scala 193:27]
  assign Processor_1_io_x_new = io_x; // @[array.scala 182:31]
  assign Processor_1_io_r_in = Processor_io_r_out; // @[array.scala 185:30]
  assign Processor_1_io_s_in = Processor_io_s_out; // @[array.scala 184:30]
  assign Processor_1_io_a_in = Processor_io_a_out; // @[array.scala 183:30]
  assign p_0_clock = clock;
  assign p_0_reset = reset;
  assign p_0_io_x_new = io_x; // @[array.scala 162:18]
  assign p_0_io_R = io_R; // @[array.scala 163:14]
  assign p_0_io_u = {Processor_1_io_u,Processor_io_u}; // @[Cat.scala 31:58]
  always @(posedge clock) begin
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"u: %b\n",u); // @[array.scala 206:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
