`include "define.v"

module pc_reg (
    input wire clk,
    input wire rst,
    output reg[`InstAddrBus] pc_o,
    output reg ce_o
);
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce_o <= `ChipDisable;
        end else begin
            ce_o <= `ChipEnable;
        end
    end

    always @(posedge clk ) begin
        if (ce==`ChipDisable) begin
            pc_o <= 32'b00000000;
        end else begin
            pc_o <= pc + 4'h4; 
        end
    end
endmodule