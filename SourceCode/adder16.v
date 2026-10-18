module adder16(
    input [15:0] input,
    input [15:0] input2,
    output reg [15:0] output
);

always @(*)
begin
    output=input+input2;
end
endmodule