/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

dados(um).
dados(dois).
dados(tres).

cut_teste_a(X) :-
      dados(X).
cut_teste_a('ultima_clausula').

cut_teste_a(X) :-
      dados(X), !.
cut_teste_a('ultima_clausula').

cut_teste_c(X,Y) :-
      dados(X),
      !,
      dados(Y).
cut_teste_c('ultima_clausula').