// RISCV32I CPU top module
// port modification allowed for debugging purposes
`include "tmp.v"
module cpu(
    input  wire                 clk_in,			// system clock signal
    input  wire                 rst_in,			// reset signal
	input  wire					rdy_in,			// ready signal, pause cpu when low

    input  wire [ 7:0]          mem_din,		// data input bus
    output wire [ 7:0]          mem_dout,		// data output bus
    output wire [31:0]          mem_a,			// address bus (only 17:0 is used)
    output wire                 mem_wr,			// write/read signal (1 for write)
	
	input  wire                 io_buffer_full, // 1 if uart buffer is full
	
	output wire [31:0]			dbgreg_dout		// cpu register output (debugging demo)
);

wire rst = rst_in | (~rdy_in);

wire if_stall;
wire id_stall;
wire mem_stall;
wire [5:0] main_stall;
Stallctrl stallctrl(
    .rst(rst_in),
    .if_stall(if_stall),
    .id_stall(id_stall),
    .mem_stall(mem_stall),
    .stall_out(main_stall)
);


wire ex_out_branch_enable;
wire [31:0] ex_out_branch_addr;
wire [31:0] pc;
Pc_Reg pc_reg(
    .clk(clk_in),
    .rst(rst),
    .pc(pc),
    .stall(main_stall),
    .branch_enable(ex_out_branch_enable),
    .branch_addr(ex_out_branch_addr)
);


wire wb_rd_enable;
wire [31:0] wb_rd_num;
wire [4:0] wb_rd_addr;
// wire write_enable;
// wire [4:0] write_addr;
// wire [31:0] write_data;

wire reg1_read_enable;   
wire [4:0] reg1_addr;
wire [31:0] reg1_data;
wire reg2_read_enable;   
wire [4:0] reg2_addr;
wire [31:0] reg2_data;
Register register(
    .clk(clk_in),
    .rst(rst),
    .write_enable(wb_rd_enable),
    .write_addr(wb_rd_addr),
    .write_data(wb_rd_num),
    .reg1_read_enable(reg1_read_enable),   
    .reg1_addr(reg1_addr),
    .reg1_data(reg1_data),
    .reg2_read_enable(reg2_read_enable),   
    .reg2_addr(reg2_addr),
    .reg2_data(reg2_data)
);


wire [31:0] if_to_ifid_pc;
wire [31:0] if_inst;
wire if_to_mem_ctrl_enable;
wire [31:0] if_to_mem_ctrl_addr;
wire mem_ctrl_to_if_busy;
wire mem_ctrl_to_if_enable;
wire [31:0] mem_ctrl_to_if_inst;
wire mem_ctrl_to_mem_busy;
wire mem_ctrl_to_mem_enable;

IF ifif(
    .rst(rst),
    .pc_in(pc),
    .mem_ctrl_inst_in(mem_ctrl_to_if_inst),
    .mem_ctrl_busy_if_in(mem_ctrl_to_if_busy),
    .mem_ctrl_busy_mem_in(mem_ctrl_to_mem_busy),
    .mem_ctrl_inst_done_in(mem_ctrl_to_if_enable),
    // .mem_ctrl_mem_done_in(mem_ctrl_to_mem_enable),
    .branch_enable(ex_out_branch_enable),
    .mem_ctrl_enable_out(if_to_mem_ctrl_enable),
    .mem_ctrl_addr_out(if_to_mem_ctrl_addr),
    .stall_from_if(if_stall),
    .pc_out(if_to_ifid_pc),
    .inst_out(if_inst)
);


wire [31:0] ifid_to_id_pc;
wire [31:0] id_inst;
IFID ifid(
    .clk(clk_in),
    .rst(rst),
    .stall(main_stall),
    .if_pc(if_to_ifid_pc),
    .if_inst(if_inst),
    .id_pc(ifid_to_id_pc),
    .id_inst(id_inst),
    .branch_enable(ex_out_branch_enable)
);


wire [31:0] id_rs1;
wire [31:0] id_rs2;
wire [31:0] id_imm;
wire [4:0] id_rd_addr;
wire id_rd_enable;
wire [5:0] id_aluop;
wire [2:0] id_alusel;
wire [31:0] id_to_idex_pc;
ID id(
    .rst(rst),
    .pc_in(ifid_to_id_pc),
    .pc_out(id_to_idex_pc),
    .inst(id_inst),
    .reg1_read_enable(reg1_read_enable),   
    .reg1_addr(reg1_addr),
    .reg1_data(reg1_data),
    .reg2_read_enable(reg2_read_enable),   
    .reg2_addr(reg2_addr),
    .reg2_data(reg2_data),
    .rs1_num(id_rs1),
    .rs2_num(id_rs2),
    .imm(id_imm),
    .rd(id_rd_addr),
    .rd_enable(id_rd_enable),
    .aluop(id_aluop),
    .alusel(id_alusel)
);


wire [31:0] ex_rs1;
wire [31:0] ex_rs2;
wire [31:0] ex_imm;
wire [4:0] idex_to_ex_rd_addr;
wire [31:0] idex_to_ex_pc;
wire idex_to_ex_rd_enable;
wire [5:0] ex_aluop;
wire [2:0] ex_alusel;
IDEX idex(
    .clk(clk_in),
    .rst(rst),
    .stall(main_stall),
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .id_imm(id_imm),
    .id_rd_addr(id_rd_addr),
    .id_rd_enable(id_rd_enable),
    .id_aluop(id_aluop),
    .id_alusel(id_alusel),
    .id_pc(id_to_idex_pc),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .ex_imm(ex_imm),
    .ex_rd_addr(idex_to_ex_rd_addr),
    .ex_rd_enable(idex_to_ex_rd_enable),
    .ex_aluop(ex_aluop),
    .ex_alusel(ex_alusel),
    .ex_pc(idex_to_ex_pc),
    .branch_enable(ex_out_branch_enable)
); 

wire [31:0] ex_rd_num;
wire [4:0] ex_rd_addr;
wire ex_rd_enable;
wire [31:0] ex_val_store_num;
wire [31:0] ex_val_store_and_load_addr;
wire ex_val_store_enable;
wire ex_val_load_enable;
EX ex(
    .rst(rst),
    .rs1(ex_rs1),
    .rs2(ex_rs2),
    .imm(ex_imm),
    .rd_addr_in(idex_to_ex_rd_addr),
    .rd_enable_in(idex_to_ex_rd_enable),
    .aluop(ex_aluop),
    .alusel(ex_alusel),
    .pc_in(idex_to_ex_pc),
    .pc_change(ex_out_branch_enable),
    .new_pc_num(ex_out_branch_addr),
    .rd_num_out(ex_rd_num),
    .rd_addr_out(ex_rd_addr),
    .rd_enable_out(ex_rd_enable),
    .val_store_num(ex_val_store_num),
    .val_store_and_load_addr(ex_val_store_and_load_addr),
    .val_store_enable(ex_val_store_enable),
    .val_load_enable(ex_val_load_enable)
);

wire exmem_to_mem_rd_enable;
wire [31:0] exmem_to_mem_rd_num;
wire [4:0] exmem_to_mem_rd_addr;
wire [5:0] mem_aluop;
wire [31:0] mem_val_store_num;
wire [31:0] mem_val_store_and_load_addr;
wire mem_val_store_enable;
wire mem_val_load_enable;
EXMEM exmem(
    .clk(clk_in),
    .rst(rst),
    .stall(main_stall),
    .ex_rd_enable(ex_rd_enable),
    .ex_rd_num(ex_rd_num),
    .ex_rd_addr(ex_rd_addr),
    .ex_aluop(ex_aluop),
    .ex_val_store_num(ex_val_store_num),
    .ex_val_store_and_load_addr(ex_val_store_and_load_addr),
    .ex_val_store_enable(ex_val_store_enable),
    .ex_val_load_enable(ex_val_load_enable),
    .mem_rd_enable(exmem_to_mem_rd_enable),
    .mem_rd_num(exmem_to_mem_rd_num),
    .mem_rd_addr(exmem_to_mem_rd_addr),
    .mem_aluop(mem_aluop),
    .mem_val_store_num(mem_val_store_num),
    .mem_val_store_and_load_addr(mem_val_store_and_load_addr),
    .mem_val_store_enable(mem_val_store_enable),
    .mem_val_load_enable(mem_val_load_enable)
);

wire mem_rd_enable;
wire [31:0] mem_rd_num;
wire [4:0] mem_rd_addr;
// wire mem_ctrl_to_mem_enable;
wire [31:0] mem_ctrl_to_mem_addr;
wire [31:0] mem_ctrl_to_mem_data;
wire mem_to_mem_ctrl_enable;
wire mem_to_mem_ctrl_rw_status;
wire [31:0] mem_to_mem_ctrl_addr;
wire [31:0] mem_to_mem_ctrl_data;
wire [2:0] mem_to_mem_ctrl_data_len;
MEM mem(
    .rst(rst),
    .rd_enable_in(exmem_to_mem_rd_enable),
    .rd_addr_in(exmem_to_mem_rd_addr),
    .rd_num_in(exmem_to_mem_rd_num),
    .aluop(mem_aluop),
    .val_store_num(mem_val_store_num),
    .val_store_and_load_addr(mem_val_store_and_load_addr),
    .val_store_enable(mem_val_store_enable),
    .val_load_enable(mem_val_load_enable),
    .mem_ctrl_enable_in(mem_ctrl_to_mem_enable),
    .mem_ctrl_if_busy_in(mem_ctrl_to_if_busy),
    .mem_ctrl_mem_busy_in(mem_ctrl_to_mem_busy),
    .mem_ctrl_addr_in(mem_ctrl_to_mem_addr),
    .mem_ctrl_data_in(mem_ctrl_to_mem_data),
    .mem_ctrl_enable_out(mem_to_mem_ctrl_enable),
    .mem_ctrl_rw_status_out(mem_to_mem_ctrl_rw_status),
    .mem_ctrl_addr_out(mem_to_mem_ctrl_addr),
    .mem_ctrl_data_out(mem_to_mem_ctrl_data),
    .mem_ctrl_data_len_out(mem_to_mem_ctrl_data_len),
    .stall_from_mem(mem_stall),
    .rd_enable_out(mem_rd_enable),
    .rd_data_out(mem_rd_num),
    .rd_addr_out(mem_rd_addr)
);

MEMCTRL memctrl(
    .clk(clk_in),
    .rst(rst),
    .if_enable_in(if_to_mem_ctrl_enable),
    .if_addr_in(if_to_mem_ctrl_addr),
    .mem_enable_in(mem_to_mem_ctrl_enable),
    .mem_rw_status_in(mem_to_mem_ctrl_rw_status),
    .mem_addr_in(mem_to_mem_ctrl_addr),
    .mem_data_in(mem_to_mem_ctrl_data),
    .mem_data_len_in(mem_to_mem_ctrl_data_len),
    .ram_data_in(mem_din),
    .ram_rw_status_out(mem_wr),
    .ram_addr_out(mem_a),
    .ram_data_out(mem_dout),
    .if_busy_out(mem_ctrl_to_if_busy),
    .if_enable_out(mem_ctrl_to_if_enable),
    .if_inst_out(mem_ctrl_to_if_inst),
    .mem_busy_out(mem_ctrl_to_mem_busy),
    .mem_enable_out(mem_ctrl_to_mem_enable),
    .mem_data_out(mem_ctrl_to_mem_data)
);

MEMWB memwb(
    .clk(clk_in),
    .rst(rst),
    .stall(main_stall),
    .mem_rd_enable(mem_rd_enable),
    .mem_rd_num(mem_rd_num),
    .mem_rd_addr(mem_rd_addr),
    .wb_rd_enable(wb_rd_enable),
    .wb_rd_num(wb_rd_num),
    .wb_rd_addr(wb_rd_addr)
);


// implementation goes here

// Specifications:
// - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
// - Memory read result will be returned in the next cycle. Write takes 1 cycle(no need to wait)
// - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
// - I/O port is mapped to address higher than 0x30000 (mem_a[17:16]==2'b11)
// - 0x30000 read: read a byte from input
// - 0x30000 write: write a byte to output (write 0x00 is ignored)
// - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
// - 0x30004 write: indicates program stop (will output '\0' through uart tx)

endmodule