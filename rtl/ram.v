module  ram(
    input   wire            clk,
    input   wire            rst,
    
    input   wire    [3:0]   wen,
    input   wire    [31: 0] w_addr_i,
    input   wire    [31: 0] w_data_i,
    input   wire            ren,
    input   wire    [31: 0] r_addr_i,
    output  wire    [31: 0] r_data_o
);
wire    [11:0]  w_addr = w_addr_i[13:2];
wire    [11:0]  r_addr = r_addr_i[13:2];

dual_ram #(
    .DW(8),
    .AW(12),
    .MEM_NUM(4096)
)
rom_byte_0
(
.clk        (clk),
.rst        (rst),
.wen        (wen[0]),
.w_addr_i   (w_addr),
.w_data_i   (w_data_i[7:0]),
.ren        (ren),
.r_addr_i   (r_addr),

.r_data_o   (r_data_o[7:0])
); 

dual_ram #(
    .DW(8),
    .AW(12),
    .MEM_NUM(4096)
)
rom_byte_1
(
.clk        (clk),
.rst        (rst),
.wen        (wen[1]),
.w_addr_i   (w_addr),
.w_data_i   (w_data_i[15:8]),
.ren        (ren),
.r_addr_i   (r_addr),

.r_data_o   (r_data_o[15:8])
); 

dual_ram #(
    .DW(8),
    .AW(12),
    .MEM_NUM(4096)
)
rom_byte_2
(
.clk        (clk),
.rst        (rst),
.wen        (wen[2]),
.w_addr_i   (w_addr),
.w_data_i   (w_data_i[23:16]),
.ren        (ren),
.r_addr_i   (r_addr),

.r_data_o   (r_data_o[23:16])
); 

dual_ram #(
    .DW(8),
    .AW(12),
    .MEM_NUM(4096)
)
rom_byte_3
(
.clk        (clk),
.rst        (rst),
.wen        (wen[3]),
.w_addr_i   (w_addr),
.w_data_i   (w_data_i[31:24]),
.ren        (ren),
.r_addr_i   (r_addr),

.r_data_o   (r_data_o[31:24])
); 
endmodule