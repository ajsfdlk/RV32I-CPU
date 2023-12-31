`include "define.v"
module main_control(
                    input[6:0] opcode,
                    input[2:0] func,
                    output mem_read,//主存读使能
                    output memtoreg,
                    output[1:0] alu_op,//发给alu控制器的命令
                    output mem_write,//主存写使能
                    output mux1,
                    output reg_write,//寄存器堆写使能
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
                    output[2:0] rm_type//主存的5种加载类型
                  );//除alu外的控制器
                  wire[6:0] type_w;
                  //从低到高b_type,r_type,i_type,u_type,load,store,auipc
                  assign type_w[0]=(opcode==`B_type)?1'b1:1'b0;
                  assign type_w[1]=(opcode==`R_type)?1'b1:1'b0;
                  assign type_w[2]=(opcode==`I_type)?1'b1:1'b0;
                  assign type_w[3]=(lui|type_w[6])?1'b1:1'b0;//存立即数
                  assign type_w[4]=(opcode==`load)?1'b1:1'b0;
                  assign type_w[5]=(opcode==`store)?1'b1:1'b0;
                  assign type_w[6]=(opcode==`auipc)?1'b1:1'b0;
                  
                  assign jal=(opcode==`jal)?1'b1:1'b0;
									assign jalr=(opcode==`jalr)?1'b1:1'b0;
									assign lui=(opcode==`lui)?1'b1:1'b0;
									assign beq= type_w[0] & (func==3'b000);
									assign bne= type_w[0] & (func==3'b001);
									assign blt= type_w[0] & (func==3'b100);
									assign bge= type_w[0] & (func==3'b101);
									assign bltu= type_w[0] & (func==3'b110);
									assign bgeu= type_w[0] & (func==3'b111);
                  assign rm_type=func;
                  
                  assign mem_read=type_w[4];//从存储器加载数据
                  assign mem_write=type_w[5];//存储数据
                  assign u_type=type_w[3];//存立即数
                  assign reg_write=(jal|jalr|type_w[1]|type_w[2]|type_w[3]|type_w[4])?1'b1:1'b0;
                  //所有需要存数据的取或
                  
                  assign mux1=jalr|type_w[5]|type_w[4]|type_w[2];
                  assign memtoreg=type_w[4];
                  assign alu_op[1]=type_w[0]|type_w[1];
                  assign alu_op[0]=type_w[2]|type_w[0];
                  // 01I型指令 10R型指令 11条件跳转(B) 00 R/I/B都不是，以b2处理
endmodule