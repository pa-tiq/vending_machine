module vm(x , y, clock,reset);
	input reais,clock,reset;
	output reg y;
	
	reg [1:0] state, previous_state; 
	parameter start=0,select=1,change=2,
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