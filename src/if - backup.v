`include "tmp.v"
module IF(
    input wire rst,
    input wire [31:0] pc_in,

    input wire [31:0] mem_ctrl_inst_in,
    input wire mem_ctrl_busy_if_in,
    input wire mem_ctrl_busy_mem_in,
    input wire mem_ctrl_inst_done_in,
    input wire mem_ctrl_mem_done_in,

    input wire branch_enable,
    output reg mem_ctrl_enable_out,
    output reg [31:0] mem_ctrl_addr_out,
    
    output reg stall_from_if,
    output reg [31:0] pc_out,
    output reg [31:0] inst_out
);

reg [31:0] pre_addr;
// always @(posedge clk) begin
//     pc_out <= pc_in + 4;
// end

always @(*) begin
    if(rst == 1) begin
        stall_from_if <= 0;
        pc_out <= 0;
        inst_out <= 0;
        mem_ctrl_enable_out <= 0;
        mem_ctrl_addr_out <= 0;
    end
    else if(branch_enable) begin
        stall_from_if <= 0;
        pc_out <= 0;
        inst_out <= 0;
        mem_ctrl_enable_out <= 0;
        mem_ctrl_addr_out <= 0;
    end
    else if(mem_ctrl_inst_done_in) begin
        stall_from_if <= 0;
        pc_out <= pc_in;
        inst_out <= mem_ctrl_inst_in;
        mem_ctrl_enable_out <= 0;
        mem_ctrl_addr_out <= 0;
        pre_addr <= pc_in;
    end
    else if(mem_ctrl_busy_mem_in) begin
        stall_from_if <= 1;
        pc_out <= 0;
        inst_out <= 0;
        mem_ctrl_enable_out <= 0;
        mem_ctrl_addr_out <= 0;
    end
    else if(mem_ctrl_mem_done_in && pre_addr == pc_in) begin
        stall_from_if <= 0;
        pc_out <= pc_in;
        inst_out <= mem_ctrl_inst_in;
        mem_ctrl_enable_out <= 0;
        mem_ctrl_addr_out <= 0;
    end
    else if(mem_ctrl_busy_if_in) begin
        stall_from_if <= 1;
        pc_out <= pc_in;
        inst_out <= 0;
        mem_ctrl_enable_out <= 1;
        mem_ctrl_addr_out <= pc_in;
        pre_addr <= pc_in;
    end
    else if(mem_ctrl_busy_if_in == 0 && mem_ctrl_busy_mem_in == 0) begin
        stall_from_if <= 1;
        pc_out <= pc_in;
        inst_out <= 0;
        mem_ctrl_enable_out <= 1;
        mem_ctrl_addr_out <= pc_in;
        pre_addr <= pc_in;
    end
    else begin
        stall_from_if <= 1;
        pc_out <= 0;
        inst_out <= 0;
        mem_ctrl_enable_out <= 1;
        mem_ctrl_addr_out <= pc_in;
    end
end

always @(*) begin
    
end
endmodule