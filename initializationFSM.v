module initializationFSM(clk, reset, bram_data, LCD_E, LCD_RS, LCD_RW,
							SF_D8, SF_D9, SF_D10, SF_D11);

input clk, reset;
input [9:0] bram_data;

output reg SF_D8, SF_D9, SF_D10, SF_D11;
output reg LCD_E, LCD_RW, LCD_RS;

reg [9:0]	tx_data;
reg [17:0] 	state;
reg [19:0] 	counter, counter_max;
reg [10:0] 	addr_reg;
reg [25:0]  refresh_counter;
reg instrFSM_EN;

wire FSM_done;
wire [10:0] addr;
wire [7:0]	char;

/* define the time we have to wait according to the cycles */
`define T_15_MS 	749999
`define T_12_CYCLES	11
`define T_4_1_MS 	204999 		
`define T_100_US 	4999
`define T_40_US  	1999
`define T_1_64_MS 	81999
`define T_REFRESH   49999999

/* states of FSM */
parameter [17:0] INIT_1		= 18'b00000000000000001;
parameter [17:0] INIT_2 	= 18'b00000000000000010;
parameter [17:0] INIT_3 	= 18'b00000000000000100;
parameter [17:0] INIT_4 	= 18'b00000000000001000;
parameter [17:0] INIT_5 	= 18'b00000000000010000;
parameter [17:0] INIT_6 	= 18'b00000000000100000;
parameter [17:0] INIT_7 	= 18'b00000000001000000;
parameter [17:0] INIT_8 	= 18'b00000000010000000;
parameter [17:0] INIT_9 	= 18'b00000000100000000;
parameter [17:0] CONFIG_1 	= 18'b00000001000000000;
parameter [17:0] CONFIG_2 	= 18'b00000010000000000;
parameter [17:0] CONFIG_3 	= 18'b00000100000000000;
parameter [17:0] CONFIG_4 	= 18'b00001000000000000;
parameter [17:0] CONFIG_5 	= 18'b00010000000000000;
parameter [17:0] CONFIG_6 	= 18'b00100000000000000;
parameter [17:0] DISPLAY 	= 18'b01000000000000000;
//parameter [17:0] DISPLAY 	= 18'b10000000000000000;

always @(posedge clk or posedge reset) begin
	if(reset) begin
		counter_max = T_15_MS; 
		counter = 20'd0;
		state = INIT_1;
		addr_reg = 11'd0;
		refresh_counter = 26'd0;
	end
	else begin
		case(state)
			INIT_1: begin
				if(counter == counter_max) begin
					counter_max = T_12_CYCLES;
					counter = 20'd0;
					state = INIT_2;
				end
				else
					counter = counter + 1;
			end
			INIT_2: begin
				if(counter == counter_max) begin
					counter_max = T_4_1_MS;
					counter = 20'd0;
					state = INIT_3;
				end
				else
					counter = counter + 1;
			end
			INIT_3: begin
				if(counter == counter_max) begin
					counter_max = T_12_CYCLES;
					counter = 20'd0;
					state = INIT_4;
				end
				else
					counter = counter + 1;
			end
			INIT_4: begin
				if(counter == counter_max) begin
					counter_max = T_100_US;
					counter = 20'd0;
					state = INIT_5;
				end
				else
					counter = counter + 1;
			end
			INIT_5: begin
				if(counter == counter_max) begin
					counter_max = T_12_CYCLES;
					counter = 20'd0;
					state = INIT_6;
				end
				else
					counter = counter + 1;
			end
			INIT_6: begin
				if(counter == counter_max) begin
					counter_max = T_40_US;
					counter = 20'd0;
					state = INIT_7;
				end
				else
					counter = counter + 1;
			end
			INIT_7: begin
				if(counter == counter_max) begin
					counter_max = T_12_CYCLES;
					counter = 20'd0;
					state = INIT_8;
				end
				else
					counter = counter + 1;
			end
			INIT_8: begin
				if(counter == counter_max) begin
					counter_max = T_40_US;
					counter = 20'd0;
					state = INIT_9;
				end
				else
					counter = counter + 1;
			end
			INIT_9: begin
				if(counter == counter_max) begin
					counter_max = T_40_US;
					counter = 20'd0;
					state = CONFIG_1;
				end
				else
					counter = counter + 1;
			end
			CONFIG_1: begin
				if(FSM_done)
					state = CONFIG_2;
			end
			CONFIG_2: begin
				if(FSM_done)
					state = CONFIG_3;
			end
			CONFIG_3: begin
				if(FSM_done)
					state = CONFIG_4;
			end
			CONFIG_4: begin
				if(FSM_done) begin
					counter_max = T_1_64_MS;
					counter = 20'd0;
					state = CONFIG_5;
				end
			end
			CONFIG_5: begin
				if(counter == counter_max) begin
					state = CONFIG_6;
				end
			end
			CONFIG_6: begin
				if(FSM_done) begin
					state = DISPLAY;
				end
			end
			DISPLAY: begin
				/* give the next address untill it reaches the 31 */
				if(FSM_done) begin
					if(addr_reg < 11'd31) begin
						addr_reg = addr_reg + 1'b1;
					end
				end

				/* refresh the address every one second */
				if(addr_reg >= 11'd31) begin
					if(refresh_counter == T_REFRESH) begin
						if(addr_reg == 11'd31) begin
							addr_reg == 11'd32;
						end
						else begin
							addr_reg == 11'd31;
						end
						refresh_counter = 0;
					end
					refresh_counter = refresh_counter + 1;
				end

				state = DISPLAY;
			end
		endcase
	end
end

always @(*) begin
	if(FSM_done)
		instrFSM_EN = 0;
	case(state)
		INIT_1: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		INIT_2: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b1;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b1;
			SF_D8	= 1'b1;
		end
		INIT_3: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		INIT_4: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b1;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b1;
			SF_D8	= 1'b1;
		end
		INIT_5: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		INIT_6: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b1;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b1;
			SF_D8	= 1'b1;
		end
		INIT_7: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		INIT_8: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b1;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b1;
			SF_D8	= 1'b0;
		end
		INIT_9: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		CONFIG_1: begin
			instrFSM_EN = 1;
			tx_data = 10'b00_0010_1000;
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
		CONFIG_2: begin
			instrFSM_EN = 1;
			tx_data = 10'b00_0000_0110;
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
		CONFIG_3: begin
			instrFSM_EN = 1;
			tx_data = 10'b00_0000_1100;
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
		CONFIG_4: begin
			instrFSM_EN = 1;
			tx_data = 10'b00_0000_0001;
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
		CONFIG_5: begin
			instrFSM_EN = 0;
			tx_data = 10'd0;
			LCD_RS 	= 1'b0;
			LCD_RW 	= 1'b0;
			LCD_E 	= 1'b0;
			SF_D11	= 1'b0;
			SF_D10	= 1'b0;
			SF_D9	= 1'b0;
			SF_D8	= 1'b0;
		end
		CONFIG_6: begin
			instrFSM_EN = 1;
			tx_data = 10'b00_1000_0000;
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
		DISPLAY: begin
			instrFSM_EN = 1;
			tx_data = {1'b1, 1'b0, char};
			LCD_RS 	= instrFSM_LCD_RS;
			LCD_RW 	= instrFSM_LCD_RW;
			LCD_E 	= instrFSM_LCD_E;
			SF_D11 	= instrFSM_SF_D11;
			SF_D10 	= instrFSM_SF_D10;
			SF_D9 	= instrFSM_SF_D9;
			SF_D8 	= instrFSM_SF_D8;
		end
	endcase
end

bram bramINST(clk, 8'd0, addr, 1, 0, 0, char);

instructionFSM instructionFSM_INST(clk, reset, data, instrFSM_EN, 
						instrFSM_LCD_E, instrFSM_LCD_RS, instrFSM_LCD_RW, 
						instrFSM_SF_D8, instrFSM_SF_D9, instrFSM_SF_D10,
						instrFSM_SF_D11, FSM_done);

endmodule