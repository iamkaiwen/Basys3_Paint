module vga(
    input CLK_I,
    input RST_I,
    input [11 : 0] pixel,
    output reg [11 : 0] h_cntr_reg,
    output reg [11 : 0] v_cntr_reg,
    output VGA_HS_O,
    output VGA_VS_O,
    output [3 : 0] VGA_RED_O,
    output [3 : 0] VGA_BLUE_O,
    output [3 : 0] VGA_GREEN_O
);
    parameter FRAME_WIDTH = 1280;
    parameter FRAME_HEIGHT = 1024;
    parameter H_FP = 48;
    parameter H_PW = 112;
    parameter H_MAX = 1688;
    parameter V_FP = 1;
    parameter V_PW = 3;
    parameter V_MAX = 1066;
    parameter H_POL = 1;
    parameter V_POL = 1;

    wire active;
    reg h_sync_reg , v_sync_reg;
    wire [3 : 0] vga_red , vga_blue , vga_green;


    always@(posedge CLK_I or posedge RST_I)begin
        if(RST_I)begin
            h_cntr_reg <= 12'd0;
        end
        else begin
            if(h_cntr_reg == H_MAX - 1)begin
                h_cntr_reg <= 12'd0;
            end
            else begin
                h_cntr_reg <= h_cntr_reg + 12'd1;
            end
        end
    end

    always@(posedge CLK_I or posedge RST_I)begin
        if(RST_I)begin
            v_cntr_reg <= 12'd0;
        end
        else begin
            if(h_cntr_reg == H_MAX - 1 && v_cntr_reg == V_MAX - 1)begin
                v_cntr_reg <= 12'd0;
            end
            else if(h_cntr_reg == H_MAX - 1)begin
                v_cntr_reg <= v_cntr_reg + 12'd1;
            end
            else begin
                v_cntr_reg <= v_cntr_reg;
            end
        end
    end

    always@(posedge CLK_I or posedge RST_I)begin
        if(RST_I)begin
            h_sync_reg <= 1'b1;
        end
        else begin
            if(h_cntr_reg >= (H_FP + FRAME_WIDTH - 1) && h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1))begin
                h_sync_reg <= 1'b1;
            end
            else begin
                h_sync_reg <= 1'b0;
            end
        end
    end

    always@(posedge CLK_I or posedge RST_I)begin
        if(RST_I)begin
            v_sync_reg <= 1'b1;
        end
        else begin
            if(v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1) && v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1))begin
                v_sync_reg <= 1'b1;
            end
            else begin
                v_sync_reg <= 1'b0;
            end
        end
    end

    assign active = ((h_cntr_reg < FRAME_WIDTH) && (v_cntr_reg < FRAME_HEIGHT))? 1'b1 : 1'b0;
    assign {vga_red , vga_green , vga_blue} = pixel;
    assign VGA_RED_O = {active , active , active , active} & vga_red;
    assign VGA_GREEN_O = {active , active , active , active} & vga_green;
    assign VGA_BLUE_O = {active , active , active , active} & vga_blue;
    assign VGA_HS_O = h_sync_reg;
    assign VGA_VS_O = v_sync_reg;

endmodule