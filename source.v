module source(x);
output reg x;
 initial begin 
 x=1;
 #10;
 x=0;
 #10;
 x=0;
 #10;
 x=1;
 #10;
 x=1;
 #10;
 x=0;
 #10;
 x=1;
 #10;
 x=0;
 #10;
 end
endmodule