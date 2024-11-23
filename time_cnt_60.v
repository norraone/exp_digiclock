module time_cnt_60 (
  input   wire        sys_rst_p   ,
  input   wire        clk    ,
  input   wire        ena    ,      // enable counting
  input   wire        set_time,
  input   wire        set    ,

  output  reg  [3:0]  upper  ,      // the ten
  output  reg  [3:0]  low    ,      // the one
  output  reg         carry         // enable the next module to count
);

// low
always @(posedge clk or posedge sys_rst_p) begin
  if(sys_rst_p)
    low  	<=  4'h0;
  else if(set_time) begin
    if(low == 4'h9 && set)
      low 	<=  4'h0;
    else if(set)
      low 	<=  low + 1'b1;
  end else if(ena && ~set_time) begin
    if(low == 4'h9)
      low 	<=  4'h0;
    else
      low 	<=  low + 1'b1;
  end
end

// upper
always @(posedge clk or posedge sys_rst_p) begin
  if(sys_rst_p) begin
    upper   <=  4'h0;
  end
  else if(set_time) begin
    if(low == 4'h9 && upper == 4'h5 && set)
      upper   <=  4'h0;
    else if(low == 4'h9 && set)
      upper   <=  upper + 1'b1;
  end else if(ena && ~set_time) begin
    if(low == 4'h9 && upper == 4'h5)
      upper   <=  4'h0;
    else if(low == 4'h9)
      upper   <=  upper + 1'b1;
  end
end

always @* carry = (({upper, low} == 8'h59)) ? 1'b1 : 1'b0;
    
endmodule