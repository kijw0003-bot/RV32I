`timescale 1ns / 1ps


module tb_rv32i ();

    logic clk;
    logic rst;

    rv32i_top dut (.*);

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        #250;
        $stop;
    end
endmodule
