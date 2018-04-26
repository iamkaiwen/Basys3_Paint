module write_ram(
    input clk,
    input rst,
    input [23 : 0] new_MOUSE_X_POS,
    input [23 : 0] new_MOUSE_Y_POS,
    input MOUSE_LEFT,
    input [23 : 0] h_cntr_reg,
    input [23 : 0] v_cntr_reg,
    output wea,
    output [16 : 0] pixel_addr
);
    parameter x = 3;
    reg [23 : 0] prev_MOUSE_X_POS , next_prev_MOUSE_X_POS;
    reg [23 : 0] prev_MOUSE_Y_POS , next_prev_MOUSE_Y_POS;
    reg [23 : 0] MOUSE_X_POS , next_MOUSE_X_POS;
    reg [23 : 0] MOUSE_Y_POS , next_MOUSE_Y_POS;
    wire [23 : 0] upper_left_X_POS , upper_left_Y_POS , bottom_right_X_POS , bottom_right_Y_POS , ratio;
    wire [23 : 0] upper_right_X_POS , upper_right_Y_POS , bottom_left_X_POS , bottom_left_Y_POS;
    wire judge_X_POS , judge_Y_POS , judge_sq , judge_sq1;
    wire judge;

    always@(posedge clk)begin
        prev_MOUSE_X_POS <= next_prev_MOUSE_X_POS;
        prev_MOUSE_Y_POS <= next_prev_MOUSE_Y_POS;
        MOUSE_X_POS <= next_MOUSE_X_POS;
        MOUSE_Y_POS <= next_MOUSE_Y_POS;
    end


    always@(*)begin
        next_prev_MOUSE_X_POS = MOUSE_X_POS;
        next_prev_MOUSE_Y_POS = MOUSE_Y_POS;
        next_MOUSE_X_POS = new_MOUSE_X_POS;
        next_MOUSE_Y_POS = new_MOUSE_Y_POS;
    end
    
    assign judge_X_POS = (MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= prev_MOUSE_X_POS) || (prev_MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= MOUSE_X_POS);
    assign judge_Y_POS = (MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= prev_MOUSE_Y_POS) || (prev_MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= MOUSE_Y_POS);
    assign {upper_left_X_POS , bottom_right_X_POS} = (MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= prev_MOUSE_X_POS)? {MOUSE_X_POS , prev_MOUSE_X_POS} :
                                                      (prev_MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= MOUSE_X_POS)? {prev_MOUSE_X_POS , MOUSE_X_POS} : 48'd0;
    assign {upper_left_Y_POS , bottom_right_Y_POS} = (MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= prev_MOUSE_Y_POS)? {MOUSE_Y_POS , prev_MOUSE_Y_POS} :
                                                     (prev_MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= MOUSE_Y_POS)? {prev_MOUSE_Y_POS , MOUSE_Y_POS} : 48'd0;
    assign {bottom_left_X_POS , upper_right_X_POS} = (MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= prev_MOUSE_X_POS)? {MOUSE_X_POS , prev_MOUSE_X_POS} :
                                                     (prev_MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= MOUSE_X_POS)? {prev_MOUSE_X_POS , MOUSE_X_POS} : 48'd0;
    assign {upper_right_Y_POS , bottom_left_Y_POS} = (MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= prev_MOUSE_Y_POS)? {MOUSE_Y_POS , prev_MOUSE_Y_POS} :
                                                     (prev_MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= MOUSE_Y_POS)? {prev_MOUSE_Y_POS , MOUSE_Y_POS} : 48'd0;
    assign judge_sq1 = ((prev_MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= MOUSE_X_POS) && (prev_MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= MOUSE_Y_POS))? 1'b0 :
                       ((MOUSE_X_POS <= h_cntr_reg && h_cntr_reg <= prev_MOUSE_X_POS) && (MOUSE_Y_POS <= v_cntr_reg && v_cntr_reg <= prev_MOUSE_Y_POS))? 1'b0 : 1'b1;
    assign judge_sq = (judge_sq1 == 1'b0 && bottom_right_X_POS - upper_left_X_POS <= bottom_right_Y_POS - upper_left_Y_POS)? 1'b1 :
                      (judge_sq1 == 1'b1 && upper_right_X_POS - bottom_left_X_POS <= bottom_left_Y_POS - upper_right_Y_POS)? 1'b1 : 1'b0;
    assign ratio = (judge_sq1 == 1'b0 && judge_sq == 1'b1 && bottom_right_X_POS - upper_left_X_POS != 24'd0)? (bottom_right_Y_POS - upper_left_Y_POS) / (bottom_right_X_POS - upper_left_X_POS) : 
                   (judge_sq1 == 1'b0 && judge_sq == 1'b0 && bottom_right_Y_POS - upper_left_Y_POS != 24'd0)? (bottom_right_X_POS - upper_left_X_POS) / (bottom_right_Y_POS - upper_left_Y_POS) : 
                   (judge_sq1 == 1'b1 && judge_sq == 1'b1 && upper_right_X_POS - bottom_left_X_POS != 24'd0)? (bottom_left_Y_POS - upper_right_Y_POS) / (upper_right_X_POS - bottom_left_X_POS) :
                   (judge_sq1 == 1'b1 && judge_sq == 1'b0 && bottom_left_Y_POS - upper_right_Y_POS != 24'd0)? (upper_right_X_POS - bottom_left_X_POS) / (bottom_left_Y_POS - upper_right_Y_POS) : 24'd0;
    assign judge = (MOUSE_X_POS == h_cntr_reg && MOUSE_Y_POS == v_cntr_reg)? 1'b1 :
                   (judge_X_POS == 1'b0 || judge_Y_POS == 1'b0)? 1'b0 :
                   (judge_sq1 == 1'b0 && bottom_right_X_POS == upper_left_X_POS)? (upper_left_Y_POS <= v_cntr_reg && v_cntr_reg <= bottom_right_Y_POS) :
                   (judge_sq1 == 1'b0 && bottom_right_Y_POS == upper_left_Y_POS)? (upper_left_X_POS <= h_cntr_reg && h_cntr_reg <= bottom_right_X_POS) :
                   (judge_sq1 == 1'b1 && bottom_left_X_POS == upper_right_X_POS)? (upper_right_Y_POS <= v_cntr_reg && v_cntr_reg <= bottom_left_Y_POS) :
                   (judge_sq1 == 1'b1 && bottom_left_Y_POS == upper_right_Y_POS)? (bottom_left_X_POS <= h_cntr_reg && h_cntr_reg <= upper_right_X_POS) : 
                   (judge_sq1 == 1'b0 && (h_cntr_reg == bottom_right_X_POS || h_cntr_reg == upper_left_X_POS))? 1'b0 :
                   (judge_sq1 == 1'b1 && (h_cntr_reg == upper_right_X_POS || h_cntr_reg == bottom_left_X_POS))? 1'b0 :
                   (judge_sq1 == 1'b0 && judge_sq == 1'b1)? (upper_left_X_POS <= h_cntr_reg && h_cntr_reg <= bottom_right_X_POS) && ((h_cntr_reg - upper_left_X_POS) * ratio + upper_left_Y_POS < v_cntr_reg && v_cntr_reg < (h_cntr_reg - upper_left_X_POS + 24'd3) * ratio + upper_left_Y_POS) :
                   (judge_sq1 == 1'b0 && judge_sq == 1'b0)? (upper_left_Y_POS <= v_cntr_reg && v_cntr_reg <= bottom_right_Y_POS) && ((v_cntr_reg - upper_left_Y_POS) * ratio + upper_left_X_POS <= h_cntr_reg && h_cntr_reg <= (v_cntr_reg - upper_left_Y_POS + 24'd3) * ratio + upper_left_X_POS) :
                   (judge_sq1 == 1'b1 && judge_sq == 1'b1)? (bottom_left_X_POS <= h_cntr_reg && h_cntr_reg <= upper_right_X_POS) && ((upper_right_X_POS - h_cntr_reg) * ratio + upper_right_Y_POS <= v_cntr_reg && v_cntr_reg <= (upper_right_X_POS - h_cntr_reg + 24'd3) * ratio + upper_right_Y_POS) :
                   (judge_sq1 == 1'b1 && judge_sq == 1'b0)? (upper_right_Y_POS <= v_cntr_reg && v_cntr_reg <= bottom_left_Y_POS) && ((bottom_left_Y_POS - v_cntr_reg) * ratio + bottom_left_X_POS <= h_cntr_reg && h_cntr_reg <= (bottom_left_Y_POS - v_cntr_reg + 24'd3) * ratio + bottom_left_X_POS) : 1'b0;
  
    assign wea = (rst == 1'b1)? 1'b1 :
                 (v_cntr_reg >= 1024 || h_cntr_reg >= 1280)? 1'b0 :
                 (MOUSE_LEFT == 1'b0)? 1'b0 : judge;
    assign pixel_addr = (v_cntr_reg < 1024 && h_cntr_reg < 1280)? ((v_cntr_reg - (v_cntr_reg % 4)) * 80 + (h_cntr_reg - (h_cntr_reg % 4)) / 4) : 17'd0; 
endmodule