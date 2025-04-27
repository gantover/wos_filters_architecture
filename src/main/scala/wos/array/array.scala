package wos.array

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFileInline

class RankUpdateUnit(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val io = IO(new Bundle {
        val s = Input(UInt(K.W))
        val u = Input(UInt(1.W))
        // df is a vector of size K-1 of the differences in weights of adjacent samples
        val df = Input(Vec((K-1), SInt((c+1).W))) // not sure about the c + 1, added because of the sign
        val fp0 = Input(UInt(c.W))
        val fpkm1 = Input(UInt(c.W)) 
        val r_old = Input(UInt(mr.W))
        val r_new = Output(UInt(mr.W))
    })

    val Df = (0 until K-1).foldLeft(0.S((mr+1).W)) { (sum , i) =>
        sum + Mux(io.s(i) === 1.U, io.df(i), 0.S((mr+1).W))
    }
    io.r_new := (io.r_old.asSInt + Mux(io.u === 1.U, io.fp0.asSInt, 0.S) + Mux(io.s(K-1) === 1.U, -io.fpkm1.asSInt, 0.S)+ Df ).asUInt
}

class Processor0(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val io = IO(new Bundle {
        val x_new = Input(UInt(b.W)) // where the new sample arrives
        val R = Input(UInt(mr.W)) // the desired rank
        val weights = Input(Vec(K, UInt(c.W))) // 0 will be the weight of P(0)
        val u = Input(UInt((K-1).W)) // the comparision with the new sample from P(1) to P(K-1)

        val r_out = Output(UInt(mr.W)) // store the weighted rank of the sample
        val s_out = Output(UInt(K.W))
        val a_out = Output(UInt(b.W))

        val res = Output(UInt(b.W))
    })


    val r = RegInit(0.U(mr.W)) // the weighted rank of the sample
    val s = RegInit(0.U(K.W)) // stores the result of the comparison to all samples that arrrived beofre it
    val a = RegInit(0.U(b.W)) // holds the samples

    a := io.x_new

    // Step 2.2 : compute the rank of x_new
    // Here we start at weights(1) because of .tail but u is offset by 1 so it matches : u(0) <-> weights(1)
    val acc = (1 until io.weights.length).foldLeft(0.U(mr.W)) { (sum, i) =>
        sum + Mux(io.u(i - 1) === 0.U, io.weights(i), 0.U)
    }
    r := 1.U + acc

    // Step 2.3 : Update comparison with other samples
    val s_new = Cat(VecInit((0 until K-1).map(j => !io.u(j))).asUInt, 0.U(1.W))
    s := s_new

    // step 3 : match rank
    val rmr = Wire(SInt((c+1).W))
    rmr := io.R.asSInt - r.asSInt 
    val cond = Wire(UInt(1.W))
    cond := (rmr >= 0.S && rmr < io.weights(0).asSInt).asUInt
    io.res := Mux(cond === 1.U, a, 0.U)

    io.r_out := r
    io.s_out := s 
    io.a_out := a
}

class Processor(val b: Int, val c: Int, val mr: Int, val K: Int, val id : Int) extends Module {
    val io = IO(new Bundle {
        val R = Input(UInt(mr.W)) // the desired rank
        val weights = Input(Vec(K, UInt(c.W)))
        val df = Input(Vec(K-1, SInt((c+1).W))) // differences in weights of adjacent samples

        // from P(...-1)
        val x_new = Input(UInt(b.W)) // where the new sample arrives
        val r_in = Input(UInt(mr.W)) // store the weighted rank of the new sample
        val s_in = Input(UInt(K.W)) 
        val a_in = Input(UInt(b.W))

        // to P(...+1)
        val r_out = Output(UInt(mr.W)) 
        val s_out = Output(UInt(K.W))
        val a_out = Output(UInt(b.W))

        // to P(0)
        val u = Output(UInt(1.W))

        // to output logic
        val res = Output(UInt(b.W))
    })

    val r = RegInit(0.U(mr.W)) // the weighted rank of the sample, mistake : b -> mr
    val s = RegInit(0.U(K.W)) // store the comparaison result with all samples that arrived before it
    val a = RegInit(0.U(b.W)) // holds the samples
    
    a := io.a_in

    val ruu = Module(new RankUpdateUnit(b, c, mr, K))

    // Setup weights

    val f = Wire(UInt(c.W)) 
    val fp0 = Wire(UInt(c.W)) 
    val fpkm1 = Wire(UInt(c.W)) 
    f := io.weights(id)
    fp0 := io.weights(0)
    fpkm1 := io.weights(K-1)


    // step 1 : compare with new sample
    val u = Wire(UInt(1.W))
    u := Mux(io.a_in >= io.x_new, 1.U, 0.U) // compare the new sample with the previous one
    io.u := u // to send it immediately to P(0)

    // step 2.1 : update rank
    ruu.io.s := io.s_in
    ruu.io.u := u // freshly computed

    // sharing the constants
    ruu.io.df := io.df
    ruu.io.fp0 := fp0
    ruu.io.fpkm1 := fpkm1

    // ruu.io.r_old := io.r_in
    ruu.io.r_old := io.r_in

    r := ruu.io.r_new

    // step 2.3 : update comparison with other samples
    s := Cat(io.s_in(K-2, 0), u) // discard msb and shifts everything 

    // step 3 : match rank
    val rmr = Wire(SInt((mr+1).W)) // mistake : c+1 -> mr+1
    rmr := io.R.asSInt - r.asSInt 
    val cond = Wire(UInt(1.W))
    cond := (rmr >= 0.S && rmr < f.asSInt).asUInt
    io.res := Mux(cond === 1.U, a, 0.U)

    io.r_out := r
    io.s_out := s
    io.a_out := a
}

class ArrayUnit(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val y = Output(UInt(b.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W))) // 0 will be the weight of P(0)
    })

    // setting up df
    val diffs = Array.fill(K-1)(0.S((c+1).W)) // Use Array for mutability
    for (i <- 0 until K-1) { // until does not include the last element
        diffs(i) = io.weights(i+1).asSInt - io.weights(i).asSInt
    }
    val df = RegInit(VecInit(Seq.fill(K-1)(0.S((c+1).W)))) 
    df := VecInit(diffs)

    val weights = RegInit(VecInit(Seq.fill(K)(0.U(c.W)))) 
    weights := io.weights

    val R = RegInit(0.U(mr.W))
    R := io.R

    val p_array = Array.tabulate(K-1)(i => Module(new Processor(b, c, mr, K, i+1)))
    val p_0 = Module(new Processor0(b, c, mr, K))

    // P(0)
    p_0.io.x_new := io.x
    p_0.io.R := R
    p_0.io.weights := weights

    // P(1)
    p_array(0).io.x_new := io.x 

    p_array(0).io.r_in := p_0.io.r_out
    p_array(0).io.s_in := p_0.io.s_out
    p_array(0).io.a_in := p_0.io.a_out

    p_array(0).io.R := R 
    p_array(0).io.weights := weights
    p_array(0).io.df := df

    // P(2) to P(K-1)
    for (i <- 0 until K-2) {
        p_array(i+1).io.x_new := io.x 

        p_array(i+1).io.a_in := p_array(i).io.a_out
        p_array(i+1).io.s_in := p_array(i).io.s_out
        p_array(i+1).io.r_in := p_array(i).io.r_out

        p_array(i+1).io.R := R
        p_array(i+1).io.weights := weights
        p_array(i+1).io.df := df
    } // goes up to the last processor, we don't need the state r,s,a of the last one to be transferred

    // sharing u with P(0)
    val u = Wire(UInt((K-1).W))
    // I want u(0) to match with weights(1) and u(1) with weights(2)
    // so LSB u(0) should be the value of the first processor
    u := Cat(p_array.map(_.io.u).reverse) // we need to reverse the order of the bits
    p_0.io.u := u

    // Output logic
    // There should only be one processor with the right rank
   // Create a Vec to hold all res outputs
    val resVec = VecInit(p_0.io.res +: p_array.map(_.io.res))

    // Combine all res outputs into a single wire
    io.y := resVec.reduce(_ | _) 
}

class ArrayContainer(val b: Int, val c: Int, val mr: Int, val K: Int) extends Module {
    val arrayUnit = Module(new ArrayUnit(b, c, mr, K))
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val y = Output(UInt(b.W))
        val R = Input(UInt(mr.W))
        val weights = Input(Vec(K, UInt(c.W)))
    })
    
    val x = RegInit(0.U(b.W))
    val y = RegInit(0.U(b.W))

    x := io.x
    arrayUnit.io.x := x

    arrayUnit.io.R := io.R
    arrayUnit.io.weights := io.weights

    y := arrayUnit.io.y
    io.y := y
}

object ArrayUnit extends App {
    val b = sys.env.getOrElse("B", "4").toInt
    val c = sys.env.getOrElse("C", "4").toInt
    val mr = sys.env.getOrElse("MR", "4").toInt
    val K = sys.env.getOrElse("K", "3").toInt
    emitVerilog(new ArrayUnit(b, c, mr, K), Array("--target-dir", "generated"))
}

object ArrayContainer extends App {
    val b = sys.env.getOrElse("B", "4").toInt
    val c = sys.env.getOrElse("C", "4").toInt
    val mr = sys.env.getOrElse("MR", "4").toInt
    val K = sys.env.getOrElse("K", "3").toInt
    emitVerilog(new ArrayContainer(b, c, mr, K), Array("--target-dir", "generated"))
}