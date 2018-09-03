/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

conta([],0).
conta([_|T],C) :- conta(T,C1), C is C1 + 1. 

conta_elem(_,[],0).
conta_elem(X,[X|T],N) :- conta_elem(X,T,N1), N is N1 + 1.
conta_elem(X,[_|T],N) :- conta_elem(X,T,N).