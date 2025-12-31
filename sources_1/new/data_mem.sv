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


    //  logic [7:0] n_mem_reg[0:63];
    //  logic [7:0] c_mem_reg[0:63];
    
    // always_ff @(posedge clk ) begin
    //         for(int i=0; i<{d_we,d_he,d_be} ; i++) begin
    //             c_mem_reg[daddr+i] <= n_mem_reg[daddr+i];
    //         end
    // end

    // always_comb begin 

    //     for(int i=0 ; i<{d_we,d_he,d_be} ; i++) begin
    //         n_mem_reg[daddr+i] = dwdata[8*i+:8];    
    //     end
        
    // end




    // assign drdata = c_mem_reg[daddr];

endmodule
