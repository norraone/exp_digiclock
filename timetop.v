// `include "cnt60.v"
// `include "cnt24.v"

module timeTop (
  input  wire         sys_rst_p    ,
  input  wire         clk     ,

  input  wire         set_time,       // Set mode on/off(1 or 0)
  input  wire         set_hour,       // pulse
  input  wire         set_min ,       // pulse

  output wire [7:0]   hour    ,
  output wire [7:0]   min     ,
  output wire [7:0]   sec     
);

wire        min2hour;      	// enable signal from minute module to hour module.
wire        sec2min;       	// enable signal from second module to minute module.

time_cnt_24 hour_inst (
  .sys_rst_p  (       sys_rst_p       ),
  .clk        (       clk             ),
  .ena        (  min2hour && sec2min  ),
  .set_time   (       set_time        ),
  .set        (       set_hour        ),

  .upper      (       hour[7:4]       ),
  .low        (       hour[3:0]       ) 
);

time_cnt_60 minute_inst (
  .sys_rst_p  (       sys_rst_p       ),
  .clk        (       clk             ),
  .ena        (       sec2min         ),
  .set_time   (       set_time        ),
  .set        (       set_min         ),
  .upper      (       min[7:4]        ),
  .low        (       min[3:0]        ),
  .carry      (       min2hour        ) 
);

time_cnt_60 second_inst (
  .sys_rst_p  (       sys_rst_p       ),
  .clk        (       clk             ),
  .ena        (       ~set_time       ),
  .set_time   (       1'b0            ),
  .set        (       1'b0            ),

  .upper      (       sec[7:4]        ),
  .low        (       sec[3:0]        ),
  .carry      (       sec2min         ) 
);

endmodule