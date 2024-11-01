module instr_mem(
                  input[7:0] address,
                  output[31:0] instr
                );
                reg[31:0] rom[255:0];
                initial begin
                    //$readmemb("binary_code.txt",rom);
                    $readmemh("code_buffer.txt",rom);
                end
                assign instr=rom[address];
endmodule