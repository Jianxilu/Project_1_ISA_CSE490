module Program_counter(
    input clock,
    input reset,
    input [1:0] next,
    output reg [1:0] out
);
initial
begin
    out=2'b00;
end
    
always @(posedge clock)begin
    if (reset==1'b1)
        out<=2'b00;
    else
        out<=next;
end  

endmodule