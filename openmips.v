`include "define.v"
`include "pc_reg.v"
`include "if_id.v"
`include "id.v"
`include "regfile.v"
`include "id_ex.v"
`include "ex.v"
`include "ex_mem.v"
`include "mem.v"
`include "mem_wb.v"
`include "wb.v"

module openmips (
    input wire clk,
    input wire rst,

    input wire[`RegBus] rom_data_i,

    output wire[`RegBus] rom_addr_o,
    output wire rom_ce_o
);
    //if_id -> id
    wire[`InstAddrBus] pc;
    wire[`InstAddrBus] id_pc_i;
    wire[`InstBus] id_inst_i;
    
    //id -> id_ex
    wire[`AluOpBus] id_aluop_o;
    wire[`AluSelBus] id_alusel_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire[`RegAddrBus] id_wd_o;

    //id_ex -> ex
    wire[`AluOpBus] ex_aluop_i;
    wire[`AluSelBus] ex_alusel_i;
    wire[`RegBus] ex_reg1_i;
    wire[`RegBus] ex_reg2_i;
    wire ex_wreg_i;
    wire[`RegAddrBus] ex_wd_i;

    //ex -> ex_mem
    wire ex_wreg_o;
    wire[`RegAddrBus] ex_wd_o;
    wire[`RegBus] ex_wdata_o;

    //ex_mem -> mem
    wire mem_wreg_i;
    wire[`RegAddrBus] mem_wd_i;
    wire[`RegBus] mem_wdata_i;

    //mem -> mem_wb
    wire mem_wreg_o;
    wire[`RegAddrBus] mem_wd_o;
    wire[`RegBus] mem_wdata_o;

    //mem_wb -> wb
    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wreg_i;
    wire[`RegBus] wb_wdata_i;

    //id -> Regfile
    wire reg1_read;
    wire reg2_read;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;

    //initialize pc_reg
    pc_reg pc_reg0(.clk(clk), .rst(rst), .pc(pc), .ce(rom_ce_o));

    assign rom_addr_o = pc;

    //initialize if_id
    if_id if_id0(.clk(clk), .rst(rst), .if_pc(pc), .if_inst(rom_data_i), .id_pc(id_pc_i), .id_inst(id_inst_i));
    
    //initialize id
    id id0(.rst(rst), pc_i(id_pc_i), .inst_i(id_inst_i), 
            //from Regfile
            .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
            //to Regfile
            .reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
            .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
            //to id_ex
            .aluop_o(id_aluop_o), .alusel_o(id_alusel_o),
            .reg1_o(id_reg1_o), .reg2_o(id_reg2_o),
            .wd_o(id_wd_o), .wreg_o(id_wreg_o)
            );

    //initialize regfile
    regfile regfile1(.clk(clk), .rst(rst), .we(wb_wreg_i),
                    .waddr(wb_wd_i), .wdata(wb_wdata_i), .re1(reg1_read),
                    .raddr1(reg1_addr), .rdata1(reg1_data),
                    .re2(reg2_read), .raadr2(reg2_addr), .rata2(read2_data)
                    )
    id_ex id_ex0()
endmodule