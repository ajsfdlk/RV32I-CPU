//2023.10.1
`include "define.v"
module pc(
           input clk,
           input reset,
           input[31:0] addr,
           output reg[31:0] addr1
         );
         always@(posedge clk or negedge reset)
         begin
             if(reset)
             begin
                 addr1<=`zero_word;
             end
             else
             begin
                 addr1<=addr;
             end
         end
endmodule