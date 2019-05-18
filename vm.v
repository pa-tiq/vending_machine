module vm(x , y, clock,reset);

	input clock,reset;
	
	input [1:0] LEDR1, LEDR2, LEDR3, LEDR4, LEDR5
	//Leds (SW1 to SW5)
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
	parameter select=0,insert_money=1,give_change=2,
			chocolate = 1.20;
			coffee = 1.00;
			juice = 0.70;
	
	always @(posedge clock, negedge reset) begin
		if (~reset) begin
		state<=select;
		previous_state<=select;
		money7seg digit(0, HEX0,HEX1,HEX2);
		end
		else begin
			case (state)
				select: begin
					if (x==1) state<=s11;
					else state<=inicio;
					y<=0;
				end
				insert_money: begin
					if (SW1==1) begin
						LEDR1 = 1;
						money += 5;
						money7seg digit(money, HEX0,HEX1,HEX2);
						LEDR1 = 0;						
					end
					if (SW2==1) begin
						LEDR2 = 1;
						money += 10;
						LEDR2 = 0;						
					end
					if (SW3==1) begin
						LEDR3 = 1;
						money += 25;
						LEDR3 = 0;						
					end
					if (SW4==1) begin
						LEDR4 = 1;
						money += 50;
						LEDR4 = 0;						
					end
					if (SW5==1) begin
						LEDR5 = 1;
						money += 100;
						LEDR5 = 0;						
					end
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

module money7seg(value,ds0,ds1,ds2);

	
	
	bcd7seg digit2 (ds0, HEX2);
	bcd7seg digit1 (ds1, HEX1);
	bcd7seg digit0 (ds2, HEX0);	
endmodule

module bcd7seg (bcd, display);
	input [3:0] bcd;
	output [0:6] display;
	reg [0:6] display;
	/*
	 *       0  
	 *      ---  
	 *     |   |
	 *    5|   |1
	 *     | 6 |
	 *      ---  
	 *     |   |
	 *    4|   |2
	 *     |   |
	 *      ---  
	 *       3  
	 */
	always @ (bcd)
		case (bcd)
			4'h0: display = 7'b0000001;
			4'h1: display = 7'b1001111;
			4'h2: display = 7'b0010010;
			4'h3: display = 7'b0000110;
			4'h4: display = 7'b1001100;
			4'h5: display = 7'b0100100;
			4'h6: display = 7'b1100000;
			4'h7: display = 7'b0001111;
			4'h8: display = 7'b0000000;
			4'h9: display = 7'b0001100;
			default: display = 7'b1111111;
		endcase
endmodule