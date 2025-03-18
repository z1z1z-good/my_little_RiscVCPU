module  if_id(
    input   wire    clk,
    input   wire    rst,
    
    input   wire    [31:0]  rom_inst_addr_i,
    input   wire    [31:0]  inst_i,
    
    output  wire    [31:0]  rom_inst_addr_o,
    output  wire    [31:0]  inst_o
);

PipeReg #(32)  dff1(clk,rst,32'b0,rom_inst_addr_i,rom_inst_addr_o);
PipeReg #(32)  dff2(clk,rst,32'h00000013,inst_i,inst_o);

endmodule