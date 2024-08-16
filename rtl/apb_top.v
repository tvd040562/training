`timescale 1ns/1ps
module apb_top (
	pclk,
	prst,
	psel,
	pwrite,
	penable,
	pready,
	paddr,
	pwdata,
	prdata);

	parameter 	AW = 4,
				DW = 8,
				W  = 0;

	input pclk;
	input prst;
	input psel; 
	input pwrite; 
	input penable;
	output pready;
	input [AW-1:0] paddr;
	input [DW-1:0] pwdata;
	output reg [DW-1:0] prdata;

	enum bit[3:0] {IDLE,ADDR,WAIT,DATA} state, nx_state;
	//reg [DW-1:0] prdata;

	reg [3:0] ready;
	reg ordy, wen, ren;

	//reg [DW-1:0] mem [0:2**AW-1];
	sky130_sram_16byte_1r1w_wrapper 
		#(.DATA_WIDTH(DW),
		  .ADDR_WIDTH(AW),
		  .DELAY(3),
		  .T_HOLD(1))
		mem (
		.clk0(pclk),
		.csb0(!wen),
		.addr0(paddr),
		.din0(pwdata),
		.clk1(pclk),
		.csb1(!ren),
		.addr1(paddr),
		.dout1(prdata)
	);

	/*
	sky130_sram_1r1w_8x16_8_wrapper mem (
		.clk(pclk),
		.wdata(pwdata),
		.wen(wen),
		.write_pointer(paddr),
		.rdata(prdata),
		.ren(ren),
		.read_pointer(paddr)
	);*/

	assign pready = ordy;

	assign ordy = (W>0)? ready[W-1]:1'b1;

	always @(posedge pclk or negedge penable)
	begin
		if (!penable)
			ready = 4'b0000;
		else begin
			ready[3] = ready[2];
			ready[2] = ready[1];
			ready[1] = ready[0];
			ready[0] = 1'b1;
		end
	end

	always @(posedge pclk or posedge prst)
	begin
		if (prst)
			state <= IDLE;
		else begin
			state <= nx_state;
			//wen = 0;
			//ren = 0;
			//if (nx_state == DATA)
				//if (pwrite)
				//	wen = 1;
				//else
				//	ren = 1;
				//mem[paddr] <= pwdata;
		end
	end

	//always_comb 
	always @*
	begin
		wen = 0;
		ren = 0;
		case (state)
			IDLE: begin
				if (psel) 
					nx_state = ADDR;
				else
					nx_state = state;
			end
			ADDR: begin
				if (penable && ordy) begin
					nx_state = DATA;
					if (pwrite)
						wen = 1;
					else
						ren = 1;
					//prdata = mem[paddr];
				end
				else
					nx_state = state;
			end
			DATA: begin
				if (psel)
                    			nx_state = ADDR;
				else
					nx_state = IDLE;
			end
		endcase
	end
endmodule

