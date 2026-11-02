module display_select(
 input [15:0] sw,
 input [15:0] pc,
  input [15:0] instr,
  input [15:0] reg_value,
  output reg [15:0] value
);
always @(*)
begin
if(sw[15]==1'b1)
        value=pc;
 else if(sw[14]==1'b1)
        value=instr;
 else
        value=reg_value;
end
endmodule
