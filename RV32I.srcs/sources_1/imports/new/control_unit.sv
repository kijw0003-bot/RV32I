`timescale 1ns / 1ps

`include "define.vh"

module control_unit (
    input        [31:0] instr_code,
    output logic        regfile_we,
    output logic        alu_src_sel_1,
    output logic        alu_src_sel_2,
    output logic [ 1:0] reg_w_src_sel,
    output logic [ 3:0] alu_control,
    output logic [ 2:0] comp_control,
    output logic [ 2:0] size_control,
    output logic        branch,
    output logic        jal,
    // output logic        d_be,
    // output logic        d_he,
    output logic        d_we

);

    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] opcode;

    assign funct7 = instr_code[31:25];
    assign funct3 = instr_code[14:12];
    assign opcode = instr_code[6:0];


    always_comb begin
        regfile_we = 1'b0;
        d_we = 1'b0;
        alu_src_sel_1 = 1'b0;
        alu_src_sel_2 = 1'b0;
        reg_w_src_sel = 2'b00;
        alu_control = 4'b0000;  // dufault ADD
        comp_control = 3'b000;
        branch = 1'b0;
        jal = 1'b0;
        size_control = 3'b000;
        case (opcode)
            `OP_R_TYPE: begin  // to write to reg_file
                regfile_we = 1'b1;
                d_we = 1'b0;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b0;
                reg_w_src_sel = 2'b00;
                alu_control = {funct7[5], funct3};
                branch = 1'b0;
            end
            `OP_S_TYPE: begin  // to write to data memory
                regfile_we = 1'b0;
                d_we = 1'b1;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b1;
                reg_w_src_sel = 2'b00;
                alu_control = `ADD;
                size_control = funct3;
                branch = 1'b0;
            end
            `OP_I_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b00;
                branch = 1'b0;
                if (funct3 == `SRLI || funct3 == `SRAI) begin
                    alu_control = {funct7[5], funct3};
                end else begin
                    alu_control = {1'b0, funct3};

                end
            end
            `OP_IL_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b01;
                branch = 1'b0;
                alu_control = `ADD;
                size_control = funct3;
                // case (funct3)
                //     `LB: begin

                //     end
                //     `LH: begin

                //     end
                //     `LW: begin

                //     end
                //     `LBU: begin

                //     end
                //     `LHU: begin

                //     end

                // endcase
            end

            `OP_B_TYPE: begin
                regfile_we = 1'b0;
                alu_src_sel_1 = 1'b1;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b00;
                branch = 1'b1;
                comp_control = funct3;
                alu_control = `ADD;
            end
            `OP_U_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b0;
                d_we = 1'b0;
                reg_w_src_sel = 2'b10;
                branch = 1'b0;
                alu_control = 4'b0000;
            end

            `OP_U_AUI_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b1;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b00;
                branch = 1'b0;
                alu_control = `ADD;
            end

            `OP_JAL_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b1;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b11;
                branch = 1'b0;
                jal = 1'b1;
                alu_control = `ADD;
            end
            `OP_JALR_TYPE: begin
                regfile_we = 1'b1;
                alu_src_sel_1 = 1'b0;
                alu_src_sel_2 = 1'b1;
                d_we = 1'b0;
                reg_w_src_sel = 2'b11;
                branch = 1'b0;
                jal = 1'b1;
                alu_control = `ADD;
            end

        endcase
    end

endmodule
