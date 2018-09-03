
:- use_module(library(clpfd)).
:- use_module(library(lists)).

pessoas(P) :-
	domain([Po,Liquido,Nao],1,1000000),
	domain([P],1,3000000),
	
	Po #= 2 * (P / 3),
	Liquido #= 5 * (P / 7),
	Liquido #= 427 - Po,
	Nao #= P / 5,
	
	labeling([],[Po,Liquido,Nao,P]).
	
	