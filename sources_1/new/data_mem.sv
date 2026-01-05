`timescale 1ns / 1ps

module data_mem (
    input        clk,
    // input        d_be,
    // input        d_he,
    input        d_we,
    input [ 6:0] daddr,
    input [31:0] dwdata,
    output [31:0] drdata
);

    logic [31:0] mem_reg[0:127];
    
    always_ff @(posedge clk) begin
        if (d_we) begin
            mem_reg[daddr] <= dwdata;
        end
    end

    assign drdata = mem_reg[daddr];

endmodule
