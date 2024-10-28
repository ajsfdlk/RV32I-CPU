`include "chip.v"
`timescale 1ns / 1ps
module chip_tb;
    reg clk;
    reg reset;
    chip chip(
               .clk(clk),
               .reset(reset)
             );
    initial begin
        clk<=0;reset<=1;
        #80 reset<=0;
        #8000 $stop;
    end
    initial begin            
		    $dumpfile("wave.vcd");        //生成的vcd文件名称
		    $dumpvars(0, chip_tb);    //tb模块名称
    end
    always #10 clk<=~clk;
endmodule 