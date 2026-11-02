module reg_file_tb;
  
reg clk;
reg reset;
reg reg_write;
reg [3:0] read_reg1;
reg [3:0] read_reg2;
reg [3:0] write_reg;
reg [15:0] write_data;
wire [15:0] read_data1;
wire [15:0] read_data2;
integer errors;

reg_file dut(.clk(clk), .reset(reset), .read_reg1(read_reg1), .read_reg2(read_reg2),  .write_reg(write_reg), .write_data(write_data), .reg_write(reg_write),.read_data1(read_data1), .read_data2(read_data2));

always #5 clk=~clk;

initial begin
    clk=0;
    reset=0;
    reg_write=0;
    read_reg1=0;
    read_reg2=0;
    write_reg=0;
    write_data=0;
    errors=0;

    //write $s3, $s15 and $s0, 1 per clk
    @(negedge clk); reg_write=1; write_reg=3; write_data=16'h1234;
    @(negedge clk); write_reg=15; write_data=16'hBEEF;
    @(negedge clk); write_reg=0; write_data=16'h00AA;
    //reg_write = 0, so $s3 doesnt change
    @(negedge clk); reg_write=0; write_reg=3; write_data=16'hFFFF;

    @(negedge clk); read_reg1=3; read_reg2=15;
    #1;
    $display("read port 1: $s3 = %h (expected 1234)", read_data1);
    if(read_data1!==16'h1234) errors=errors+1;
    $display("read port 2: $s15 = %h (expected beef)", read_data2);
    if(read_data2!==16'hBEEF) errors=errors+1;
    read_reg1=0;
    #1;
    $display("$s0 = %h (expected 00aa)", read_data1);
    if (read_data1!==16'h00AA) errors=errors+1;
    //reset clears all regs
    @(negedge clk); reset=1;
    @(negedge clk); reset=0; read_reg1=3;
    #1;
    $display("$s3 after reset = %h (expected 0000)", read_data1);
    if(read_data1!==16'h0000) errors=errors+1;
    $display("$s15 after reset = %h (expected 0000)", read_data2);
    if(read_data2!==16'h0000) errors=errors+1;

    if(errors==0)
        $display("REGISTER FILE TESTS PASSED");
    else
        $display("%0d REGISTER FILE TEST(S) FAILED", errors);
    $finish;
end
endmodule
