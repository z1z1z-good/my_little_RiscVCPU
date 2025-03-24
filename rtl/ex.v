`include "defines.v"

module ex(
    input   wire    [31:0]  inst_i      ,
    input   wire    [31:0]  inst_addr_i ,

    input   wire    [31:0]  op_num1_i   ,
    input   wire    [31:0]  op_num2_i   ,
    input   wire    [4:0]   rd_addr_i   ,
    input   wire            rd_wen_i    ,
    
    input   wire    [31:0]  base_addr_i ,
    input   wire    [31:0]  addr_offset_i,
    
    output  reg     [4:0]   rd_addr_o   ,
    output  reg     [31:0]  rd_data_o   ,
    output  reg             rd_wen_o    ,
    
    output  reg     [31:0]  jump_addr_o ,
    output  reg             jump_en_o   ,
    output  reg             hold_flag_o,
    
    input   wire    [31:0]  mem_rd_data_i,
    
    output  reg             mem_wr_req_o,
    output  reg     [3:0]   mem_wr_sel_o,
    output  reg     [31:0]  mem_wr_addr_o,
    output  reg     [31:0]  mem_wr_data_o
);

wire    [6:0]   opcode; 
//wire    [4:0]   rd; 
wire    [2:0]   func3; 
//wire    [4:0]   rs1;
//wire    [4:0]   rs2;
wire    [6:0]   func7;  
//wire    [11:0]  imm;
//wire    [4:0]   shamt;

assign opcode = inst_i[6:0];
//assign rd 	  = inst_i[11:7];
assign func3  = inst_i[14:12];
//assign rs1 	  = inst_i[19:15];
//assign rs2 	  = inst_i[24:20];
assign func7  = inst_i[31:25];
//assign imm    = inst_i[31:20];
//assign shamt  = inst_i[24:20];

//wire    [31:0]  jump_imm = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0}; //改 21+6+4+1
wire            op1_i_equal_op2_i;
wire            op1_i_less_op2_i_signed;
wire            op1_i_less_op2_i_unsigned;

assign  op1_i_less_op2_i_signed = ($signed(op_num1_i) < $signed(op_num2_i))?1'b1:1'b0;
assign  op1_i_less_op2_i_unsigned = (op_num1_i < op_num2_i)?1'b1:1'b0;
assign  op1_i_equal_op2_i = (op_num1_i == op_num2_i)?1'b1:1'b0;

wire    [31:0]  op1_i_add_op2_i;
wire    [31:0]  op1_i_and_op2_i;
wire    [31:0]  op1_i_xor_op2_i;
wire    [31:0]  op1_i_or_op2_i;
wire    [31:0]  op1_i_shift_left_op2_i;
wire    [31:0]  op1_i_shift_right_op2_i;
wire    [31:0]  base_addr_add_addr_offset;

assign  op1_i_add_op2_i             = op_num1_i + op_num2_i;
assign  op1_i_and_op2_i             = op_num1_i & op_num2_i;
assign  op1_i_xor_op2_i             = op_num1_i ^ op_num2_i;
assign  op1_i_or_op2_i              = op_num1_i | op_num2_i;
assign  op1_i_shift_left_op2_i      = op_num1_i << op_num2_i;
assign  op1_i_shift_right_op2_i     = op_num1_i >> op_num2_i;
assign  base_addr_add_addr_offset   = base_addr_i + addr_offset_i;

wire    [31:0]  SRA_mask;
assign  SRA_mask = (32'hffff_ffff) >> op_num2_i[4:0];

wire    [1:0]   store_index = base_addr_add_addr_offset[1:0];
wire    [1:0]   load_index  = base_addr_add_addr_offset[1:0];

always @(*)begin
    jump_addr_o     = 32'b0;
    jump_en_o       = 1'b0;
    hold_flag_o     = 1'b0;
    rd_data_o       = 32'b0;
    rd_addr_o       = 5'b0;
    rd_wen_o        = 1'b0;
    mem_wr_req_o     = 1'b0;
    mem_wr_sel_o     = 4'b0;
    mem_wr_addr_o    = 32'b0;
    mem_wr_data_o    = 32'b0;
    case(opcode)
        //-----------------------------------TYPE_I--------------------------------------
        `INST_TYPE_I: begin
            case(func3)
                `INST_ADDI: begin//加立即数
                    rd_data_o = op1_i_add_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SLTI: begin//小于立即数
                    rd_data_o = {30'b0,op1_i_less_op2_i_signed};
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SLTIU: begin//小于立即数(无符号)
                    rd_data_o = {30'b0,op1_i_less_op2_i_unsigned};
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_XORI: begin//异或
                    rd_data_o = op1_i_xor_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_ORI: begin//或
                    rd_data_o = op1_i_or_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_ANDI: begin//与
                    rd_data_o = op1_i_and_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SLLI: begin//逻辑左移
                    rd_data_o = op1_i_shift_left_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SRLI_SRAI: begin
                    case(func7)
                        `FUNCT7_INST_SRLI:begin//逻辑右移
                            rd_data_o = op1_i_shift_right_op2_i;
                            rd_addr_o = rd_addr_i;
                            rd_wen_o  = 1'b1;
                        end 
                        `FUNCT7_INST_SRAI:begin//算术右移
                            rd_data_o = ((op1_i_shift_right_op2_i) & SRA_mask) | ({32{op_num1_i[31]}} & (~SRA_mask));
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
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wen_o  = 1'b0;
                end
            endcase
        end
        //---------------------------------TYPE_R_M----------------------------------
        `INST_TYPE_R_M: begin//R型和I型相同部分存在面积的优化空间
            case(func3)
                `INST_ADD_SUB: begin
                    case(func7)
                        `FUNCT7_INST_ADD:begin
                            rd_data_o = op1_i_add_op2_i;
                            rd_addr_o = rd_addr_i;
                            rd_wen_o  = 1'b1;
                        end 
                        `FUNCT7_INST_SUB:begin
                            rd_data_o = op_num1_i - op_num2_i;
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
                `INST_SLL: begin//
                    rd_data_o = op1_i_shift_left_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SLT: begin//
                    rd_data_o = {30'b0,op1_i_less_op2_i_signed};
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SLTU: begin//
                    rd_data_o = {30'b0,op1_i_less_op2_i_unsigned};
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_XOR: begin//
                    rd_data_o = op1_i_xor_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_OR: begin//
                    rd_data_o = op1_i_or_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_AND: begin//
                    rd_data_o = op1_i_and_op2_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end
                `INST_SRL_SRA: begin//
                    case(func7)
                        `FUNCT7_INST_SRL:begin
                            rd_data_o = op1_i_shift_right_op2_i;
                            rd_addr_o = rd_addr_i;
                            rd_wen_o  = 1'b1;
                        end 
                        `FUNCT7_INST_SRA:begin
                            rd_data_o = ((op1_i_shift_right_op2_i) & SRA_mask) | ({32{op_num1_i[31]}} & (~SRA_mask));
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
                default:begin
                    rd_data_o = 32'b0;
                    rd_addr_o = 5'b0;
                    rd_wen_o  = 1'b0;
                end
            endcase
        end
        //------------------------------------TYPE_B-----------------------------------
        `INST_TYPE_B: begin
            case(func3)
                `INST_BEQ: begin
                    jump_addr_o = (base_addr_add_addr_offset); //& {32{(op1_i_equal_op2_i)}};有使能信号，不需要
                    jump_en_o   = op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end 
                `INST_BNE: begin
                    jump_addr_o = (base_addr_add_addr_offset);
                    jump_en_o   = ~op1_i_equal_op2_i;
                    hold_flag_o = 1'b0;
                end
                `INST_BLT: begin
                    jump_addr_o = (base_addr_add_addr_offset);
                    jump_en_o   = op1_i_less_op2_i_signed;
                    hold_flag_o = 1'b0;
                end
                `INST_BGE: begin
                    jump_addr_o = (base_addr_add_addr_offset);
                    jump_en_o   = ~op1_i_less_op2_i_signed;
                    hold_flag_o = 1'b0;
                end
                `INST_BLTU: begin
                    jump_addr_o = (base_addr_add_addr_offset);
                    jump_en_o   = op1_i_less_op2_i_unsigned;
                    hold_flag_o = 1'b0;
                end
                `INST_BGEU: begin
                    jump_addr_o = (base_addr_add_addr_offset);
                    jump_en_o   = ~op1_i_less_op2_i_unsigned;
                    hold_flag_o = 1'b0;
                end
                default:begin
                    jump_addr_o = 32'b0;
                    jump_en_o   = 1'b0;
                    hold_flag_o = 1'b0;
                end
            endcase
        end 
        //------------------------------------TYPE_L-----------------------------------
        `INST_TYPE_L:begin
            case(func3)
                `INST_LB:begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                    case(load_index)
                        2'b00:begin//小端模式，低字节放低地址
                            rd_data_o = {{24{mem_rd_data_i[7]}},mem_rd_data_i[7:0]};
                        end 
                        2'b01:begin
                            rd_data_o = {{24{mem_rd_data_i[15]}},mem_rd_data_i[15:8]};
                        end 
                        2'b10:begin
                            rd_data_o = {{24{mem_rd_data_i[23]}},mem_rd_data_i[23:16]};
                        end 
                        2'b11:begin
                            rd_data_o = {{24{mem_rd_data_i[31]}},mem_rd_data_i[31:24]};
                        end 
                        default:begin
                            rd_data_o = 32'b0;
                        end 
                    endcase
                end 
                `INST_LH:begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                    case(load_index[1])
                        1'b0:begin//小端模式，低字节放低地址
                            rd_data_o = {{16{mem_rd_data_i[15]}},mem_rd_data_i[15:0]};
                        end 
                        1'b1:begin
                            rd_data_o = {{16{mem_rd_data_i[31]}},mem_rd_data_i[31:16]};
                        end 
                        default:begin
                            rd_data_o = 32'b0;
                        end 
                    endcase
                end 
                `INST_LW:begin
                    rd_data_o = mem_rd_data_i;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                end 
                `INST_LBU:begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                    case(load_index)
                        2'b00:begin
                            rd_data_o = {24'b0,mem_rd_data_i[7:0]};
                        end 
                        2'b01:begin
                            rd_data_o = {24'b0,mem_rd_data_i[15:8]};
                        end 
                        2'b10:begin
                            rd_data_o = {24'b0,mem_rd_data_i[23:16]};
                        end 
                        2'b11:begin
                            rd_data_o = {24'b0,mem_rd_data_i[31:24]};
                        end 
                        default:begin
                            rd_data_o = 32'b0;
                        end 
                    endcase
                end 
                `INST_LHU:begin
                    rd_addr_o = rd_addr_i;
                    rd_wen_o  = 1'b1;
                    case(load_index[1]) //二字节对齐 所以是第 1 位,第零位默认为0的，其实这里要做处理，
                        1'b0:begin      //如果发现最低为不为零要进行硬件报异常(说明你程序员的代码没有二字节对齐，16位对齐)
                            rd_data_o = {16'b0,mem_rd_data_i[15:0]};
                        end 
                        1'b1:begin
                            rd_data_o = {16'b0,mem_rd_data_i[31:16]};
                        end 
                        default:begin
                            rd_data_o = 32'b0;
                        end 
                    endcase
                end 
                default:begin
                    mem_wr_req_o  = 1'b0;
                    mem_wr_sel_o  = 4'b0;
                    mem_wr_addr_o = 32'b0;
                    mem_wr_data_o = 32'b0;
                end
            endcase
        end 
        //------------------------------------TYPE_S-----------------------------------
        `INST_TYPE_S:begin
            case(func3)
                `INST_SB:begin
                    mem_wr_req_o  = 1'b1;
                    mem_wr_addr_o = base_addr_add_addr_offset;
                    case(store_index)
                        2'b00:begin
                            rd_data_o = {24'b0,op_num2_i[7:0]};
                            mem_wr_sel_o  = 4'b0001;
                        end 
                        2'b01:begin
                            rd_data_o = {16'b0,op_num2_i[7:0],8'b0};
                            mem_wr_sel_o  = 4'b0010;
                        end 
                        2'b10:begin
                            rd_data_o = {8'b0,op_num2_i[7:0],16'b0};
                            mem_wr_sel_o  = 4'b0100;
                        end 
                        2'b11:begin
                            rd_data_o = {op_num2_i[7:0],24'b0};
                            mem_wr_sel_o  = 4'b1000;
                        end 
                        default:begin
                            mem_wr_data_o = 32'b0;
                            mem_wr_sel_o  = 4'b0000;
                        end 
                    endcase
                end 
                `INST_SH:begin
                    mem_wr_req_o  = 1'b1;
                    mem_wr_addr_o = base_addr_add_addr_offset;
                    case(store_index[1])
                        1'b0:begin//小端模式，低字节放低地址
                            mem_wr_data_o = {16'b0,op_num2_i[15:0]};
                            mem_wr_sel_o  = 4'b0011;
                        end 
                        1'b1:begin
                            mem_wr_data_o = {op_num2_i[15:0],16'b0};
                            mem_wr_sel_o  = 4'b1100;
                        end 
                        default:begin
                            mem_wr_data_o = 32'b0;
                            mem_wr_sel_o  = 4'b0000;
                        end 
                    endcase
                end 
                `INST_SW:begin
                    mem_wr_req_o  = 1'b1;
                    mem_wr_sel_o  = 4'b1111;
                    mem_wr_addr_o = base_addr_add_addr_offset;
                    mem_wr_data_o = op_num2_i;
                end 
                default:begin
                    mem_wr_req_o  = 1'b0;
                    mem_wr_sel_o  = 4'b0;
                    mem_wr_addr_o = 32'b0;
                    mem_wr_data_o = 32'b0;
                end
            endcase
        end 
        //------------------------------------TYPE_J-----------------------------------
        `INST_JAL: begin
            rd_data_o   = op1_i_add_op2_i;
            rd_addr_o   = rd_addr_i  ;
            rd_wen_o    = 1'b1  ; 
            jump_addr_o = base_addr_add_addr_offset;
            jump_en_o   = 1'b1  ;
            hold_flag_o = 1'b0  ;
        end 
        `INST_JALR: begin
            rd_data_o   = op1_i_add_op2_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
            jump_addr_o = base_addr_add_addr_offset;
            jump_en_o   = 1'b1;
            hold_flag_o = 1'b0;
        end 
        //------------------------------------TYPE_U-----------------------------------
        `INST_LUI: begin
            rd_data_o   = op_num1_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
        end 
        `INST_AUIPC: begin
            rd_data_o   = op1_i_add_op2_i;
            rd_addr_o   = rd_addr_i;
            rd_wen_o    = 1'b1;
        end 
        
        default: begin
            jump_addr_o     = 32'b0;
            jump_en_o       = 1'b0;
            hold_flag_o     = 1'b0;
            rd_data_o       = 32'b0;
            rd_addr_o       = 5'b0;
            rd_wen_o        = 1'b0;
            mem_wr_req_o     = 1'b0;
            mem_wr_sel_o     = 4'b0;
            mem_wr_addr_o    = 32'b0;
            mem_wr_data_o    = 32'b0;
        end
    endcase
end

endmodule