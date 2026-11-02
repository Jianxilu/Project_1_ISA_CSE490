module fpga_top_tb;
reg clk;
reg btnC;
reg btnU;
reg [15:0] sw;
wire [15:0] led;
wire [6:0] seg;
wire [3:0] an;
wire dp;
reg [15:0] value;
wire [6:0] seg2;
wire [3:0] an2;
wire dp2;
integer presses;
integer i;
integer errors;

fpga_top dut(.clk(clk), .btnC(btnC), .btnU(btnU), .sw(sw), .led(led), .seg(seg), .an(an), .dp(dp));
seven_seg display(.clk(clk), .value(value), .seg(seg2), .an(an2), .dp(dp2));

always #5 clk=~clk;

initial begin
    clk=0;
    btnC=0;
    btnU=0;
    sw=16'h0000;
    value=16'h1234;
    errors=0;

    //7seg driver showing 1234
  //each digit gets its own anode and pattern
    wait (an2==4'b1110);
    #1;
    $display("digit 0 = %b (expected 0011001, a 4)", seg2);
    if (seg2!==7'b0011001) errors=errors+1;
    wait (an2==4'b1101);
    #1;
    $display("digit 1 = %b (expected 0110000, a 3)", seg2);
    if (seg2!==7'b0110000) errors=errors+1;
    wait (an2==4'b1011);
    #1;
    $display("digit 2 = %b (expected 0100100, a 2)", seg2);
    if (seg2!==7'b0100100) errors=errors+1;
    wait (an2==4'b0111);
    #1;
    $display("digit 3 = %b (expected 1111001, a 1)", seg2);
    if (seg2!==7'b1111001) errors=errors+1;

    //press the step button 10 times;
    //program 1 sits in its jmp -1 at 0x18
    for (presses=1; presses<=10; presses=presses+1)
    begin
        //bounce for the first 1 ms of the press
        for (i=0; i<5; i=i+1)
        begin
            btnC=1;
            #100000;
            btnC=0;
            #100000;
        end
        btnC=1;
        #11000000;
        btnC=0;
        #11000000;
        if (presses==1)
        begin
            $display("PC after 1 press = %h (expected 0002)", led);
            if (led!==16'h0002) errors=errors+1;
        end
    end
    $display("PC after 10 presses = %h (expected 0018)", led);
    if (led!==16'h0018) errors=errors+1;

    //read registers through the debug port with sw[3:0]
    sw=16'h0001;
    #1;
    $display("$s1 = %h (expected 0004)", dut.reg_value);
    if (dut.reg_value!==16'h0004) errors=errors+1;
    sw=16'h0003;
    #1;
    $display("$s3 = %h (expected ffee)", dut.reg_value);
    if (dut.reg_value!==16'hFFEE) errors=errors+1;

    //display_select sw[15] shows PC, sw[14] the instruction, otherwise the register
    sw=16'h8001;
    #1;
    $display("display with sw[15] up = %h (expected 0018, the PC)", dut.display_value);
    if (dut.display_value!==16'h0018) errors=errors+1;
    sw=16'h4001;
    #1;
    $display("display with sw[14] up = %h (expected 6fff, the jmp -1)", dut.display_value);
    if (dut.display_value!==16'h6FFF) errors=errors+1;
    sw=16'h0001;
    #1;
    $display("display with both down = %h (expected 0004, $s1)", dut.display_value);
    if (dut.display_value!==16'h0004) errors=errors+1;

    //reset hold up button and press the center button once
    btnU=1;
    #11000000;
    btnC=1;
    #11000000;
    btnC=0;
    #11000000;
    btnU=0;
    #11000000;
    $display("PC after reset = %h (expected 0000)", led);
    if (led!==16'h0000) errors=errors+1;
    sw=16'h0003;
    #1;
    $display("$s3 after reset = %h (expected 0000)", dut.reg_value);
    if (dut.reg_value!==16'h0000) errors=errors+1;

    if (errors==0)
        $display("FPGA TESTS PASSED");
    else
        $display("%0d FPGA TEST(S) FAILED", errors);
    $finish;
end
endmodule
