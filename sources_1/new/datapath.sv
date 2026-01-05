`timescale 1ns / 1ps

`include "define.vh"

module datapath (
    input         clk,
    input         rst,
    input         regfile_we,
    input         alu_src_sel_1,
    input         alu_src_sel_2,
    input  [ 1:0] reg_w_src_sel,
    input         branch,
    input         jal,
    input  [ 3:0] alu_control,
    input  [ 2:0] comp_control,
    input  [ 2:0] size_control,
    input  [31:0] instr_code,     // instruction code from rom
    input  [31:0] drdata,
    output [31:0] instr_raddr,    // pc to rom
    output [ 4:0] daddr,
    output [31:0] dwdata
);

    logic [31:0]
        alu_result,
        rdata1,
        rdata2,
        o_imm,
        alu_src_1,
        alu_src_2,
        reg_w_src,
        next_pc;
    logic btaken;

    logic [31:0] data_mem_src_mux, data_selected;
    assign dwdata = rdata2;
    assign daddr  = alu_result[6:2];


    register_file u_register_file (
        .clk   (clk),
        .rst   (rst),
        .raddr1(instr_code[19:15]),  // instruction code rs 1
        .raddr2(instr_code[24:20]),  // instruction code rs 2
        .waddr (instr_code[11:7]),   // instruction code rd
        .wdata (reg_w_src),          // alu output
        .we    (regfile_we),         // from control unit
        .rdata1(rdata1),             // to alu a
        .rdata2(rdata2)              // to alu b
    );

    mux_2x1 U_ALU_SRC_1_MUX (
        .mux_sel(alu_src_sel_1),
        .in_0(rdata1),
        .in_1(instr_raddr),  // PC
        .mux_out(alu_src_1)
    );

    mux_2x1 U_ALU_SRC_2_MUX (
        .mux_sel(alu_src_sel_2),
        .in_0(rdata2),
        .in_1(o_imm),  // IMM
        .mux_out(alu_src_2)
    );

    comparator u_in_alu_comparator (
        .a(rdata1),
        .b(rdata2),
        .comp_control(comp_control),
        .btaken(btaken)
    );

    alu u_alu (
        .alu_control(alu_control),
        .a(alu_src_1),
        .b(alu_src_2),
        .alu_result(alu_result)
    );



    program_counter U_PROGRAM_COUNTER (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .btaken(btaken),
        .jal(jal),
        .alu_result(alu_result),
        .current_pc(instr_raddr),
        .next_pc(next_pc)
    );

    extend_imm u_extend_imm (
        .instr_code(instr_code),
        .o_imm(o_imm)
    );

    mux_w_data_src_mux U_W_DATA_SRC_MUX (
        .mux_sel(reg_w_src_sel),
        .in_0(alu_result),
        .in_1(data_selected),
        .in_2(o_imm),
        .in_3(next_pc),
        .mux_out(reg_w_src)
    );

    w_h_b_selector U_w_h_b_selector (
        .in_data(drdata),
        .size_control(size_control),
        .out_data(data_selected)
    );

endmodule

module register_file (
    input         clk,
    input         rst,
    input  [ 4:0] raddr1,  // instruction code rs 1
    input  [ 4:0] raddr2,  // instruction code rs 2
    input  [ 4:0] waddr,   // instruction code rd
    input  [31:0] wdata,   // alu output
    input         we,      // from control unit
    output [31:0] rdata1,  // to alu a
    output [31:0] rdata2   // to alu b
);

    logic [31:0] register_file[0:31];

`ifdef SIMULATION
    initial begin
        for (int i = 0; i < 30; i++) begin
            register_file[i] = i;
        end

        register_file[30] = 32'hfa_ff_7b_80;
        register_file[31] = 32'hff_ff_ff_f0;
    end
`endif  
    always_ff @(posedge clk) begin
        if(rst) begin
           
            register_file[0] = 0;
            register_file[1] = 32'h10;
        
        end else if (we&(waddr!=0)) begin
            register_file[waddr] <= wdata;
        end
    end

    assign rdata1 = register_file[raddr1];
    assign rdata2 = register_file[raddr2];

endmodule


module alu (
    input  [ 3:0] alu_control,
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] alu_result

);

    logic [31:0] r_alu_result;
    assign alu_result = r_alu_result;




    always_comb begin
        r_alu_result = 0;

        case (alu_control)
            `ADD: begin
                r_alu_result = a + b;
            end
            `SUB: begin
                r_alu_result = a - b;
            end
            `SLL: begin
                r_alu_result = a << b[4:0];
            end
            `SLT: begin
                r_alu_result = ($signed(a) < $signed(b)) ? 1 : 0;
            end
            `SLTU: begin
                r_alu_result = a < b ? 1 : 0;
            end

            `XOR: begin
                r_alu_result = a ^ b;
            end
            `SRL: begin
                r_alu_result = a >> b[4:0];
            end
            `SRA: begin
                r_alu_result = $signed(a) >>> b[4:0];
            end
            `OR: begin
                r_alu_result = a | b;
            end
            `AND: begin
                r_alu_result = a & b;
            end

        endcase

    end


endmodule

module program_counter (
    input         clk,
    input         rst,
    input         btaken,
    input         branch,
    input         jal,
    input  [31:0] alu_result,
    output [31:0] current_pc,
    output [31:0] next_pc
);

    logic [31:0] pc_src_mux_out;

    mux_2x1 U_PC_SRC_MUX (
        .mux_sel(jal | (btaken & branch)),
        .in_0(next_pc),
        .in_1(alu_result),
        .mux_out(pc_src_mux_out)
    );

    alu_pc u_alu_pc (
        .a(32'd4),
        .b(current_pc),
        .o_alu(next_pc)
    );

    register u_register (
        .clk(clk),
        .rst(rst),
        .data_in(pc_src_mux_out),
        .data_out(current_pc)
    );

endmodule



module register (
    input         clk,
    input         rst,
    input  [31:0] data_in,
    output [31:0] data_out
);
    logic [31:0] register;

    assign data_out = register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            register <= 0;
        end else begin
            register <= data_in;
        end
    end
endmodule


module alu_pc (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] o_alu
);
    assign o_alu = a + b;

endmodule

module extend_imm (
    input        [31:0] instr_code,
    output logic [31:0] o_imm
);

    always_comb begin
        o_imm = 32'd0;
        case (instr_code[6:0])
            `OP_S_TYPE: begin
                // sign extends with instr_code[31] 
                o_imm = {
                    {20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]
                };
            end

            `OP_I_TYPE, `OP_IL_TYPE: begin
                o_imm = {{20{instr_code[31]}}, instr_code[31:20]};
            end

            `OP_B_TYPE: begin
                case ({
                    instr_code[14:12]
                })
                    3'b000, 3'b001, 3'b100, 3'b101: begin  // sign extend
                        o_imm = {
                            {19{instr_code[31]}},
                            instr_code[31],
                            instr_code[7],
                            instr_code[30:25],  // 6개
                            instr_code[11:8],  // 4개
                            1'b0
                        };
                    end
                    3'b110, 3'b111: begin  // unsign extend
                        o_imm = {
                            {19{1'b0}},
                            instr_code[31],
                            instr_code[7],
                            instr_code[30:25],  // 6개
                            instr_code[11:8],  // 4개
                            1'b0
                        };
                    end
                endcase
            end

            `OP_U_TYPE, `OP_U_AUI_TYPE: begin
                o_imm = {instr_code[31:12], {12{1'd0}}};
            end

            `OP_JAL_TYPE: begin
                o_imm = {
                    {11{instr_code[31]}},
                    instr_code[31],
                    instr_code[19:12],
                    instr_code[20],
                    instr_code[30:21],
                    1'b0
                };
            end

            `OP_JALR_TYPE: begin
                o_imm = {{20{instr_code[31]}}, instr_code[31:20]};
            end

        endcase
    end


endmodule

module mux_2x1 (
    input         mux_sel,
    input  [31:0] in_0,
    input  [31:0] in_1,
    output [31:0] mux_out
);

    assign mux_out = mux_sel ? in_1 : in_0;

endmodule

module mux_w_data_src_mux (
    input [1:0] mux_sel,
    input [31:0] in_0,
    input [31:0] in_1,
    input [31:0] in_2,
    input [31:0] in_3,
    output logic [31:0] mux_out
);

    always_comb begin
        mux_out = in_0;
        case (mux_sel)
            2'b00: mux_out = in_0;
            2'b01: mux_out = in_1;
            2'b10: mux_out = in_2;
            2'b11: mux_out = in_3;

        endcase
    end

endmodule



module comparator (
    input        [31:0] a,
    input        [31:0] b,
    input        [ 2:0] comp_control,
    output logic        btaken
);

    always_comb begin
        btaken = 0;
        case (comp_control)
            `BEQ:  btaken = a == b ? 1 : 0;
            `BNE:  btaken = a != b ? 1 : 0;
            `BLT:  btaken = $signed(a) < $signed(b) ? 1 : 0;
            `BGE:  btaken = $signed(a) >= $signed(b) ? 1 : 0;
            `BLTU: btaken = a < b ? 1 : 0;
            `BGEU: btaken = a >= b ? 1 : 0;

        endcase
    end


endmodule


module w_h_b_selector (
    input        [31:0] in_data,
    input        [ 2:0] size_control,
    output logic [31:0] out_data
);

    always_comb begin
        out_data = 32'd0;
        case (size_control)
            `SB, `LB: begin
                out_data = {{24{in_data[7]}}, in_data[7:0]};

            end
            `SH, `LH: begin
                out_data = {{16{in_data[15]}}, in_data[15:0]};

            end
            `SW, `LW: begin
                out_data = in_data;

            end
            `LBU: begin
                out_data = {{24{1'b0}}, in_data[7:0]};

            end
            `LHU: begin
                out_data = {{16{1'b0}}, in_data[15:0]};

            end
        endcase
    end
endmodule
