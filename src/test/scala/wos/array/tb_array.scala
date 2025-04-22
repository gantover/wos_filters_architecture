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
            c.io.s.poke("b101".U) // we have 0 at the MSB so v should be 0
            c.io.u.poke(0.U)
            c.io.df(0).poke(1.S) // that's for P(1) - P(0)
            c.io.df(1).poke(1.S) // that's for P(2) - P(1)
            c.io.fp0.poke(1.U)
            c.io.fpkm1.poke(1.U)
            c.io.r_old.poke(1.U)

            c.io.r_new.expect(1.U)
        }
    }
    "Processor0" should "pass" in {
        test(new Processor0(4, 4, 4, 3, Array(1, 2, 3))) { c =>
            c.io.x_new.poke(1.U)
            c.io.R.poke(2.U)
            c.io.u.poke("b00".U) 

            c.clock.step()

            c.io.r_out.expect(6.U)
            c.io.s_out.expect("b110".U)
            c.io.a_out.expect(1.U)

            c.io.x_new.poke(1.U)
            c.io.R.poke(2.U)
            c.io.u.poke("b01".U) // I want u(0) to match with wights(1) and u(1) with weights(2)

            c.clock.step()

            c.io.r_out.expect(4.U)
            c.io.s_out.expect("b100".U)
        }
    }
    "Processor0_1" should "pass" in {
        // test(new ArrayUnit(4, 4, 4, 6, Array(2, 2, 4, 3, 3, 3))) { c =>
        test(new Processor0(4, 4, 4, 6, Array(2, 2, 4, 3, 3, 3))) { c =>
            c.io.R.poke(7.U)
            c.io.x_new.poke(1.U)
            c.io.u.poke("b11111".U)

            c.clock.step()

            c.io.r_out.expect(1.U)
            c.io.s_out.expect("b00000".U)
            c.io.res.expect(0.U)
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
            c.io.u.expect(1.U) // u = 1 if a >= x_new

            c.clock.step()

            c.io.a_out.expect(1.U)
            c.io.r_out.expect(4.U) // r_old = 1, u = 1, v = 0, df = 1,1 : 1 + 1 + 0 + 1 + 1 = 4
            c.io.s_out.expect("b111".U)

            c.io.res.expect(0.U) 
            c.io.R.poke(4.U)
            c.io.res.expect(1.U) 
        }
    }

    "Processor_2" should "pass" in {
        test(new Processor(4, 4, 4, 6, Array(2, 2, 4, 3, 3, 3), 2)) { c =>
            c.io.R.poke(7.U)

            c.io.x_new.poke(1.U)
            c.io.a_in.poke(3.U)
            c.io.r_in.poke(4.U)
            c.io.s_in.poke("b001000".U)

            c.io.u.expect(1.U) 

            c.clock.step()

            c.io.r_out.expect(6.U) // r_old = 1, u = 1, v = 0, df = 1,1 : 1 + 1 + 0 + 1 + 1 = 4
            c.io.s_out.expect("b010001".U)
            c.io.res.expect(1.U) 
        }
    }
    "ArrayUnit1" should "pass" in {
        test(new ArrayUnit(8, 8, 8, 3, Array(1, 1, 3))) { c =>
            // c.io.R.poke(2.U)
            c.io.R.poke(4.U)

            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(2.U)
            c.clock.step()
            c.io.x.poke(3.U)
            c.clock.step()

            c.io.y.expect(2.U)
            c.io.R.poke(3.U)
            c.io.y.expect(1.U)
        }
    }
    "ArrayUnit2" should "pass" in {
        test(new ArrayUnit(8, 8, 8, 3, Array(1, 1, 3))) { c =>
            // c.io.R.poke(2.U)
            c.io.R.poke(4.U)

            c.io.x.poke(3.U)
            c.clock.step()
            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(4.U)
            c.clock.step()

            c.io.y.expect(3.U)

            c.io.x.poke(4.U)
            c.clock.step()

            c.io.y.expect(4.U)

            c.io.x.poke(5.U)
            c.clock.step()

            c.io.y.expect(4.U)
        }
    }
    "ArrayUnit3" should "pass" in {
        test(new ArrayUnit(8, 8, 8, 3, Array(3, 2, 1))) { c =>
            // c.io.R.poke(2.U)
            c.io.R.poke(3.U)

            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(2.U)
            c.clock.step()
            c.io.x.poke(3.U)
            c.clock.step()

            c.io.y.expect(2.U)
        }
    }
    "ArrayUnit4" should "pass" in {
        test(new ArrayUnit(8, 8, 8, 3, Array(1, 2, 3))) { c =>
            // c.io.R.poke(2.U)
            c.io.R.poke(4.U)

            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(2.U)
            c.clock.step()
            c.io.x.poke(3.U)
            c.clock.step()
            c.io.x.poke(4.U)
            c.clock.step()
            c.io.x.poke(5.U)
            c.clock.step()
            c.io.x.poke(6.U)
            c.clock.step()

            c.io.x.poke(10.U)
            c.clock.step()
            c.io.x.poke(11.U)
            c.clock.step()
            c.io.x.poke(4.U)
            c.clock.step()

            c.io.y.expect(10.U)
        }
    }
    // "ArrayUnit" should "pass" in {
    //     test(new ArrayUnit(4, 4, 4, 6, Array(2, 2, 4, 3, 3, 3))) { c =>
    //         // c.io.R.poke(2.U)
    //         c.io.R.poke(7.U)

    //         c.io.x.poke(8.U)
    //         c.clock.step()

    //         c.io.x.poke(5.U)
    //         c.clock.step()

    //         c.io.x.poke(2.U)
    //         c.clock.step()

    //         c.io.x.poke(6.U)
    //         c.clock.step()

    //         c.io.x.poke(3.U)
    //         c.clock.step()

    //         c.io.x.poke(4.U)
    //         c.clock.step()

    //         c.io.x.poke(1.U)
    //         c.clock.step()

    //         // c.io.y.expect(1.U)
    //         // c.io.y.expect(2.U)

    //         c.io.x.poke(0.U)
    //         c.clock.step()
    //         // c.io.y.expect(3.U)

    //         c.io.x.poke(0.U)
    //         c.clock.step()
    //         // c.io.y.expect(3.U)

    //         c.io.x.poke(0.U)
    //         c.clock.step()
    //     }
    // }
}
