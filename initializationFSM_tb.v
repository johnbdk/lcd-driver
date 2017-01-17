`timescale 1ns / 1ps

module initializationFSM_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire LCD_E;
	wire LCD_RS;
	wire LCD_RW;
	wire SF_D8;
	wire SF_D9;
	wire SF_D10;
	wire SF_D11;

	// Instantiate the Unit Under Test (UUT)
	initializationFSM uut (
		.clk(clk), 
		.reset(reset), 
		.LCD_E(LCD_E), 
		.LCD_RS(LCD_RS), 
		.LCD_RW(LCD_RW), 
		.SF_D8(SF_D8), 
		.SF_D9(SF_D9), 
		.SF_D10(SF_D10), 
		.SF_D11(SF_D11)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#57
		reset = 0;

	end
	
	always #10
		clk = ~clk;
      
endmodule

