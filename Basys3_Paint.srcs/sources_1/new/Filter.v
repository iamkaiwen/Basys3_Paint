module filter(
    input [4 : 0] SW,
    input [11 : 0] pixel_mem,
    input [11 : 0] pixel_background ,
    output reg [11 : 0] pixel_filter,
    output reg [15 : 0] LED
);

    wire [11 : 0] pixel_white; 
    always@(*)begin
        if(SW[0] == 1'b1)begin
            case (pixel_mem)
                12'hFFF : pixel_filter = pixel_white;
                12'hE12 : pixel_filter = 12'hF88;
                12'hF72 : pixel_filter = 12'hF84;
                12'hFC0 : pixel_filter = 12'hFF8;
                12'h2B4 : pixel_filter = 12'h8F8;
                12'h0AE : pixel_filter = 12'h9DE;
                12'h34C : pixel_filter = 12'h79B;
                12'hA4A : pixel_filter = 12'hCBE;
                12'h000 : pixel_filter = 12'h333;
                12'h777 : pixel_filter = 12'hCCC;
                12'hB75 : pixel_filter = 12'hC97;
                12'hEEB : pixel_filter = 12'hEEA;
              default: pixel_filter = pixel_white;
            endcase
            LED = (SW[4] == 1'b1)? {10'd0 , 6'b100010} : {11'd0 , 5'b00010};
        end
        else if(SW[1] == 1'b1)begin
            case (pixel_mem)
                12'hFFF : pixel_filter = pixel_white;
                12'hE12 : pixel_filter = 12'h600;
                12'hF72 : pixel_filter = 12'h940;
                12'hFC0 : pixel_filter = 12'h990;
                12'h2B4 : pixel_filter = 12'h021;
                12'h0AE : pixel_filter = 12'h046;
                12'h34C : pixel_filter = 12'h115;
                12'hA4A : pixel_filter = 12'h424;
                12'h000 : pixel_filter = 12'h000;
                12'h777 : pixel_filter = 12'h333;
                12'hB75 : pixel_filter = 12'h421;
                12'hEEB : pixel_filter = 12'hDC6;
              default: pixel_filter = pixel_white;
            endcase
            LED = (SW[4] == 1'b1)? {10'd0 , 6'b100100} : {11'd0 , 5'b00100};
        end
        else if(SW[2] == 1'b1)begin
            case (pixel_mem)
                12'hFFF : pixel_filter = pixel_white;
                12'hE12 : pixel_filter = 12'h666;
                12'hF72 : pixel_filter = 12'hAAA;
                12'hFC0 : pixel_filter = 12'hCCC;
                12'h2B4 : pixel_filter = 12'h555;
                12'h0AE : pixel_filter = 12'h999;
                12'h34C : pixel_filter = 12'h333;
                12'hA4A : pixel_filter = 12'h444;
                12'h000 : pixel_filter = 12'h000;
                12'h777 : pixel_filter = 12'h222;
                12'hB75 : pixel_filter = 12'h888;
                12'hEEB : pixel_filter = 12'hCCC;
              default: pixel_filter = pixel_white;
            endcase
            LED = (SW[4] == 1'b1)? {10'd0 , 6'b101000} : {11'd0 , 5'b01000};
        end
        else if(SW[3] == 1'b1)begin
            case (pixel_mem)
                12'hFFF : pixel_filter = pixel_white;
                12'hE12 : pixel_filter = 12'hA55;
                12'hF72 : pixel_filter = 12'hB86;
                12'hFC0 : pixel_filter = 12'hAA5;
                12'h2B4 : pixel_filter = 12'h485;
                12'h0AE : pixel_filter = 12'h489;
                12'h34C : pixel_filter = 12'h56A;
                12'hA4A : pixel_filter = 12'h858;
                12'h000 : pixel_filter = 12'h000;
                12'h777 : pixel_filter = 12'h555;
                12'hB75 : pixel_filter = 12'hA87;
                12'hEEB : pixel_filter = 12'hEDB;
              default: pixel_filter = pixel_white;
            endcase
            LED = (SW[4] == 1'b1)? {10'd0 , 6'b110000} : {11'd0 , 5'b10000};
        end
        else begin
            case (pixel_mem)
                12'hFFF : pixel_filter = pixel_white;
                12'hE12 : pixel_filter = 12'hE12;
                12'hF72 : pixel_filter = 12'hF72;
                12'hFC0 : pixel_filter = 12'hFC0;
                12'h2B4 : pixel_filter = 12'h2B4;
                12'h0AE : pixel_filter = 12'h0AE;
                12'h34C : pixel_filter = 12'h34C;
                12'hA4A : pixel_filter = 12'hA4A;
                12'h000 : pixel_filter = 12'h000;
                12'h777 : pixel_filter = 12'h777;
                12'hB75 : pixel_filter = 12'hB75;
                12'hEEB : pixel_filter = 12'hEEB;
              default: pixel_filter = pixel_white;
            endcase
            LED = (SW[4] == 1'b1)? {10'd0 , 6'b100001} : {11'd0 , 5'b00001};
        end
    end
    
    assign pixel_white = (SW[4] == 1'b1)? pixel_background :
                         (SW[3] == 1'b1)? 12'hEEE : 12'hFFF;

endmodule