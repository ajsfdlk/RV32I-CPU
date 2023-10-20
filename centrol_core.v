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
											                  .memtoreg(memtoreg),// ѡ��alu_result��RD_data
											                  .mux1(mux1),
											                  .reg_write(reg_write),
											                  .lui(lui),//luiָ��
											                  .U_type(U_type),//U��ָ��
											                  .beq(beq),//8����ת����
											                  .bne(bne),
											                  .blt(blt),
											                  .bge(bge),
											                  .bltu(bltu),
											                  .bgeu(bgeu),
											                  .jal(jal),
											                  .jalr(jalr),
											                  .alu_order(alu_order),
											                  .RD_data(RD_data),//�����������
											                  
											                  .ins_address(ins_address),
											                  .mem_datain(mem_datain),//������������
											                  .alu_result(address),
											                  .opcode(opcode),
											                  .func(func),//ALU����ģʽ
											                  .func1(func1)//������������
											                );//gpr��alu���ڲ�����
						                
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