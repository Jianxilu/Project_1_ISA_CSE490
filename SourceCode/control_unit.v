module control_unit(
    input [3:0] opcode,
    output reg [1:0] alu_op,
    output reg reg_write,
    output reg alu_src,
    output reg mem_to_reg,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg bne,
    output reg jump
);

always @(*)
begin
    alu_op=2'b00;
    reg_write =1'b0;
    alu_arc=1'b0;
    mem_to_reg=1'b0;
    mem_read=1'b0;
    mem_write=1'b0;
    branch=1'b0;
    bne=1'b0;
    jump=1'b0;

    case(opcode)
        4'b0000: //this is for rtype
        begin 
            alu_op=2'b10;
            reg_write =1'b1;
        end

        4'b0001: //this is for lw
        begin  
            reg_write=1'b1;
            alu_src=1'b1;
            mem_to_reg=1'b1;
            mem_read=1'b1;
        end

        4'b0010:  //this is for sw
        begin
            alu_src=1'b1;
            mem_write=1'b1;
        end

        4'b0011:  //this is for addi
        begin
            reg_write=1'b1;
            alu_arc=1'b1;
        end

        4'b0100:  //this is for beq
        begin
            alu_op=2'b01;
            branch=1'b1;
        end

        4'b0101:  //this is for bne
        begin 
            alu_op=2'b01;
            bne=1'b1;
        end

        4'b0110:  //this is for jump
        begin  
            jump=1'b1;
        end
        default: ;
    endcase
end
endmodule
