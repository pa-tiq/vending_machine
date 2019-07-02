module vm(escolher,inserir_dinheiro,dar_troco,
produto_escolhido, dinheiro_inserido, produto_vendido,
carteira,valor_troco,dinheiro_inserido_c, dinheiro_inserido_d,
dinheiro_inserido_u, reset_n,clock, moedas_inseridas,moedas_carteira);

	input[1:0] escolher, inserir_dinheiro, dar_troco;
	input[7:0] produto_escolhido, dinheiro_inserido;
	input reset_n;
	input clock;
	output reg[7:0] produto_vendido, carteira, valor_troco;
	output reg[3:0]	dinheiro_inserido_c, dinheiro_inserido_d, dinheiro_inserido_u;
	
	input[23:0] moedas_inseridas;
	output reg[23:0] moedas_carteira;
	//moedas[7:0] = moedas de R$0,25
	//moedas[15:8] = moedas de R$0,50
	//moedas[23:16] = moedas de R$1,00
	
	reg[1:0] estado_atual;
	reg[7:0] price;
	reg[11:0] cdu;
	reg[7:0] moedas_25,moedas_50,moedas_100;
	reg[23:0] moedas_troco;
	reg[1:0] flag_sem_troco_devolver_dinheiro_inserido
	
	parameter espera=0,start=1,insert_money=2,give_change=3;
	
	//parte combinacional
	always @(posedge clock, negedge reset_n)
		if(~reset_n) begin
			flag_sem_troco_devolver_dinheiro_inserido = 0;
			price = 0;
			carteira = 0;
			valor_troco = 0;
			dinheiro_inserido_c = 0;
			dinheiro_inserido_d = 0;
			dinheiro_inserido_u = 0;
			produto_vendido = 0;
			cdu=0;
			moedas_carteira = 0;
			moedas_troco = 0;
		end
		else
		case(estado_atual)
			espera:begin
				//carteira não é zerada
				flag_sem_troco_devolver_dinheiro_inserido = 0;
				price = 0;
				valor_troco = 0;
				dinheiro_inserido_c = 0;
				dinheiro_inserido_d = 0;
				dinheiro_inserido_u = 0;
				produto_vendido = 0;
				moedas_troco = 0;
				cdu=0;			
			end
			start:begin
				case(produto_escolhido)
					1: begin
						price = 50;
					end
					2: begin
						price = 75;
					end
					3: begin
						price = 100;
					end				
				endcase							
			end			
			insert_money:begin
				cdu = bin2bcd(dinheiro_inserido);
				dinheiro_inserido_c = cdu[11:8];
				dinheiro_inserido_d = cdu[7:4];
				dinheiro_inserido_u = cdu[3:0];
				
				moedas_carteira = moedas_carteira + moedas_inseridas;
			end
			give_change:begin
				if(dinheiro_inserido>price)
				begin
					valor_troco = dinheiro_inserido - price;
					moedas_troco = calcular_moedas_troco(valor_troco,moedas_carteira);
					if(moedas_troco != 0) begin
						moedas_carteira = moedas_carteira - moedas_troco;
						carteira = carteira + price;
						produto_vendido = produto_escolhido;
					end
					else begin
						flag_sem_troco_devolver_dinheiro_inserido = 1;
						valor_troco = dinheiro_inserido;
						moedas_carteira = moedas_carteira - moedas_inseridas;
						moedas_troco = moedas_inseridas;
						produto_vendido = 0;
					end
				end
			end
			default:begin

			end
		endcase
		
	//o comando <= é uma atribuição não bloqueante.
	//significa que todos os lados direitos de todos os <= serão salvos ao entrar na função
	//de forma que se eu quisesse trocar os valores de x e y, poderia escrever
	//x<=y;y<=x
		
	//parte sequencial
	always @(posedge clock, negedge reset_n)
		if(~reset_n) begin 
			estado_atual<=espera;
		end
		//só entra na máquina de estados se
		//o reset_n for zero ao menos uma vez
		else case(estado_atual)
			espera:begin
				if(escolher) estado_atual <= start;
			end
			start:begin
				if(inserir_dinheiro) estado_atual <= insert_money;
			end
			insert_money:begin
				if(dar_troco & (dinheiro_inserido >= price)) 
				estado_atual <= give_change;
			end
			give_change:begin
				if(escolher) estado_atual <= start;
			end
			default:begin
				estado_atual <= espera;
			end
		endcase
		
	function automatic [23:0] calcular_moedas_troco;
		
		input [7:0] troco;
		input [23:0] moedascarteira;
		reg [23:0] moedas;
		reg [3:0] i,j,k;
		
		begin
			for (i = 0; i < moedascarteira[23:16]; i = i+1)
			begin
				for (j = 0; j < moedascarteira[15:8]; j = j+1)
				begin
					for (k = 0; k < moedascarteira[7:0]; k = k+1)
					begin
						if((25*k + 50*j + 100*i) == troco)
						begin
							moedas[7:0] = k;
						    moedas[15:8] = j;
						    moedas[23:16] = i;
							calcular_moedas_troco = moedas;
						end
					end
					k=0;
				end
				j=0;
			end
			calcular_moedas_troco = 0;
		end
	endfunction
		
	function automatic [11:0] bin2bcd;

		input [7:0] bin;
		reg [11:0] bcd; 
		reg [3:0] i;
		
		begin		
			//Double Dabble algorithm
			bcd = 0;
			for (i = 0; i < 8; i = i+1)
			begin
				bcd = {bcd[10:0],bin[7-i]}; //concatenation					
				//if a hex digit of 'bcd' is more than 4, add 3 to it.  
				if(i < 7 && bcd[3:0] > 4) 
					bcd[3:0] = bcd[3:0] + 3;
				if(i < 7 && bcd[7:4] > 4)
					bcd[7:4] = bcd[7:4] + 3;
				if(i < 7 && bcd[11:8] > 4)
					bcd[11:8] = bcd[11:8] + 3;  
			end
			bin2bcd = bcd;
		end
	endfunction

endmodule
