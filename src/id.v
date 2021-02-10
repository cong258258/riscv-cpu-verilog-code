`include "tmp.v"
module ID(
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] inst,
    input wire [31:0] reg1_data,
    input wire [31:0] reg2_data,

    output reg [31:0] pc_out,
    output reg [4:0] reg1_addr,
    output reg reg1_read_enable,
    output reg [4:0] reg2_addr,
    output reg reg2_read_enable,

    output reg [31:0] rs1_num,
    output reg [31:0] rs2_num,
    output reg [31:0] imm,
    output reg [4:0] rd,
    output reg rd_enable,
    output reg [5:0] aluop,
    output reg [2:0] alusel
    );
    wire[6:0] opcode = inst[6:0];
    wire[2:0] func3 = inst[14:12];
    wire[4:0] rs1 = inst[19:15];
    wire[4:0] rs2 = inst[24:20];
    wire[6:0] func7 = inst[31:25];
    
always @ (*) begin
    if (rst == 1) begin
        reg1_addr = 0;
        reg2_addr = 0;
    end
    else begin
        reg1_addr = inst[19:15];
        reg2_addr = inst[24:20];
    end
end
always @(*) begin
    imm = 0;
    rd_enable = 0;
    reg1_read_enable = 0;
    reg2_read_enable = 0;
    rd = 0; 
    aluop = 0;
    alusel = 0;
    case(opcode)
        `op_LUI: begin
            rd_enable = 1;
            rd = inst[11:7];
            imm = {inst[31:12], 12'h0};
            aluop = `realop_LUI;
        end
        `op_AUIPC: begin
            rd_enable = 1;
            rd = inst[11:7];
            imm = {inst[31:12], 12'h0};
            aluop = `realop_AUIPC;
        end
        `op_JAL: begin
            rd_enable = 1;
            rd = inst[11:7];
            imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
            aluop = `realop_JAL;
        end
        `op_JALR: begin
            rd_enable = 1;
            rd = inst[11:7];
            reg1_read_enable = 1;
            imm = {{21{inst[31]}}, inst[30:20]};
            aluop = `realop_JALR;
        end
        `op_B: begin
            reg1_read_enable = 1;
            reg2_read_enable = 1;
            imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            case(func3)
                `func3_BEQ: begin
                    aluop = `realop_BEQ;
                end
                `func3_BNE: begin
                    aluop = `realop_BNE;
                end
                `func3_BLT: begin
                    aluop = `realop_BLT;
                end
                `func3_BGE: begin
                    aluop = `realop_BGE;
                end
                `func3_BLTU: begin
                    aluop = `realop_BLTU;
                end
                `func3_BGEU: begin
                    aluop = `realop_BGEU;
                end
            endcase
        end
        `op_L: begin
            rd_enable = 1;
            rd = inst[11:7];
            reg1_read_enable = 1;
            imm = {{21{inst[31]}}, inst[30:20]};
            case(func3)
                `func3_LB: begin
                    aluop = `realop_LB;
                end
                `func3_LH: begin
                    aluop = `realop_LH;
                end
                `func3_LW: begin
                    aluop = `realop_LW;
                end
                `func3_LBU: begin
                    aluop = `realop_LBU;
                end
                `func3_LHU: begin
                    aluop = `realop_LHU;
                end
            endcase
        end
        `op_S: begin
            reg1_read_enable = 1;
            reg2_read_enable = 1;
            imm = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
            case(func3)
                `func3_SB: begin
                    aluop = `realop_SB;
                end
                `func3_SH: begin
                    aluop = `realop_SH;
                end
                `func3_SW: begin
                    aluop = `realop_SW;
                end
            endcase
        end
        `op_I: begin
            rd_enable = 1;
            rd = inst[11:7];
            reg1_read_enable = 1;
            imm = {{21{inst[31]}}, inst[30:20]};
            case(func3)
                `func3_ADDI: begin
                    aluop = `realop_ADDI;
                end
                `func3_SLTI: begin
                    aluop = `realop_SLTI;
                end
                `func3_SLTIU: begin
                    aluop = `realop_SLTIU;
                end
                `func3_XORI: begin
                    aluop = `realop_XORI;
                end
                `func3_ORI: begin
                    aluop = `realop_ORI;
                end
                `func3_ANDI: begin
                    aluop = `realop_ANDI;
                end
                `func3_SLLI: begin
                    aluop = `realop_SLLI;
                end
                `func3_SRLI: begin
                    imm = {27'b0, inst[24:20]};
                    if(func7 == `func7_SRLI)
                        aluop = `realop_SRLI;
                    else
                        aluop = `realop_SRAI;
                end
            endcase
        end
        `op_R: begin
            rd_enable = 1;
            rd = inst[11:7];
            reg1_read_enable = 1;
            reg2_read_enable = 1;
            if(func3 == `func3_ADD && func7 == `func7_ADD) begin
                aluop = `realop_ADD;
            end
            else if(func3 == `func3_SUB && func7 == `func7_SUB) begin
                aluop = `realop_SUB;
            end
            else if(func3 == `func3_SLL && func7 == `func7_SLL) begin
                aluop = `realop_SLL;
            end
            else if(func3 == `func3_SLT && func7 == `func7_SLT) begin
                aluop = `realop_SLT;
            end
            else if(func3 == `func3_SLTU && func7 == `func7_SLTU) begin
                aluop = `realop_SLTU;
            end
            else if(func3 == `func3_XOR && func7 == `func7_XOR) begin
                aluop = `realop_XOR;
            end
            else if(func3 == `func3_SRL && func7 == `func7_SRL) begin
                aluop = `realop_SRL;
            end
            else if(func3 == `func3_SRA && func7 == `func7_SRA) begin
                aluop = `realop_SRA;
            end
            else if(func3 == `func3_OR && func7 == `func7_OR) begin
                aluop = `realop_OR;
            end
            else if(func3 == `func3_AND && func7 == `func7_AND) begin
                aluop = `realop_AND;
            end
        end
        // `INTCOM_ORI: begin
        //     Imm = { {19{inst[31]}} ,inst[31:20] };
        //     rd_enable = `WriteEnable;
        //     reg1_read_enable = `ReadEnable;
        //     reg2_read_enable = `ReadDisable;
        //     rd = inst[11 : 7];            
        //     aluop = `EXE_OR;
        //     alusel = `LOGIC_OP;
        //     useImmInstead = 1'b1;
        // end
        //todo: add more op here. 
    endcase
end

//Get rs1
always @ (*) begin
    if (rst == 1) begin
        rs1_num = 0;
    end
    else if (reg1_read_enable == 0) begin
        rs1_num = 0;
    end
    else begin
        rs1_num = reg1_data;
    end
end

//Get rs2
always @ (*) begin
    if (rst == 1) begin
        rs2_num = 0;
    end
    else if (reg2_read_enable == 0) begin
        rs2_num = 0;
    end
    else begin
        rs2_num = reg2_data;
    end
end

always @(*) begin
    pc_out = pc_in;
end
endmodule