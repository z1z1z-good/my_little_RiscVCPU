`include "defines.v"

module ex(
    input   wire    [31:0]  inst_i      ,
    input   wire    [31:0]  inst_addr_i ,
    input   wire    [31:0]  op_num1_i   ,
    input   wire    [31:0]  op_num2_i   ,
    input   wire    [4:0]   rd_addr_i   ,
    input   wire            rd_wen_i    ,
    
    output  reg     [4:0]   rd_addr_o   ,
    output  reg     [31:0]  rd_data_o   ,
    output  reg             rd_wen_o    ,
    
    output  reg     [31:0]  jump_addr_o ,
    output  reg             jump_en_o   ,
    output  reg             hold_flag_o
);

wire[6:0] opcode; 
wire[4:0] rd; 
wire[2:0] func3; 
wire[4:0] rs1;
wire[4:0] rs2;
wire[6:0] func7;
wire[11:0]imm;

assign opcode = inst_i[6:0];
assign rd 	  = inst_i[11:7];
assign func3  = inst_i[14:12];
assign rs1 	  = inst_i[19:15];
assign rs2 	  = inst_i[24:20];
assign func7  = inst_i[31:25];
assign imm    = inst_i[31:20];

wire[31:0] jump_imm = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0}; //改 21+6+4+1
wire       op1_i_equal_op2_i;

assign     op1_i_equal_op2_i = (op_num1_i == op_num2_i)?1'b1:1'b0;


always @(*)begin
    jump_addr_o = 32'b0;
    jump_en_o   = 5'b0;
    hold_flag_o = 1'b0;
    rd_data_o = 32'b0;
    rd_addr_o = 5'b0;
    rd_wen_o  = 1'b0;
    case(opcode)
        `INST_TYPE_I: begin
            case(func3)
                `INST_ADDI: begin
                    rd_data_o = op_num1_i + op_num2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wen_o  = 1'b0;
                end
            endcase
        end
        
        `INST_TYPE_R_M: begin
            case(func3)
                `INST_ADD_SUB: begin
                    if(func7 == `FUNCT7_INST_A) begin//add
                        rd_data_o = op_num1_i + op_num2_i;
                        rd_addr_o = rd_addr_i;
                        rd_wen_o  = 1'b1;
                    end
                    else begin
                        rd_data_o = op_num2_i - op_num1_i;
                        rd_addr_o = rd_addr_i;
                        rd_wen_o  = 1'b1;
                    end
                end
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wen_o  = 1'b0;
                end
            endcase
        end
        
        `INST_TYPE_B: begin
            case(func3)
                `INST_BEQ: begin
                    jump_addr_o = (inst_addr_i + jump_imm) & {32{(op1_i_equal_op2_i)}};
                    jump_en_o   = op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end 
                `INST_BNE: begin
                    jump_addr_o = (inst_addr_i + jump_imm) & {32{(~op1_i_equal_op2_i)}};
                    jump_en_o   = ~op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end
                default:begin
                    jump_addr_o = 32'b0;
                    jump_en_o   = 1'b0;
                    hold_flag_o = 1'b0;
                end
            endcase
        end 
        
        `INST_JAL: begin
            rd_data_o   = inst_addr_i + 32'h4;
            rd_addr_o   = rd_addr_i  ;
            rd_wen_o    = 1'b1  ; 
            jump_addr_o = op_num1_i + inst_addr_i;
            jump_en_o   = 1'b1  ;
            hold_flag_o = 1'b0  ;
        end 
        
        `INST_LUI: begin
            rd_data_o   = op_num1_i     ;
            rd_addr_o   = rd_addr_i     ;
            rd_wen_o    = 1'b1          ;
            jump_addr_o = 32'b0         ;
            jump_en_o   = 1'b0          ;
            hold_flag_o = 1'b0          ;
        end 
        
        default: begin
            rd_data_o   = 32'b0 ;
            rd_addr_o   = 5'b0  ;
            rd_wen_o    = 1'b0  ; 
            jump_addr_o = 32'b0 ;
            jump_en_o   = 1'b0  ;
            hold_flag_o = 1'b0  ;
        end
    endcase
end

endmodule