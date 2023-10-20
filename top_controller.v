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
							                    .mem_read(mem_read),//�����ʹ��
							                    .memtoreg(memtoreg),
							                    .alu_op(alu_op),//����alu������������
							                    .mem_write(memwrite),//����дʹ��
							                    .mux1(mux1),
							                    .reg_write(reg_write),//�Ĵ�����дʹ��
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
							                    .rm_type(rw_type)//�����5�ּ�������
							                  );
							          alu_control alu_control(
									                    .alu_op(alu_op),
// 01I��ָ�� 10R��ָ�� 11������ת(B) 00 R/I/B�����ǣ��Լӷ�����
									                    .func(func),
									                    .func1(func1),//SRAI��Ϊ1 SLLI��Ϊ0
									                    .alu_order(alu_order)
									                  );
endmodule