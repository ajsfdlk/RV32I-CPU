`include"basic_module.v"
`include"define.v"
module alu(
           input[31:0] d1,
           input[31:0] d2,
           input[3:0] alu_order,
           output[31:0] result,
           output zero_wire
          );
          wire[31:0] neg_wire;
          wire[31:0] adder_result;
          wire[31:0] adder_2;
          wire[31:0] shf_out;
          wire[4:0] sh;
          wire[1:0] sh_order;
          wire sel;
          wire ul_res;
          wire l_res;
          wire add_cout;
          assign sh=d2[4:0];
          assign sh_order=alu_order[1:0];
          assign sel=(alu_order==`ALU_ADD)?1'b1:1'b0;
          assign ul_res=add_cout;//无符号比大小
          assign l_res=~adder_result[31];//有符号比大小
          negative_num neg_n(
								             .data_in(d1),
								             .data_out(neg_wire)
								            );
				  mux add_or_sub(
				                  .data1(d1),
				                  .data2(neg_wire),
				                  .sel(sel),
				                  .data_out(adder_2)
				                );//加减法的选择
				  adder_32 add(
				                .cin(1'b0),
				                .data1(d2),
				                .data2(adder_2),
				                .is_zero(),
				                .data_out(adder_result),
				                .cout(add_cout)
				              );//d2-d1
          shifter shf(
                      .data_in(d1),
                      .sh(sh),     
                      .sh_order(sh_order),
                      .data_out(shf_out)          
                     );
          assign result=(alu_order==`ALU_ADD)?adder_result:
                        (alu_order==`ALU_SUB)?adder_result:
                        (alu_order==`ALU_AND)?d1&d2:
                        (alu_order==`ALU_OR)?d1|d2:
                        (alu_order==`ALU_XOR)?d1^d2:
                        (alu_order==`ALU_NOR)?~(d1|d2):
                        (alu_order==`ALU_UL)?{{31{1'b0}},ul_res}:
                        (alu_order==`ALU_L)?{{31{1'b0}},l_res}:
                        (alu_order==`ALU_LL)?shf_out:
                        (alu_order==`ALU_LR)?shf_out:
                        (alu_order==`ALU_CR)?shf_out:d2;
          assign zero_wire=~(|result);
endmodule