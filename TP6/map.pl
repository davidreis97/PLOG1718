/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */


map([X|Xs], P, [Y|Ys]) :-
        G =.. [P,X,Y],
        G,
        map(Xs,P,Ys).
map([],_,[]).

/*
        real/1
        integer/1 - Inteiro
        atom/1 - Átomo (a, b, c, ...)
        atomic/1 - Átomo ou Inteiro
        numeric/1 - Inteiro ou Real
*/

g(a).
g(b).
g(1).
g(10).

filtro([],_,[]).
filtro([X|Xs],F,[X|Ys]) :-
         G =.. [F,X],
         G, !,
         filtro(Xs,F,Ys).
filtro([_|Xs],F,Y) :-
         filtro(Xs,F,Y).
   