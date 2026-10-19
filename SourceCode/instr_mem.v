module instr_mem(
  input [15:0] addr,
  output reg [15:0] instr
);
reg [7:0] memory [0:255];
integer x;

initial
begin
  for(x=0;x<=255;x=x+1)
    memory[x]=8'b00000000;
  $readmemh("program1.mem",memory);
end

always @(*)
begin
  instr={memory[addr[7:0]],memory[addr[7:0]+8'd1]};
end
endmodule
