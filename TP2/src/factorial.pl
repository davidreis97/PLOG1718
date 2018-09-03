/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

/* N is 3-1 --Operador "is" faz o calculo da expressao do lado direito e unifica com o lado esquerdo */ 
factorial(0,1). /*Fatorial de 0 é 1*/
factorial(N,F) :- N > 0, N1 is N-1, factorial(N1, F1), F is N * F1. /*factorial(3,F) funciona, mas factorial(F,3) ja nao, pois ele tenta fazer F-1 atraves do "is"*/
