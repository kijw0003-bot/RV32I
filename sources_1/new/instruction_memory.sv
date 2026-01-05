`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] instr_raddr,
    output [31:0] instr_code
);
    logic [31:0] rom_file [0:31];

    initial begin
        
        $readmemh("rom_instr_ex0.mem",rom_file); // $readmemh : hexa 코드로  "rom_snstr_ex0.mem" 파일을 읽어서  rom_file 에 로드 하겠다
                                                 // $readmemb : binary 코드로

        /*
        // rom_file[0] = 32'h004182b3; // ADD
        // rom_file[1] = 32'h40740333; // SUB
        // rom_file[2] = 32'h001818b3;  // SLL
        // rom_file[3] = 32'h001fa933;  // SLT
        // rom_file[4] = 32'h001fb9b3;  // SLTU
        // rom_file[5] = 32'h00184a33;  // XOR
        // rom_file[6] = 32'h001fdab3;  // SRL
        // rom_file[7] = 32'h401fdb33;  // SRA
        // rom_file[8] = 32'h00186bb3;  // OR
        // rom_file[9] = 32'h00187c33;  // AND

        // // S type
        // rom_file[10] = 32'h01e10123;  // SB x30, 2(x2)
        // rom_file[11] = 32'h01e11123;  // SH x30, 2(x2)
        // rom_file[12] = 32'h01e12123;  // SW x30, 2(x2)

        // // I type
        // rom_file[13] = 32'h00218a13;  // ADDI x20, x3, 2
        // rom_file[14] = 32'h002faa13;  // SLTI x20, x31, 2
        // rom_file[15] = 32'h002fba13;  // SLTIU x20, x31, 2
        // rom_file[16] = 32'h0021ca13;  // XORI x20, x3, 2
        // rom_file[17] = 32'h0021ea13;  // ORI x20, x3, 2
        // rom_file[18] = 32'h0021fa13;  // ANDI x20, x3, 2
        // rom_file[19] = 32'h00219a13;  // SLLI x20, x3, 2
        // rom_file[20] = 32'h002fda13;  // SRLI x20, x31, 2
        // rom_file[21] = 32'h402fda13;  // SRAI x20, x31, 2

        
        // // IL type
        // rom_file[22] = 32'h00212a03;  // LW x20, 2(x2)
        // rom_file[23] = 32'h00211a03;  // LH x20, 2(x2)
        // rom_file[24] = 32'h00210a03;  // LB x20, 2(x2)
        // rom_file[25] = 32'h00214a03;  // LBU x20, 2(x2)
        // rom_file[26] = 32'h00215a03;  // LHU x20, 2(x2)

        // // U-type
        // rom_file[27] = 32'h00064a37;  // LUI x20, 100
        // rom_file[28] = 32'h00064a17;  // AUIPC x20, 100
        
        // // J-type
        // rom_file[27] = 32'h00800a6f;  // JAL x20, 8
        // rom_file[29] = 32'h00f08a67;  // JALR x20, 15(x1)

        //B-type
        rom_file[0] = 32'h00216863;  // BLTU x2, x2, 16
        rom_file[1] = 32'h00316863;  // BLTU x2, x3, 16

        rom_file[5] = 32'h00317863;  // BGEU x2, x3, 16
        rom_file[6] = 32'h00217863;  // BGEU x2, x2, 16

        rom_file[10] = 32'h00310863;  // BEQ x2, x3, 16
        rom_file[11] = 32'h00210863;  // BEQ x2, x2, 16
        
        rom_file[15] = 32'h00211863;  // BNE x2, x2, 16
        rom_file[16] = 32'h02311263;  // BNE x2, x2, 36
        
        rom_file[20] = 32'h00214863;  // BLT x2, x2, 16
        rom_file[21] = 32'h00314863;  // BLT x2, x3, 16
        
        rom_file[25] = 32'h00315863;  // BGE x2, x3, 16
        rom_file[26] = 32'hfe2154e3;  // BGE x2, x2, -24
        */
    end

    assign instr_code = rom_file[instr_raddr[31:2]];

endmodule
