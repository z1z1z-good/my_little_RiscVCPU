module  rom(
    input   wire    [31:0]  inst_addr_i,
    
    output  reg     [31:0]  inst_o
);

 reg [31:0]  rom_mem [0:4095];

    initial begin
    $readmemh("D:/FPGA/my_prj/my_little_RiscVCPU/inst_txt/rv32ui-p-auipc.txt",rom_mem);
    end

always@(*)  begin
    inst_o = rom_mem[inst_addr_i>>2];
end

endmodule
