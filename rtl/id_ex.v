module  id_ex(
    input   wire    clk,
    input   wire    rst,
    
    input   wire    [31:0]  inst_i,
    input   wire    [31:0]  inst_addr_i,
    
    input   wire    [31:0]  op_num1_i,
    input   wire    [31:0]  op_num2_i,
    input   wire    [4:0]   rd_addr_i,
    input   wire            reg_wen_i,


    output  wire    [31:0]  inst_o,
    output  wire    [31:0]  inst_addr_o,

    output  wire    [31:0]  op_num1_o,
    output  wire    [31:0]  op_num2_o,
    output  wire    [4:0]   rd_addr_o,
    output  wire            reg_wen_o
);

PipeReg #(32)  dff1(clk,rst,32'h00000013,inst_i,inst_o);
PipeReg #(32)  dff2(clk,rst,32'b0,inst_addr_i,inst_addr_o);

PipeReg #(32)  dff3(clk,rst,32'b0,op_num1_i,op_num1_o);
PipeReg #(32)  dff4(clk,rst,32'b0,op_num2_i,op_num2_o);
PipeReg #(32)  dff5(clk,rst,5'b0,rd_addr_i,rd_addr_o);
PipeReg #(32)  dff6(clk,rst,1'b0,reg_wen_i,reg_wen_o);

endmodule