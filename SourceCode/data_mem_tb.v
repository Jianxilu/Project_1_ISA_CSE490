module data_mem_tb;

reg clk;
reg reset;
reg mem_write;
reg mem_read;
reg [15:0] addr;
reg [15:0] write_data;
wire [15:0] read_data;
integer errors;

data_mem dut(.clk(clk), .reset(reset), .addr(addr), .write_data(write_data),  .mem_write(mem_write), .mem_read(mem_read), .read_data(read_data));

always #5 clk=~clk;

initial begin
    clk=0;
    reset=0;
    mem_write=0;
    mem_read=0;
    addr=0;
    write_data=0;
    errors=0;

    //sw abcd to address 0x10 
   //highest byte -> 0x10, low byte -> 0x11
    @(negedge clk); addr=16'h0010; write_data=16'hABCD; mem_write=1;
    @(negedge clk); mem_write=0;
    $display("byte 0x10 = %h (expected ab)", dut.memory[16]);
    if (dut.memory[16]!==8'hAB) errors=errors+1;
    $display("byte 0x11 = %h (expected cd)", dut.memory[17]);
    if (dut.memory[17]!==8'hCD) errors=errors+1;

    //lw from 0x10
   //same with mem_read = 0
    mem_read=1;
    #1;
    $display("lw 0x10 = %h (expected abcd)", read_data);
    if (read_data!==16'hABCD) errors=errors+1;
    mem_read=0;
    #1;
    $display("mem_read = 0: %h (expected 0000)", read_data);
    if (read_data!==16'h0000) errors=errors+1;

    //mem_write = 0, mem doesnt change
    @(negedge clk); write_data=16'h1111;
    @(negedge clk); mem_read=1;
    #1;
    $display("lw 0x10 with mem_write = 0 = %h (expected abcd)", read_data);
    if (read_data!==16'hABCD) errors=errors+1;

    //no write while reset
    @(negedge clk); reset=1; mem_write=1; write_data=16'h2222;
    @(negedge clk); reset=0; mem_write=0;
    #1;
    $display("lw 0x10 after reset = %h (expected abcd)", read_data);
    if (read_data!==16'hABCD) errors=errors+1;

    //sw to 0xFF
   //the low byte wraps around to address 0x00
    @(negedge clk); addr=16'h00FF; write_data=16'h5A3C; mem_write=1;
    @(negedge clk); mem_write=0;
    $display("byte 0xFF = %h (expected 5a)", dut.memory[255]);
    if (dut.memory[255]!==8'h5A) errors=errors+1;
    $display("byte 0x00 = %h (expected 3c)", dut.memory[0]);
    if (dut.memory[0]!==8'h3C) errors=errors+1;

    if (errors==0)
        $display("DATA MEMORY TESTS PASSED");
    else
        $display("%0d DATA MEMORY TEST(S) FAILED", errors);
    $finish;
end
endmodule
