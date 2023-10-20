`include "pc.v"
`include "decode.v"
`include "gpr.v"
`include "ALU.v"

module main_part(
                  input clk,
                  input reset,
                  input[31:0] instr,
                  input memtoreg,// ѡ��alu_result��RD_data
                  input mux1,
                  input reg_write,
                  input lui,//luiָ��
                  input U_type,//U��ָ��
                  input beq,//8����ת����
                  input bne,
                  input blt,
                  input bge,
                  input bltu,
                  input bgeu,
                  input jal,
                  input jalr,
                  input[3:0] alu_order,
                  input[31:0] RD_data,//�����������
                  
                  output[7:0] ins_address,
                  output[31:0] mem_datain,//������������
                  output[31:0] alu_result,
                  output[6:0] opcode,
                  output[2:0] func,//ALU����ģʽ
                  output func1//������������
                );//gpr��alu���ڲ�����
                
                wire   [31:0]pc_in;
	              wire [31:0]pc_out;
	              assign ins_address=pc_out[9:2];
	              pc pc(.clk(clk),
	                    .reset(reset),
	                    .addr(pc_in),
	                    .addr1(pc_out));//pc�Ĵ���
	                    
	              wire [4:0]rs1;
	              wire [4:0]rs2;
								wire [4:0]rd;
								wire [31:0]imm;
								decode decode(
					               .ins(instr),
					               .imm(imm),//ÿ��ģʽ��������
					               .rs1(rs1),
					               .rs2(rs2),
					               .rd(rd),
					               .op(opcode),//ǰ7λ������
					               .func(func),//ALUģʽ
					               .func1(func1)//������������
					             );//������
					             
					      wire [31:0] wr_reg_data;
	              wire [31:0] rd_data1;
	              wire [31:0] rd_data2;
	              assign mem_datain=rd_data2;
								gpr gpr(
					            .reg_write(reg_write),//дʹ��
					            .clk(clk),
					            .reset(reset),
					            .data_write(wr_reg_data),//д�������
					            .rd(rd),
					            .rs1(rs1),
					            .rs2(rs2),
					            .read_data1(rd_data1),
					            .read_data2(rd_data2)
					          );//ͨ�üĴ�����
					      
					      wire[31:0] mux1_out;    
					      mux mux1_a(
					            .data1(imm),
					            .data2(rd_data2),
					            .sel(mux1),
					            .data_out(mux1_out)
					          );
                
                wire zero_wire;
                alu alu(
					           .d1(rd_data1),
					           .d2(mux1_out),
					           .alu_order(alu_order),
					           .result(alu_result),
					           .zero_wire(zero_wire)
					          );
					          
					      wire jump_flag;
					      judge judge(
					              .beq(beq),
					              .bne(bne),
					              .blt(blt),
					              .bge(bge),
					              .bltu(bltu),
					              .bgeu(bgeu),
					              .jal(jal),
					              .jalr(jalr),
					              .zero_wire(zero_wire),
					              .result(alu_result),
					              .jump_flag(jump_flag)
					            );
					       
					       wire[31:0] wb_data;
					       mux reg_and_dm_mux(
					                           .data1(RD_data),
													           .data2(alu_result),
													           .sel(memtoreg),
													           .data_out(wb_data)
					                         );
					        
					        wire sel;
					        wire[31:0] pc_order;
					        wire[31:0] w_r_d2;
					        wire[31:0] w_r_d1;
					        assign sel=jal|jalr;
					        mux jal_mux(
					                     .data1(pc_order),
													     .data2(wb_data),
													     .sel(sel),
													     .data_out(w_r_d2)
					                   );
					        
					                   
					         wire[31:0] pc_jump;
					         wire[31:0] pc_jump_order;
					         wire[31:0] pc_jalr;
					         assign pc_jalr={alu_result[31:1],1'b0};//set����
					         mux jump_mux(
					                       .data1(pc_jump),
													       .data2(pc_order),
													       .sel(jump_flag),
													       .data_out(pc_jump_order)
					                     );
					         mux pc_in_mux(
					                        .data1(pc_jalr),
													        .data2(pc_jump_order),
													        .sel(jalr),
													        .data_out(pc_in)
					                      );//����pc�����벿��
					         
					         mux lui_mux(
					                      .data1(imm),
													      .data2(pc_jump),
													      .sel(lui),
													      .data_out(w_r_d1)
					                    );
					         mux u_type_mux(
					                         .data1(w_r_d1),
					                         .data2(w_r_d2),
					                         .sel(U_type),
					                         .data_out(wr_reg_data)
					                       );//����gpr�����벿��
					         
					         adder_32 pc_adder_4(
					                            .cin(1'd0),
																	    .data1(pc_out), 
																	    .data2(32'd4),  
																	    .data_out(pc_order), 
																	    .cout(),
																	    .is_zero()
																	    );
									 adder_32 pc_adder_imme(
									                       .cin(1'd0),
																		     .data1(pc_out), 
																		     .data2(imm),  
																		     .data_out(pc_jump),
																		     .cout(), 
																		     .is_zero()
									                       );
endmodule