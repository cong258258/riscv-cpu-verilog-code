`include "tmp.v"

module Stallctrl(
    input wire rst,
    input wire if_stall,
    input wire id_stall,
    input wire mem_stall,

    output reg [5:0] stall_out
);

    always @ (*) begin
        if (rst == 1)
            stall_out <= `nostall;
        else if (mem_stall == 1)
            stall_out <= `memstall;
        else if (id_stall == 1)
            stall_out <= `idstall;
        else if (if_stall == 1)
            stall_out <= `ifstall;
        else
            stall_out <= `nostall;
    end
endmodule