`include "tmp.v"
module EXMEM(
    input wire clk,
    input wire rst,
    input wire [5:0] stall,
    input wire ex_rd_enable,
    input wire [31:0] ex_rd_num,
    input wire [4:0] ex_rd_addr,
    input wire [5:0] ex_aluop,
    input wire [31:0] ex_val_store_num,
    input wire [31:0] ex_val_store_and_load_addr,
    input wire ex_val_store_enable,
    input wire ex_val_load_enable,

    output reg mem_rd_enable,
    output reg [31:0] mem_rd_num,
    output reg [4:0] mem_rd_addr,
    output reg [5:0] mem_aluop,
    output reg [31:0] mem_val_store_num,
    output reg [31:0] mem_val_store_and_load_addr,
    output reg mem_val_store_enable,
    output reg mem_val_load_enable
);

always @(posedge clk) begin
    if(rst == 1) begin
        mem_rd_enable <= 0;
        mem_rd_num <= 0;
        mem_rd_addr <= 0;
        mem_aluop <= 0;
        mem_val_store_num <= 0;
        mem_val_store_and_load_addr <= 0;
        mem_val_store_enable <= 0;
        mem_val_load_enable <= 0;
    end
    else if(stall[3] == 1 && stall[4] == 0) begin
        mem_rd_enable <= 0;
        mem_rd_num <= 0;
        mem_rd_addr <= 0;
        mem_aluop <= 0;
        mem_val_store_num <= 0;
        mem_val_store_and_load_addr <= 0;
        mem_val_store_enable <= 0;
        mem_val_load_enable <= 0;
    end
    else if(stall[3] == 0) begin
        mem_rd_enable <= ex_rd_enable;
        mem_rd_num <= ex_rd_num;
        mem_rd_addr <= ex_rd_addr;
        mem_aluop <= ex_aluop;
        mem_val_store_num <= ex_val_store_num;
        mem_val_store_and_load_addr <= ex_val_store_and_load_addr;
        mem_val_store_enable <= ex_val_store_enable;
        mem_val_load_enable <= ex_val_load_enable;
    end
end

endmodule