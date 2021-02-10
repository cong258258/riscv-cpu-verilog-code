`include "tmp.v"
module MEMCTRL(
    input wire clk,
    input wire rst,
    
    input wire if_enable_in,
    input wire [31:0] if_addr_in,
    
    input wire mem_enable_in,
    input wire mem_rw_status_in,
    input wire [31:0] mem_addr_in,
    input wire [31:0] mem_data_in,
    input wire [2:0] mem_data_len_in,
    
    input wire [7:0] ram_data_in,
    
    output reg ram_rw_status_out,
    output wire [31:0] ram_addr_out,
    output reg [7:0] ram_data_out,

    output reg if_busy_out,
    output reg if_enable_out,
    output reg [31:0] if_inst_out,
    
    output reg mem_busy_out,
    output reg mem_enable_out,
    output reg [31:0] mem_data_out
);

wire [7:0] store_data [3:0];
assign store_data[0] = mem_data_in[7:0];
assign store_data[1] = mem_data_in[15:8];
assign store_data[2] = mem_data_in[23:16];
assign store_data[3] = mem_data_in[31:24];

reg[7:0] load_data[2:0];
reg[2:0] cnt;
assign ram_addr_out = if_enable_in ? (if_addr_in + cnt) : (mem_rw_status_in ? (cnt == 0? 0 : mem_addr_in + cnt - 1) :mem_addr_in + cnt);
// assign ram_data_out = store_data[cnt];

always @(posedge clk) begin
    if (rst == 1) begin
        cnt <= 0;
        load_data[0] <= 8'b00000000;
        load_data[1] <= 8'b00000000;
        load_data[2] <= 8'b00000000;
        ram_rw_status_out <= 0;
        ram_data_out <= 0;
        mem_enable_out <= 0;
        mem_data_out <= 0;
        if_busy_out <= 0;
        if_enable_out <= 0;
        if_inst_out <= 0;
        mem_busy_out <= 0;
        mem_enable_out <= 0;
        mem_data_out <= 0;
    end
    else begin
        if(mem_enable_in == 1) begin
            ram_rw_status_out <= 0;
            ram_data_out <= 0;
            if_busy_out <= 0;
            if_enable_out <= 0;
            if_inst_out <= 0;
            mem_busy_out <= 1;
            mem_enable_out <= 0;
            mem_data_out <= 0;
            if(mem_rw_status_in == 0) begin
                if(cnt == 0) begin
                    cnt <= cnt + 1;
                end
                if(cnt < 4) begin
                    load_data[cnt-1] <= ram_data_in;
                    cnt <= cnt + 1;
                end
                else if(cnt == 4) begin
                    cnt <= 0;
                    mem_enable_out <= 1;
                    mem_data_out <= {ram_data_in, load_data[2], load_data[1], load_data[0]};
                    mem_busy_out <= 0;
                    if_busy_out <= 0;
                end
            end
            else if(mem_rw_status_in == 1) begin
                ram_rw_status_out <= 1;
                if(cnt < mem_data_len_in) begin
                    ram_data_out <= store_data[cnt];
                    cnt <= cnt + 1;
                end
                else if(cnt == mem_data_len_in) begin
                    cnt <= 0;
                    mem_enable_out <= 1;
                    mem_busy_out <= 0;
                    if_busy_out <= 0;
                    ram_rw_status_out <= 0;
                end
            end   
        end
        else if(if_enable_in == 1) begin
            ram_rw_status_out <= 0;
            if_busy_out <= 1;
            if_enable_out <= 0;
            if_inst_out <= 0;
            mem_busy_out <= 0;
            mem_enable_out <= 0;
            mem_data_out <= 0;
            if(cnt == 0) begin
                cnt <= cnt + 1;
            end
            if(cnt < 4) begin
                load_data[cnt-1] <= ram_data_in;
                cnt <= cnt + 1;
            end
            else if(cnt == 4) begin
                cnt <= 0;
                if_enable_out <= 1;
                if_inst_out <= {ram_data_in, load_data[2], load_data[1], load_data[0]};
                if_busy_out <= 0;
                mem_busy_out <= 0;
            end
        end
        else begin
            cnt <= 0;
            if_enable_out <= 0;
            mem_enable_out <= 0;
        end
    end
end
endmodule