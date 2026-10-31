module mux2(
    input [15:0] d0,
    input [15:0] d1,
    input sel,
    output reg [15:0] y
);

always @(*)
begin
    if (sel==1'b1)
        y=d1;
    else
        y=d0;
end
endmodule