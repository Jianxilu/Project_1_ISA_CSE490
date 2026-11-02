module cpu_tb;
reg clk;
reg reset;
wire [15:0] pc1;
wire [15:0] instr1;
wire [15:0] pc2;
wire [15:0] instr2;
integer errors;

cpu_top cpu1(.clk(clk), .reset(reset), .pc(pc1), .instr(instr1));
cpu_top cpu2(.clk(clk), .reset(reset), .pc(pc2), .instr(instr2));

always #5 clk=~clk;

initial begin
    clk=0;
    reset=1;
    errors=0;
    #1;
    $readmemh("program2.mem", cpu2.imem.memory);
    $readmemh("data2.mem", cpu2.dmem.memory);

    //keep reset on for the first clk edge at time = 5, then run for 60 cycles
    #5 reset=0;
    #600;

    $display("Program 1");
    $display("R1 = %h (expected 0004)", cpu1.rf.registers[1]);
    if(cpu1.rf.registers[1]!==16'h0004) errors=errors+1;
    $display("R2 = %h (expected 0002)", cpu1.rf.registers[2]);
    if(cpu1.rf.registers[2]!==16'h0002) errors=errors+1;
    $display("R3 = %h (expected ffee)", cpu1.rf.registers[3]);
    if(cpu1.rf.registers[3]!==16'hFFEE) errors=errors+1;
    $display("R4 = %h (expected 0000, the addi was skipped)", cpu1.rf.registers[4]);
    if(cpu1.rf.registers[4]!==16'h0000) errors=errors+1;
    $display("M[4..5] = %h%h (expected 0014)", cpu1.dmem.memory[4], cpu1.dmem.memory[5]);
    if({cpu1.dmem.memory[4], cpu1.dmem.memory[5]}!==16'h0014) errors=errors+1;
    $display("PC = %h (expected 0018, the jmp -1 at the end)", pc1);
    if(pc1!==16'h0018) errors=errors+1;

    $display("Program 2");
    $display("R1 = %h (expected 0028, array pointer)", cpu2.rf.registers[1]);
    if(cpu2.rf.registers[1]!==16'h0028) errors=errors+1;
    $display("R2 = %h (expected 0005)", cpu2.rf.registers[2]);
    if(cpu2.rf.registers[2]!==16'h0005) errors=errors+1;
    $display("R3 = %h (expected 0000, loop counter)", cpu2.rf.registers[3]);
    if(cpu2.rf.registers[3]!==16'h0000) errors=errors+1;
    $display("R4 = %h (expected 0018, the sum 3+5+7+9)", cpu2.rf.registers[4]);
    if(cpu2.rf.registers[4]!==16'h0018) errors=errors+1;
    $display("R5 = %h (expected ffff)", cpu2.rf.registers[5]);
    if(cpu2.rf.registers[5]!==16'hFFFF) errors=errors+1;
    $display("R6 = %h (expected 0002)", cpu2.rf.registers[6]);
    if(cpu2.rf.registers[6]!==16'h0002) errors=errors+1;
    $display("R7 = %h (expected 0009, last value loaded)", cpu2.rf.registers[7]);
    if(cpu2.rf.registers[7]!==16'h0009) errors=errors+1;
    $display("R8 = %h (expected 0003, runs after the beq)", cpu2.rf.registers[8]);
    if(cpu2.rf.registers[8]!==16'h0003) errors=errors+1;
    $display("M[0x28..0x29] = %h%h (expected 0018)", cpu2.dmem.memory[40], cpu2.dmem.memory[41]);
    if({cpu2.dmem.memory[40], cpu2.dmem.memory[41]}!==16'h0018) errors=errors+1;
    $display("PC = %h (expected 0022, the jmp -1 at the end)", pc2);
    if(pc2!==16'h0022) errors=errors+1;

    if(errors==0)
        $display("CPU TESTS PASSED");
    else
        $display("%0d CPU TEST(S) FAILED", errors);
    $finish;
end
endmodule
