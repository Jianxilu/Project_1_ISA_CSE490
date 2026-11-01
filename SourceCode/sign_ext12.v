module sign_ext12(
    input [11:0] in,
    output reg [15:0] out
);
always @(*)
begin   
    out[11:0]=in;
    if (in[11]==1'b1)
        out[15:12]=4'b1111;
    else    
        out[15:12]=4'b0000;
end
endmodule 
