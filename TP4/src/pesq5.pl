/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

disponibilidade(pedro, [disp(2,4), disp(12,20), disp(25,28)]).
disponibilidade(fernando, [disp(23,30), disp(1,20)]).
disponibilidade(luis, [disp(15,28)]).
disponibilidade(rogerio, [disp(2,5)]).
disponibilidade(paulo, [disp(12,20), disp(25,28)]).
disponibilidade(jorge, [disp(2,7), disp(10,22), disp(23,30), disp(8,9)]).


estaDisponivelHorario(disp(X,Y), K) :- X =< K, Y >= K.
estaDisponivelListaHorario([A|T],K) :- estaDisponivelHorario(A,K); estaDisponivelListaHorario(T,K).
estaDisponivelPessoa(N,D) :- disponibilidade(N,L), estaDisponivelListaHorario(L,D).