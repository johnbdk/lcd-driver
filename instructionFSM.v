module instructionFSM(clk, reset, data, ENABLE, LCD_E, LCD_RS, LCD_RW, 
						SF_D8, SF_D9, SF_D10, SF_D11, FSM_done);

input clk, reset, ENABLE;
input [9:0] data;

output 		LCD_E;
output reg 	LCD_RS, LCD_RW, SF_D8, SF_D9, SF_D10, SF_D11, FSM_done;

reg [4:0]	state;
reg [10:0] 	counter, counter_max;

//1us = 50 cycles
//40us = 2000cycles
//40ns = 2 cycles
//230ns = 12cycles
//10ns = 1 cycles

parameter [4:0] TX_UPPER_FOUR_BITS	= 5'b00001;
parameter [4:0] TX_LOWER_FOUR_BITS	= 5'b00010;
parameter [4:0] LCD_E_FIRST_FALL	= 5'b00100;
parameter [4:0] LCD_E_SECOND_FALL	= 5'b01000;
parameter [4:0] INSTRUCTION_DONE	= 5'b10000;

always @(posedge clk or posedge reset)
begin
	if (reset) begin
		counter_max = 11'd14;
		counter = 11'd0;
		state = INSTRUCTION_DONE;
	end
	else begin
		case (state)
			TX_UPPER_FOUR_BITS: begin
				if(counter == counter_max) begin
					counter_max = 11'd49;
					counter = 11'd0;
					state = LCD_E_FIRST_FALL;
				end
				else
					counter = counter + 1;
			end
			LCD_E_FIRST_FALL: begin
				if(counter == counter_max) begin
					counter_max = 11'd14;
					counter = 11'd0;
					state = TX_LOWER_FOUR_BITS;
				end
				else
					counter = counter + 1;
			end
			TX_LOWER_FOUR_BITS: begin
				if(counter == counter_max) begin
					counter_max = 11'd1999;
					counter = 11'd0;
					state = LCD_E_SECOND_FALL;
				end
				else
					counter = counter + 1;
			end
			LCD_E_SECOND_FALL: begin
				if(counter == counter_max) begin
					counter_max = 11'd14;
					counter = 11'd0;
					state = INSTRUCTION_DONE;
				end
				else
					counter = counter + 1;
			end
			INSTRUCTION_DONE: begin
				if(ENABLE) begin
					counter_max = 11'd14;
					counter = 11'd0;
					state = TX_UPPER_FOUR_BITS;
				end
				else
					state = INSTRUCTION_DONE;
			end
		endcase
	end
end

always @(*)
begin
	LCD_RS = data[9];
	LCD_RW = data[8];
	SF_D11 = data[7];
	SF_D10 = data[6];
	SF_D9 = data[5];
	SF_D8 = data[4];
	FSM_done = 0;
	case (state)
		TX_UPPER_FOUR_BITS: begin
			LCD_RS = data[9];
			LCD_RW = data[8];
			SF_D11 = data[7];
			SF_D10 = data[6];
			SF_D9 = data[5];
			SF_D8 = data[4];
		end
		LCD_E_FIRST_FALL: begin
			LCD_RS = 1'b0;
			LCD_RW = 1'b1;
			SF_D11 = 0;
			SF_D10 = 0;
			SF_D9 = 0;
			SF_D8 = 0;
		end
		TX_LOWER_FOUR_BITS: begin
			LCD_RS = data[9];
			LCD_RW = data[8];
			SF_D11 = data[3];
			SF_D10 = data[2];
			SF_D9 = data[1];
			SF_D8 = data[0];
		end
		LCD_E_SECOND_FALL: begin
			if(counter == counter_max) begin
				FSM_done = 1;
			end
			LCD_RS = 1'b0;
			LCD_RW = 1'b1;
			SF_D11 = 0;
			SF_D10 = 0;
			SF_D9 = 0;
			SF_D8 = 0;
		end
		INSTRUCTION_DONE: begin
			LCD_RS = 1'b0;
			LCD_RW = 1'b1;
			SF_D11 = 0;
			SF_D10 = 0;
			SF_D9 = 0;
			SF_D8 = 0;
		end
	endcase
end

assign LCD_E = (((counter >= 2) && (counter < counter_max)) && 
				((state == TX_UPPER_FOUR_BITS) || (state == TX_LOWER_FOUR_BITS))) ? 1 : 0;

endmodule