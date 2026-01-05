`timescale 1ns / 1ps
`include "define.vh"

module data_mem (
    input        clk,
    input        d_we,
    input [2:0] size_control,
    input [ 4:0] daddr,
    input [31:0] dwdata,
    output [31:0] drdata
);

    logic [31:0] mem_reg[0:31];
    
    always_ff @(posedge clk) begin
        if (d_we) begin
            case (size_control)
                `SB: begin
                    mem_reg[daddr][8:0] <= dwdata[8:0];
                end
                `SH: begin
                    mem_reg[daddr][16:0] <= dwdata[16:0];
                end
                `SW: begin
                    mem_reg[daddr] <= dwdata;
                end
                
            endcase
            
        end
    end

    assign drdata = mem_reg[daddr];

endmodule
