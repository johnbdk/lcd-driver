/* define the time we have to wait according to the cycles */
`define T_15_MS		749999
`define T_12_CYCLES	11
`define T_4_1_MS	204999 		
`define T_100_US	4999
`define T_40_US 	1999
`define T_1_64_MS	81999
`define T_REFRESH	49999999

module initializationFSM(clk, reset, LCD_E, LCD_RS, LCD_RW,
							SF_D8, SF_D9, SF_D10, SF_D11);

input clk, reset;

output reg SF_D8, SF_D9, SF_D10, SF_D11;
output reg LCD_E, LCD_RW, LCD_RS;

reg [9:0]	tx_data;
reg [15:0] 	state;
reg [19:0] 	counter;
reg [10:0] 	addr_reg;
reg [25:0]  refresh_counter;

wire FSM_done, instrFSM_LCD_E, instrFSM_LCD_RS, instrFSM_LCD_RW, instrFSM_EN;
wire instrFSM_SF_D8, instrFSM_SF_D9, instrFSM_SF_D10, instrFSM_SF_D11;
wire [9:0] data;
wire [10:0] addr;
wire [7:0]	char;

/* states of FSM */
parameter [15:0] INIT_1		= 16'b0000000000000001;
parameter [15:0] INIT_2 	= 16'b0000000000000010;
parameter [15:0] INIT_3 	= 16'b0000000000000100;
parameter [15:0] INIT_4 	= 16'b0000000000001000;
parameter [15:0] INIT_5 	= 16'b0000000000010000;
parameter [15:0] INIT_6 	= 16'b0000000000100000;
parameter [15:0] INIT_7 	= 16'b0000000001000000;
parameter [15:0] INIT_8 	= 16'b0000000010000000;
parameter [15:0] INIT_9 	= 16'b0000000100000000;
parameter [15:0] CONFIG_1 	= 16'b0000001000000000;
parameter [15:0] CONFIG_2 	= 16'b0000010000000000;
parameter [15:0] CONFIG_3 	= 16'b0000100000000000;
parameter [15:0] CONFIG_4 	= 16'b0001000000000000;
parameter [15:0] CONFIG_5 	= 16'b0010000000000000;
parameter [15:0] CONFIG_6 	= 16'b0100000000000000;
parameter [15:0] DISPLAY 	= 16'b1000000000000000;



bram bramINST(clk, 8'd0, addr, 1'd1, 1'd0, 1'd0, char);

instructionFSM instructionFSM_INST(clk, reset, data, instrFSM_EN, 
						instrFSM_LCD_E, instrFSM_LCD_RS, instrFSM_LCD_RW, 
						instrFSM_SF_D8, instrFSM_SF_D9, instrFSM_SF_D10,
						instrFSM_SF_D11, FSM_done);

assign addr = addr_reg;
assign data = tx_data;
assign instrFSM_EN = ((state > INIT_9) && (state != CONFIG_5) && !FSM_done) ? 1'd1 : 1'd0; 

always @(posedge clk or posedge reset) begin
	if(reset) begin
		counter = 20'd0;
		state = INIT_1;
		addr_reg = 11'd0;
		refresh_counter = 26'd0;
	end
	else begin
		case(state)
			INIT_1: begin
				if(counter == `T_15_MS) begin
					counter = 20'd0;
					state = INIT_2;
				end
				else
					counter = counter + 1;
			end
			INIT_2: begin
				if(counter == `T_12_CYCLES) begin
					counter = 20'd0;
					state = INIT_3;
				end
				else
					counter = counter + 1;
			end
			INIT_3: begin
				if(counter == `T_4_1_MS) begin
					counter = 20'd0;
					state = INIT_4;
				end
				else
					counter = counter + 1;
			end
			INIT_4: begin
				if(counter == `T_12_CYCLES) begin
					counter = 20'd0;
					state = INIT_5;
				end
				else
					counter = counter + 1;
			end
			INIT_5: begin
				if(counter == `T_100_US) begin
					counter = 20'd0;
					state = INIT_6;
				end
				else
					counter = counter + 1;
			end
			INIT_6: begin
				if(counter == `T_12_CYCLES) begin
					counter = 20'd0;
					state = INIT_7;
				end
				else
					counter = counter + 1;
			end
			INIT_7: begin
				if(counter == `T_40_US) begin
					counter = 20'd0;
					state = INIT_8;
				end
				else
					counter = counter + 1;
			end
			INIT_8: begin
				if(counter == `T_12_CYCLES) begin
					counter = 20'd0;
					state = INIT_9;
				end
				else
					counter = counter + 1;
			end
			INIT_9: begin
				if(counter == `T_40_US) begin
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
					counter = 20'd0;
					state = CONFIG_5;
				end
			end
			CONFIG_5: begin
				if(counter == `T_1_64_MS) begin
					state = CONFIG_6;
				end
				else
					counter = counter + 1;
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
					if(refresh_counter == `T_REFRESH) begin
						if(addr_reg == 11'd31) begin
							addr_reg = 11'd32;
						end
						else begin
							addr_reg = 11'd31;
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
	tx_data = 10'd0;
	LCD_RS 	= 1'b0;
	LCD_RW 	= 1'b0;
	LCD_E 	= 1'b0;
	SF_D11	= 1'b0;
	SF_D10	= 1'b0;
	SF_D9	= 1'b0;
	SF_D8	= 1'b0;
	case(state)
		INIT_1: begin
		end
		INIT_2: begin
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
		end
		INIT_4: begin
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
		end
		INIT_6: begin
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
		end
		INIT_8: begin
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
		end
		CONFIG_1: begin
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
		end
		CONFIG_6: begin
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

endmodule