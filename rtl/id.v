`include "defines.v"

module  id(
    input   wire    [31:0]  inst_i,
    input   wire    [31:0]  inst_addr_i,
    
    //--------regs---------------------
    input   wire    [31:0]  rs1_data_i,
    input   wire    [31:0]  rs2_data_i,
    
    output  reg     [4:0]   rs1_addr_o,
    output  reg     [4:0]   rs2_addr_o,
    //---------regs--------------------
    
    output  reg     [31:0]  inst_o,
    output  reg     [31:0]  inst_addr_o,

    output  reg     [31:0]  op_num1_o,
    output  reg     [31:0]  op_num2_o,
    output  reg     [4:0]   rd_addr_o,
    output  reg             reg_wen
);

wire[6:0] opcode;
wire[4:0] rd;
wire[2:0] func3;
wire[6:0] func7;
wire[4:0] rs1;
wire[4:0] rs2;
wire[11:0]imm;
wire[4:0] shamt;

assign opcode   = inst_i[6:0];
assign rd       = inst_i[11:7];
assign func3    = inst_i[14:12];
assign func7    = inst_i[31:25];
assign rs1      = inst_i[19:15];
assign rs2      = inst_i[24:20];
assign imm      = inst_i[31:20];
assign shamt    = inst_i[24:20];

always@(*) begin
    inst_o = inst_i;
    inst_addr_o = inst_addr_i;

    case(opcode)
        `INST_TYPE_I:begin
            case(func3)
                `INST_ADDI,`INST_SLTI,`INST_SLTIU,`INST_XORI,`INST_ORI,`INST_ANDI:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = 5'b0;
                    op_num1_o   = rs1_data_i;
                    op_num2_o   = {{20{imm[11]}},imm};
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end
                `INST_SLLI,`INST_SRLI_SRAI:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = 5'b0;
                    op_num1_o   = rs1_data_i;
                    op_num2_o   = {27'b0,shamt};
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end 
                default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o   = 32'b0;
                    op_num2_o   = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end
            endcase
        end 
        `INST_TYPE_R_M:begin
            case(func3)
                `INST_ADD_SUB,`INST_SLL,`INST_SLT,`INST_SLTU,`INST_XOR,`INST_SRL_SRA,`INST_OR,`INST_AND:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = rs2;
                    op_num1_o   = rs1_data_i;
                    op_num2_o   = rs2_data_i;
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end 
                default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o   = 32'b0;
                    op_num2_o   = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end 
            endcase
        end
        `INST_TYPE_B:begin
            case(func3)
                `INST_BEQ,`INST_BNE:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = rs2;
                    op_num1_o   = rs1_data_i;
                    op_num2_o   = rs2_data_i;
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end 
                default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o   = 32'b0;
                    op_num2_o   = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end 
            endcase
        end 
        `INST_JAL:begin
            rs1_addr_o  = 5'b0;
            rs2_addr_o  = 5'b0;
            op_num1_o   = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            op_num2_o   = 32'b0;
            rd_addr_o   = rd;
            reg_wen     = 1'b1;
        end 
        `INST_LUI:begin
            rs1_addr_o  = 5'b0;
            rs2_addr_o  = 5'b0;
            op_num1_o   = {inst_i[31:12],12'b0};
            op_num2_o   = 32'b0;
            rd_addr_o   = rd;
            reg_wen     = 1'b1;
        end 
        default:begin
            rs1_addr_o  = 5'b0;
            rs2_addr_o  = 5'b0;
            op_num1_o   = 32'b0;
            op_num2_o   = 32'b0;
            rd_addr_o   = 5'b0;
            reg_wen     = 1'b0;
        end 
    endcase
end 
endmodule