/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

max(X, Y, Z, X):- X>=Y, X>=Z, !.
max(_, Y, Z, Y):- /*Y>=X,*/ Y>=Z, !. /*Unnecessary*/
max(_, _, Z, Z).