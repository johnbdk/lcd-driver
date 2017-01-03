module initializationFSM(clk, reset);

input clk, reset;

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
