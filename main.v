`include "source.v"
`include "vm.v"

module tb;
	wire x,y;
	reg clock, reset;
	source source(.x(x));
	vm vm(.x(x), .y(y), .clock(clock), .reset(reset));
	
	initial begin
		$dumpfile("vm.vcd");  //especifica em qual arquivo serao armazenadas as formas de onda
		$dumpvars;  //especifica para colocar todos os sinais no add.vcd 
		reset=0;
		clock = 0;
		#5;

		reset=1;
		#5;
		#150 $finish;
	end
	
	always
	 # 5 clock = ~clock;
endmodule