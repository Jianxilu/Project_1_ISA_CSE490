module sign_ext4(
    input [3:0] in,
    output reg [15:0] out
);
always @(*)
begin
    out[3:0]=in;
    if(in[3]==1'b1)
        out[15:4]=12'b111111111111;
    else
        out[15:4]=12'b000000000000;
end
endmodule