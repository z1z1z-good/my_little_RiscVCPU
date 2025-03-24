`define INST_NOP    32'h00000013

// opcode
`define OPCODE_WIDTH 7
`define INST_TYPE_R_M   `OPCODE_WIDTH'b0110011 // add/sub/xor/or/and/sll/srl/sra/slt/sltu
                                               // mul/mulh/mulhsu/mulhu/div/divu/rem/remu
`define INST_TYPE_I     `OPCODE_WIDTH'b0010011 // addi/xori/ori/andi/slli/srli/srai/slti/sltiu
`define INST_TYPE_L     `OPCODE_WIDTH'b0000011 // lb/lh/lw/lbu/lhu
`define INST_TYPE_S     `OPCODE_WIDTH'b0100011 // sb/sh/sw
`define INST_TYPE_B     `OPCODE_WIDTH'b1100011 // beq/bne/blt/bge/bltu/bgeu
`define INST_JAL        `OPCODE_WIDTH'b1101111 // jal
`define INST_JALR       `OPCODE_WIDTH'b1100111 // jalr
`define INST_LUI        `OPCODE_WIDTH'b0110111 // lui
`define INST_AUIPC      `OPCODE_WIDTH'b0010111 // auipc
`define INST_TYPE_IE    `OPCODE_WIDTH'b1110011 // ecall/ebreak

// funct3
    // R_M-type
`define FUNCT3_WIDTH 3
`define INST_ADD_SUB   `FUNCT3_WIDTH'h0
`define INST_SLL       `FUNCT3_WIDTH'h1
`define INST_SLT       `FUNCT3_WIDTH'h2
`define INST_SLTU      `FUNCT3_WIDTH'h3
`define INST_XOR       `FUNCT3_WIDTH'h4
`define INST_SRL_SRA   `FUNCT3_WIDTH'h5
`define INST_OR        `FUNCT3_WIDTH'h6
`define INST_AND       `FUNCT3_WIDTH'h7
    // I-type 
`define INST_ADDI      `FUNCT3_WIDTH'h0
`define INST_SLLI      `FUNCT3_WIDTH'h1
`define INST_SLTI      `FUNCT3_WIDTH'h2
`define INST_SLTIU     `FUNCT3_WIDTH'h3
`define INST_XORI      `FUNCT3_WIDTH'h4
`define INST_SRLI_SRAI `FUNCT3_WIDTH'h5
`define INST_ORI       `FUNCT3_WIDTH'h6
`define INST_ANDI      `FUNCT3_WIDTH'h7
    // L-type
`define INST_LB        `FUNCT3_WIDTH'h0
`define INST_LH        `FUNCT3_WIDTH'h1
`define INST_LW        `FUNCT3_WIDTH'h2
`define INST_LBU       `FUNCT3_WIDTH'h4
`define INST_LHU       `FUNCT3_WIDTH'h5
    // S-type
`define INST_SB        `FUNCT3_WIDTH'h0
`define INST_SH        `FUNCT3_WIDTH'h1
`define INST_SW        `FUNCT3_WIDTH'h2
    // B-type
`define INST_BEQ       `FUNCT3_WIDTH'h0
`define INST_BNE       `FUNCT3_WIDTH'h1
`define INST_BLT       `FUNCT3_WIDTH'h4
`define INST_BGE       `FUNCT3_WIDTH'h5
`define INST_BLTU      `FUNCT3_WIDTH'h6
`define INST_BGEU      `FUNCT3_WIDTH'h7
    // I-type environment
`define INST_ECALL     `FUNCT3_WIDTH'h0
`define INST_EBREAK    `FUNCT3_WIDTH'h0

// funct7
    //R-TYPE
`define FUNCT7_WIDTH 7
`define FUNCT7_INST_ADD `FUNCT7_WIDTH'h00
`define FUNCT7_INST_SUB `FUNCT7_WIDTH'h20
`define FUNCT7_INST_SRL `FUNCT7_WIDTH'h00
`define FUNCT7_INST_SRA `FUNCT7_WIDTH'h20
    //I-TYPE
`define FUNCT7_INST_SRLI `FUNCT7_WIDTH'h00
`define FUNCT7_INST_SRAI `FUNCT7_WIDTH'h20


