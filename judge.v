module judge(
              input beq,
              input bne,
              input blt,
              input bge,
              input bltu,
              input bgeu,
              input jal,
              input jalr,
              input zero_wire,
              input[31:0] result,
              output jump_flag
            );
            assign jump_flag=(beq&zero_wire)|(bne&~zero_wire)|(blt&result[0])
            |(bge&~result[0])|(bltu&result[0])|(bgeu&~result[0])|jal|jalr;
endmodule