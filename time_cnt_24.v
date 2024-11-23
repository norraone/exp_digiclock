module time_cnt_24(
	input sys_rst_p,
	input clk,
	input set_time,
	input set,
	input ena,
	output reg [3:0] upper,
	output reg [3:0] low
	);

// low
always @(posedge clk or posedge sys_rst_p) begin
  if(sys_rst_p)
    low		<=  4'h0;
  else if(set_time) begin
    if((upper == 4'h0 || upper == 4'h1) && low == 4'h9 && set)
      low   <=  4'h0;
		else if(upper == 4'h2 && low == 4'h3 && set)
			low		<= 	4'h0;
    else if(set)
      low   <=  low + 1'b1;
  end else if(ena && ~set_time) begin
    if((upper == 4'h0 || upper == 4'h1) && low == 4'h9)
      low   <=  4'h0;
    else if(upper == 4'h2 && low == 4'h3)
      low   <=  4'h0;
    else
      low   <=  low + 1'b1;
  end
end

// upper
always @(posedge clk or posedge sys_rst_p) begin
  if(sys_rst_p) begin
      upper   <=  4'h0;
  end
  else if(set_time) begin
    if(upper == 4'h0 && low == 4'h9 && set)
      upper   <=  4'h1;
    else if(upper == 4'h1 && low == 4'h9 && set)
      upper   <=  4'h2;
		else if(upper == 4'h2 && low == 4'h3 && set)
			upper 	<=	4'h0;
  end else if(ena && ~set_time) begin
    if(upper == 4'h0 && low == 4'h9)
      upper   <=  4'h1;
    else if(upper == 4'h1 && low == 4'h9)
      upper   <=  4'h2;
		else if(upper == 4'h2 && low == 4'h3)
			upper 	<=	4'h0;
  end
end
endmodule