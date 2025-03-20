module  ifetch(
    input   wire    [31:0]  pc_addr_i,
    input   wire    [31:0]  rom_inst_i,

    output  wire    [31:0]  if2rom_addr_o,
    output  wire    [31:0]  rom_addr_o,
    output  wire    [31:0]  inst_o
);

assign  rom_addr_o = pc_addr_i;
assign  inst_o = rom_inst_i;
assign  if2rom_addr_o = pc_addr_i;

endmodule