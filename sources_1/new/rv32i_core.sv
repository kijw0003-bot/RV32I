`timescale 1ns / 1ps

module rv32i_top (
    input clk,
    input rst
);

    logic [31:0] instr_code, instr_raddr, dwdata, drdata;
    logic [4:0] daddr;
    logic d_we;
    logic [2:0] size_control;
    instruction_memory u_instruction_memory (.*);

    data_mem U_Data_Mem (.*);
    rv32i_core u_rv32i_core (.*);

endmodule


module rv32i_core (
    input         clk,
    input         rst,
    input  [31:0] instr_code,
    input  [31:0] drdata,
    output        d_we,
    output logic [2:0] size_control,
    output [31:0] instr_raddr,
    output [31:0] dwdata,
    output [ 4:0] daddr
);

    logic regfile_we,alu_src_sel_1, alu_src_sel_2,branch,jal;
    
    logic [1:0] reg_w_src_sel;
    logic [3:0] alu_control;
    logic [ 2:0] comp_control;
    

    datapath u_datapath (.*);

    control_unit u_control_unit (.*);




endmodule
