package wos.stack_filters

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline

class ThresholdDecomposition(width: Int) extends Module {
    val out_dim = scala.math.pow(2,width).toInt - 1
  val io = IO(new Bundle {
    val x = Input(UInt(width.W))
    val out = Output(UInt(out_dim.W))
  })
  io.out := VecInit(Seq.tabulate(out_dim)(i => ((i+1).U <= io.x).asUInt)).asUInt
}

class ShiftRegister(val width: Int, val depth: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(width.W))
    val out = Output(UInt((depth * width).W))
    val transfer = Output(UInt(width.W))
  })
  val regs = Seq.fill(depth)(RegInit(0.U(width.W)))
  regs.head := io.in
  io.transfer := regs.head
  for (i <- 1 until depth) {
    regs(i) := regs(i-1)
  }
  io.out := Cat(regs) 
}

class Regs(val depth: Int) extends Module {
    assert(depth > 1)
    val io = IO(new Bundle {
        val in = Input(UInt(1.W))
        val out = Output(UInt(depth.W))
    })

    // val regs = RegInit(VecInit(Seq.fill(depth)(0.U(1.W))))
    val regs = RegInit(0.U(depth.W))
    // regs := regs << 1.U ## io.in
    // regs := Cat(regs(depth-2, 0), io.in)
    regs := Cat(io.in, regs(depth-1, 1)) // ->in$$-> MSB contains the new value
    io.out := regs
}

class BLL(val weights : Array[Int], val rank : Int, val width : Int) extends Module {
    val depth = weights.length
    val io = IO(new Bundle {
        val regs_in = Input(UInt(depth.W))
        val out = Output(UInt(1.W))
    })
    val acc = Wire(UInt(width.W))
    acc := 0.U
    // for (i <- 0 until depth) { // until does not include the last element
    //     acc := acc + Mux(io.regs_in(i) === 1.U, weights(i).U(width.W), 0.U(width.W))
    // }
    acc := weights.zipWithIndex.foldLeft(0.U(width.W)) { case (sum, (weight, i)) =>
        sum + Mux(io.regs_in(depth-1-i) === 0.U, weight.U(width.W), 0.U(width.W))
    }
    io.out := (acc < rank.U).asUInt
}

class ThresholdRecomposition(width: Int) extends Module {
    val in_dim = scala.math.pow(2, width).toInt - 1
    val io = IO(new Bundle {
        val in = Input(UInt(in_dim.W))
        val out = Output(UInt(width.W))
    })
    when(io.in(in_dim-1) === 1.U) {
        io.out := in_dim.U
    } .otherwise {
        io.out := PriorityEncoder(~io.in)
    }
}

class StackFiltersUnit(val weights : Array[Int], val rank : Int, val width : Int) extends Module {
    // val mem_file = "./src/main/resources/stack_filters/stack_filters.mem"
    val depth = weights.length
    val exp_dim = scala.math.pow(2, width).toInt - 1
    val io = IO(new Bundle {
        val x = Input(UInt(width.W))
        val y = Output(UInt(width.W))
    })

    // val mem = SyncReadMem(8, UInt(width.W))
    // assert (mem_file.trim().nonEmpty)
    // loadMemoryFromFileInline(mem, mem_file)

    val tdu = Module(new ThresholdDecomposition(width))
    val regs_array = Array.fill(exp_dim)(Module(new Regs(depth)))
    val bll_array = Array.fill(exp_dim)(Module(new BLL(weights, rank, width)))
    val tru = Module(new ThresholdRecomposition(width))
    tdu.io.x := io.x
    for (i <- 0 until exp_dim) {
        regs_array(i).io.in := tdu.io.out(i)
        bll_array(i).io.regs_in := regs_array(i).io.out
    }
    val bll_outputs = Cat(bll_array.map(_.io.out).reverse)
    // for (i <- 0 until exp_dim) {
    //     printf(p"regs_array($i).io.in: ${regs_array(i).io.in}\n")
    //     printf(p"regs_array($i).io.out: ${regs_array(i).io.out}\n")
    //     printf(p"bll_array($i).io.regs_in: ${bll_array(i).io.regs_in}\n")
    //     printf(p"bll_array($i).io.out: ${bll_array(i).io.out}\n")
    // }
    // printf("bll_outputs: %b\n", bll_outputs)
    tru.io.in := bll_outputs
    io.y := tru.io.out
}

class StackFiltersContainer(val weights : Array[Int], val rank : Int, val width : Int) extends Module {
    // Acts as a buffer for input and output so that we can impose a clock constraint for speed measurement
    val io = IO(new Bundle {
        val x = Input(UInt(width.W))
        val y = Output(UInt(width.W))
    })
    val stack_filters_unit = Module(new StackFiltersUnit(weights, rank, width))

    val regx = RegInit(0.U(width.W))
    val regy = RegInit(0.U(width.W))

    regx := io.x
    io.y := regy

    stack_filters_unit.io.x := regx 
    regy := stack_filters_unit.io.y
}

object StackFiltersUnit extends App {
    val weights = Array(1, 2, 3) 
    val rank = 4
    val width = 3 
    emitVerilog(new StackFiltersUnit(weights, rank, width), Array("--target-dir", "generated"))
}

object StackFiltersContainer extends App {
    val weights = Array(1, 2, 3) 
    val rank = 4
    val width = 3 
    emitVerilog(new StackFiltersContainer(weights, rank, width), Array("--target-dir", "generated"))
}