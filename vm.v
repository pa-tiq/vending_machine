module vm(escolher,inserir_dinheiro,dar_troco,
produto_escolhido, dinheiro_inserido, produto_vendido,
carteira,valor_troco,dinheiro_inserido_c, dinheiro_inserido_d,
dinheiro_inserido_u, reset_n,clock,  moedas_inseridas_25, moedas_inseridas_50, 
moedas_inseridas_100, moedas_carteira_25, moedas_carteira_50, moedas_carteira_100);

	input[1:0] escolher, inserir_dinheiro, dar_troco;
	input[7:0] produto_escolhido, dinheiro_inserido;
	input reset_n;
	input clock;
	output reg[7:0] produto_vendido, carteira, valor_troco;
	output reg[3:0]	dinheiro_inserido_c, dinheiro_inserido_d, dinheiro_inserido_u;
	
	input[7:0] moedas_inseridas_25, moedas_inseridas_50, moedas_inseridas_100;
	output reg[7:0] moedas_carteira_25, moedas_carteira_50, moedas_carteira_100;
	
	reg[1:0] estado_atual;
	reg[7:0] price;
	reg[11:0] cdu;
	reg[7:0] moedas_troco_25,moedas_troco_50,moedas_troco_100;
	reg[23:0] troco_calculado;
	reg[1:0] flag_sem_troco_devolver_dinheiro_inserido;
	reg[1:0] flag_dinheiro_insuficiente;	
	reg[1:0] executou_start, executou_insert_money, executou_give_change;
	
	
	
	parameter espera=0,start=1,insert_money=2,give_change=3;
	
	//parte combinacional
	always @(posedge clock, negedge reset_n)
		if(~reset_n) begin
			flag_dinheiro_insuficiente = 0;
			flag_sem_troco_devolver_dinheiro_inserido = 0;
			price = 0;
			carteira = 0;
			valor_troco = 0;
			dinheiro_inserido_c = 0;
			dinheiro_inserido_d = 0;
			dinheiro_inserido_u = 0;
			produto_vendido = 0;
			cdu=0;
			moedas_carteira_25 = 0;
			moedas_carteira_50 = 0;
			moedas_carteira_100 = 0;
			moedas_troco_25 = 0;
			moedas_troco_50 = 0;
			moedas_troco_100 = 0;
			executou_start = 0;
			executou_insert_money = 0;
			executou_give_change = 0;
		end
		else
		case(estado_atual)
			espera:begin
				//carteira não é zerada
				flag_dinheiro_insuficiente = 0;
				flag_sem_troco_devolver_dinheiro_inserido = 0;
				price = 0;
				valor_troco = 0;
				dinheiro_inserido_c = 0;
				dinheiro_inserido_d = 0;
				dinheiro_inserido_u = 0;
				produto_vendido = 0;
				moedas_troco_25 = 0;
				moedas_troco_50 = 0;
				moedas_troco_100 = 0;
				cdu=0;	
				executou_start = 0;
				executou_insert_money = 0;
				executou_give_change = 0;				
			end
			start:begin
				if(!executou_start) begin
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
				executou_start = 1;
			end			
			insert_money:begin
				if(!executou_insert_money) begin
					cdu = bin2bcd(dinheiro_inserido);
					dinheiro_inserido_c = cdu[11:8];
					dinheiro_inserido_d = cdu[7:4];
					dinheiro_inserido_u = cdu[3:0];
					moedas_carteira_25 = moedas_carteira_25 + moedas_inseridas_25;
					moedas_carteira_50 = moedas_carteira_50 + moedas_inseridas_50;
					moedas_carteira_100 = moedas_carteira_100 + moedas_inseridas_100;
					valor_troco = dinheiro_inserido - price;
				end
				executou_insert_money = 1;
			end
			give_change:begin
				if(!executou_give_change) begin
					if(dinheiro_inserido>=price) begin				
						valor_troco = dinheiro_inserido - price;
						if(valor_troco>0)begin
							troco_calculado = calcular_moedas_troco(valor_troco,moedas_carteira_25,
												moedas_carteira_50,moedas_carteira_100);
							moedas_troco_25 = troco_calculado[7:0];
							moedas_troco_50 = troco_calculado[15:8];
							moedas_troco_100 = troco_calculado[23:16];
						end
						if(moedas_troco_25 != 0 || moedas_troco_50 != 0 || moedas_troco_100 != 0) begin
							moedas_carteira_25 = moedas_carteira_25 - moedas_troco_25;
							moedas_carteira_50 = moedas_carteira_50 - moedas_troco_50;
							moedas_carteira_100 = moedas_carteira_100 - moedas_troco_100;
							carteira = carteira + price;
							produto_vendido = produto_escolhido;
						end
						else begin
							flag_sem_troco_devolver_dinheiro_inserido = 1;
							valor_troco = dinheiro_inserido;
							moedas_carteira_25 = moedas_carteira_25 - moedas_inseridas_25;
							moedas_carteira_50 = moedas_carteira_50 - moedas_inseridas_50;
							moedas_carteira_100 = moedas_carteira_100 - moedas_inseridas_100;
							moedas_troco_25 = moedas_inseridas_25;
							moedas_troco_50 = moedas_inseridas_50;
							moedas_troco_100 = moedas_inseridas_100;
							produto_vendido = 0;
						end
					end
					else begin
						flag_dinheiro_insuficiente = 1;
						valor_troco = dinheiro_inserido;
						moedas_carteira_25 = moedas_carteira_25 - moedas_inseridas_25;
						moedas_carteira_50 = moedas_carteira_50 - moedas_inseridas_50;
						moedas_carteira_100 = moedas_carteira_100 - moedas_inseridas_100;
						moedas_troco_25 = moedas_inseridas_25;
						moedas_troco_50 = moedas_inseridas_50;
						moedas_troco_100 = moedas_inseridas_100;
						produto_vendido = 0;
					end
				end
				executou_give_change = 1;
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
		else begin
			case(estado_atual)
				espera:begin
					if(escolher) estado_atual <= start;
				end
				start:begin
					if(inserir_dinheiro && executou_start) estado_atual <= insert_money;
				end
				insert_money:begin
					if(dar_troco && executou_insert_money) estado_atual <= give_change;
				end
				give_change:begin
					if(escolher && executou_give_change) estado_atual <= espera;
				end
				default:begin
					estado_atual <= espera;
				end
			endcase
		end
		
	function automatic [23:0] calcular_moedas_troco;
		
		input [7:0] troco;
		input [7:0] moedas_25;
		input [7:0] moedas_50;
		input [7:0] moedas_100;
		reg [23:0] moedas;
		reg [3:0] i,j,k;
		reg [1:0] sair;
		
		begin
			sair = 0;
			for (i = 0; i <= moedas_100; i = i+1)
			begin
				for (j = 0; j <= moedas_50; j = j+1)
				begin
					for (k = 0; k <= moedas_25; k = k+1)
					begin
						if((25*k + 50*j + 100*i) == troco)
						begin
							moedas[7:0] = k;
						    moedas[15:8] = j;
						    moedas[23:16] = i;
							calcular_moedas_troco = moedas;
							i = moedas_100+1;
							j = moedas_50+1;
							k = moedas_25+1;
							sair = 1;
						end
					end
					if(!sair)k=0;
				end
				if(!sair)k=0;
				if(!sair)j=0;
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
