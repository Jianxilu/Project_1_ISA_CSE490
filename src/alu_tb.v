module alu_tb;
reg [15:0} rs;
reg [15:0] r;
reg [1:0] op;
wire [15:0] res;

alu dut(.rs(rs), .r(r), .op(op), .res(res));

intial begin
	a=5; b=3; op=2'b00; 
  #10;
	$display("add: %0d + %0d = %0d", rs, r, res);
	//expected out = 8

	a=10; b=3; op=2'b01; 
  #10;
  $display("sub: %0d + %0d = %0d", rs, r, res);
	//expected out = 7

	a=4; b=90; op=2'b10; 
  #10;
	$display("add: %0d + %0d = %0d", rs, r, res);
	//expected out = 1440

	a=12; b=10; op=2'b11; 
  #10;
	$display("add: %0d + %0d = %0d", rs, r, res);
	//expected out = 8

	$finish;
end
endmodule	
