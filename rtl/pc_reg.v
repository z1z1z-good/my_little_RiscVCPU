module  pc_reg(
    input   wire        clk,
    input   wire        rst,

    output  reg [31:0]  pc_addr_o
);

always@(posedge clk)  begin
    if(rst == 1'b0)
        pc_addr_o <= 32'b0;
    else
        pc_addr_o <= pc_addr_o + 3'd4;
end

endmodule