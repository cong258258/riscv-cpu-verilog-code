`include "tmp.v"
module IDEX(
    input wire clk,
    input wire rst,
    input wire [5:0] stall,
    input wire [31:0] id_rs1,
    input wire [31:0] id_rs2,
    input wire [31:0] id_imm,
    input wire [4:0] id_rd_addr,
    input wire id_rd_enable,
    input wire [5:0] id_aluop,
    input wire [2:0] id_alusel,
    input wire [31:0] id_pc,

    input wire branch_enable,

    output reg [31:0] ex_rs1,
    output reg [31:0] ex_rs2,
    output reg [31:0] ex_imm,
    output reg [4:0] ex_rd_addr,
    output reg ex_rd_enable,
    output reg [5:0] ex_aluop,
    output reg [2:0] ex_alusel,
    output reg [31:0] ex_pc
    );

always @ (posedge clk) begin
    if (rst == 1) begin
        ex_aluop <= 0;
        ex_alusel <= 0;
        ex_rs1 <= 0;
        ex_rs2 <= 0;
        ex_rd_addr <= 0;
        ex_imm <= 0;
        ex_rd_enable <= 0;
        ex_pc <= 0;
    end
    else if(stall[2] == 1 && stall[3] == 0) begin
        ex_aluop <= 0;
        ex_alusel <= 0;
        ex_rs1 <= 0;
        ex_rs2 <= 0;
        ex_rd_addr <= 0;
        ex_imm <= 0;
        ex_rd_enable <= 0;
        ex_pc <= 0;
    end
    else if(branch_enable) begin
        ex_aluop <= 0;
        ex_alusel <= 0;
        ex_rs1 <= 0;
        ex_rs2 <= 0;
        ex_rd_addr <= 0;
        ex_imm <= 0;
        ex_rd_enable <= 0;
        ex_pc <= 0;
    end
    else if(stall[2] == 0) begin
        ex_rs1 <= id_rs1;
        ex_rs2 <= id_rs2;
        ex_imm <= id_imm;
        ex_rd_addr <= id_rd_addr;
        ex_rd_enable <= id_rd_enable;
        ex_aluop <= id_aluop;
        ex_alusel <= id_alusel;
        ex_pc <= id_pc;
    end
end

endmodule
