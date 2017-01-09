module initializationFSM(clk, reset);
//kentrikou elegxou
input clk, reset;
input [3:0] data;
reg [2:0] state, state_next;
reg [20:0] counter, counter_next;

parameter [2:0] INTIALIAZATION_1 = 3'b000;
parameter [2:0] INTIALIAZATION_3 = 3'b001;
parameter [2:0] INTIALIAZATION_5 = 3'b010;
parameter [2:0] INTIALIAZATION_7 = 3'b011;
parameter [2:0] INTIALIAZATION_9 = 3'b100;
parameter [2:0]	CONFIG =

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		counter_next = 21'd0;
	end
	else
	begin
		counter = counter_next;
	end
end

always@(*)
begin
	case(state)
	INTIALIAZATION_1:
	begin
		if(counter == 750000)
		begin
			counter_next = 0;
			
		else
			counter_next = counter + 1;





  

endmodule
/*
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
*/

/*
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
		*/