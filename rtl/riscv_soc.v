module riscv_soc(
    input  wire           clk,
    input  wire           rst
);


//riscv to rom 
wire    [31:0]  riscv_inst_addr_o;

//rom to riscv
wire    [31:0]  rom_inst_o;

//riscv to ram 
wire    [31:0]  riscv_mem_rd_addr_o;
wire    [31:0]  riscv_mem_wr_addr_o;
wire    [31:0]  riscv_mem_wr_data_o;
wire    [3:0]   riscv_mem_wr_sel_o;
wire            riscv_mem_rd_req_o;
wire            riscv_mem_wr_req_o;

//ram to riscv 
wire    [31:0]  ram_data_o;


riscv riscv_inst(
    .clk            (clk), 
    .rst            (rst),
    .inst_i         (rom_inst_o),
    .inst_addr_o    (riscv_inst_addr_o),
    
    .mem_rd_data_i  (ram_data_o),
    .mem_rd_req_o   (riscv_mem_rd_req_o),
    .mem_rd_addr_o  (riscv_mem_rd_addr_o),

    .mem_wr_req_o   (riscv_mem_wr_req_o),
    .mem_wr_sel_o   (riscv_mem_wr_sel_o),
    .mem_wr_addr_o  (riscv_mem_wr_addr_o),
    .mem_wr_data_o  (riscv_mem_wr_data_o)

);

rom rom_inst(
    .clk        (clk),
    .rst        (rst),

    .wen        (1'b0),
    .w_addr_i   (32'b0),
    .w_data_i   (32'b0),

    .ren        (1'b1),
    .r_addr_i   (riscv_inst_addr_o),
    .r_data_o   (rom_inst_o)
);

ram ram_inst(
    .clk        (clk),
    .rst        (rst),

    .ren        (riscv_mem_rd_req_o),
    .r_addr_i   (riscv_mem_rd_addr_o),
    .r_data_o   (ram_data_o),
    
    .wen        (riscv_mem_wr_sel_o),
    .w_addr_i   (riscv_mem_wr_addr_o),
    .w_data_i   (riscv_mem_wr_data_o)
);

endmodule