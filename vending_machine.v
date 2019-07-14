module vending_machine(
//escolher,inserir_dinheiro,dar_troco,
//produto_escolhido, dinheiro_inserido, 
produto_vendido,carteira,valor_troco,
dinheiro_inserido_c, dinheiro_inserido_d,dinheiro_inserido_u, 
clock,  
//moedas_inseridas_25, moedas_inseridas_50,moedas_inseridas_100, 
moedas_carteira_25, moedas_carteira_50, moedas_carteira_100,
KEY, SW, LEDR, HEX5,HEX4,HEX3,HEX2, HEX1, HEX0);
	
	input [0:2] KEY;
	output [0:9] LEDR;
	output [0:6] HEX5,HEX4,HEX3,HEX2, HEX1, HEX0;
	input [0:9] SW;
	
	assign LEDR = SW;
	
	reg[1:0] escolher, inserir_dinheiro, dar_troco;
	reg[7:0] produto_escolhido, dinheiro_inserido;
	input clock;
	output reg[7:0] produto_vendido, carteira, valor_troco;
	output reg[3:0] dinheiro_inserido_c, dinheiro_inserido_d, dinheiro_inserido_u;
	
	reg[7:0] moedas_inseridas_25, moedas_inseridas_50, moedas_inseridas_100;
	output reg[7:0] moedas_carteira_25, moedas_carteira_50, moedas_carteira_100;
	
	reg[3:0] estado_atual;
	reg[7:0] price;
	reg[11:0] cdu;
	reg[7:0] moedas_troco_25,moedas_troco_50,moedas_troco_100;
	reg[23:0] troco_calculado;
	reg[1:0] flag_sem_troco_devolver_dinheiro_inserido;
	reg[1:0] flag_dinheiro_insuficiente;
	reg[3:0] flag_um_de_cada_vez;
	reg[3:0] executou_select, executou_insert_money, executou_give_change, executou_show;
	reg[3:0] bcd1,bcd2,bcd3, bcdstate, bcd4,bcd5;
	reg[1:0] key0;
	
	parameter espera=0,select=1,insert_money=2,give_change=3,show=4;
	
	always @(estado_atual)
	begin
		case(estado_atual)
			0: bcdstate=4'hF;
			1: bcdstate=4'h1;
			2: bcdstate=4'h2;
			3: bcdstate=4'h3;
			4: bcdstate=4'h4;
			default:bcdstate=4'hF;
		endcase
	end
	
	always @(posedge clock)
	begin	//se KEY[0] é pressionado, ele fica igual a zero
		if(KEY[0] == 0) key0 = 1;
		else key0=0;
		
		if(key0==1) bcd4 = 4'h1;
		else bcd4 = 4'h0;
	end
	
	//parte combinacional
	always @(posedge clock)
	begin
		if(SW[9]==0) begin
			flag_dinheiro_insuficiente = 0;
			flag_sem_troco_devolver_dinheiro_inserido = 0;
			flag_um_de_cada_vez = 0;
			price = 0;
			carteira = 0;
			valor_troco = 0;
			dinheiro_inserido_c = 0;
			dinheiro_inserido_d = 0;
			dinheiro_inserido_u = 0;
			produto_vendido = 0;
			produto_escolhido = 0;
			cdu=0;
			moedas_carteira_25 = 0;
			moedas_carteira_50 = 0;
			moedas_carteira_100 = 0;
			moedas_troco_25 = 0;
			moedas_troco_50 = 0;
			moedas_troco_100 = 0;
			executou_select = 0;
			executou_insert_money = 0;
			executou_give_change = 0;
			executou_show=0;
			troco_calculado = 0;
			bcd1=4'h0;bcd2=4'h0;bcd3=4'h0; bcd5=4'h0;
			estado_atual = 0;
		end
		else
		case(estado_atual)
			espera:begin				
				//carteira não é zerada
				flag_dinheiro_insuficiente = 0;
				flag_sem_troco_devolver_dinheiro_inserido = 0;
				flag_um_de_cada_vez = 0;
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
				executou_select = 0;
				executou_insert_money = 0;
				executou_give_change = 0;	
				executou_show=0;
				troco_calculado = 0;
				dinheiro_inserido = 0;
				moedas_inseridas_25 = 0;
				moedas_inseridas_50 = 0;
				moedas_inseridas_100 = 0;
				escolher = 0;
				inserir_dinheiro = 0;
				dar_troco = 0;
				if(key0 == 1)escolher = escolher + 1;
				
				if(escolher > 0) begin
					estado_atual = select;
					bcd5 = 4'h1;
				end
			end
			select:begin
				if(key0 == 1 && produto_escolhido != 0)begin
					executou_select = executou_select + 1;
					bcd1 = 4'h0;
					bcd2 = 4'h0;
					bcd3 = 4'h0;
					bcd5 = 4'h2;
				end
				
				if(executou_select == 0)begin				
					if(SW[0]==1) produto_escolhido = 1;
					if(SW[1]==1) produto_escolhido = 2;
					if(SW[2]==1) produto_escolhido = 3;		
					
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
					cdu = bin2bcd(price);
					if(price > 99) bcd1 = cdu[11:8];
					else bcd1 = 4'h0;
					if(price > 9) bcd2 = cdu[7:4];
					else bcd2 = 4'h0;
					if(price > 0) bcd3 = cdu[3:0];
					else bcd2 = 4'h0;
				end
				
				if(executou_select > 0) begin
					escolher = 0;
					inserir_dinheiro = 1;
					dar_troco = 0;
				end
				
				if(inserir_dinheiro == 1 && executou_select > 0) estado_atual = insert_money;
			
			end			
			insert_money:begin
				if(key0 == 1 && dinheiro_inserido!=0) begin
					executou_insert_money = executou_insert_money + 1;
					bcd1 = 4'h0;
					bcd2 = 4'h0;
					bcd3 = 4'h0;
					bcd5 = 4'h4;
				end
				
				if(executou_insert_money == 0)
				begin					
					case(flag_um_de_cada_vez)
						1: if(SW[0] == 0) flag_um_de_cada_vez = 0;
						2: if(SW[1] == 0) flag_um_de_cada_vez = 0;
						3: if(SW[2] == 0) flag_um_de_cada_vez = 0;
						8: if(SW[8] == 0) flag_um_de_cada_vez = 0;
						0:	begin
								if(SW[0] == 1) begin
									dinheiro_inserido = dinheiro_inserido + 25;
									moedas_inseridas_25 = moedas_inseridas_25+1;
									flag_um_de_cada_vez = 1;
								end
								if(SW[1] == 1) begin
									dinheiro_inserido = dinheiro_inserido + 50;
									moedas_inseridas_50 = moedas_inseridas_50+1;
									flag_um_de_cada_vez = 2;
								end
								if(SW[2] == 1) begin
									dinheiro_inserido = dinheiro_inserido + 100;
									moedas_inseridas_100 = moedas_inseridas_100+1;
									flag_um_de_cada_vez = 3;
								end
								if(SW[8] == 1) begin
									dinheiro_inserido = 0;
									moedas_inseridas_25 = 0;
									moedas_inseridas_50 = 0;
									moedas_inseridas_100 = 0;
									moedas_carteira_25 = 0;
									moedas_carteira_50 = 0;
									moedas_carteira_100 = 0;
									bcd1 = 4'h0;
									bcd2 = 4'h0;
									bcd3 = 4'h0;
									flag_um_de_cada_vez = 8;
								end
							end
						default: flag_um_de_cada_vez = 0;
					endcase
					
					if(SW[0]==0&&SW[1]==0&&SW[2]==0&&SW[8]==0)flag_um_de_cada_vez=0;
					
					if(dinheiro_inserido > 0)
					begin
						bcd5 = 4'h3;
						cdu = bin2bcd(dinheiro_inserido);
						bcd1 = cdu[11:8];
						bcd2 = cdu[7:4];
						bcd3 = cdu[3:0];
						
						dinheiro_inserido_c = cdu[11:8];
						dinheiro_inserido_d = cdu[7:4];
						dinheiro_inserido_u = cdu[3:0];

						moedas_carteira_25 = moedas_carteira_25 + moedas_inseridas_25;
						moedas_carteira_50 = moedas_carteira_50 + moedas_inseridas_50;
						moedas_carteira_100 = moedas_carteira_100 + moedas_inseridas_100;
						
						moedas_inseridas_25 = 0;
						moedas_inseridas_50 = 0;
						moedas_inseridas_100 = 0;
					end
				end
				
				if(executou_insert_money > 0 && key0==0) begin
					escolher = 0;
					inserir_dinheiro = 0;
					dar_troco = 1;
				end
				
				if(dar_troco == 1 && executou_insert_money > 0) estado_atual = give_change;
				
			end
			give_change:begin				
				if(executou_give_change>0 && flag_dinheiro_insuficiente == 0 &&
					flag_sem_troco_devolver_dinheiro_inserido == 0) bcd5 = 4'h5;
				
				if(key0 == 1 && executou_give_change > 0) begin
					executou_give_change = executou_give_change + 1;
					bcd5 = 4'h7;
				end
				
				if(executou_give_change>0) begin
					if(SW[8]==1)
					begin
						if(flag_dinheiro_insuficiente==0 &&
							flag_sem_troco_devolver_dinheiro_inserido==0) bcd5 = 4'h6;
						bcd1 = moedas_troco_25[3:0];
						bcd2 = moedas_troco_50[3:0];
						bcd3 = moedas_troco_100[3:0];
					end
					else begin
						cdu = bin2bcd(valor_troco);
						bcd1 = cdu[11:8];
						bcd2 = cdu[7:4];
						bcd3 = cdu[3:0];
					end
				end

				if(executou_give_change == 0)
				begin
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
							bcd5 = 4'hE;
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
						bcd5 = 4'hE;
						valor_troco = dinheiro_inserido;
						moedas_carteira_25 = moedas_carteira_25 - moedas_inseridas_25;
						moedas_carteira_50 = moedas_carteira_50 - moedas_inseridas_50;
						moedas_carteira_100 = moedas_carteira_100 - moedas_inseridas_100;
						moedas_troco_25 = moedas_inseridas_25;
						moedas_troco_50 = moedas_inseridas_50;
						moedas_troco_100 = moedas_inseridas_100;
						produto_vendido = 0;
					end					
					executou_give_change = executou_give_change+1;					
				end
				
				if(executou_give_change > 2 && key0==0) begin
					bcd1 = 4'h0;
					bcd2 = 4'h0;
					bcd3 = 4'h0;
					escolher=1;
					inserir_dinheiro = 0;
					dar_troco = 0;
				end
				
				if(escolher == 1) estado_atual = show;
				
			end
			show:begin
			
				bcd5 = 4'h7;
				cdu = bin2bcd(carteira);
				bcd1 = cdu[11:8];
				bcd2 = cdu[7:4];
				bcd3 = cdu[3:0];
				
				if(key0==1 && executou_show==0)
				begin
					executou_show = executou_show + 1;
				end
				
				if(key0==0 && executou_show>0)
				begin
					executou_show = executou_show + 1;
				end
				
				if(executou_show>1)
				begin
					estado_atual = espera;
				end
			
			end
			default:begin
				estado_atual = espera;
			end
		endcase		
	end
	
	bcd7seg digit5 (bcd5, HEX5);
	bcd7seg digit4 (bcd4, HEX4);
	bcd7seg digit3 (bcdstate, HEX3);
	bcd7seg digit2 (bcd1, HEX2);
	bcd7seg digit1 (bcd2, HEX1);
	bcd7seg digit0 (bcd3, HEX0);
	
		
	//o comando <= é uma atribuição não bloqueante.
	//significa que todos os lados direitos de todos os <= serão salvos ao entrar na função
	//de forma que se eu quisesse trocar os valores de x e y, poderia escrever
	//x<=y;y<=x
		
	//parte sequencial
	//always @(posedge clock)
	//	if(KEY[0]) begin 
	//		estado_atual<=espera;
	//	end
	//	//só entra na máquina de estados se
	//	//o reset_n for zero ao menos uma vez
	//	else begin
	//		case(estado_atual)
	//			espera:begin
	//				if(escolher) estado_atual <= select;
	//			end
	//			select:begin
	//				if(inserir_dinheiro && executou_select) estado_atual <= insert_money;
	//			end
	//			insert_money:begin
	//				if(dar_troco && executou_insert_money) estado_atual <= give_change;
	//			end
	//			give_change:begin
	//				if(escolher && executou_give_change) estado_atual <= espera;
	//			end
	//			default:begin
	//				estado_atual <= espera;
	//			end
	//		endcase
	//	end
		
	function automatic [23:0] calcular_moedas_troco;
		
		input [7:0] valor_troco;
		input [7:0] moedas_25;
		input [7:0] moedas_50;
		input [7:0] moedas_100;
		reg [23:0] moedas;
		reg [3:0] i,j,k;
		reg [1:0] sair;
		
		begin
			i = 0;
			j = 0;
			k = 0;
			sair = 0;
			moedas = 0;			
			if(moedas_25>0 || moedas_50>0 || moedas_100>0) begin			
				repeat(10) begin
					if( i*100 < valor_troco && moedas_100 > 0) begin
						i = i + 1;
					end
					if( i*100 > valor_troco) begin
						i = i - 1;
					end
				end
				if(i*100 < valor_troco)	begin
					repeat(10) begin
						if((i*100+j*50) < valor_troco && moedas_50>0) begin
							j = j + 1;
						end
						if((i*100+j*50) > valor_troco) begin
							j = j - 1;
						end
					end
					if((i*100+j*50) < valor_troco)begin
						repeat(10) begin
							if((i*100+j*50+k*25) < valor_troco && moedas_25>0) begin
								k = k + 1;
							end
							if((i*100+j*50+k*25) > valor_troco) begin
								k = k - 1;
							end
						end
					end
				end
				if((i*100+j*50+k*25) == valor_troco) begin
					moedas[7:0] = k;
					moedas[15:8] = j;
					moedas[23:16] = i;
				end
			end
			calcular_moedas_troco = moedas;
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
			4'hE: display = 7'b1000101;
			default: display = 7'b1111111;
		endcase
endmodule
