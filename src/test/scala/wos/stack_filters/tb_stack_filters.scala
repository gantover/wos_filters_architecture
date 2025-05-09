package wos.stack_filters

import org.scalatest.flatspec.AnyFlatSpec
import chisel3._
import chiseltest._

class tb_stack_filters extends AnyFlatSpec with ChiselScalatestTester {
    "ThresholdDecomposition" should "pass" in {
        test(new ThresholdDecomposition(3)) { c =>
            c.io.x.poke(0.U)
            c.io.out.expect(0.U)
            c.io.x.poke(6.U)
            c.io.out.expect("b0111111".U)
            c.io.x.poke(7.U)
            c.io.out.expect("b1111111".U)
        }
    }
    "Regs" should "pass" in {
        test(new Regs(3)) { c => 
            c.io.in.poke(1.U)
            c.clock.step()
            c.io.in.poke(1.U)
            c.clock.step()
            c.io.out.expect("b011".U)
            c.io.in.poke(1.U)
            c.clock.step()
            c.io.out.expect("b111".U)
        }
    }
    "BLL" should "pass" in {
        test(new BLL(4, 4, 4, 3)) { c => 
            c.io.R.poke(4.U)
            c.io.weights(0).poke(1.U)
            c.io.weights(1).poke(2.U)
            c.io.weights(2).poke(3.U)
            c.clock.step()
            // We give (1, 2, 3) as weights and 4 as rank
            // We follow the convention that the first weight in the array goes to the MSB of the reg
            // the MSB is the lattest bit added to the shift register, on the left
            c.io.regs_in.poke("b110".U)
            // 110 means 0 + 0 + 3 = 3 < R=4 so we should have 1 at the output
            c.io.out.expect(1.U)
            c.io.regs_in.poke("b011".U)
            // 011 means 1 + 0 + 0 < R=4 so we should have 1 at the output
            c.io.out.expect(1.U)
            c.io.regs_in.poke("b010".U)
            // 101 means 1 + 0 + 3 >= R=4 so we should have 0 at the output
            c.io.out.expect(0.U)
        }
    }
    // "BLL_Method2" should "pass" in {
    //     test(new BLL_Method2(4, 4, 4, 5)) { c => 
    //         c.io.R.poke(3.U)
    //         // 1,2,1,1,2
    //         c.io.weights(0).poke(1.U)
    //         c.io.weights(1).poke(2.U)
    //         c.io.weights(2).poke(1.U)
    //         c.io.weights(3).poke(1.U)
    //         c.io.weights(4).poke(2.U)
    //         c.io.enable.poke(0.U)
    //         c.clock.step()
    //         c.clock.step()

    //         c.io.num0.poke(1.S)
    //         c.io.regs_in.poke("b011010".U) // xnew is at 0, the LSB

    //         c.clock.step()

    //         c.io.out.expect(1.U)
    //     }
    // }
    "TR" should "pass" in {
        test(new ThresholdRecomposition(3)) { c =>
            c.io.in.poke("b1111111".U)
            c.io.out.expect(7.U)
            c.io.in.poke("b0000000".U)
            c.io.out.expect(0.U)
            c.io.in.poke("b0000001".U)
            c.io.out.expect(1.U)
            c.io.in.poke("b0000011".U)
            c.io.out.expect(2.U)
            c.io.in.poke("b0111111".U)
            c.io.out.expect(6.U)
        }
    }
    "StackFiltersUnit" should "pass" in {
        test(new StackFiltersUnit(4, 4, 4, 3)) { c =>
            c.io.R.poke(4.U)
            c.io.weights(0).poke(1.U)
            c.io.weights(1).poke(2.U)
            c.io.weights(2).poke(3.U)
            c.clock.step()

            c.io.x.poke(1.U)
            c.clock.step()
            c.io.x.poke(3.U)
            c.clock.step()
            c.io.x.poke(2.U)
            c.clock.step()

            c.io.y.expect(2.U)

            c.io.x.poke(3.U)
            c.clock.step()
            c.io.y.expect(3.U)

            c.io.x.poke(5.U)
            c.clock.step()
            c.io.y.expect(3.U)

            c.io.x.poke(5.U)
            c.clock.step()
            c.io.y.expect(5.U)
        }
    }
}
