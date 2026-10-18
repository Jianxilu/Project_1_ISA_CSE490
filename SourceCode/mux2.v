module mux2(
    input [15:0] input1,
    input [15:0] input2,
    input selection,
    output red[15;0] out
);

always @(*)
begin
    if (selection==1'b1)
        out==input2;
    else
        out==input1;
end
endmodule