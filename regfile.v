`include "define.v"

module regfile (
    input wire rst,
    input wire clk,

    input wire[`RegAddrBus] waddr_i,
    input wire[`RegBus] wdata_i,
    input wire we_i, 

    input wire[`RegAddrBus] raddr1_i,
    input wire re1_i,
    output reg[`RegBus] rdata1_o,

    input wire[`RegAddrBus] raddr2_i,
    input wire re2_i,
    output reg[`RegBus] rdata2_o

);
    reg[`RegBus] regs[0:`RegNum-1];
    
    always @(posedge clk ) begin
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog'h0)) begin
                regs[waddr] <= wdata_i;
            end
        end
    end

    always @(*) begin
        if(rst == `RstEnable)begin
            rdata1_o <= `ZeroWord;
        end else if (raddr1_i == `RegNumLog2'h0) begin
            rdata1_o <= `ZeroWord;
        end else if ((raddr1_i == waddr_i) && (we_i == `WriteEnable) && (re1_i == `ReadEnable)) begin
            rdata1_o <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata1_o <= regs[raddr1_i];
        end else begin
            rdata1_o <= `ZeroWord;
        end
    end

    always @(*) begin
        if(rst == `RstEnable)begin
            rdata2_o <= `ZeroWord;
        end else if (raddr2_i == `RegNumLog2'h0) begin
            rdata2_o <= `ZeroWord;
        end else if ((raddr2_i == waddr_i) && (we_i == `WriteEnable) && (re2_i == `ReadEnable)) begin
            rdata2_o <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata2_o <= regs[raddr2_i];
        end else begin
            rdata2_o <= `ZeroWord;
        end

    end
    
endmodule