`include "tmp.v"
module Register(
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [4:0] write_addr,
    input wire [31:0] write_data,

    input wire reg1_read_enable,   
    input wire [4:0] reg1_addr,
    output reg [31:0] reg1_data,

    input wire reg2_read_enable,   
    input wire [4:0] reg2_addr,
    output reg [31:0] reg2_data
);
reg[31:0] real_register[31:0];

integer i;
initial begin
    for(i = 0; i<= 31; i = i + 1)
        real_register[i] = 0;
end

always @(posedge clk) begin
    if(rst == 1) begin
        for(i = 0; i<= 31; i = i + 1)
            real_register[i] <= 0;
    end
    else begin
        if(write_enable == 1 && rst == 0 && write_addr != 32'h0) 
            real_register[write_addr] <= write_data;
    end
end

always @(*) begin
    if(reg1_read_enable == 1 && rst == 0) begin
        if(reg1_addr == 5'h0)
            reg1_data = 32'h0;
        else
            reg1_data = real_register[reg1_addr];
    end
    else
        reg1_data = 32'h0;
end

always @(*) begin
    if(reg2_read_enable == 1 && rst == 0) begin
        if(reg2_addr == 5'h0)
            reg2_data = 32'h0;
        else
            reg2_data = real_register[reg2_addr];
    end
    else
        reg2_data = 32'h0;
end
endmodule