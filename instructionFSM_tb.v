`timescale 1ns / 1ps

module instructionFSM_tb;

	// Inputs
	reg ENABLE;
	reg clk;
	reg reset;
	reg [9:0] data;

	// Outputs
	wire LCD_E;
	wire LCD_RS;
	wire LCD_RW;
	wire DB4;
	wire DB5;
	wire DB6;
	wire DB7;
	wire FSM_done;

	// Instantiate the Unit Under Test (UUT)
	instructionFSM uut (
		.clk(clk), 
		.reset(reset), 
		.data(data),
		.ENABLE(ENABLE), 
		.LCD_E(LCD_E), 
		.LCD_RS(LCD_RS), 
		.LCD_RW(LCD_RW), 
		.DB4(DB4), 
		.DB5(DB5), 
		.DB6(DB6), 
		.DB7(DB7),
		.FSM_done(FSM_done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		data = 0;
		ENABLE = 0;

		// Wait 100 ns for global reset to finish
		#100;
      	reset = 1;
		#20 
		reset = 0;
		ENABLE = 1;
		data = 10'd1;
		#40000
		ENABLE = 0;
	end

	always #10
		clk = ~clk;
endmodule

