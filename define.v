//2023.10.1


`define		zero_word		32'd0
`define   true_word   32'h00000001

`define		lui				7'b0110111
`define		auipc			7'b0010111
`define		jal				7'b1101111
`define		jalr			7'b1100111
`define		B_type			7'b1100011
`define		load			7'b0000011
`define		store			7'b0100011
`define		I_type			7'b0010011
`define		R_type			7'b0110011  //寄存器运算

`define 	ADD  			4'b0001
`define 	SUB  			4'b0011
`define 	SLL  			4'b1100
`define 	SLT  			4'b1001
`define 	SLTU 			4'b1000
`define 	XOR  			4'b0110
`define 	SRL  			4'b1101
`define 	SRA  			4'b1110
`define 	OR   			4'b0101
`define 	AND  			4'b0100


`define ALU_ADD     4'b0000
`define ALU_D2      4'b0010
`define ALU_SUB     4'b0011
`define ALU_AND     4'b0100
`define ALU_OR      4'b0101
`define ALU_XOR     4'b0110
`define ALU_NOR     4'b0111
`define ALU_UL      4'b1000   //无符号小于置一
`define ALU_L       4'b1001   //有符号小于置一
`define ALU_LL      4'b1100   //逻辑左移
`define ALU_LR      4'b1101   //逻辑右移
`define ALU_CR      4'b1110   //算数右移


`define mod0        7'b0000000
`define mod1        7'b0100000