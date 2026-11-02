//Top level of the 16 bit single cycle CPU
//purely for conencting modules
module cpu_top(
    input clk,
    input reset,
    input [3:0] debug_reg,
    output [15:0] pc,
    output [15:0] instr,
    output [15:0] debug_data
);
wire [15:0] pc_next;
wire [15:0] pc_plus2;
wire [15:0] read_data1;
wire [15:0] read_data2;
wire [15:0] write_data;
wire [15:0] imm4_ext;
wire [15:0] addr12_ext;
wire [15:0] alu_b;
wire [15:0] alu_result;
wire [15:0] mem_data;
wire [15:0] offset;
wire [15:0] offset_x2;
wire [15:0] target;
wire [1:0] alu_op;
wire [1:0] alu_ctrl;
wire reg_write;
wire alu_src;
wire mem_to_reg;
wire mem_read;
wire mem_write;
wire branch;
wire bne;
wire jump;
wire pc_src;

//fetch
Program_counter pc_reg(.clock(clk),.reset(reset), .next(pc_next), .out(pc));
adder16 pc_add(.a(pc), .b(16'd2), .sum(pc_plus2));
instr_mem imem(.addr(pc), .instr(instr));

//decode -> rs = [7:4], rt/rd = [11:8], and the destination = rt/rd
control_unit ctrl(.opcode(instr[15:12]), .alu_op(alu_op), .reg_write(reg_write), .alu_src(alu_src),.mem_to_reg(mem_to_reg), .mem_read(mem_read), .mem_write(mem_write), .branch(branch), .bne(bne), .jump(jump));
reg_file rf(.clk(clk), .reset(reset), .read_reg1(instr[7:4]), .read_reg2(instr[11:8]),.write_reg(instr[11:8]), .write_data(write_data), .reg_write(reg_write), .read_data1(read_data1), .read_data2(read_data2), .debug_reg(debug_reg), .debug_data(debug_data));
sign_ext4 se4(.in(instr[3:0]), .out(imm4_ext));
sign_ext12 se12(.in(instr[11:0]), .out(addr12_ext));

//execute
mux2 alu_src_mux(.d0(read_data2), .d1(imm4_ext), .sel(alu_src), .y(alu_b));
alu_control alu_ctl(.alu_op(alu_op), .funct(instr[3:0]), .alu_ctrl(alu_ctrl));
alu alu0(.rs(read_data1), .r(alu_b), .op(alu_ctrl), .res(alu_result));

//memory
data_mem dmem(.clk(clk), .reset(reset), .addr(alu_result), .write_data(read_data2),.mem_write(mem_write), .mem_read(mem_read), .read_data(mem_data));

//write back
mux2 wb_mux(.d0(alu_result), .d1(mem_data), .sel(mem_to_reg), .y(write_data));

//next PC target = PC+2+(offset<<1), offset is imm for branches and address for jmp
mux2 offset_mux(.d0(imm4_ext), .d1(addr12_ext), .sel(jump), .y(offset));
shift_left1 shl(.in(offset), .out(offset_x2));
adder16 tgt_add(.a(pc_plus2), .b(offset_x2), .sum(target));
branch_logic br(.branch(branch), .bne(bne), .jump(jump), .alu_res(alu_result), .pc_src(pc_src));
mux2 pc_mux(.d0(pc_plus2), .d1(target), .sel(pc_src), .y(pc_next));

endmodule
