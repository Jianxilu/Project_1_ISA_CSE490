module Register_file(
    input clk,
    input reset,
    input [3:0] read_reg1,
    input [3:0] read_reg2,
    input [3:0] write_reg,
    input [15:0] write_data,
    input reg_write,
    output reg [15:0] read_data1,
    output reg [15:0] read_data2
);

reg [15:0] registers [0:15];
integer x;

initial
begin
    for (x=0;x<16;x=x+1)
        registers[x]=16'b0000000000000000;
end
always @(posedge clk) 
    begin
    if (reset==1'b1)
    begin
        for (x=0;x<16;x=x+1)
            registers[x]=16'b0000000000000000;
    end
    else if (reg_write==1'b1)
        registers[write_reg]<=write_data;
end
always @(*)
begin
read_data1=registers[read_reg1];
read_daat2=registers[read_reg2];
end

endmodule