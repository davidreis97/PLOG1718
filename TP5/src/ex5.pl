/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

unificavel([],_,[]).
unificavel([L1X|L1Xs], T, [L1X|L2Xs]) :- \+naoUnifica(L1X,T), !, unificavel(L1Xs, T, L2Xs).
unificavel([_|L1Xs], T, L2) :- unificavel(L1Xs,T,L2).
             
naoUnifica(K,K) :- !, fail.
naoUnifica(_,_).