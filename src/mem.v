`include "tmp.v"
module MEM(
    input wire rst,
    input wire rd_enable_in,
    input wire [4:0] rd_addr_in,
    input wire [31:0] rd_num_in,
    input wire [5:0] aluop,
    input wire [31:0] val_store_num,
    input wire [31:0] val_store_and_load_addr,
    input wire val_store_enable,
    input wire val_load_enable,

    input wire mem_ctrl_enable_in,
    input wire mem_ctrl_if_busy_in,
    input wire mem_ctrl_mem_busy_in,
    input wire [31:0] mem_ctrl_addr_in,
    input wire [31:0] mem_ctrl_data_in,

    output reg mem_ctrl_enable_out,
    output reg mem_ctrl_rw_status_out,
    output reg [31:0] mem_ctrl_addr_out,
    output reg [31:0] mem_ctrl_data_out,
    output reg [2:0] mem_ctrl_data_len_out,
    output reg stall_from_mem,

    output reg rd_enable_out,
    output reg [31:0] rd_data_out,
    output reg [4:0] rd_addr_out
);

always @(*) begin
    if(rst == 1) begin
        mem_ctrl_enable_out <= 0;
        mem_ctrl_rw_status_out <= 0;
        mem_ctrl_addr_out <= 0;
        mem_ctrl_data_out <= 0;
        mem_ctrl_data_len_out <= 0;
        stall_from_mem <= 0;
        rd_enable_out <= 0;
        rd_data_out <= 0;
        rd_addr_out <= 0;
    end
    else if(mem_ctrl_enable_in) begin
        mem_ctrl_enable_out <= 0;
        mem_ctrl_rw_status_out <= 0;
        mem_ctrl_addr_out <= 0;
        mem_ctrl_data_out <= 0;
        stall_from_mem <= 0;
        rd_enable_out <= 1;
        rd_addr_out <= rd_addr_in;
    // else if(aluop == `realop_LB || aluop == `realop_LH || aluop == `realop_LW || aluop == `realop_LBU || aluop == `realop_LHU) begin
    //     mem_ctrl_enable_out <= 1;
    //     mem_ctrl_rw_status_out <= 0;
    //     mem_ctrl_addr_out <= val_store_and_load_addr;
    //     mem_ctrl_data_out <= 0;
    //     rd_enable_out <= rd_enable_in;
        if (aluop == `realop_LB)
            rd_data_out <= {{24{mem_ctrl_data_in[7]}}, mem_ctrl_data_in[7:0]};
        else if (aluop == `realop_LBU)
            rd_data_out <= mem_ctrl_data_in[7:0];
        else if (aluop == `realop_LH)
            rd_data_out <= {{16{mem_ctrl_data_in[15]}}, mem_ctrl_data_in[15:0]};
        else if (aluop == `realop_LHU)
            rd_data_out <= mem_ctrl_data_in[15:0];
        else if (aluop == `realop_LW)
            rd_data_out <= mem_ctrl_data_in;
        else
            rd_data_out <= 0;
    end
    else if(val_load_enable) begin
        if(mem_ctrl_if_busy_in) begin
            mem_ctrl_enable_out <= 0;
            mem_ctrl_rw_status_out <= 0;
            mem_ctrl_addr_out <= 0;
            mem_ctrl_data_out <= 0;
            stall_from_mem <= 1;
            rd_enable_out <= 0;
            rd_data_out <= 0;
            rd_addr_out <= 0;
        end
        else begin
            mem_ctrl_enable_out <= 1;
            mem_ctrl_rw_status_out <= 0;
            mem_ctrl_addr_out <= val_store_and_load_addr;
            mem_ctrl_data_out <= 0;
            stall_from_mem <= 1;
            rd_enable_out <= 0;
            rd_data_out <= 0;
            rd_addr_out <= 0;
        end
    end
    else if(val_store_enable) begin
        if(mem_ctrl_if_busy_in) begin
            mem_ctrl_enable_out <= 0;
            mem_ctrl_rw_status_out <= 0;
            mem_ctrl_addr_out <= 0;
            mem_ctrl_data_out <= 0;
            stall_from_mem <= 1;
            rd_enable_out <= 0;
            rd_data_out <= 0;
            rd_addr_out <= 0;
        end
        else begin
            mem_ctrl_enable_out <= 1;
            mem_ctrl_rw_status_out <= 1;
            mem_ctrl_addr_out <= val_store_and_load_addr;
            // mem_ctrl_data_out <= val_store_num;
            stall_from_mem <= 1;
            rd_enable_out <= 0;
            rd_data_out <= 0;
            rd_addr_out <= 0;
            if (aluop == `realop_SB)
                mem_ctrl_data_out <= val_store_num[7:0];
            else if (aluop == `realop_SH)
                mem_ctrl_data_out <= val_store_num[15:0];
            else if (aluop == `realop_SW)
                mem_ctrl_data_out <= val_store_num;
            else
                mem_ctrl_data_out <= 0;
            if (aluop == `realop_SB)
                mem_ctrl_data_len_out <= 1;
            else if (aluop == `realop_SH)
                mem_ctrl_data_len_out <= 2;
            else if (aluop == `realop_SW)
                mem_ctrl_data_len_out <= 4;
            else
                mem_ctrl_data_len_out <= 0;
        end
    end
    // else if(aluop == `realop_SB || aluop == `realop_SH || aluop == `realop_SW) begin
    //     mem_ctrl_enable_out <= 1;
    //     mem_ctrl_rw_status_out <= 1;
    //     mem_ctrl_addr_out <= val_store_and_load_addr;
    //     mem_ctrl_data_out <= val_store_num;
    //     rd_enable_out <= rd_enable_in;
    //     rd_data_out <= 0;
    //     if (aluop == `realop_SB)
    //         mem_ctrl_data_out <= val_store_num[7:0];
    //     else if (aluop == `realop_SH)
    //         mem_ctrl_data_out <= val_store_num[15:0];
    //     else if (aluop == `realop_SW)
    //         mem_ctrl_data_out <= val_store_num;
    //     else
    //         mem_ctrl_data_out <= 0;
    // end
    else begin
        mem_ctrl_enable_out <= 0;
        mem_ctrl_rw_status_out <= 0;
        mem_ctrl_addr_out <= 0;
        mem_ctrl_data_out <= 0;
        stall_from_mem <= 0;
        rd_enable_out <= rd_enable_in;
        rd_data_out <= rd_num_in;
        rd_addr_out <= rd_addr_in;
    end
end
endmodule