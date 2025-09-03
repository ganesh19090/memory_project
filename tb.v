`include "memory_project.v"
module tb;
parameter WIDTH=8; //wdata
parameter DEPTH=32; 
parameter ADDR_WIDTH=$clog2(DEPTH);
reg clk,rst,wr_rd,valid;
reg [WIDTH-1:0]wdata;
reg [ADDR_WIDTH-1:0]addr;
wire [WIDTH-1:0]rdata;
wire ready; 

memory dut(.clk(clk),.rst(rst),.wr_rd(wr_rd),.addr(addr),.wdata(wdata),.rdata(rdata),.valid(valid),.ready(ready));

integer i;
always #5 clk=~clk;
reg[20*8-1:0]test_name;

initial begin
$value$plusargs("test_name=%0s",test_name);
$display("test_name=%0s",test_name);
end

initial begin
clk=0;
rst=1;
repeat(2) @(posedge clk);
rst=0;

case(test_name)
"1WR_1RD":begin
$display("***** wdata=%d, addr=%d", wdata, addr);
writes(15,1);
reads(15,1);
end

"5WR_5RD":begin
writes(20,5); // from 20 to 25 it must store value random
reads(20,5);  
end

"FD_WR_FD_RD":begin
writes(0,DEPTH);  // all 32 location will be filled with random data
reads(0,DEPTH);
end

"BD_WR_BD_RD":begin 
bd_writes();     
bd_reads();
end

"FD_WR_BD_RD":begin
writes(0,DEPTH);
bd_reads();
end

"BD_WR_FD_RD":begin
bd_writes();
reads(0,DEPTH);
end

"1st_QUATOR_WR_RD":begin
writes(0,DEPTH/4);
reads(0,DEPTH/4);
end

"2nd_QUATOR_WR_RD":begin
writes(DEPTH/4,DEPTH/4);
reads(DEPTH/4,DEPTH/4);
end

"3rd_QUATOR_WR_RD":begin
writes(DEPTH/2,DEPTH/4);
reads(DEPTH/2,DEPTH/4);
end

"4th_QUATOR_WR_RD":begin
writes((3*DEPTH)/4,DEPTH/4);
reads((3*DEPTH)/4,DEPTH/4);
end

"CONSECUTIVE":begin
for(i=0;i<DEPTH;i=i+1) begin
consecutive(i);
end

end
default:begin  //consecutive writes/reads
$display("default");
end
endcase

#100;
$finish;
end

task writes(input reg[ADDR_WIDTH-1:0]start_loc,input reg[ADDR_WIDTH:0]num_writes);
begin
for(i=start_loc;i<(start_loc+num_writes);i=i+1) begin
@(posedge clk);
wr_rd=1; 
addr=i; 
wdata=$random();
valid=1; 
wait(ready==1);
end

@(posedge clk);
wr_rd=0;
addr=0;
wdata=0;
valid=0;
end
endtask  //writes finished

task reads(input reg[ADDR_WIDTH-1:0]start_loc,input reg[ADDR_WIDTH:0]num_reads);
begin
for(i=start_loc;i<(start_loc+num_reads);i=i+1) begin
@(posedge clk);
wr_rd=0; //read operation
addr=i;
valid=1;
wait(ready==1);
end

@(posedge clk);
wr_rd=0;
addr=0;
valid=0;
end
endtask // reads finished

task bd_writes();
$readmemh("input.hex",dut.mem);
endtask

task bd_reads();
$writememh("output.hex",dut.mem);
endtask

task consecutive(input reg[ADDR_WIDTH-1:0]loc); begin
@(posedge clk);
wr_rd=1; 
addr=loc; 
wdata=$random();
valid=1; 
wait(ready==1);

@(posedge clk);
wr_rd=0; 
addr=loc;
valid=1;
wait(ready==1);
end

endtask

endmodule


