module top(
	input			sys_clk,
	input			sys_rst_p,
	input			set_time,
	input			set_hour,
	input			set_min,
	output	[6:0]	seg,
	output	[3:0]	sel
	);
	
wire clk_1Hz;
wire [7:0]   min;
wire [7:0]   sec;
wire [7:0]   hour;
//wire [23:0] carry;

clk_div inst_clk_div (
	.clk_100M(sys_clk), 
	.sys_rst_p(sys_rst_p), 
	.clk_1Hz(clk_1Hz)
	);



timeTop inst_timeTop
	(
		.sys_rst_p (sys_rst_p),
		.clk       (clk_1Hz),
		.set_time  (set_time),
		.set_hour  (set_hour),
		.set_min   (set_min),
		.hour      (hour),
		.min       (min),
		.sec       (sec)
	);
	/*
cycle_left_register #(
	.MSB(24)
) inst_cycle_left_register (
	.i_din  ({hour,min,sec}),
	.i_rst  (sys_rst_p),
	.i_load (clk_1Hz),
	.i_clk  (clk_10Hz),
	.dout   (carry)
);
*/
seg_dynamic #(
	.CNT_MAX(49_999)
) inst_seg_dynamic (
	.clk       (sys_clk),
	.sys_rst_p (sys_rst_p),
	.data      ({min,sec}),
	.sel       (sel),
	.seg       (seg)
);

endmodule