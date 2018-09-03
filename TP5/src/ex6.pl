/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

not(X) :- X, !, fail. /*!,fail aparece varias vezes como not*/
not(_). 

imaturo(X):- adulto(X), !, fail.
imaturo(_).
     
adulto(X):- pessoa(X), !, idade(X, N), N>=18.
adulto(X):- tartaruga(X), !, idade(X, N), N>=50.

teste(adolfo).

caralhao(porco).

test_repeat(X) :-
        repeat,
                read(X),
                write(X),
                teste(X), !,
                caralhao(X).
        
        