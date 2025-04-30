# FOLDER = array
# UNIT = ArrayUnit
FOLDER = stack_filters
UNIT = StackFiltersUnit

# defaults
SIM ?= verilator 
TOPLEVEL_LANG ?= verilog

export K=5
export B=3
export C=5
export MR=8

TEST_ARGS += K=$(K) B=$(B) C=$(C) MR=$(MR)

VERILOG_SOURCES += /$(PWD)/../generated/$(UNIT).v
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = $(UNIT)

# MODULE is the basename of the Python test file
MODULE = main $(TEST_ARGS)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

generate:
	cd .. && sbt "runMain wos.$(FOLDER).$(UNIT)" 