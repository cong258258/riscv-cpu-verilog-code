`define op_EMPTY 7'b0000000
`define op_LUI 7'b0110111
`define op_AUIPC 7'b0010111
`define op_JAL 7'b1101111
`define op_JALR 7'b1100111

`define op_B 7'b1100011
`define func3_BEQ 3'b000
`define func3_BNE 3'b001
`define func3_BLT 3'b100
`define func3_BGE 3'b101
`define func3_BLTU 3'b110
`define func3_BGEU 3'b111

`define op_L 7'b0000011
`define func3_LB 3'b000
`define func3_LH 3'b001
`define func3_LW 3'b010
`define func3_LBU 3'b100
`define func3_LHU 3'b101

`define op_S 7'b0100011 
`define func3_SB  3'b000
`define func3_SH  3'b001
`define func3_SW  3'b010

`define op_I 7'b0010011
`define func3_ADDI 3'b000
`define func3_SLTI 3'b010
`define func3_SLTIU 3'b011
`define func3_XORI 3'b100
`define func3_ORI 3'b110
`define func3_ANDI 3'b111
`define func3_SLLI 3'b001
`define func3_SRLI 3'b101
`define func3_SRAI 3'b101

`define op_R 7'b0110011
`define func3_ADD 3'b000
`define func3_SUB 3'b000
`define func3_SLL 3'b001
`define func3_SLT 3'b010
`define func3_SLTU 3'b011
`define func3_XOR 3'b100
`define func3_SRL 3'b101
`define func3_SRA 3'b101
`define func3_OR 3'b110
`define func3_AND 3'b111
`define func7_SLLI 7'b0000000
`define func7_SRLI 7'b0000000
`define func7_SRAI 7'b0100000
`define func7_ADD 7'b0000000
`define func7_SUB 7'b0100000
`define func7_SLL 7'b0000000
`define func7_SLT 7'b0000000
`define func7_SLTU 7'b0000000
`define func7_XOR 7'b0000000
`define func7_SRL 7'b0000000
`define func7_SRA 7'b0100000
`define func7_OR 7'b0000000
`define func7_AND 7'b0000000

`define realop_EMPTY 6'd0
`define realop_LUI 6'd1
`define realop_AUIPC 6'd2
`define realop_JAL 6'd3
`define realop_JALR 6'd4

`define realop_BEQ 6'd5
`define realop_BNE 6'd6
`define realop_BLT 6'd7
`define realop_BGE 6'd8
`define realop_BLTU 6'd9
`define realop_BGEU 6'd10

`define realop_LB 6'd11
`define realop_LH 6'd12
`define realop_LW 6'd13
`define realop_LBU 6'd14
`define realop_LHU 6'd15

`define realop_SB 6'd16
`define realop_SH 6'd17
`define realop_SW 6'd18

`define realop_ADDI 6'd19
`define realop_SLTI 6'd20
`define realop_SLTIU 6'd21
`define realop_XORI 6'd22
`define realop_ORI 6'd23
`define realop_ANDI 6'd24
`define realop_SLLI 6'd25
`define realop_SRLI 6'd26
`define realop_SRAI 6'd27

`define realop_ADD 6'd28
`define realop_SUB 6'd29
`define realop_SLL 6'd30
`define realop_SLT 6'd31
`define realop_SLTU 6'd32
`define realop_XOR 6'd33
`define realop_SRL 6'd34
`define realop_SRA 6'd35
`define realop_OR  6'd36
`define realop_AND 6'd37

`define nostall 6'b000000
`define ifstall 6'b000011
`define idstall 6'b000111
`define exstall 6'b001111
`define memstall 6'b011111
`define allstall 6'b111111