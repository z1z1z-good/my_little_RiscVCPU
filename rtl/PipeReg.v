module  PipeReg #(
    parameter   DataWidth = 32
)
(
    input   wire                    clk,
    input   wire                    rst,
    input   wire    [DataWidth-1:0] default_data,
    input   wire    [DataWidth-1:0] data_i,
    input   wire                    hold_flag_i,
    
    output  reg     [DataWidth-1:0]  data_o//注意时序逻辑赋值要为reg型
);

always@(posedge clk) begin
    if(rst == 1'b0 || hold_flag_i == 1'b1)
        data_o <= default_data;
    else
        data_o <= data_i;
end

endmodule

//DFF函数例化模板
//PipeReg #(32)  dff1(clk,rst,default_data,data_i,data_o);