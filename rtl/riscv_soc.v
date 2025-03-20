module riscv_soc(
    input  wire           clk,
    input  wire           rst
);


    // open_risc_v to rom 
    wire[31:0] riscv_inst_addr_o;
    
    //rom to open_risc_v
    wire[31:0] rom_inst_o;
    
    riscv riscv_inst(
    .clk            (clk), 
    .rst            (rst),
    .inst_i         (rom_inst_o),
    .inst_addr_o    (riscv_inst_addr_o)
    );


	rom rom_inst(
	.inst_addr_i    (riscv_inst_addr_o),
	.inst_o         (rom_inst_o)
);


endmodule