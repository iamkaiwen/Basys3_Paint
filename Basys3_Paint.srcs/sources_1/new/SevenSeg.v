module seven_seg (clk , BCD0 , BCD1 , DISPLAY , DIGIT);
    input clk;
    input [3:0] BCD0 , BCD1;
    output reg [6:0] DISPLAY;
    output reg [3:0] DIGIT;

    reg state , next_state;
    reg [3:0] value , next_value;

    always@(posedge clk)begin
      state <= next_state;
      value <= next_value;
    end

    always@(*)begin
        if (state == 1'b0)begin
            next_state <= 1'b1;
            next_value <= BCD1;
        end
        else begin
            next_state <= 1'b0;
            next_value <= BCD0;
        end
    end
    
    always@(*)begin
        case(value)
            4'd0: DISPLAY = 7'b1000000;
            4'd1: DISPLAY = 7'b1111001;
            4'd2: DISPLAY = 7'b0100100;
            4'd3: DISPLAY = 7'b0110000;
            4'd4: DISPLAY = 7'b0011001;
            4'd5: DISPLAY = 7'b0010010;
            4'd6: DISPLAY = 7'b0000011;
            4'd7: DISPLAY = 7'b1011000;
            4'd8: DISPLAY = 7'b0000000;
            4'd9: DISPLAY = 7'b0011000;
            default: DISPLAY = 7'b1111111;
        endcase
        if(state == 1'b0)begin
            DIGIT <= 4'b1110;
        end
        else begin
            DIGIT <= 4'b1101;
        end
    end    

endmodule