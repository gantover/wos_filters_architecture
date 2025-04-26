import cocotb
from cocotb.triggers import FallingEdge, Timer, RisingEdge


import random

# Generate an array of 10 random integers between 1 and 100
rvs = [random.randint(0, 7) for _ in range(10000)]

K = 3

weights = [random.randint(1, 5) for _ in range(K)]
# weights = [1, 2, 3]

rank = 4

async def clock_step(dut, cycles=1):
    """Simulate clock steps."""
    for _ in range(cycles):
        dut.clock.value = 0
        await Timer(5, units="ns")  # Half clock period
        dut.clock.value = 1
        await Timer(5, units="ns")  # Half clock period

@cocotb.test()
async def my_first_test(dut):

    # await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    
    await clock_step(dut)

    dut.reset.value = 1

    await clock_step(dut)
    
    dut.reset.value = 0
    
    await clock_step(dut)

    dut.io_R.value = rank

    for i in range(len(weights)):
        getattr(dut, f"io_weights_{i}").value = weights[i]

    await clock_step(dut)

    for i in range(len(rvs)):

        dut.io_x.value = rvs[i]
        await clock_step(dut)

        if i > 1:
            window = rvs[i-2:i+1]
            window.reverse()
            extended_window = [[window[j] for _ in range(w)] for j, w in enumerate(weights)]
            flat_extended_window = [item for sublist in extended_window for item in sublist]
            flat_extended_window.sort()
            true_y = flat_extended_window[rank-1]
            assert dut.io_y.value == true_y, f"Expected {true_y}, but got {dut.io_y.value} for x = {rvs[i]} with {flat_extended_window}"