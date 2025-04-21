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

    val Df = io.df.zipWithIndex.foldLeft(0.S(b.W)) { case (sum, (df_i, i)) =>
        sum + Mux(io.s(K-1-i) === 1.U, df_i, 0.S)
    }
    // io.s(0) is the LSB of s, it should contain v, the comparison with xold
    io.r_new := ((io.r_old + Mux(io.u === 1.U, io.fp0, 0.U) - Mux(io.s(0) === 1.U, io.fpkm1, 0.U)).asSInt + Df).asUInt
}

class Processor0(val b: Int, val c: Int, val mr: Int, val K: Int, val weights: Array[Int]) extends Module {
    val io = IO(new Bundle {
        val x_new = Input(UInt(b.W)) // where the new sample arrives
        val R = Input(UInt(mr.W)) // the desired rank
        val u = Input(UInt((K-1).W)) // the comparision with the new sample from P(1) to P(K-1)

        val r = Output(UInt(mr.W)) // store the weighted rank of the sample
        val s = Output(UInt(K.W))
        val a = Output(UInt(b.W))

        val res = Output(UInt(1.W))
    })


    val r = RegInit(0.U(mr.W)) // the weighted rank of the sample
    val s = RegInit(0.U(K.W)) // stores the result of the comparison to all samples that arrrived beofre it
    val a = RegInit(0.U(b.W)) // holds the samples

    a := io.x_new

    // Step 2.2 : compute the rank of x_new
    // Here we start at weights(1) because of .tail but u is offset by 1 so it matches : u(0) <-> weights(1)
    val acc = weights.tail.zipWithIndex.foldLeft(0.U(mr.W)) { case (sum, (weight, i)) =>
        sum + Mux(io.u(i) === 0.U, weight.U(mr.W), 0.U(mr.W))
    }
    r := 1.U + acc

    // Step 2.3 : Update comparison with other samples
    // for (j <- 0 until K-1) {  
    //     // loads !u(P(j)) into s[j-1] for 1 <= j <= K-1 but the order of the bits of s is reversed and u is offset by 1
    //     s(K - 1 - j) := !io.u(j)
    // }
    val s_new = (0 until K-1).foldLeft(0.U(K.W)) { (acc, j) =>
        acc | (!io.u(j) << (K - 1 - j))
    }
    s := s_new

    // step 3 : match rank
    val rmr = Wire(SInt((c+1).W))
    rmr := io.R.asSInt - r.asSInt 
    io.res := (rmr >= 0.S && rmr < weights(0).asSInt).asUInt
    // res will come out at the next clock cycle

    io.r := r
    io.s := s
    io.a := a
}

class Processor(val b: Int, val c: Int, val mr: Int, val K: Int, val weights: Array[Int], val id : Int) extends Module {
    // val max_rank = weights.sum
    // val mr = math.ceil(math.log10(max_rank + 1) / math.log10(2)).toInt
    val io = IO(new Bundle {
        val R = Input(UInt(mr.W)) // the desired rank

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
        val res = Output(UInt(1.W))
    })

    val r = RegInit(0.U(b.W)) // the weighted rank of the sample
    val s = RegInit(0.U(K.W)) // store the comparaison result with all samples that arrived before it
    val a = RegInit(0.U(b.W)) // holds the samples
    
    a := io.a_in

    val ruu = Module(new RankUpdateUnit(b, c, mr, K))

    // Setup weights
    // val diffs = Array.fill(K-1)(0.S((c+1).W))
    // for (i <- 0 until K-1) { // until does not include the last element
    //     diffs(i) := weights(i+1).S((c+1).W) - weights(i).S((c+1).W)
    // }
    // val df = RegInit(VecInit(diffs)) // the difference in weights of adjacent samples 

    val diffs = Array.fill(K-1)(0.S((c+1).W)) // Use Array for mutability
    for (i <- 0 until K-1) { // until does not include the last element
        diffs(i) = weights(i+1).S((c+1).W) - weights(i).S((c+1).W)
        // printf(p"diffs($i): ${diffs(i)}\n")
    }
    val df = RegInit(VecInit(diffs)) // Convert the mutable Array to a Vec
    // printf("bll_outputs: %b\n", bll_outputs)

    val f = RegInit(weights(id).U(c.W)) // the weight of the sample, constant 
    val fp0 = RegInit(weights(0).U(c.W)) // weight of sample at P(0), constant
    // printf(p"fp0: ${fp0}\n")
    val fpkm1 = RegInit(weights(K-1).U(c.W)) // weight of sample at P(K-1), constant
    // printf(p"fpkm1: ${fpkm1}\n")


    // step 1 : compare with new sample
    val u = Wire(UInt(1.W))
    u := Mux(a >= io.x_new, 1.U, 0.U) // compare the new sample with the previous one
    io.u := u // to send it immediately to P(0)

    // step 2.1 : update rank

    ruu.io.s := io.s_in
    ruu.io.u := u // freshly computed

    // sharing the constants
    ruu.io.df := df
    ruu.io.fp0 := fp0
    ruu.io.fpkm1 := fpkm1

    ruu.io.r_old := io.r_in

    r := ruu.io.r_new

    // step 2.3 : update comparison with other samples
    s := Cat(u, io.s_in(K-1, 1)) // we discard the lsb shift everything and add the new sample to the msb

    // sending state to the next processor (at next clock cycle)

    // step 3 : match rank
    val rmr = Wire(SInt((c+1).W))
    // printf(p"r : ${r} at id : ${id} and f : ${f}\n")
    rmr := io.R.asSInt - r.asSInt 
    io.res := (rmr >= 0.S && rmr < f.asSInt).asUInt
    // as of right now, we need to wait a clock cycle to get the result
    // because we use r instead of ruu.io.r_new

    io.r_out := r
    io.s_out := s
    io.a_out := a
}

class ArrayUnit(val b: Int, val c: Int, val mr: Int, val K: Int, val weights: Array[Int]) extends Module {
    val io = IO(new Bundle {
        val x = Input(UInt(b.W))
        val y = Output(UInt(b.W))
        val R = Input(UInt(mr.W))
    })

    // val p_array = Array.fill(depth)(Module(new Processor(b, c, mr, K, weights, 0)))
    val p_array = Array.tabulate(K-1)(i => Module(new Processor(b, c, mr, K, weights, i+1))) // length is K-1
    val p_0 = Module(new Processor0(b, c, mr, K, weights))

    p_0.io.x_new := io.x
    p_0.io.R := io.R
    printf(p"p_0.io.x_new: ${p_0.io.x_new}\n")
    printf(p"p_0.io.r: ${p_0.io.r}\n")
    printf(p"p_0.io.s: ${p_0.io.s}\n")
    printf(p"p_0.io.res: ${p_0.io.res}\n")

    p_array(0).io.x_new := io.x 
    p_array(0).io.r_in := p_0.io.r
    p_array(0).io.s_in := p_0.io.s
    p_array(0).io.a_in := p_0.io.a 
    printf(p"p_array(1).io.a_in: ${p_array(0).io.a_in}\n")
    printf(p"p_array(1).io.r_in: ${p_array(0).io.r_in}\n")
    printf("s_in: %b\n", p_array(0).io.s_in.asUInt)
    printf(p"p_array(1).io.u: ${p_array(0).io.u}\n")
    printf(p"p_array(1).io.res: ${p_array(0).io.res}\n")
    p_array(0).io.R := io.R 

    for (i <- 0 until K-2) {
        p_array(i+1).io.x_new := io.x 
        p_array(i+1).io.a_in := p_array(i).io.a_out
        p_array(i+1).io.s_in := p_array(i).io.s_out
        p_array(i+1).io.r_in := p_array(i).io.r_out
        printf(p"p_array(${i+2}).io.a_in: ${p_array(i+1).io.a_in}\n")
        // printf(p"p_array(${i+2}).io.s_in: ${p_array(i+1).io.s_in}\n")
        printf("s_in: %b\n", p_array(i+1).io.s_in.asUInt)
        printf(p"p_array(${i+2}).io.r_in: ${p_array(i+1).io.r_in}\n")
        printf(p"p_array(${i+2}).io.u: ${p_array(i+1).io.u}\n")
        printf(p"p_array(${i+2}).io.res: ${p_array(i+1).io.res}\n")
        p_array(i+1).io.R := io.R
    } // goes up to the last processor, we don't need the state r,s,a of the last one to be transferred

    // sharing u with P(0)
    val u = Wire(UInt((K-1).W))
    // I want u(0) to match with weights(1) and u(1) with weights(2)
    // so LSB u(0) should be the value of the first processor
    u := Cat(p_array.map(_.io.u).reverse) // we need to reverse the order of the bits
    p_0.io.u := u

    // printf u in binary
    printf("u: %b\n", u.asUInt)



    // Output logic
    // There should only be one processor with the right rank
    // Default value for io.y
    io.y := 0.U

    // Check if p_0 has the right rank
    when (p_0.io.res === 1.U) {
        io.y := p_0.io.a
    }.otherwise {
        // Check each processor in the array
        for (i <- 0 until K-1) {
            when (p_array(i).io.res === 1.U) {
                io.y := p_array(i).io.a_out
            }
        }
    }
    printf(p"io.y: ${io.y}\n")
    printf("---------\n")
}

