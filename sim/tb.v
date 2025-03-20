module tb;

	reg clk;
	reg rst;
	
	wire x3 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[3];
	wire x26 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[26];
	wire x27 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[27];
	
	
	always #10 clk = ~clk;
	
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
		.clk   		(clk),
		.rst 		(rst)
	);


	
endmodule