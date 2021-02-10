`include "tmp.v"
module EX(
    input wire rst,
    input wire [31:0] rs1,
    input wire [31:0] rs2,
    input wire [31:0] imm,
    input wire [4:0] rd_addr_in,
    input wire rd_enable_in,
    input wire [5:0] aluop,
    input wire [2:0] alusel,

    input wire [31:0] pc_in,

    output reg pc_change,
    output reg [31:0] new_pc_num,
    output reg [31:0] rd_num_out,
    output reg [4:0] rd_addr_out,
    output reg rd_enable_out,
    output reg [31:0] val_store_num,
    output reg [31:0] val_store_and_load_addr,
    output reg val_store_enable,
    output reg val_load_enable
    );

    reg [31:0] temp_out;

    //Do the calculation
    always @(*) begin
        if (rst == 1) begin
            pc_change = 0;
            new_pc_num = 0;
            temp_out = 0;
            rd_num_out = 0;
            rd_addr_out = 0;
            rd_enable_out = 0;
            val_store_num = 0;
            val_store_and_load_addr = 0;
            val_store_enable = 0;
            val_load_enable = 0;
        end
        else begin
            pc_change = 0;
            new_pc_num = 0;
            temp_out = 0;
            rd_num_out = 0;
            rd_addr_out = rd_addr_in;
            rd_enable_out = rd_enable_in;
            val_store_num = 0;
            val_store_and_load_addr = 0;
            val_store_enable = 0;
            val_load_enable = 0;
            case (aluop)
                `realop_LUI: begin
                    rd_num_out = imm;
                end
                `realop_AUIPC: begin
                    rd_num_out = pc_in + imm;
                end
                `realop_JAL: begin
                    rd_num_out = pc_in + 4;
                    pc_change = 1;
                    new_pc_num = pc_in + imm;
                end
                `realop_JALR: begin
                    rd_num_out = pc_in + 4;
                    pc_change = 1;
                    new_pc_num = (rs1 + imm) & 32'hFFFFFFFE;
                end
                `realop_BEQ: begin
                    if(rs1 == rs2) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_BNE: begin
                    if(rs1 != rs2) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_BLT: begin
                    if($signed(rs1) < $signed(rs2)) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_BGE: begin
                    if($signed(rs1) >= $signed(rs2)) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_BLTU: begin
                    if(rs1 < rs2) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_BGEU: begin
                    if(rs1 >= rs2) begin
                        pc_change = 1;
                        new_pc_num = pc_in + imm;
                    end
                    else begin
                        pc_change = 0;
                    end
                end
                `realop_LB: begin
                    val_load_enable = 1;
                    val_store_and_load_addr = rs1 + imm;
                
                end
                `realop_LH: begin
                    val_load_enable = 1;
                    val_store_and_load_addr = rs1 + imm;
                
                end
                `realop_LW: begin
                    val_load_enable = 1;
                    val_store_and_load_addr = rs1 + imm;
                
                end
                `realop_LBU: begin
                    val_load_enable = 1;
                    val_store_and_load_addr = rs1 + imm;
                
                end
                `realop_LHU: begin
                    val_load_enable = 1;
                    val_store_and_load_addr = rs1 + imm;
                
                end
                `realop_SB: begin
                    val_store_enable = 1;
                    val_store_num = rs2;
                    val_store_and_load_addr = rs1 + imm;
                end
                `realop_SH: begin
                    val_store_enable = 1;
                    val_store_num = rs2;
                    val_store_and_load_addr = rs1 + imm;
                end
                `realop_SW: begin
                    val_store_enable = 1;
                    val_store_num = rs2;
                    val_store_and_load_addr = rs1 + imm;
                end
                `realop_ADDI: begin
                    rd_num_out = rs1 + imm;
                end
                `realop_SLTI: begin
                    rd_num_out = $signed(rs1) < $signed(imm);
                end
                `realop_SLTIU: begin
                    rd_num_out = rs1 < imm;
                end
                `realop_XORI: begin
                    rd_num_out = rs1 ^ imm;
                end
                `realop_ORI: begin
                    rd_num_out = rs1 | imm;
                end
                `realop_ANDI: begin
                    rd_num_out = rs1 & imm;
                end
                `realop_SLLI: begin
                    rd_num_out = rs1 << imm[4:0];
                end
                `realop_SRLI: begin
                    rd_num_out = rs1 >> imm[4:0];
                end
                `realop_SRAI: begin
                    rd_num_out = $signed(rs1) >> imm[4:0];
                end
                `realop_ADD: begin
                    rd_num_out = rs1 + rs2;
                end
                `realop_SUB: begin
                    rd_num_out = rs1 - rs2;
                end
                `realop_SLL: begin
                    rd_num_out = rs1 << rs2[4:0];
                end
                `realop_SLT: begin
                    rd_num_out = $signed(rs1) < $signed(rs2);
                end
                `realop_SLTU: begin
                    rd_num_out = rs1 < rs2;
                end
                `realop_XOR: begin
                    rd_num_out = rs1 ^ rs2;
                end
                `realop_SRL: begin
                    rd_num_out = rs1 >> rs2[4:0];
                end
                `realop_SRA: begin
                    rd_num_out = $signed(rs1) >> rs2[4:0];
                end
                `realop_OR : begin
                    rd_num_out = rs1 | rs2;
                end
                `realop_AND: begin
                    rd_num_out = rs1 & rs2;
                end
                default: 
                    rd_num_out = 0;
            endcase
        end
    end

    //Determine the output
    // always @ (*) begin
    //     if (rst == 1) begin
    //         rd_enable_out = 0;
    //     end
    //     else begin 
    //         rd_addr_out = rd_addr_in;
    //         rd_enable_out = rd_enable_in;
    //         rd_num_out = temp_out;
    //     end
    // end
endmodule
