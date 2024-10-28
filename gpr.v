//2023.10.1
`include "define.v"
module gpr(
            input reg_write,//写使能
            input clk,
            input reset,
            input[31:0] data_write,
            input[4:0] rd,
            input[4:0] rs1,
            input[4:0] rs2,
            output[31:0] read_data1,
            output[31:0] read_data2
          );
          wire inside_clk;
          assign inside_clk=(reset)?1'b0:clk;
		      reg[31:0] data_main[31:0];
		      always@(posedge inside_clk)
		      begin
		      		if(reg_write)
		      				data_main[rd]<=data_write;
		      		
		      end
		      	

		      assign read_data1=(rs1)?data_main[rs1]:`zero_word;//寄存器0的值为0
		      assign read_data2=(rs2)?data_main[rs2]:`zero_word;
endmodule