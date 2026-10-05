module Program_counter(
    input clock,
    input reset,
    input [15:0] next,
    output reg [15:0] out
);
initial
begin
    out=16'b0000000000000000;
end
    
always @(posedge clock)begin
    if (reset==1'b1)
        out<=16'b0000000000000000;
    else
        out<=next;
end  

endmodule
