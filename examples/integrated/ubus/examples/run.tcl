# QuestaSim Script


set UVM_HOME    ../../../..
set SV          ../sv
set RTL         ./

set TEST test_2m_4s

quit -sim
catch {file delete -force work}

vlib work

# UVM
vlog -incr +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm_pkg.sv -ccflags -DQUESTA \
    -ccflags -Wno-maybe-uninitialized \
    -ccflags -Wno-missing-declarations \
    -ccflags -Wno-return-type \
    ${UVM_HOME}/src/dpi/uvm_dpi.cc

# RTL
vlog -sv ${RTL}/dut_dummy.v -timescale 1ns/10ps

# AGENTS & SEQS
vlog -incr +incdir+${UVM_HOME}/src +incdir+${SV} ${SV}/ubus_pkg.sv -suppress 2263

# TB
vlog -incr +incdir+${UVM_HOME}/src +incdir+${SV} +incdir+${RTL} ubus_tb_top.sv -timescale 1ns/10ps

# SIM
vsim -c -do "run -all" ubus_tb_top +UVM_TESTNAME=${TEST} -suppress 8887

# coverage report -detail