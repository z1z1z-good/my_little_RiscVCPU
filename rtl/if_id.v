`include "defines.v"
module  if_id(
    input   wire    clk,
    input   wire    rst,
    
    input   wire    hold_flag_i,
    
    input   wire    [31:0]  inst_addr_i,
    input   wire    [31:0]  inst_i,
    
    output  wire    [31:0]  inst_addr_o,
    output  wire    [31:0]  inst_o
);

reg rom_flag;

always @(posedge clk) begin//检查这里打一拍的时序，疑似是补充指令的暂停
    if(!rst | hold_flag_i)
        rom_flag <= 1'b0;
    else
        rom_flag <= 1'b1;
end

assign inst_o = rom_flag ? inst_i : `INST_NOP;

//经过rom读指令已经让指令数据打了一拍了
//PipeReg #(32)  dff2(clk,rst,hold_flag_i,`INST_NOP,inst_i,inst_o);
PipeReg #(32)  dff1(clk,rst,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);


endmodule