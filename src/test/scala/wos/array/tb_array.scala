package wos.array

import org.scalatest.flatspec.AnyFlatSpec
import chisel3._
import chiseltest._

class tb_array extends AnyFlatSpec with ChiselScalatestTester {
    "RankUpdateUnitPos" should "pass" in {
        test(new RankUpdateUnit(4, 4, 4, 3)) { c =>
            c.io.s.poke("b011".U) // 
            c.io.u.poke(1.U)
            c.io.df(0).poke(1.S) // that's for P(1) - P(0)
            c.io.df(1).poke(2.S) // that's for P(2) - P(1)
            c.io.fp0.poke(2.U)
            c.io.fpkm1.poke(3.U) // don't care because v should be 0
            c.io.r_old.poke(2.U)

            c.io.r_new.expect(7.U)
        }
    }
    "RankUpdateUnitNeg" should "pass" in {
        test(new RankUpdateUnit(4, 4, 4, 3)) { c =>
            c.io.s.poke("b011".U) // we have 0 at the MSB so v should be 0
            c.io.u.poke(1.U)
            c.io.df(0).poke(-1.S) // that's for P(1) - P(0)
            c.io.df(1).poke(-2.S) // that's for P(2) - P(1)
            c.io.fp0.poke(2.U)
            c.io.fpkm1.poke(3.U) // don't care because v should be 0
            c.io.r_old.poke(2.U)

            c.io.r_new.expect(1.U)
        }
    }
    "RankUpdateUnitGen" should "pass" in {
        test(new RankUpdateUnit(4, 4, 4, 3)) { c =>
            c.io.s.poke("b001".U) // we have 0 at the MSB so v should be 0
            c.io.u.poke(0.U)
            c.io.df(0).poke(1.S) // that's for P(1) - P(0)
            c.io.df(1).poke(1.S) // that's for P(2) - P(1)
            c.io.fp0.poke(1.U)
            c.io.fpkm1.poke(3.U)
            c.io.r_old.poke(1.U)

            c.io.r_new.expect(2.U)
        }
    }
    "Processor0" should "pass" in {
        test(new Processor0(4, 4, 4, 3, Array(1, 2, 3))) { c =>
            c.io.x_new.poke(1.U)
            c.io.R.poke(2.U)
            c.io.u.poke("b00".U) 

            c.clock.step()

            c.io.r.expect(6.U)
            c.io.s.expect("b011".U)
            c.io.a.expect(1.U)

            c.io.x_new.poke(1.U)
            c.io.R.poke(2.U)
            c.io.u.poke("b01".U) // I want u(0) to match with wights(1) and u(1) with weights(2)

            c.clock.step()

            c.io.r.expect(4.U)
            c.io.s.expect("b010".U)
        }
    }

    "Processor" should "pass" in {
        test(new Processor(4, 4, 4, 3, Array(1, 2, 3), 1)) { c =>
            c.io.R.poke(2.U)

            c.io.x_new.poke(1.U)
            c.io.a_in.poke(1.U)
            c.io.r_in.poke(1.U)
            c.io.s_in.poke("b011".U)

            c.io.a_out.expect(0.U)
            c.io.u.expect(0.U) // u = 1 if a >= x_new

            c.clock.step()

            c.io.a_out.expect(1.U)
            c.io.r_out.expect(3.U)
            c.io.s_out.expect("b110".U)

            c.clock.step()

            c.io.res.expect(0.U) 
            c.io.R.poke(4.U)
            c.io.res.expect(1.U) 
        }
    }
    "ArrayUnit" should "pass" in {
        test(new ArrayUnit(4, 4, 4, 3, Array(1, 1, 3))) { c =>
            // c.io.R.poke(2.U)
            c.io.R.poke(4.U)

            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(2.U)
            c.clock.step()
            c.io.x.poke(3.U)
            c.clock.step()

            // c.io.y.expect(1.U)
            // c.io.y.expect(2.U)

            c.io.x.poke(3.U)
            c.clock.step()
            // c.io.y.expect(3.U)

            c.io.x.poke(5.U)
            c.clock.step()
            // c.io.y.expect(3.U)

            c.io.x.poke(5.U)
            c.clock.step()
        }
    }
}
