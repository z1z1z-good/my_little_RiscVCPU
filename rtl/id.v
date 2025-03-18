module  id(
    input   wire    [31:0]  inst_i,
    input   wire    [31:0]  rom_inst_addr_i,
    
    input   wire    [31:0]  rs1_data_i,
    input   wire    [31:0]  rs2_data_i,
    
    output  reg     [4:0]   rs1_addr_o,
    output  reg     [4:0]   rs2_addr_o,
    
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

assign opcode   = inst_i[6:0];
assign rd       = inst_i[11:7];
assign func3    = inst_i[14:12];
assign func7    = inst_i[31:25];
assign rs1      = inst_i[19:15];
assign rs2      = inst_i[24:20];
assign imm      = inst_i[31:20];

always@(*) begin
    inst_o = inst_i;
    inst_addr_o = rom_inst_addr_i;

    case(opcode)
        7'b0010011:begin
            case(func3)
                3'b000:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = 5'b0;
                    op_num1_o     = rs1_data_i;
                    op_num2_o     = {{20{imm[11]}},imm};
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end
                default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o     = 32'b0;
                    op_num2_o     = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end
            endcase
        end 
        7'b0110011:begin
            case(func3)
                3'b000:begin
                    rs1_addr_o  = rs1;
                    rs2_addr_o  = rs2;
                    op_num1_o     = rs1_data_i;
                    op_num2_o     = rs2_data_i;
                    rd_addr_o   = rd;
                    reg_wen     = 1'b1;
                end 
                default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o     = 32'b0;
                    op_num2_o     = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
                end 
            endcase
        end
        default:begin
                    rs1_addr_o  = 5'b0;
                    rs2_addr_o  = 5'b0;
                    op_num1_o     = 32'b0;
                    op_num2_o     = 32'b0;
                    rd_addr_o   = 5'b0;
                    reg_wen     = 1'b0;
        end 
    endcase
end 
endmodule