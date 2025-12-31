
// OP_CODE
`define OP_R_TYPE 7'b011_0011
`define OP_S_TYPE 7'b010_0011
`define OP_I_TYPE 7'b001_0011
`define OP_IL_TYPE 7'b000_0011
`define OP_B_TYPE 7'b110_0011
`define OP_U_TYPE 7'b011_0111
`define OP_U_AUI_TYPE 7'b001_0111
`define OP_JAL_TYPE 7'b110_1111
`define OP_JALR_TYPE 7'b110_0111


// 00011000011010011111

// R-type  , funct7[5], funct3
`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define SRL 4'b0101
`define SRA 4'b1101
`define OR 4'b0110
`define AND 4'b0111

// S-type  , funct3
`define SB 3'b000
`define SH 3'b001
`define SW 3'b010

// I-type , funct3
`define ADDI 3'b000
`define SLLI 3'b001
`define SLTI 3'b010
`define SLTIU 3'b011
`define XORI 3'b100
`define SRLI 3'b101
`define SRAI 3'b101
`define ORI 3'b110
`define ANDI 3'b111

//IL-type, funct3
`define LB  3'b000
`define LH  3'b001
`define LW  3'b010
`define LBU 3'b100
`define LHU 3'b101

//B-type, funct3
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111




