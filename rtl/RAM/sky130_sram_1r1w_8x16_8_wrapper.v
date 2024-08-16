`define USE_SRAM_SIMULATION_MODEL

module sky130_sram_1r1w_8x16_8_wrapper #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   clk,
    //write
    input   [WIDTH - 1 : 0] wdata,
    input                   wen,
    input   [$clog2(DEPTH)  -1:0]   write_pointer,
    //read
    output  [WIDTH - 1 : 0] rdata,
    input                   ren,
    input   [$clog2(DEPTH)  -1:0]   read_pointer
  );

`ifdef USE_SRAM_SIMULATION_MODEL

  sky130_sram_1r1w_8x16_8 #(
        .DATA_WIDTH(WIDTH),
        .ADDR_WIDTH($clog2(DEPTH)),
        .DELAY(0),
        .T_HOLD(1)
    )
    u_ram (
        .clk0(clk),
        .csb0(!wen),
        .addr0(write_pointer),
        .din0(wdata),
        .clk1(clk),
        .csb1(!ren),
        .addr1(read_pointer),
        .dout1(rdata)
    );

`else
// instantiate RAM for synthesis here

sky130_sram_1r1w_8x16_8
    u_ram (
        .clk0(clk),
        .csb0(!wen),
        .addr0(write_pointer),
        .din0(wdata),
        .clk1(clk),
        .csb1(!ren),
        .addr1(read_pointer),
        .dout1(rdata)
    );
`endif
endmodule

