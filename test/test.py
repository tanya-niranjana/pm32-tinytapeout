import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start sequential PM32 multiplier test")

    # Start clock
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset design
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Test: 3 * 5 = 15
    # Wrapper uses:
    # ui_in = multiplier input
    # uio_in = multiplicand input
    # ui_in[0] is also start, so use an odd value to start
    dut.ui_in.value = 3
    dut.uio_in.value = 5

    await RisingEdge(dut.clk)

    # Drop start low after one clock
    dut.ui_in.value = 0

    # Wait long enough for PM32 to finish
    await ClockCycles(dut.clk, 70)

    assert int(dut.uio_out.value) & 1 == 1    
    assert int(dut.uo_out.value) == 15

    dut._log.info("Sequential PM32 multiplier test passed")
