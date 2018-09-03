/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

potencia(_,0,1).
potencia(N,P,R) :- P > 0, P1 is P-1, potencia(N,P1,R1), R is R1*N.

list_to_term([],_).
list_to_term([H|T],X) :- list_to_term(T,H+X).

taller(bob,mike).
taller(mike,jim).
taller(jim,george).

taller(A,B) :- taller(A,C), taller(C,B).


factorial(0,1).
factorial(N,R) :- N1 is N-1, factorial(N1,R1), R is N*R1.