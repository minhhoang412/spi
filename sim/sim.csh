#!/bin/csh

set WAVE = on
set COV = off
set SVA = off

set next = ""
foreach arg ($argv)
  if ( "$next" == "" ) then
    set next = "${arg}"
  else
    switch ("${next}")
      case "-wave":
        set WAVE = ${arg}
        breaksw
      case "-cov":
        set COV = ${arg}
        breaksw
      case "-sva":
        set SVA = ${arg}
        breaksw
      default:
        breaksw
    endsw
    set next = ""
  endif
end

set TOP_SIM_DIR = `pwd`
setenv DIR_TB ${TOP_SIM_DIR}/../tb/src
set RTL_DIR = "${TOP_SIM_DIR}/../rtl"
set TB_DIR = "${TOP_SIM_DIR}/../tb/src/*"
set TB_LIST = "${TOP_SIM_DIR}/../tb/list/list_tb.txt"
set SIM_DIR = "${TOP_SIM_DIR}"
set LOG_FILE = "${TOP_SIM_DIR}/xrun.log"
set worklib = "worklib"
set RTL_COMP_DIR = "${TOP_SIM_DIR}/work/rtl_compile"


if (! -d work/sim_log) then
    mkdir work/sim_log
endif 

cd work/sim_log

set WORK_DIR = "${TOP_SIM_DIR}/work/sim_log"

#remove old file before run
if (! -d ${WORK_DIR}) then
    rm -rf $WORK_DIR xcelium.d simv* *.log *.history *.key *.shm
endif

if ($WAVE == "on") then
    echo "database -open wave -shm -default -event" > wave.tcl
    echo "probe -create -database wave testbench -all -dynamic -shm -depth all" >> wave.tcl
    echo "probe -create testbench.data* testbench.tb_arr_vld -database wave -unpacked 1500000 " >> wave.tcl
    echo "run" >> wave.tcl
    echo "assertion -summary -show all" >> wave.tcl
    echo "exit" >> wave.tcl
else
    echo "run" > wave.tcl
    echo "assertion -summary -show all" >> wave.tcl
    echo "exit" >> wave.tcl
endif


#compile testbench

cp -rf ${RTL_COMP_DIR}/xcelium.d ./
xrun \
    -sv \
    -compile \
    -64bit \
    -work $worklib \
    -uvm \
    -uvmhome CDNS-1.1d \
    -incdir ${DIR_TB} \
    -f ${TB_LIST} 


#compile elaborate
xrun \
    -sv \
    -64bit \
    -work $worklib \
    -disable_sem2009 \
    -top tb_spi \
    +access+rwc \
    -disable_sem2009 \
    -INPUT wave.tcl \
    -incdir ${DIR_TB} \
    -f ${TB_LIST}


#run simulate
# xrun \
#     -R \
#     -64bit \
#     -INPUT wave.tcl \
#     -uvmhome CDNS-1.2 
    #-log_xmsim sim_log/sim.log

# #move wave
# if ($WAVE == "on") then
#     if (-d wave ) then
#         rm -rf wave
#         endif
#         rm -rf
#         mkdir wave/
#         mv -f *.shm/* wave/
#         rm -rf */shm
# endif
cd ../..

#     # -uvmhome CDNS-1.2

