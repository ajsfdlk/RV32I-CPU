//2023.10.1
`include "define.v"
module decode(
               input[31:0] ins,
               output[31:0] imm,//每个模式的立即数
               output[4:0] rs1,
               output[4:0] rs2,
               output[4:0] rd,
               output[6:0] op,//前7位操作数
               output[2:0] func,//ALU模式（也就是中间三位的模式选择）
               output func1//减、算术右移
             );
             assign func1=ins[30];
             assign op=ins[6:0];
             assign func=ins[14:12];
             assign rs1=ins[19:15];
             assign rs2=ins[24:20];
             assign rd=ins[11:7];
             imm_count imm_count(.ins(ins),.imm(imm));
endmodule


module imm_count(
                input[31:0] ins,
                output[31:0] imm
                );//计算立即数
                wire[6:0] op;
                wire[4:0] mod;//5种立即数的处理模式
                wire[31:0] imm_i,imm_u,imm_j,imm_b,imm_s;
                assign op=ins[6:0];
                assign mod[0]=(op==`jalr)|(op==`load)|(op==`I_type);//I_type：立即数运算
                assign mod[1]=(op==`lui)|(op==`auipc);//imm[31:12],低位补0
                assign mod[2]=(op==`jal);
                assign mod[3]=(op==`B_type);
                assign mod[4]=(op==`store);
                assign imm_i={{20{ins[31]}},ins[31:20]}; 
                assign imm_u={ins[31:12],{12{1'b0}}};
                assign imm_j={{12{ins[31]}},ins[19:12],ins[20],ins[30:21],1'b0};//j型和b型最后一位都是0  
                assign imm_b={{20{ins[31]}},ins[7],ins[30:25],ins[11:8],1'b0};
                assign imm_s={{20{ins[31]}},ins[31:25],ins[11:7]};
                assign imm=(mod[0])?imm_i:
                           (mod[1])?imm_u:
                           (mod[2])?imm_j:
                           (mod[3])?imm_b:
                           (mod[4])?imm_s:`zero_word;//一种新的赋值方式，代替always
endmodule