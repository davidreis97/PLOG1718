/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */


achata_lista([],[]).
achata_lista([X|Xs],L) :- achata_lista(X,L1), achata_lista(Xs,L2), append(L1,L2,L), !.
achata_lista(X,[X|_]).

break_me(A,B) :- break_me(A,B).