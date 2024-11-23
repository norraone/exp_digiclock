module clk_div (
    input wire clk_100M,      // 100MHz input clock
    input wire sys_rst_p,           // Active high reset
    output reg clk_1Hz        // 1Hz output clock
);

    // Calculate needed counter bits: log2(100M/2) = 26 bits needed
    reg [26:0] counter;
    
    // 100M/2 = 50M counts for half period
    localparam HALF_PERIOD = 27'd50_000_000;
    
    always @(posedge clk_100M or posedge sys_rst_p) begin
        if (sys_rst_p) begin
            counter <= 27'd0;
            clk_1Hz <= 1'b0;
        end else begin
            if (counter >= HALF_PERIOD - 1) begin
                counter <= 27'd0;
                clk_1Hz <= ~clk_1Hz;  // Toggle output
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule