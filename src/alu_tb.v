module alu_tb;
reg [15:0] rs;
reg [15:0] r;
reg [1:0] op;
wire [15:0] res;

alu dut(.rs(rs), .r(r), .op(op), .res(res));

initial begin
	rs=5; r=3; op=2'b00; 
 	 #10;
	$display("add: %0d + %0d = %0d", rs, r, res);
	//expected out = 8

	rs=10; r=3; op=2'b01; 
  	#10;
  	$display("sub: %0d + %0d = %0d", rs, r, res);
	//expected out = 7

	rs=4; r=90; op=2'b10; 
  	#10;
	$display(“sll: %0d + %0d = %0d", rs, r, res);
	//expected out = 1440

	rs=12; r=10; op=2'b11; 
  	#10;
	$display("and: %0d + %0d = %0d", rs, r, res);
	//expected out = 8

	$finish;
end
endmodule	
