module initializationFSM(clk, reset, BRAM_data, SEND_data, instructionFSM_EN);

input clk, reset;
input [9:0] BRAM_data;

output reg [9:0] SEND_data;
output reg instructionFSM_EN;

reg [2:0] state
reg [19:0] counter, counter_max;

`define T_15_MS 	749999		// time to wait for initialization of circuit
`define T_12_CYCLES	11			// time to wait for 12 cycles
`define T_4_1_MS 	204999 		// same as before
`define T_100_US 	4999
`define T_40_US  	1999
`define T_1_64_MS 	81999

parameter [9:0] INIT_1 = 3'b000000001;
parameter [9:0] INIT_2 = 3'b000000010;
parameter [9:0] INIT_3 = 3'b000000100;
parameter [9:0] INIT_4 = 3'b000001000;
parameter [9:0] INIT_5 = 3'b000010000;
parameter [9:0] INIT_6 = 3'b000100000;
parameter [9:0] INIT_7 = 3'b001000000;
parameter [9:0] INIT_8 = 3'b010000000;
parameter [9:0] INIT_9 = 3'b100000000;

always @(posedge clk or posedge reset)
begin
	if(reset) begin
		counter_max = T_15_MS; 
		counter = 20'd0;
		state = INIT_1;
	end
	else begin
		case(state)
			INIT_1: begin
				if(counter == counter_max)begin
					counter_max = T_4_1_MS;
					counter = 20'd0;
					state = INIT_2;
				end
				else
					counter = counter + 1;
			end
			INIT_2: begin
				if(counter == counter_max)begin
					counter_max = T_100_US;
					counter = 20'd0;
					state = INIT_3;
				end
				else
					counter = counter + 1;
			end
			INIT_3: begin
				if(counter == counter_max)begin
					counter_max = T_40_US;
					counter = 20'd0;
					state = INIT_4;
				end
				else
					counter = counter + 1;
			end
			INIT_4: begin
				if(counter == counter_max)begin
					counter_max = T_40_US;
					counter = 20'd0;
					state = INIT_8;
				end
				else
					counter = counter + 1;
			end
			INIT_5: begin
			end
		endcase
	end
end

always @(*)
begin
	case(state)
		INIT_1: begin
			if(counter == counter_max)begin
				instructionFSM_EN = 1;
				SEND_data = 10'h03;
			end
			else
			begin
				instructionFSM_EN = 0;
				SEND_data = 10'h00;
			end
		end
		INIT_2: begin
			if(counter == counter_max)begin
				instructionFSM_EN = 1;
				SEND_data = 10'h03;
			end
			else
			begin
				instructionFSM_EN = 0;
				SEND_data = 10'h00;
			end
		end
		INIT_3: begin
			if(counter == counter_max)begin
				instructionFSM_EN = 1;
				SEND_data = 10'h03;
			end
			else
			begin
				instructionFSM_EN = 0;
				SEND_data = 10'h00;
			end
		end
		INIT_4: begin
			if(counter == counter_max)begin
				instructionFSM_EN = 1;
				SEND_data = 10'h02;
			end
			else
			begin
				instructionFSM_EN = 0;
				SEND_data = 10'h00;
			end
		end
		INIT_5: begin
			instructionFSM_EN = 0;
			SEND_data = 10'h00;
		end
	endcase
end

endmodule