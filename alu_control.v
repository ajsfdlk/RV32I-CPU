`include "define.v"
module alu_control(
                    input[1:0] alu_op,// 01I型指令 10R型指令 11条件跳转(B) 00 R/I/B都不是，以b2处理
                    input[2:0] func,
                    input func1,//SRAI的为1 SLLI的为0
                    output[3:0] alu_order
                  );
                  reg[3:0] B_op;
                  reg[3:0] R_op;
                  reg[3:0] I_op;
                  always@(*)
                  begin
                  		case(func)
                  		3'b000:B_op<=`ALU_SUB;
                  		3'b001:B_op<=`ALU_SUB;
                  		3'b100:B_op<=`ALU_L;
                  		3'b101:B_op<=`ALU_L;
                  		3'b110:B_op<=`ALU_UL;
                  		3'b111:B_op<=`ALU_UL;
                  		endcase
                  end
                  always@(*)
                  begin
                  		case(func)
                  		3'b000:I_op<=`ALU_ADD;
                  		3'b010:I_op<=`ALU_L;
                  		3'b011:I_op<=`ALU_UL;
                  		3'b100:I_op<=`ALU_XOR;
                  		3'b110:I_op<=`ALU_OR;
                  		3'b111:I_op<=`ALU_AND;
                  		3'b001:I_op<=(func1)?`ALU_CR:`ALU_LL;
                  		3'b101:I_op<=`ALU_LR;
                  		endcase
                  end
                  always@(*)
                  begin
                  		case(func)
                  		3'b000:R_op<=(func1)?`ALU_SUB:`ALU_ADD;
                  		3'b001:R_op<=`ALU_LL;
                  		3'b010:R_op<=`ALU_L;
                  		3'b011:R_op<=`ALU_UL;
                  		3'b100:R_op<=`ALU_XOR;
                  		3'b101:R_op<=`ALU_LR;
                  		3'b110:R_op<=`ALU_OR;
                  		3'b111:R_op<=`ALU_AND;
                  		endcase
                  end
                  assign alu_order=(alu_op==2'b01)?I_op:
                                   (alu_op==2'b10)?R_op:
                                   (alu_op==2'b11)?B_op:`ALU_D2;
endmodule