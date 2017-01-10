module instructionFSM(clk, reset, data, LCD_E, LCD_RS, LCD_RW, 
						DB4, DB5, DB6, DB7);

input clk, reset;
input [9:0] data;

output LCD_E;
output reg LCD_RS, LCD_RW;
output reg DB4, DB5, DB6, DB7;

reg [3:0] state;
reg [10:0] counter;
reg [10:0] counter_max;

//1us = 50 cycles
//40us = 2000cycles
//40ns = 2 cycles
//230ns = 12cycles
//10ns = 1 cycles

parameter [3:0] TX_UPPER_FOUR_BITS		= 4'b0001;
parameter [3:0] TX_LOWER_FOUR_BITS		= 4'b0010;
parameter [3:0] LCD_E_FIRST_FALL		= 4'b0100;
parameter [3:0] LCD_E_SECOND_FALL		= 4'b1000;

always @(posedge clk or posedge reset)
begin
	if (reset) begin
		counter_max = 11'd14;
		counter = 11'd0;
		state = TX_UPPER_FOUR_BITS;
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
					state = TX_UPPER_FOUR_BITS;
				end
				else
					counter = counter + 1;
			end
		endcase
		
	end
end

assign LCD_E = (((counter>=2) && (counter< counter_max)) && 
				((state == TX_UPPER_FOUR_BITS) || (state == TX_LOWER_FOUR_BITS))) ? 1 : 0;

always @(*)
begin
	LCD_RS = data[9];
	LCD_RW = data[8];
	DB7 = data[7];
	DB6 = data[6];
	DB5 = data[5];
	DB4 = data[4];
	case (state)
		TX_UPPER_FOUR_BITS: begin
			LCD_RS = data[9];
			LCD_RW = data[8];
			DB7 = data[7];
			DB6 = data[6];
			DB5 = data[5];
			DB4 = data[4];
		end
		LCD_E_FIRST_FALL: begin
			LCD_RS = 1'b0;
			LCD_RW = 1'b1;
			DB7 = 0;
			DB6 = 0;
			DB5 = 0;
			DB4 = 0;
		end
		TX_LOWER_FOUR_BITS: begin
			LCD_RS = data[9];
			LCD_RW = data[8];
			DB7 = data[3];
			DB6 = data[2];
			DB5 = data[1];
			DB4 = data[0];
		end
		LCD_E_SECOND_FALL: begin
			LCD_RS = 1'b0;
			LCD_RW = 1'b1;
			DB7 = 0;
			DB6 = 0;
			DB5 = 0;
			DB4 = 0;
		end
	endcase
end

endmodule