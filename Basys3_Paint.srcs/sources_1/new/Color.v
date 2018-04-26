module color(
    input clk,
    input rst,
    output reg [11 : 0] color,
    output [3 : 0] BCD0,
    output [3 : 0] BCD1
);

    reg [3 : 0] num_color;

    always@(posedge clk or posedge rst)begin
        if(rst == 1'b1)begin
            num_color <= 4'd0;
        end
        else begin
            num_color <= (num_color == 4'd11)? 4'd0 : num_color + 4'd1;
        end
    end

    always@(*)begin
        case(num_color)
            4'd0 : color = 12'hFFF;
            4'd1 : color = 12'hE12;
            4'd2 : color = 12'hF72;
            4'd3 : color = 12'hFC0;
            4'd4 : color = 12'h2B4;
            4'd5 : color = 12'h0AE;
            4'd6 : color = 12'h34C;
            4'd7 : color = 12'hA4A;
            4'd8 : color = 12'h000;
            4'd9 : color = 12'h777;
            4'd10 : color = 12'hB75;
            4'd11 : color = 12'hEEB;
            default : color = 12'hFFF;
        endcase
    end
    assign BCD0 = num_color % 10;
    assign BCD1 = num_color / 10;
endmodule