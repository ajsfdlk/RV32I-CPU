`include "main_control.v"
`include "alu_control.v"

module top_controller(
                       input[6:0] opcode,
                       input[2:0] func,
                       input func1,
                       output mem_read,
                       output memtoreg,
                       output memwrite,
                       output mux1,
                       output reg_write,
                       output lui,
                       output u_type,
                       output jal,
                       output jalr,
                       output beq,
                       output bne,
                       output blt,
                       output bge,
                       output bltu,
                       output bgeu,
                       output[2:0] rw_type,
                       output[3:0] alu_order
                     );
                     wire[1:0] alu_op;
                     main_control main_control(
							                    .opcode(opcode),
							                    .func(func),
							                    .mem_read(mem_read),//主存读使能
							                    .memtoreg(memtoreg),
							                    .alu_op(alu_op),//发给alu控制器的命令
							                    .mem_write(memwrite),//主存写使能
							                    .mux1(mux1),
							                    .reg_write(reg_write),//寄存器堆写使能
							                    .lui(lui),
							                    .u_type(u_type),
							                    .jal(jal),
							                    .jalr(jalr),
							                    .beq(beq),
							                    .bne(bne),
							                    .blt(blt),
							                    .bge(bge),
							                    .bltu(bltu),
							                    .bgeu(bgeu),
							                    .rm_type(rw_type)//主存的5种加载类型
							                  );
							          alu_control alu_control(
									                    .alu_op(alu_op),
// 01I型指令 10R型指令 11条件跳转(B) 00 R/I/B都不是，以加法处理
									                    .func(func),
									                    .func1(func1),//SRAI的为1 SLLI的为0
									                    .alu_order(alu_order)
									                  );
endmodule