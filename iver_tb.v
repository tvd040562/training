`timescale 1ns/1ps

module tb;
	parameter 	AW = 4,
			DW = 8;
	logic clk;
	logic prst;
	logic psel; 
	logic pwrite; 
	logic penable;
	logic pready;
	logic fifo_wen; 
	logic fifo_rden;
	logic [AW-1:0] paddr;
	logic [DW-1:0] pwdata;
	logic [DW-1:0] prdata;
	logic [DW-1:0] fifo_rdata;
	logic [DW-1:0] fifo_wdata;
	reg [DW-1:0] odata;
	logic has_waited;

	apb_top #(.W(2)) u_apb_top (
		.pclk(clk),
		.prst(prst),
		.psel(psel),
		.pwrite(pwrite),
		.penable(penable),
		.pready(pready),
		.paddr(paddr),
		.pwdata(pwdata),
		.prdata(prdata)
	);

	initial begin
		clk = 1'b0;
		forever begin
			#(10/2) clk = ~clk;
		end
	end

	task waitforclk(integer N);
		begin
			integer i;
			for (i=0;i<N;i++)
				@(posedge clk);
		end
	endtask

	task reset_if;
	begin
		prst = 1'b1;
		psel = 1'b0;
		pwrite = 1'b0;
		penable = 1'b0;
		paddr = 0;
		pwdata = 0;
		waitforclk(2);
		prst = 1'b0;
		fifo_rdata = 16'hbeef;
		waitforclk(1);
	end
	endtask

	task write(input [AW-1:0] a_d, input [DW-1:0] d_d);
		begin
		//waitforclk(1);
		#0;
		paddr = a_d;
		pwdata = d_d;
		psel = 1'b1;
		pwrite = 1'b1;
		has_waited = 1'b0;
		waitforclk(1);
		#0;
		penable = 1'b1;
		waitforclk(1);
		while (!pready) begin
			has_waited = 1'b1;
			waitforclk(1);
		end
		//if (!has_waited && 0>0)
		//	waitforclk(1);
		psel = 1'b0;
		penable = 1'b0;
		end
	endtask

	task read(input [AW-1:0] a_d, output [DW-1:0] d_o);
		begin
		//waitforclk(1);
		#0;
		paddr = a_d;
		psel = 1'b1;
		pwrite = 1'b0;
		has_waited = 1'b0;
		waitforclk(1);
		#0;
		penable = 1'b1;
		waitforclk(1);
		while (!pready) begin
			has_waited = 1'b1;
			waitforclk(1);
		end
		//if (!has_waited && 0>0)
		//	waitforclk(1);
		//psel = 1'b0;
		//penable = 1'b0;
		psel = 1'b0;
		penable = 1'b0;
		waitforclk(1);
		d_o = prdata;
		end
	endtask

	task run;
		write(5,10);
		write(6,12);
		write(7,14);
		write(8,16);
		read(8,odata);
		$display("Addr: 8; Data: %h", odata);
		read(7,odata);
		$display("Addr: 7; Data: %h", odata);
		read(6,odata);
		$display("Addr: 6; Data: %h", odata);
		read(5,odata);
		$display("Addr: 5; Data: %h", odata);
		waitforclk(2);
	endtask

	task run2;
		write(5,100);
		write(6,120);
		write(7,140);
		write(8,160);
		read(8,odata);
		$display("Addr: 8; Data: %h", odata);
		read(7,odata);
		$display("Addr: 7; Data: %h", odata);
		read(6,odata);
		$display("Addr: 6; Data: %h", odata);
		read(5,odata);
		$display("Addr: 5; Data: %h", odata);
		waitforclk(2);
	endtask

	initial begin
		$dumpfile("tb.vcd");
		$dumpvars(0,tb);
		reset_if();
		run();
		run2();
		$finish();
	end
endmodule
