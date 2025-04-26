# Makefile

# UNIT = ArrayUnit
UNIT = StackFiltersUnit 

# defaults
SIM ?= verilator 
TOPLEVEL_LANG ?= verilog

# VERILOG_SOURCES += /$(PWD)/../generated/$(UNIT).v
VERILOG_SOURCES += /$(PWD)/../generated/StackFiltersUnit.v
# VERILOG_SOURCES += ../generated/Array.v
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = $(UNIT)

# MODULE is the basename of the Python test file
MODULE = main 

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim