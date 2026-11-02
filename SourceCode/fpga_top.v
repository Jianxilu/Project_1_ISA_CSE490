module fpga_top(
    input clk,
    input btnC,
    input btnU,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
);
wire step;
wire reset;
wire [15:0] pc;
wire [15:0] instr;
wire [15:0] reg_value;
wire [15:0] display_value;

debouncer step_button(.clk(clk), .button(btnC), .clean(step));
debouncer reset_button(.clk(clk), .button(btnU), .clean(reset));
cpu_top cpu(.clk(step), .reset(reset), .debug_reg(sw[3:0]),.pc(pc), .instr(instr), .debug_data(reg_value));
display_select pick(.sw(sw), .pc(pc), .instr(instr), .reg_value(reg_value), .value(display_value));
seven_seg display(.clk(clk), .value(display_value), .seg(seg), .an(an), .dp(dp));
assign led= pc;

endmodule
