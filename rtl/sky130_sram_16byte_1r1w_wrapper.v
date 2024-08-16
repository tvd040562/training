// OpenRAM SRAM model
// Words: 16
// Word size: 8
`timescale 1ns/1ps

module	sky130_sram_16byte_1r1w_wrapper (
    clk0,csb0,addr0,din0,
    clk1,csb1,addr1,dout1
  );
  parameter DATA_WIDTH = 8 ;
  parameter ADDR_WIDTH = 4 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
  // FIXME: This delay is arbitrary.
  parameter DELAY = 3 ;
  parameter VERBOSE = 1 ; //Set to 0 to only display warnings
  parameter T_HOLD = 1 ; //Delay to hold dout value after posedge. Value is arbitrary

  input  clk0; // clock
  input   csb0; // active low chip select
  input [ADDR_WIDTH-1:0]  addr0;
  input [DATA_WIDTH-1:0]  din0;
  input  clk1; // clock
  input   csb1; // active low chip select
  input [ADDR_WIDTH-1:0]  addr1;
  output [DATA_WIDTH-1:0] dout1;

  sky130_sram_16byte_1r1w
	`ifdef USE_SRAM_SIMULATION_MODEL
		#(.DATA_WIDTH(DATA_WIDTH),
		  .ADDR_WIDTH(ADDR_WIDTH),
		  .DELAY(3),
		  .T_HOLD(1))
	`endif
		u_ram (
		.clk0(clk0),
		.csb0(csb0),
		.addr0(addr0),
		.din0(din0),
		.clk1(clk1),
		.csb1(csb1),
		.addr1(addr1),
		.dout1(dout1)
	);

endmodule
