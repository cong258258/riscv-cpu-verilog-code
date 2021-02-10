`include "tmp.v"
module IFID(
    input wire clk, 
    input wire rst,
    input wire [5:0] stall,

    input wire [31:0] if_pc,
    input wire [31:0] if_inst,
    output reg [31:0] id_pc,
    output reg [31:0] id_inst,

    input wire branch_enable


);
    
always @(posedge clk) begin
    if (rst == 1) begin
        id_pc <= 0;
        id_inst <= 0;
    end
    else if(stall[1] == 1 && stall[2] == 0) begin
        id_pc <= 0;
        id_inst <= 0;
    end  
    else if(branch_enable) begin
        id_pc <= 0;
        id_inst <= 0;
    end
    else if(stall[1] == 0) begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
    // else begin
    //     id_pc <= if_pc;
    //     id_inst <= if_inst;
    // end
end
endmodule
