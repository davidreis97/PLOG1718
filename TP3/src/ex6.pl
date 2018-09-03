/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

/* a) */
delete_one(X,L1,L2) :- append(B,[X|A],L1), append(B,A,L2).

/* OU 

delete_one(X,[X|Xs],Xs).
delete_one(X,[Y|Xs],[Y|Ys]) :- X \= Y, delete_one(X,Xs,Ys). */

/* b) */
delete_all(_,[],[]).
delete_all(X,[X|Xs],Ys) :- delete_all(X,Xs,Ys).
delete_all(X,[Y|Xs],[Y|Ys]) :- X \= Y, delete_all(X,Xs,Ys).

/* c) */
/*
delete_all_list([],[],[],_).
delete_all_list([X|Xs], [X|L1T], L2) :- delete_all_list([X|Xs], L1T, L2).
delete_all_list([X|Xs], [L1H|L1T], [L1H|L2T]) :- X \= L1H, delete_all_list([X|Xs],L1T,L2T).
*/

delete_all_list([],L,L).
delete_all_list([X|Xs],L1,L2) :- delete_all(X,L1,L3), delete_all_list(Xs,L3,L2).

