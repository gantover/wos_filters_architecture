# Makefile

FOLDER = array
UNIT = ArrayUnit
# UNIT = StackFiltersUnit 

# defaults
SIM ?= verilator 
TOPLEVEL_LANG ?= verilog
K = 6
export K

VERILOG_SOURCES += /$(PWD)/../generated/$(UNIT).v
# VERILOG_SOURCES += /$(PWD)/../generated/StackFiltersUnit.v
# VERILOG_SOURCES += ../generated/ArrayUnit.v
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