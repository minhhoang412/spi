database -open wave -shm -default -event
probe -create -database wave testbench -all -dynamic -shm -depth all
probe -create testbench.data* testbench.tb_arr_vld -database wave -unpacked 1500000 
run
assertion -summary -show all
exit
