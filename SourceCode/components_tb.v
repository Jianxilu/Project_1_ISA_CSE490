// Tests for the components that do not have their own testbench:
// Program_counter, adder16, mux2, sign_ext4, sign_ext12, shift_left1, alu_control,
// control_unit, branch_logic and instr_mem.
module components_tb;
reg clk;
reg reset;
reg [15:0] next;
wire [15:0] pc_out;
reg [15:0] a;
reg [15:0] b;
wire [15:0] sum;
reg sel;
wire [15:0] mux_out;
reg [3:0] imm;
wire [15:0] imm_ext;
reg [11:0] addr12;
wire [15:0] addr_ext;
wire [15:0] shifted;
reg [1:0] alu_op;
reg [3:0] funct;
wire [1:0] alu_ctrl;
reg [3:0] opcode;
wire [1:0] ctrl_alu_op;
wire reg_write;
wire alu_src;
wire mem_to_reg;
wire mem_read;
wire mem_write;
wire branch;
wire bne;
wire jump;
wire [9:0] ctrl_bits;
reg br_branch;
reg br_bne;
reg br_jump;
reg [15:0] alu_result;
wire pc_src;
reg [15:0] fetch_addr;
wire [15:0] instr;
integer errors;

Program_counter pc(.clock(clk), .reset(reset), .next(next), .out(pc_out));
adder16 add(.a(a), .b(b), .sum(sum));
mux2 mux(.d0(a), .d1(b), .sel(sel), .y(mux_out));
sign_ext4 se4(.in(imm), .out(imm_ext));
sign_ext12 se12(.in(addr12), .out(addr_ext));
shift_left1 shl(.in(a), .out(shifted));
alu_control alu_ctl(.alu_op(alu_op), .funct(funct), .alu_ctrl(alu_ctrl));
control_unit ctrl(.opcode(opcode), .alu_op(ctrl_alu_op), .reg_write(reg_write), .alu_src(alu_src), .mem_to_reg(mem_to_reg), .mem_read(mem_read), .mem_write(mem_write),.branch(branch), .bne(bne), .jump(jump));
branch_logic br(.branch(br_branch), .bne(br_bne), .jump(br_jump), .alu_res(alu_result), .pc_src(pc_src));
instr_mem imem(.addr(fetch_addr), .instr(instr));

assign ctrl_bits={reg_write, alu_src, mem_to_reg, mem_read, mem_write, branch, bne, jump, ctrl_alu_op};

always #5 clk=~clk;

initial begin
    clk=0;
    reset=1;
    next=16'h0040;
    errors=0;

    //pc reset sets to 0 otherwise loads next on rising edge
    @(negedge clk);
    $display("PC during reset = %h (expected 0000)",pc_out);
    if(pc_out!==16'h0000) errors=errors+1;
    reset=0;
    @(negedge clk);
    $display("PC after one edge = %h (expected 0040)",pc_out);
    if(pc_out!==16'h0040) errors=errors+1;

    //adder16 carry out of bit 15 gets dropped
    a=16'h0005; b=16'h0003;
    #1;
    $display("adder 5 + 3 = %h (expected 0008)",sum);
    if(sum!==16'h0008) errors=errors+1;
    a=16'hFFFF; b=16'h0002;
    #1;
    $display("adder ffff + 2 = %h (expected 0001)",sum);
    if(sum!==16'h0001) errors=errors+1;

    //mux2 sel 0 -> d0, 1 -> d1
    sel=0;
    #1;
    $display("mux sel 0 = %h (expected ffff)",mux_out);
    if(mux_out!==16'hFFFF) errors=errors+1;
    sel=1;
    #1;
    $display("mux sel 1 = %h (expected 0002)",mux_out);
    if(mux_out!==16'h0002) errors=errors+1;

    //sign_ext4 and sign_ext12 positive numbers-> 0, negative numbers -> 1
    imm=4'b0111; addr12=12'h7FF;
    #1;
    $display("sign_ext4 0111 = %h (expected 0007)",imm_ext);
    if(imm_ext!==16'h0007) errors=errors+1;
    $display("sign_ext12 7ff = %h (expected 07ff)",addr_ext);
    if(addr_ext!==16'h07FF) errors=errors+1;
    imm=4'b1011; addr12=12'hFFF;
    #1;
    $display("sign_ext4 1011 = %h (expected fffb)",imm_ext);
    if(imm_ext!==16'hFFFB) errors=errors+1;
    $display("sign_ext12 fff = %h (expected ffff)",addr_ext);
    if(addr_ext!==16'hFFFF) errors=errors+1;

    //shift_left1
    a=16'h0005;
    #1;
    $display("shift 0005 = %h (expected 000a)",shifted);
    if(shifted!==16'h000A) errors=errors+1;
    a=16'h8001;
    #1;
    $display("shift 8001 = %h (expected 0002)",shifted);
    if(shifted!==16'h0002) errors=errors+1;

    //alu_control 00 add, 01 sub, 10 uses funct[1:0]
    alu_op=2'b00; funct=4'b0011;
    #1;
    $display("alu_control 00 = %b (expected 00)",alu_ctrl);
    if(alu_ctrl!==2'b00) errors=errors+1;
    alu_op=2'b01;
    #1;
    $display("alu_control 01 = %b (expected 01)",alu_ctrl);
    if(alu_ctrl!==2'b01) errors=errors+1;
    alu_op=2'b10; funct=4'b0010;
    #1;
    $display("alu_control 10, sll = %b (expected 10)",alu_ctrl);
    if(alu_ctrl!==2'b10) errors=errors+1;
    funct=4'b0011;
    #1;
    $display("alu_control 10, and = %b (expected 11)", alu_ctrl);
    if(alu_ctrl!==2'b11) errors=errors+1;

    // control_unit, bits RegWrite ALUSrc MemtoReg MemRead MemWrite Branch BNE Jump ALUOp
    opcode=4'b0000;
    #1;
    $display("control R-type = %b (expected 1000000010)",ctrl_bits);
    if(ctrl_bits!==10'b1000000010) errors=errors+1;
    opcode=4'b0001;
    #1;
    $display("control lw     = %b (expected 1111000000)",ctrl_bits);
    if(ctrl_bits!==10'b1111000000) errors=errors+1;
    opcode=4'b0010;
    #1;
    $display("control sw     = %b (expected 0100100000)",ctrl_bits);
    if(ctrl_bits!==10'b0100100000) errors=errors+1;
    opcode=4'b0011;
    #1;
    $display("control addi   = %b (expected 1100000000)",ctrl_bits);
    if(ctrl_bits!==10'b1100000000) errors=errors+1;
    opcode=4'b0100;
    #1;
    $display("control beq    = %b (expected 0000010001)",ctrl_bits);
    if(ctrl_bits!==10'b0000010001) errors=errors+1;
    opcode=4'b0101;
    #1;
    $display("control bne    = %b (expected 0000001001)",ctrl_bits);
    if(ctrl_bits!==10'b0000001001) errors=errors+1;
    opcode=4'b0110;
    #1;
    $display("control jmp    = %b (expected 0000000100)",ctrl_bits);
    if(ctrl_bits!==10'b0000000100) errors=errors+1;
    opcode=4'b0111;
    #1;
    $display("control unused = %b (expected 0000000000)",ctrl_bits);
    if(ctrl_bits!==10'b0000000000) errors=errors+1;

    //branch_logic beq when ALU result is 0, otherwise bne, and always jmp
    br_branch=1; br_bne=0; br_jump=0; alu_result=16'h0000;
    #1;
    $display("beq, equal = %b (expected 1)",pc_src);
    if(pc_src!==1'b1) errors=errors+1;
    alu_result=16'h0005;
    #1;
    $display("beq, not equal = %b (expected 0)",pc_src);
    if(pc_src!==1'b0) errors=errors+1;
    br_branch=0; br_bne=1;
    #1;
    $display("bne, not equal = %b (expected 1)",pc_src);
    if(pc_src!==1'b1) errors=errors+1;
    alu_result=16'h0000;
    #1;
    $display("bne, equal = %b (expected 0)",pc_src);
    if(pc_src!==1'b0) errors=errors+1;
    br_bne=0; br_jump=1;
    #1;
    $display("jmp = %b (expected 1)",pc_src);
    if(pc_src!==1'b1) errors=errors+1;
    br_jump=0;
    #1;
    $display("no branch = %b (expected 0)",pc_src);
    if(pc_src!==1'b0) errors=errors+1;

    //instr_mem big endian words from program1.mem
    fetch_addr=16'h0000;
    #1;
    $display("instruction at 00 = %h (expected 3105)",instr);
    if(instr!==16'h3105) errors=errors+1;
    fetch_addr=16'h0002;
    #1;
    $display("instruction at 02 = %h (expected 320d)",instr);
    if(instr!==16'h320D) errors=errors+1;
    fetch_addr=16'h0018;
    #1;
    $display("instruction at 18 = %h (expected 6fff)",instr);
    if(instr!==16'h6FFF) errors=errors+1;

    if(errors==0)
        $display("COMPONENT TESTS PASSED");
    else
        $display("%0d COMPONENT TEST(S) FAILED",errors);
    $finish;
end
endmodule
