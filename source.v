module source(escolher, inserir_dinheiro, dar_troco, 
produto_escolhido, dinheiro_inserido, clock, reset_n);

	input clock, reset_n;
	output reg escolher, inserir_dinheiro, dar_troco;
	output reg[7:0] produto_escolhido, dinheiro_inserido;
	
	initial begin 

	//primeira compra
	//dinheiro inserido = R$1,50
	//produto 1 = R$0,50
	//carteira = R$0,50
	//troco = R$1,00
	
	escolher=0;
	inserir_dinheiro=0;
	dar_troco=0;
	
	produto_escolhido = 0;
	dinheiro_inserido = 0;
	
	#10;
	
	escolher=1;
	inserir_dinheiro=0;
	dar_troco=0;
	
	produto_escolhido = 1;
	dinheiro_inserido = 0;
	
	#10;
	
	escolher=0;
	inserir_dinheiro=1;
	dar_troco=0;
	
	dinheiro_inserido = 150;
	
	#10;
	
	escolher=0;
	inserir_dinheiro=0;
	dar_troco=1;
	
	#10;
	
	//segunda compra compra
	//dinheiro inserido = R$1,00
	//produto 2 = R$0,75
	//carteira = R$0,50 da primeira compra + R$0,75 dessa
	//carteira = R$1,25
	//troco = R$0,25
	
	escolher=0;
	inserir_dinheiro=0;
	dar_troco=0;
	
	produto_escolhido = 0;
	dinheiro_inserido = 0;
	
	#10;
	
	escolher=1;
	inserir_dinheiro=0;
	dar_troco=0;
	
	produto_escolhido = 2;
	dinheiro_inserido = 0;
	
	#10;
	
	escolher=0;
	inserir_dinheiro=1;
	dar_troco=0;
	
	dinheiro_inserido = 100;
	
	#10;
	
	escolher=0;
	inserir_dinheiro=0;
	dar_troco=1;
	
	#10;

	end	
endmodule
