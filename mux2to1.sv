module mux2to1 (Y,S,I0,I1);
	input I0,I1,S;
	output Y;
	logic a,b,c;
	or(Y,b,c);
	and(b,a,I0);
	and(c,S,I1);
	not(a,S);
endmodule
