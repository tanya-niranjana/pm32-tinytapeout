import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start PM32 multiplier test")

    # Test 2 * 2 = 4
    dut.ui_in.value = 0x22
    dut.uio_in.value = 0
    await Timer(1, units="us")
    assert dut.uo_out.value == 4

    # Test 3 * 5 = 15
    dut.ui_in.value = 0x53
    await Timer(1, units="us")
    assert dut.uo_out.value == 15

    # Test 7 * 8 = 56
    dut.ui_in.value = 0x87
    await Timer(1, units="us")
    assert dut.uo_out.value == 56

    # Test 15 * 15 = 225
    dut.ui_in.value = 0xFF
    await Timer(1, units="us")
    assert dut.uo_out.value == 225

    dut._log.info("PM32 multiplier test passed")
