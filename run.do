vlog memory_project.v
#vsim tb +test_name=BD_WR_FD_RD
#vsim tb +test_name=1st_QUATOR_WR_RD
#vsim tb +test_name=1st_QUATOR_WR_RD
#vsim tb +test_name=3rd_QUATOR_WR_RD
#vsim tb +test_name=4th_QUATOR_WR_RD
vsim tb +test_name=CONSECUTIVE
add wave -position insertpoint sim:/tb/*
run -all
