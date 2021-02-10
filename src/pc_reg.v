`include "tmp.v"
module Pc_Reg(
    input wire clk,
    input wire rst,
    input wire [5:0] stall,
    input wire branch_enable,
    input wire [31:0] branch_addr,
    output reg [31:0] pc
//    output reg chip_enable  //0为不启用，使能指令无�?
);
//always @(posedge clk) begin
//    if(rst == 1)
//        chip_enable <= 0;
//    else
//        chip_enable <= 1;
//end

always @(posedge clk) begin
    if(rst)
        pc <= 0;
//    if(chip_enable == 0)
//        pc <= 1'b0;
    else if(branch_enable)
        pc <= branch_addr;
    else if(stall[0] == 0)
        pc <= pc + 4;
end
endmodule