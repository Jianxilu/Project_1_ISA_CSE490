module adder16(
    input [15:0] input1
    input [15:0] input2,
    output reg [15:0] total
);

always @(*)
begin
    total=input1+input2;
end
endmodule