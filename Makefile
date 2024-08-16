comp:
	iverilog -o tbrun -g2005-sv iver_tb.v -DUSE_SRAM_SIMULATION_MODEL rtl/*.v
sim: comp
	./tbrun
view: sim
	gtkwave tb.vcd
clean:
	rm tbrun tb.vcd
