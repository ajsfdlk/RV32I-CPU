`include "centrol_core.v"
`include "instr_mem.v"
`include "data_mem.v"

module chip(
             input clk,
             input reset
           );
           wire[7:0] ins_address;
           wire[31:0] instr;
           wire[31:0] RD_data;//主存输出数据
           wire[31:0] mem_datain;//主存输入数据
           wire w_enable;
           wire r_enable;
           wire[31:0] address;
           wire[2:0] rw_type;
           centrol_core centrol_core(
									                     .clk(clk),
									                     .reset(reset),
									                     .instr(instr),
									                     .RD_data(RD_data),
									                     .ins_address(ins_address),
									                     .mem_datain(mem_datain),
									                     .w_enable(w_enable),
									                     .r_enable(r_enable),
									                     .address(address),
									                     .rw_type(rw_type)
									                   );
					  data_mem data_mem(
								                 .clk(clk),
								                 .write_enable(w_enable),
								                 .read_enable(r_enable),
								                 .data_in(mem_datain),
								                 .address(address),
								                 .data_out(RD_data),
								                 .rw_type(rw_type)
								               );	
						instr_mem instr_mem(
                  .address(ins_address),
                  .instr(instr)
                );			                   
endmodule           