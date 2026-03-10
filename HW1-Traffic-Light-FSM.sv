module traffic_fsm
(
	input logic clk,
	input logic rst,
	input logic TAORB,
	output reg [5:0] led
);

typedef enum logic[1:0]
{
	GREENRED = 2'b00,
	YELLOWRED = 2'b01,
	REDGREEN = 2'b10,
	REDYELLOW = 2'b11
}state_t;

state_t state_reg, state_next;
logic [3:0] timer; //Must be at least 3 bit to count 5

always_ff @(posedge clk or posedge rst)begin
	if(rst) begin
		state_reg <= GREENRED;
		timer <= 0;
	end
	else begin
		state_reg <= state_next;
		if(state_reg != state_next)
			timer <= 0;
		else
			timer <= timer + 1;
	end
end

always_comb begin
	state_next = state_reg;
	led = 6'b000000;
	case(state_reg)
		GREENRED: begin
			led = 6'b001100;
			if(!TAORB)begin
				state_next = YELLOWRED;
			end
			else begin
				state_next = GREENRED;
			end
		end

		YELLOWRED: begin
			led = 6'b010100;
			if(!TAORB && timer < 5) begin
				state_next = YELLOWRED;
			end
			else if (timer >= 5) begin
				state_next = REDGREEN;
			end
			else begin
				state_next = YELLOWRED;
			end
		end
	
		REDGREEN: begin
			led = 6'b100001;
			if(TAORB)begin
				state_next = REDYELLOW;
			end
			else begin
				state_next = REDGREEN;
			end
		end

		REDYELLOW: begin
			led = 6'b100010;
			if (timer < 5) begin
				state_next = REDYELLOW;
			end
			else begin
				state_next = GREENRED;
			end
		end
		default: state_next = GREENRED;
	endcase
end

endmodule

	
