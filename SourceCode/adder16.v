module adder16(
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] sum
);

always @(*)
begin
    sum=a+b;
end
endmodule