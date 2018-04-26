module top(
    input [15 : 0] SW,
    input [4 : 0] BTN,
    input CLK,
    output [15 : 0] LED,
    output [7 : 0] SSEG_CA,
    output [3 : 0] SSEG_AN,
    output [3 : 0] VGA_RED,
    output [3 : 0] VGA_BLUE,
    output [3 : 0] VGA_GREEN,
    output VGA_VS,
    output VGA_HS,
    output pmod_1,
    output pmod_2,
    output pmod_4,
    inout PS2_CLK,
    inout PS2_DATA
);

    wire clk_div13 , clk_div21;

    wire [16 : 0] pixel_addr;
    wire [14 : 0] pixel_addr_background;

    wire enable_mouse_display , wea;
    wire [11 : 0] MOUSE_X_POS , MOUSE_Y_POS;
    wire [3 : 0] MOUSE_Z_POS;
    wire MOUSE_LEFT , MOUSE_MIDDLE , MOUSE_RIGHT , MOUSE_NEW_EVENT;
    wire [3 : 0] mouse_cursor_red , mouse_cursor_green , mouse_cursor_blue;

    wire [11 : 0] pixel , pixel_mem , pixel_mouse , pixel_filter , pixel_background;
    wire [11 : 0] h_cntr_reg , v_cntr_reg;
    wire [11 : 0] color;
    wire [3 : 0] BCD0 , BCD1;
    wire de_btn;

    
    assign pixel_mouse = {mouse_cursor_red , mouse_cursor_green , mouse_cursor_blue};
    assign pixel = (v_cntr_reg >= 1024 || h_cntr_reg >= 1280)? 12'b1111_1111_1111 :
                   (MOUSE_LEFT == 1'b1 && wea == 1'b1)? color :
                   (MOUSE_LEFT == 1'b1)? pixel_filter :
                   (enable_mouse_display == 1'b1 && pixel_mouse == 12'hFFF)? color :
                   (enable_mouse_display == 1'b1)? pixel_mouse : pixel_filter;
    assign pixel_addr_background = (v_cntr_reg < 1024 && h_cntr_reg < 1280)? ((v_cntr_reg - (v_cntr_reg % 8)) * 20 + (h_cntr_reg - (h_cntr_reg % 8)) / 8) : 17'd0; 

    
    clock_divider #(13) cd13(.clk(CLK), .clk_div(clk_div13));
    clock_divider #(21) cd21(.clk(CLK), .clk_div(clk_div21));

    debounce de(.pb_debounced(de_btn) , .pb(BTN[0]) , .clk(clk_div13));

    filter filter_inst(.SW(SW[5 : 1]), .pixel_mem(pixel_mem) ,.pixel_background(pixel_background) , .pixel_filter(pixel_filter) ,.LED(LED));
    
    color color_inst(
        .clk(de_btn),
        .rst(SW[0]),
        .color(color),
        .BCD0(BCD0),
        .BCD1(BCD1)
    );
    
    seven_seg seven_seg_inst(
        .clk(clk_div13), 
        .BCD0(BCD0),
        .BCD1(BCD1),
        .DISPLAY(SSEG_CA),
        .DIGIT(SSEG_AN)
     );

    write_ram wr_inst(
        .clk(clk_div21),
        .rst(SW[0]),
        .new_MOUSE_X_POS({12'd0 , MOUSE_X_POS}),
        .new_MOUSE_Y_POS({12'd0 , MOUSE_Y_POS}),
        .MOUSE_LEFT(MOUSE_LEFT),
        .h_cntr_reg({12'd0 , h_cntr_reg}),
        .v_cntr_reg({12'd0 , v_cntr_reg}),
        .wea(wea),
        .pixel_addr(pixel_addr)
    );
    
    blk_mem_gen_1 blk_mem_gen_1_inst(
      .clka(CLK),
      .wea(wea),
      .addra(pixel_addr),
      .dina(color),
      .douta(pixel_mem)
    );
    
    blk_mem_gen_2 blk_mem_gen_2_background(
      .clka(CLK),
      .wea(1'b0),
      .addra(pixel_addr_background),
      .dina(color),
      .douta(pixel_background)
    );

    mouse mouse_ctrl_inst(
        .clk(CLK),
        .h_cntr_reg(h_cntr_reg),
        .v_cntr_reg(v_cntr_reg),
        .enable_mouse_display(enable_mouse_display),
        .MOUSE_X_POS(MOUSE_X_POS),
        .MOUSE_Y_POS(MOUSE_Y_POS),
        .MOUSE_Z_POS(MOUSE_Z_POS),
        .MOUSE_LEFT(MOUSE_LEFT),
        .MOUSE_MIDDLE(MOUSE_MIDDLE),
        .MOUSE_RIGHT(MOUSE_RIGHT),
        .MOUSE_NEW_EVENT(MOUSE_NEW_EVENT),
        .mouse_cursor_red(mouse_cursor_red),
        .mouse_cursor_green(mouse_cursor_green),
        .mouse_cursor_blue(mouse_cursor_blue),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );

    vga vga_ctrl_inst(
        .CLK_I(CLK),
        .RST_I(SW[6]),
        .pixel(pixel),
        .h_cntr_reg(h_cntr_reg),
        .v_cntr_reg(v_cntr_reg),
        .VGA_HS_O(VGA_HS),
        .VGA_VS_O(VGA_VS),
        .VGA_RED_O(VGA_RED),
        .VGA_BLUE_O(VGA_BLUE),
        .VGA_GREEN_O(VGA_GREEN)
    );
    
    playmusic playmusic_inst(
        .clk(CLK),
        .reset(SW[6]),
        .pmod_1(pmod_1),
        .pmod_2(pmod_2),
        .pmod_4(pmod_4)
    );

endmodule