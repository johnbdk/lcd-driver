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
	wire SF_D8;
	wire SF_D9;
	wire SF_D10;
	wire SF_D11;
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
		.SF_D8(SF_D8), 
		.SF_D9(SF_D9), 
		.SF_D10(SF_D10), 
		.SF_D11(SF_D11),
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

