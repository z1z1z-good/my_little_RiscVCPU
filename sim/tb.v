module tb;

wire    wen;
wire    ren;
wire    [31:0]  w_addr_i;
wire    [31:0]  w_data_i;
assign  wen                 = 1'b0;
assign  ren                 = 1'b1;
assign  w_addr_i            = 32'b0;
assign  w_data_i            = 32'b0;

    reg clk;
    reg rst;
    
    wire x3 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[3];
    wire x26 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[26];
    wire x27 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[27];
    
    
    always #10 clk = ~clk;
    
initial begin
    $readmemh("D:/FPGA/my_prj/my_little_RiscVCPU/inst_txt/rv32ui-p-sh.txt",tb.riscv_soc_inst.rom_inst.rom_32bit.dual_ram_template_isnt.memory);
end

    initial begin
        clk <= 1'b1;
        rst <= 1'b0;
        #30;
        rst <= 1'b1;
    end
    integer r;
    initial begin
    
        wait(x26 == 32'b1);
        
        #200;
        if(x27 == 32'b1) begin
            $display("############################");
            $display("########  pass  !!!#########");
            $display("############################");
        end
        else begin
            $display("############################");
            $display("########  fail  !!!#########");
            $display("############################");
            $display("fail testnum = %2d", x3);
            for(r = 0;r < 31; r = r + 1)begin
                $display("x%2d register value is %d",r,tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
            end
        end
    end
    
    riscv_soc riscv_soc_inst(
        .clk        (clk),
        .rst        (rst),
        
        .wen                 (wen),
        .ren                 (ren),
        .w_addr_i            (w_addr_i),
        .w_data_i            (w_data_i),
        .riscv_mem_wr_req_o  (riscv_mem_wr_req_o)
    );

endmodule