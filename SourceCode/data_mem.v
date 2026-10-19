module data_mem(
  input clk,
  input [15:0] eddr,
  input [15:0] write_data,
  input mem_write,
  input mem_readm,
  output reg [15:0] read_data
);
reg [7:0] memory [0:255];
integer x;

initial
begin
  for(x=0;x<=255;x=x+1) 
    memory[x]=8'b00000000;
end

always @(posedge clk)
begin
  if(mem_write==1'b1 && reset==1'b0)
  begin
    memory[addr[7:0]]<=write_data[15:8];
    memory[addr[7:0]+8'd1]<=write_data[7:0];
  end
end
always @(*)
begin
  if(mem_read==1'b1)
    read_data={memory[addr[7:0]],memory[addr[7:0]+8'd1]};
  else
      read_data=16'b0000000000000000;
end
endmodule
