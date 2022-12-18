`include "define.v"

module if_id (
    input wire rst,
    input wire clk,
    input wire[`InstAddrBus] if_pc_i,
    input wire[`InstBus] if_inst_i,
    output reg[`InstAddrBus] id_pc_o,
    output reg[`InstBus] id_inst_o 
);
    always @(posedge clk ) begin
        if(rst == `RstEnable) begin
            id_pc_o <= `ZeroWord;
            id_inst_o <= `ZeroWord;
        end else begin
            id_pc_o <= if_pc_i;
            id_inst_o <= if_inst_i;
        end
    end
endmodule