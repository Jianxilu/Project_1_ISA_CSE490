module alu(
	input [15:0] rs,
	input [15:0] r,
	input [1:0] op,
	output reg [15:0] res
);

always @(*) begin
	if(op == 2'b00)
		res = rs + r;
	else if(op == 2'b01)
		res = rs - r;
	else if(op == 2'b10)
		res = rs << r;
	else
		res = rs & r;
end
endmodule
