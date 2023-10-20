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
    always #10 clk<=~clk;
endmodule 