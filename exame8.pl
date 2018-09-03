:- use_module(library(clpfd)).
:- use_module(library(lists)).

squareTable(Lugares,NumCadeiras,Juntas,Separadas) :-
	domain(Lugares,1,NumCadeiras),
	
	all_distinct(Lugares),
	
	mustBeTogether(Juntas),
	mustBeSeparated(Separadas),
	
	labeling([],Lugares).
	
%  246
%  ---
% 1| |8
%  ---
%  357

mustBeTogether([]).
mustBeTogether([J1-J2|RJ]):-
	(J2 - J1 #=< 2 #/\ J2 - J1 #> 0) #\/ (J1 - J2 #=< 2 #/\ J1 - J2 #> 0),
	mustBeTogether(RJ).
	
mustBeSeparated([]).
mustBeSeparated([J1-J2|RJ]):-
	(J2 - J1 #> 2 #\/ J2 - J1 #< 0) #/\ (J1 - J2 #> 2 #\/ J1 - J2 #< 0),
	mustBeSeparated(RJ).
	
	
%  	BEF
%   ---
% A|   |G
%   ---
%   DCH