module debouncer(
    input clk,
    input button,
    output reg clean
);
reg sync1;
reg sync2;
reg [19:0] count;

initial
begin
    sync1=1'b0;
    sync2=1'b0;
    count=20'd0;
    clean=1'b0;
end
always @(posedge clk)
begin
    sync1<=button;
    sync2<=sync1;
end

always @(posedge clk)
begin
    if(sync2==clean)
        count<=20'd0;
    else if(count==20'd999999)
    begin
        clean<=sync2;
        count<=20'd0;
    end
    else
        count<=count+1;
end
endmodule
