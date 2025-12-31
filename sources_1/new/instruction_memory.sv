`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] instr_raddr,
    output [31:0] instr_code
);

    logic [31:0] rom_file [0:31];

    initial begin
//  rs1 : 0x10 => 1_0000   rs2 : 0x01 => 0_0001
        rom_file[0] = 32'h004182b3; // ADD
        rom_file[1] = 32'h40740333; // SUB
        // rom_file[2] = 32'b0000_0000_0001_1000_0001_1000_1011_0011;  // SLL
        rom_file[2] = 32'h001818b3;  // SLL

        // rom_file[3] = 32'b0000_0000_0001_1111_1010_1001_0011_0011;  // SLT
        rom_file[3] = 32'h001fa933;  // SLT

        // rom_file[4] = 32'b0000_0000_0001_1111_1011_1001_1011_0011;  // SLTU
        rom_file[4] = 32'h001fb9b3;  // SLTU

        // rom_file[5] = 32'b0000_0000_0001_1000_0100_1010_0011_0011;  // XOR
        rom_file[5] = 32'h00184a33;  // XOR
        
        // rom_file[6] = 32'b0000_0000_0001_1111_1101_1010_1011_0011;  // SRL
        rom_file[6] = 32'h001fdab3;  // SRL
        
        // rom_file[7] = 32'b0100_0000_0001_1111_1101_1011_0011_0011;  // SRA
        rom_file[7] = 32'h401fdb33;  // SRA
        
        // rom_file[8] = 32'b0000_0000_0001_1000_0110_1011_1011_0011;  // OR
        rom_file[8] = 32'h00186bb3;  // OR
        
        // rom_file[9] = 32'b0000_0000_0001_1000_0111_1100_0011_0011;  // AND
        rom_file[9] = 32'h00187c33;  // AND
        

        // S type
        rom_file[10] = 32'h00812123;  // sw x2, 2, x8
        // I type
        rom_file[11] = 32'h00218a13;  // ADDI x20, x3, 2
        rom_file[12] = 32'h002faa13;  // SLTI x20, x31, 2
        rom_file[13] = 32'h002fba13;  // SLTIU x20, x31, 2
        rom_file[14] = 32'h0021ca13;  // XORI x20, x3, 2
        rom_file[15] = 32'h0021ea13;  // ORI x20, x3, 2
        rom_file[16] = 32'h0021fa13;  // ANDI x20, x3, 2
        rom_file[17] = 32'h00219a13;  // SLLI x20, x3, 2
        rom_file[18] = 32'h002fda13;  // SRLI x20, x31, 2
        rom_file[19] = 32'h402fda13;  // SRAI x20, x31, 2

        
        // IL type
        rom_file[20] = 32'h00212a03;  // LW x20, 2(x2)
        
        //B-type
        // rom_file[21] = 32'h00210863;  // BEQ x2, x2, 16
        
        // U-type
        rom_file[21] = 32'h00064a37;  // LUI x20, 100
        
        rom_file[22] = 32'h00064a17;  // auipc x20, 100
        
        
        // J-type
        // rom_file[23] = 32'h06400a6f;  // jal x20, 100
        rom_file[23] = 32'h06408a67;  // jjalr x20, 100(x1)

    end

    assign instr_code = rom_file[instr_raddr[31:2]];

endmodule
