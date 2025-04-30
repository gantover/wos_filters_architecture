import cocotb
from cocotb.triggers import FallingEdge, Timer, RisingEdge
import os
from math import log2


import random

# random.seed(0)

B = int(os.environ.get("B", 3))
C = int(os.environ.get("C", 3))
MR = int(os.environ.get("MR", 3))
# assert MR == C, "MR must be equal to C"
K = int(os.environ.get("K", 3))

async def clock_step(dut, cycles=1):
    """Simulate clock steps."""
    for _ in range(cycles):
        dut.clock.value = 0
        await Timer(5, units="ns")  # Half clock period
        dut.clock.value = 1
        await Timer(5, units="ns")  # Half clock period

@cocotb.test()
async def my_first_test(dut):

    await clock_step(dut)

    dut.reset.value = 1

    await clock_step(dut)
    
    dut.reset.value = 0

    for it in range(10):
        weights = [random.randint(1, 2**C-1) for _ in range(K)]
        rank = random.randint(1, 2**C-1)
        print(f"It {it} Weights : {weights} Rank : {rank}")
        rvs = [random.randint(0, 2**B-1) for _ in range(10000)]
    
        await clock_step(dut)

        dut.io_R.value = rank

        for i in range(len(weights)):
            getattr(dut, f"io_weights_{i}").value = weights[i]

        await clock_step(dut)
        await clock_step(dut)

        for i in range(len(rvs)):

            dut.io_x.value = rvs[i]
            await clock_step(dut)

            if i >= K:
                window = rvs[i-(K-1):i+1]
                window.reverse()
                extended_window = [[window[j] for _ in range(w)] for j, w in enumerate(weights)]
                flat_extended_window = [item for sublist in extended_window for item in sublist]
                flat_extended_window.sort()
                true_y = flat_extended_window[rank-1]
                assert dut.io_y.value == true_y, f"Expected {true_y}, but got {dut.io_y.value} for x = {rvs[i]} at {i} with {flat_extended_window} and weights {weights}"
    