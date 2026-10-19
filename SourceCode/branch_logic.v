module branch_logic(
  input branch,
  input bne,
  input jump,
  input [15:0] alu_res,
  output reg pc_src
);
always @(*)
begin
  if(jump==1'b1)
    pc_src=1'b1;
  else if(branch==1'b1 && alu_res==16'b0000000000000000)
    pc_src=1'b1;
  else if(bne==1'b1 && alu_res!=16'b0000000000000000)
    pc_src=1'b1;
  else
    pc_src=1'b0;
end
endmodule
