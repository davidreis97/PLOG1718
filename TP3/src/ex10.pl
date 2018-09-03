/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

ordenada([_|[]]).
ordenada([A|[B|T]]) :- A < B, ordenada([B|T]).

substitui(X,Y,[X|T],[Y|T]).
substitui(X,Y,[Z|T],[Z|T1]) :- X\=Z, substitui(X,Y,T,T1).


ordena(L1,L2) :- ordena(L1,[],L2).

bubble_sort(List,Sorted):-b_sort(List,[],Sorted).
b_sort([],Acc,Acc).
b_sort([H|T],Acc,Sorted):-bubble(H,T,NT,Max),b_sort(NT,[Max|Acc],Sorted).
   
bubble(X,[],[],X).
bubble(X,[Y|T],[Y|NT],Max):-X>Y,bubble(X,T,NT,Max).
bubble(X,[Y|T],[X|NT],Max):-X=<Y,bubble(Y,T,NT,Max).