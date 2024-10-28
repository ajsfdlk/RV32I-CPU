`include "define.v"
module data_mem(
                 input clk,
                 input write_enable,
                 input read_enable,
                 input[31:0] data_in,
                 input[31:0] address,
                 output[31:0] data_out,
                 input[2:0] rw_type//000 读字节,符号扩展  001 读字,符号扩展
                                   //010 读双字
                                   //100 读字节，无符号扩展   101 读字，无符号扩展
                                   //000 存字节
                                   //001 存字
                                   //010 存双字  
               );
               reg[31:0] ram[255:0];
               wire[31:0] store_data;//最终存入的数据
               wire[31:0] output_data_prepare;
               store_control store_control(
											                      .data_input(data_in),
											                      .store_order(rw_type),
											                      .store_data(store_data)
											                    );
               
               assign output_data_prepare=(read_enable==1'b1)?ram[address[9:2]]:
                                                              `zero_word;
               load_control load_control(
											                     .output_data_prepare(output_data_prepare),
											                     .rw_type(rw_type),
											                     .output_data_final(data_out)
											                   );                                               
               
               always@(posedge clk)
               begin
               		 if(write_enable)
               		 begin
               		 		 ram[address[9:2]]<=store_data;
               		 end
               end
endmodule


module store_control(
                      input[31:0] data_input,
                      input[2:0] store_order,
                      output[31:0] store_data
                    );
                    wire[31:0] data_b;
                    wire[31:0] data_w;
                    assign data_b={{24{1'b0}},data_input[7:0]};
                    assign data_w={{16{1'b0}},data_input[15:0]};
                    assign store_data=(store_order==3'b000)?data_b:
                                      (store_order==3'b001)?data_w:
                                      (store_order==3'b010)?data_input:`zero_word;                                      
endmodule


module load_control(
                     input[31:0] output_data_prepare,
                     input[2:0] rw_type,
                     output[31:0] output_data_final
                   );
                   wire[31:0] data_b_ex;//符号扩展
                   wire[31:0] data_w_ex;
                   wire[31:0] data_b;
                   wire[31:0] data_w;
                   assign data_b_ex={{24{output_data_prepare[7]}},output_data_prepare[7:0]};
                   assign data_w_ex={{16{output_data_prepare[15]}},output_data_prepare[15:0]};
                   assign data_b={{24{1'b0}},output_data_prepare[7:0]};
                   assign data_w={{16{1'b0}},output_data_prepare[15:0]};
                   assign output_data_final=(rw_type==3'b000)?data_b_ex:
                                            (rw_type==3'b001)?data_w_ex:
                                            (rw_type==3'b010)?output_data_prepare:
                                            (rw_type==3'b100)?data_b:
                                            (rw_type==3'b101)?data_w:`zero_word;
endmodule                   