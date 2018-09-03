/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

/* a) */
membroa(X,[X|_]).
membroa(X,[_|R]) :- membroa(X,R).

/* b) */
membrob(X,L) :- append(_,[X|_],L).

/* c) */
lastc(L,X) :- append(_,[X],L).

/* d) */
nesimo([H|_],1,H).
nesimo([_|T],N,X) :- N1 is N-1, nesimo(T,N1,X).