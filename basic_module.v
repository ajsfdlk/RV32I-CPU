module mux(
            input[31:0] data1,
            input[31:0] data2,
            input sel,
            output[31:0] data_out
          );
          assign data_out=sel?data1:data2;
endmodule     

module adder_32(
                 input cin,
                 input[31:0] data1,
                 input[31:0] data2,
                 output[31:0] data_out,
                 output cout,
                 output is_zero
               );
               wire[6:0] carry;
               LCA_adder LCA_adder1(
										                  .a(data1[3:0]),
										                  .b(data2[3:0]),
										                  .cin(cin),
										                  .s(data_out[3:0]),
										                  .cout(carry[0])
										                );
               LCA_adder LCA_adder2(
										                  .a(data1[7:4]),
										                  .b(data2[7:4]),
										                  .cin(carry[0]),
										                  .s(data_out[7:4]),
										                  .cout(carry[1])
										                ); 
							 LCA_adder LCA_adder3(
										                  .a(data1[11:8]),
										                  .b(data2[11:8]),
										                  .cin(carry[1]),
										                  .s(data_out[11:8]),
										                  .cout(carry[2])
										                );
							 LCA_adder LCA_adder4(
										                  .a(data1[15:12]),
										                  .b(data2[15:12]),
										                  .cin(carry[2]),
										                  .s(data_out[15:12]),
										                  .cout(carry[3])
										                );	
							 LCA_adder LCA_adder5(
										                  .a(data1[19:16]),
										                  .b(data2[19:16]),
										                  .cin(carry[3]),
										                  .s(data_out[19:16]),
										                  .cout(carry[4])
										                );	
							 LCA_adder LCA_adder6(
										                  .a(data1[23:20]),
										                  .b(data2[23:20]),
										                  .cin(carry[4]),
										                  .s(data_out[23:20]),
										                  .cout(carry[5])
										                );
							 LCA_adder LCA_adder7(
										                  .a(data1[27:24]),
										                  .b(data2[27:24]),
										                  .cin(carry[5]),
										                  .s(data_out[27:24]),
										                  .cout(carry[6])
										                );
							 LCA_adder LCA_adder8(
										                  .a(data1[31:28]),
										                  .b(data2[31:28]),
										                  .cin(carry[6]),
										                  .s(data_out[31:28]),
										                  .cout(cout)
										                );			                			                			                		                		                			                
               assign is_zero=~(|data_out);
endmodule

module shifter(
                input[31:0] data_in,
                input[4:0] sh,
                input[1:0] sh_order,
                output reg[31:0] data_out          
              );
              always@(*)
              begin
              		case(sh_order)
              		2'b00:data_out<=data_in<<sh;//左移
              		2'b01:data_out<=data_in>>sh;//右移
              		2'b10:data_out<=({32{data_in[31]}}<<sh)|(data_in>>sh);//算数右移
              		endcase
              end
endmodule

module negative_num(
                     input[31:0] data_in,
                     output[31:0] data_out
                   );//负数
                   assign data_out=(~data_in)+1;
endmodule


module LCA_adder(
                  input[3:0] a,
                  input[3:0] b,
                  input cin,
                  output[3:0] s,
                  output cout
                );
                wire[3:0] carry_out;
                wire[3:0] G;
                wire[3:0] P;
                assign G=a&b;
                assign P=a^b;
                //C[i]=G[i]|(P[i]&C[i-1])
                assign carry_out[0]=G[0]|(P[0]&cin);
                assign carry_out[1]=G[1]|(P[1]&G[0])|(P[1]&P[0]&cin);
                assign carry_out[2]=G[2]|(P[2]&G[1])|(P[2]&P[1]&G[0])|(P[2]&P[1]&P[0]&cin);
                assign carry_out[3]=G[3]|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0])|(P[3]&P[2]&P[1]&P[0]&cin);
                assign s=P^{carry_out[2:0],cin};
                assign cout=carry_out[3];
endmodule 