module shift_left1(
    input [15:0] in,
    output reg [15:0] out
);
always @(*)
begin   
    out=in<<1;
end
endmodule