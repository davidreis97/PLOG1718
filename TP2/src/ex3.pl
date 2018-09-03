/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

/* Regras: */
exec(X,Y) :- p(X,Y).
exec(X,X) :- s(X).

p(X,Y) :- q(X),r(Y).
p(X,Y) :- s(X),r(Y).

/* Factos: */
q(a).
q(b).
r(c).
r(d).
s(e).

