module seg_dynamic(
    input               clk,
    input               sys_rst_p,
    input   [15:0]      data,
    output reg  [3:0]   sel,
    output reg  [6:0]   seg
);

// PARAMETER DEFINE
parameter CNT_MAX = 'd49_999;

// REG DEFINE
reg [15:0]  data_reg;   // 寰呮樉绀烘暟鎹瘎瀛樺櫒
reg [15:0]  cnt_1ms;    // 1ms璁℃暟鍣?
reg         flag_1ms;   // 1ms鏍囧織淇″彿
reg [3:0]   cnt_sel;    // 鏁扮爜绠′綅閫夎鏁板櫒
reg [3:0]   sel_reg;    // 浣嶉?変俊鍙?
reg [3:0]   data_disp;  // 褰撳墠鏁扮爜绠℃樉绀虹殑鏁版嵁

// MAIN CODE
always @(posedge clk or posedge sys_rst_p) begin
    if (sys_rst_p) begin
        // reset
        data_reg <= 16'b0;
    end
    else begin
        data_reg <= data;
    end
end

// CNT_1MS
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        cnt_1ms <= 16'd0;
    else if (cnt_1ms == CNT_MAX)
        cnt_1ms <= 16'd0;
    else
        cnt_1ms <= cnt_1ms + 1'b1;

// FLAG 1MS
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        flag_1ms <= 1'b0;
    else if (cnt_1ms == CNT_MAX - 1'b1)
        flag_1ms <= 1'b1;
    else
        flag_1ms <= 1'b0;

// CNT_SEL
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        cnt_sel <= 4'd0;
    else if ((cnt_sel == 4'd3) && (flag_1ms == 1'b1))
        cnt_sel <= 4'd0;
    else if (flag_1ms == 1'b1)
        cnt_sel <= cnt_sel + 1'b1;
    else
        cnt_sel <= cnt_sel;

// 鏁扮爜绠′綅閫変俊鍙峰瘎瀛樺櫒
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        sel_reg <= 4'b0111;
    else if (flag_1ms == 1'b1)
        sel_reg <= {sel_reg[2:0], sel_reg[3]};
    else
        sel_reg <= sel_reg;

// SEL
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        data_disp <= 4'b0;
    else if (flag_1ms == 1'b1)
        case(cnt_sel)
            4'd0: data_disp <= data_reg[3:0];    // 缁欑1涓暟鐮佺璧嬩釜浣嶅??
            4'd1: data_disp <= data_reg[7:4];    // 缁欑2涓暟鐮佺璧嬪崄浣嶅??
            4'd2: data_disp <= data_reg[11:8];   // 缁欑3涓暟鐮佺璧嬬櫨浣嶅??
            4'd3: data_disp <= data_reg[15:12];  // 缁欑4涓暟鐮佺璧嬪崈浣嶅??
            default: data_disp <= 4'b0;
        endcase
    else
        data_disp <= data_disp;

// 鎺у埗鏁扮爜绠℃閫変俊鍙凤紝鏄剧ず鏁板瓧
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        seg <= 7'b111_1111;
    else
        case(data_disp)
            4'd0: seg <= 7'b100_0000; // 鏄剧ず鏁板瓧0
            4'd1: seg <= 7'b111_1001; // 鏄剧ず鏁板瓧1
            4'd2: seg <= 7'b010_0100; // 鏄剧ず鏁板瓧2
            4'd3: seg <= 7'b011_0000; // 鏄剧ず鏁板瓧3
            4'd4: seg <= 7'b001_1001; // 鏄剧ず鏁板瓧4
            4'd5: seg <= 7'b001_0010; // 鏄剧ず鏁板瓧5
            4'd6: seg <= 7'b000_0010; // 鏄剧ず鏁板瓧6
            4'd7: seg <= 7'b111_1000; // 鏄剧ず鏁板瓧7
            4'd8: seg <= 7'b000_0000; // 鏄剧ず鏁板瓧8
            4'd9: seg <= 7'b001_0000; // 鏄剧ず鏁板瓧9
            default: seg <= 7'b111_1111;
        endcase

// sel: 鏁扮爜绠′綅閫変俊鍙疯祴鍊?
always @(posedge clk or posedge sys_rst_p)
    if (sys_rst_p)
        sel <= 4'b1111;
    else
        sel <= sel_reg;

endmodule