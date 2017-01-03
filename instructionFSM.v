module instructionFSM(clk, reset);

input clk, reset;
reg state, state_next;
reg [19:0] counter, counter_next;
reg [3:0] LCD_E_cnt, LCD_E_cnt_next;			

parameter [11:0] CLEAR_DISPLAY	= 12'b0000000001;
parameter [11:0] RETUNR_HOME	= 12'b0000000010;
parameter [11:0] ENTRY_MODE		= 12'b0000000110;
parameter [11:0] DISPLAY_ON		= 12'b0000001101;
parameter [11:0] DISPLAY_OFF	= 12'b0000001100;
parameter [11:0] SHIFT_CURSOR 	= 12'b0000010000;
parameter [11:0] SHIFT_DISPLAY 	= 12'b0000011000;
parameter [11:0] FUNCTION_SET 	= 12'b0000101000;
parameter [11:0] SET_CGRAM 		= 12'b0000000001;
parameter [11:0] CLEAR_DISPLAY 	= 12'b0000000001;
parameter [11:0] CLEAR_DISPLAY	= 12'b0000000001;
parameter [11:0] CLEAR_DISPLAY 	= 12'b0000000001;
parameter [11:0] CLEAR_DISPLAY	= 12'b0000000001;

always @(posedge clk or posedge reset)
begin
	if (reset) begin
		com_counter = 21'd0;
		counter = 20'd0;
		ClearDisplay = 12'b0000000001;
		state = ClearDisplay;
	end
	else begin
		com_counter = com_counter_next;
		state <= state_next;
	end
end

always @(*)
begin
	state_next = state;
	counter_next = counter;
	out = 1'b0;
	case (state)
		ClearDisplay:
		begin
			if(counter == 750000)
			begin
				state_next = 12'b000000001X;
				out =
			end
			else
				counter_next = counter_next + 1;
		end
		Return_Cur:
		begin
			if
			begin
				state_next =
					 out =
			end
		end
		Entry_Mode_Set:
		begin
			if
			begin
				state_next =
					out =
			end
		end
		Disp_OnOff:
		begin
			if
			begin
				state_next =
					 out =
			end
		end
		Cur_Disp_Shift:
		begin
			state_next =
				out =
		end
		Function_Set:
		begin
			state_next =
				out =
		end
		Set_CGRAM:
		begin
			state_next =
				out =
		end
		Set_DDRAM:
		begin
			state_next =
				out =
		end
		Ready_Busy_Flag_Addr:
		begin
			state_next =
				out =
		end
		Write_CG_DD:
		begin
			state_next =
				out =
		end
		Read_CG_DD:
		begin
			state_next =
				out =
		end
	endcase
end

always @ (posedge clk) begin
	if (rst)
		cnt <= 0;
	else 
		case (state)
			init:
				if (cnt == 75000) cnt <= 0;
				else cnt <= cnt + 1;
		endcase
end

endmodule