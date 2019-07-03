`include "source.v"
`include "vm.v"

module main;

	reg clock,reset_n;
	wire[1:0]w_escolher,w_inserir_dinheiro,
		w_dar_troco;
	wire[7:0] w_produto_escolhido, 
		w_dinheiro_inserido,w_valor_troco,
		w_produto_vendido,w_carteira;
	wire[3:0] w_dinheiro_inserido_c, w_dinheiro_inserido_d, 
		w_dinheiro_inserido_u;
	wire[7:0] w_moedas_inseridas_25, w_moedas_inseridas_50, w_moedas_inseridas_100,
		w_moedas_carteira_25, w_moedas_carteira_50, w_moedas_carteira_100;
	
	source source(.escolher(w_escolher), 
				.inserir_dinheiro(w_inserir_dinheiro), 
				.dar_troco(w_dar_troco),
				.produto_escolhido(w_produto_escolhido),
				.dinheiro_inserido(w_dinheiro_inserido),
				.clock(clock),
				.reset_n(reset_n),
				.moedas_inseridas_25(w_moedas_inseridas_25),
				.moedas_inseridas_50(w_moedas_inseridas_50),
				.moedas_inseridas_100(w_moedas_inseridas_100));
				
	vm vm(.escolher(w_escolher), 
			.inserir_dinheiro(w_inserir_dinheiro), 
			.dar_troco(w_dar_troco), 							
			.produto_escolhido(w_produto_escolhido),
			.dinheiro_inserido(w_dinheiro_inserido),
			.produto_vendido(w_produto_vendido),
			.carteira(w_carteira),
			.valor_troco(w_valor_troco),
			.dinheiro_inserido_c(w_dinheiro_inserido_c),
			.dinheiro_inserido_d(w_dinheiro_inserido_d),
			.dinheiro_inserido_u(w_dinheiro_inserido_u),
			.reset_n(reset_n),
			.clock(clock),
			.moedas_inseridas_25(w_moedas_inseridas_25),
			.moedas_inseridas_50(w_moedas_inseridas_50),
			.moedas_inseridas_100(w_moedas_inseridas_100),
			.moedas_carteira_25(w_moedas_carteira_25),
			.moedas_carteira_50(w_moedas_carteira_50),
			.moedas_carteira_100(w_moedas_carteira_100));

	initial begin
		$dumpfile("vm.vcd");
		$dumpvars;

		clock = 0;
		reset_n= 0;
		#10
		reset_n = 1;
		#300 $finish;
	end
	always
		# 1 clock = ~clock;
		
endmodule
