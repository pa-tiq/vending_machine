module vm(x , y, clock,reset);

	input clock,reset;
	input [1:0] SW1,SW2,SW3,SW4,SW5;
	//SW1 = R$0,05
	//SW2 = R$0,10
	//SW3 = R$0,25
	//SW4 = R$0,50
	//SW5 = R$1,00
	
	input [1:0] SW9;
	//SW9 = Give up
	
	input [1:0] KEY0, KEY1;
	//KEY0 = Change selection
	//KEY1 = Select product
	
	output [0:6] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output reg y;
	
	reg [7:0] money,change;
	
	reg [1:0] state, previous_state; 
	parameter start=0,select=1,give_change=2,
			chocolate = 1.20;
			coffee = 1.00;
			juice = 0.70;
	
	//parte sequencial
	always @(posedge clock, negedge reset) begin
		if (~reset) begin
		state<=start;
		previous_state<=start;
		y<=0;
		end
		else begin
			case (state)
				inicio: begin
					if (x==1) state<=s1;
					y<=0;
				end
				s1: begin
					if (x==1) state<=s11;
					else state<=inicio;
					y<=0;
				end
				s11: begin
					if(x==0) state<=s110;
					y<=0; 
				end
				s110: begin
					if(x==1) begin
					state<=s1;
					y<=1;
					end
					else begin
					state<=inicio;
					y<=0;
					end
				end
			endcase
		previous_state<=state;
		end
	end
  
 
endmodule