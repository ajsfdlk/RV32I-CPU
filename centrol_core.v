`include "top_controller.v"
`include "main_part.v"
module centrol_core(
                     input clk,
                     input reset,
                     input[31:0] instr,
                     input[31:0] RD_data,
                     output[7:0] ins_address,
                     output[31:0] mem_datain,
                     output w_enable,
                     output r_enable,
                     output[31:0] address,
                     output[2:0] rw_type
                   );
                   wire[6:0] opcode;
					wire[2:0] func;
					wire func1;
					wire memtoreg;
					wire mux1;
					wire reg_write;
					wire lui;
					wire U_type;
					wire jal;
					wire jalr;
					wire beq;
					wire bne;
					wire blt;
					wire bge;
					wire bltu;
					wire bgeu;
					wire[3:0] alu_order;
					main_part main_part(
											.clk(clk),
											.reset(reset),
											.instr(instr),
											.memtoreg(memtoreg),// 选择alu_result和RD_data
											.mux1(mux1),
											.reg_write(reg_write),
											.lui(lui),//lui指令
											.U_type(U_type),//U型指令
											.beq(beq),//8种跳转条件
											.bne(bne),
											.blt(blt),
											.bge(bge),
											.bltu(bltu),
											.bgeu(bgeu),
											.jal(jal),
											.jalr(jalr),
											.alu_order(alu_order),
											.RD_data(RD_data),//主存输出数据
											
											.ins_address(ins_address),
											.mem_datain(mem_datain),//主存输入数据
											.alu_result(address),
											.opcode(opcode),
											.func(func),//ALU操作模式
											.func1(func1)//减、算术右移
										);//gpr、alu与内部总线
					
			top_controller top_controller(
														.opcode(opcode),
														.func(func),
														.func1(func1),
														.mem_read(r_enable),
														.memtoreg(memtoreg),
														.memwrite(w_enable),
														.mux1(mux1),
														.reg_write(reg_write),
														.lui(lui),
														.u_type(U_type),
														.jal(jal),
														.jalr(jalr),
														.beq(beq),
														.bne(bne),
														.blt(blt),
														.bge(bge),
														.bltu(bltu),
														.bgeu(bgeu),
														.rw_type(rw_type),
														.alu_order(alu_order)
														); 
endmodule