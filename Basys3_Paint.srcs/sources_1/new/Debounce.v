module debounce (pb_debounced , pb , clk);
    parameter n = 4;
    output pb_debounced;
    input pb , clk;
    reg [n - 1:0] shift_reg;

    always@(posedge clk)begin
        shift_reg[n-1:1] <= shift_reg[n-2:0];
        shift_reg[0] <= pb;
    end

    assign pb_debounced = &shift_reg;
endmodule
