/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

before(M1,M2,L) :- append(_,[M1|L1],L),
                   append(_,[M2|_],L1).
