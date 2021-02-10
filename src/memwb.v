`include "tmp.v"
module MEMWB(
    input wire clk,
    input wire rst,
    input wire [5:0] stall,

    input wire mem_rd_enable,
    input wire[31:0] mem_rd_num,
    input wire[4:0] mem_rd_addr,
    
    output reg wb_rd_enable,
    output reg [31:0] wb_rd_num,
    output reg [4:0] wb_rd_addr
);
always @(posedge clk) begin
    if (rst == 1) begin
        wb_rd_enable <= 0;
        wb_rd_addr <= 0;
        wb_rd_num <= 0;
    end
    else if(stall[4] == 1 && stall[5] == 0) begin
        wb_rd_enable <= 0;
        wb_rd_addr <= 0;
        wb_rd_num <= 0;
    end
    else if(stall[4] == 0) begin
        wb_rd_enable <= mem_rd_enable;
        wb_rd_addr <= mem_rd_addr;
        wb_rd_num <= mem_rd_num;
    end  
end
endmodule