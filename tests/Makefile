# Makefile

FOLDER = array
UNIT = ArrayUnit
# FOLDER = stack_filters
# UNIT = StackFiltersUnit

# defaults
SIM ?= verilator 
TOPLEVEL_LANG ?= verilog
K = 6
export K
export B = 4
export C = 4
export MR = 8

VERILOG_SOURCES += /$(PWD)/../generated/$(UNIT).v
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = $(UNIT)

# MODULE is the basename of the Python test file
MODULE = main 

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# export K=$(K) && \

generate:
	cd .. && sbt "runMain wos.$(FOLDER).$(UNIT)" 