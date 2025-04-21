import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def my_first_test(dut):
    """Try accessing the design."""
    
    dut.io_R.value = 4

    dut.io_x.value = 1

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    dut.io_x.value = 2

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    dut.io_x.value = 3

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    dut._log.info("y %s", dut.io_y.value)
    # assert dut.my_signal_2.value[0] == 0, "my_signal_2[0] is not 0!"
    assert dut.io_y.value == 2, "io_y is not 2!"

    dut.io_R.value = 3

    dut.io_x.value = 1

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    dut.io_x.value = 2

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    dut.io_x.value = 3

    dut.clock.value = 0
    await Timer(1, units="ns")
    dut.clock.value = 1
    await Timer(1, units="ns")

    assert dut.io_y.value == 1, "io_y is not 2!"