package wos.stack_filters

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline

class ThresholdDecomposition(b: Int) extends Module {
    val out_dim = scala.math.pow(2,b).toInt - 1
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val out = Output(UInt(out_dim.W))
    })
    io.out := VecInit(Seq.tabulate(out_dim)(i => ((i+1).U <= io.x).asUInt)).asUInt
}

class Regs(val K: Int) extends Module {
    assert(K > 1)
    val io = IO(new Bundle {
        val in = Input(UInt(1.W))
        val out = Output(UInt(K.W)costs)
    })

    val regs = RegInit(Fill(K, 1.U(1.W)))

    regs := Cat(regs(K-2, 0), io.in) // <-in<- LSB contains the new value
    io.out := regs
}

class BLL(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val io = IO(new Bundle {
        val regs_in = Input(UInt(K.W))
        val out = Output(UInt(1.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W)))
    })
    val acc = (0 until io.weights.length).foldLeft((-io.R.asSInt).pad(mr + 1)) { (sum, i) =>
        sum + Mux(io.regs_in(i) === 0.U, io.weights(i).asSInt, 0.S)
    }
    io.out := (acc < 0.S).asUInt
}

class BLL_Method2(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    // failed to implement correctly, won't be used
    val io = IO(new Bundle {
        val regs_in = Input(UInt((K+1).W))
        val out = Output(UInt(1.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W)))
        val enable = Input(UInt(1.W))
    })

    // TODO, move that out
    val diffs = Array.fill(K-1)(0.S((mr+1).W)) 
    for (i <- 0 until K-1) { 
        diffs(i) = io.weights(i+1).asSInt - io.weights(i).asSInt
    }

    val df = RegInit(VecInit(diffs)) // Convert the mutable Array to a Vec
    df := VecInit(diffs)
    printf(p"df: ${df}\n")

    val Df = (0 until K-1).foldLeft(0.S((mr+1).W)) { (sum, i) =>
        sum + Mux(io.regs_in(i+1) === 0.U, df(i), 0.S((mr+1).W))
    }

    val num0 = RegInit(0.S((mr+1).W))
    val new_num0 = Wire(SInt((mr+1).W))
    new_num0 := num0 + Mux(io.regs_in(0) === 0.U, io.weights(0).asSInt, 0.S) - Mux(io.regs_in(K) === 0.U, io.weights(K-1).asSInt, 0.S) + Df

    when (io.enable === 1.U) {
        num0 := new_num0
    } otherwise {
        num0 := -io.R.asSInt
    }

    io.out := Mux(new_num0 >= 0.S, 0.U, 1.U) 
}

class ThresholdRecomposition(b: Int) extends Module {
    val in_dim = scala.math.pow(2, b).toInt - 1
    val io = IO(new Bundle {
        val in = Input(UInt(in_dim.W))
        val out = Output(UInt(b.W))
    })
    when(io.in(in_dim-1) === 1.U) {
        io.out := in_dim.U
    } .otherwise {
        io.out := PriorityEncoder(~io.in)
    }
}

class StackFiltersUnit(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val exp_dim = scala.math.pow(2, b).toInt - 1
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val y = Output(UInt(b.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W)))
    })

    val weights = RegInit(VecInit(Seq.fill(K)(0.U(c.W)))) 
    weights := io.weights

    val R = RegInit(0.U(mr.W))
    R := io.R

    val tdu = Module(new ThresholdDecomposition(b))
    val regs_array = Array.fill(exp_dim)(Module(new Regs(K)))
    val bll_array = Array.fill(exp_dim)(Module(new BLL(b, c, mr, K)))
    val tru = Module(new ThresholdRecomposition(b))
    tdu.io.x := io.x
    for (i <- 0 until exp_dim) {
        regs_array(i).io.in := tdu.io.out(i)
        bll_array(i).io.regs_in := regs_array(i).io.out
        bll_array(i).io.R := R
        bll_array(i).io.weights := weights
    }
    val bll_outputs = Cat(bll_array.map(_.io.out).reverse)
    tru.io.in := bll_outputs
    io.y := tru.io.out
}

class StackFiltersContainer(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    // Acts as a buffer for input and output so that we can impose a clock constraint for speed measurement
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val y = Output(UInt(b.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W)))
    })
    val stack_filters_unit = Module(new StackFiltersUnit(b, c, mr, K))

    stack_filters_unit.io.R := io.R
    stack_filters_unit.io.weights := io.weights

    val regx = RegInit(0.U(b.W))
    val regy = RegInit(0.U(b.W))

    regx := io.x
    io.y := regy

    stack_filters_unit.io.x := regx 
    regy := stack_filters_unit.io.y
}

object StackFiltersUnit extends App {
    val b = sys.env.getOrElse("B", "4").toInt
    val c = sys.env.getOrElse("C", "4").toInt
    val mr = sys.env.getOrElse("MR", "4").toInt
    val K = sys.env.getOrElse("K", "3").toInt
    emitVerilog(new StackFiltersUnit(b, c, mr, K), Array("--target-dir", "generated"))
}

object StackFiltersContainer extends App {
    val b = sys.env.getOrElse("B", "4").toInt
    val c = sys.env.getOrElse("C", "4").toInt
    val mr = sys.env.getOrElse("MR", "4").toInt
    val K = sys.env.getOrElse("K", "3").toInt
    emitVerilog(new StackFiltersContainer(b, c, mr, K), Array("--target-dir", "generated"))
}