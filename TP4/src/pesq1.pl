/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */


ligado(a,b,1).
ligado(a,c,5).
ligado(b,d,3).
ligado(b,e,2).
ligado(b,f,5).
ligado(c,g,3).
ligado(d,h,123).
ligado(d,i,4).
ligado(f,i,0).
ligado(f,j,76).
ligado(f,k,34).
ligado(g,l,12).
ligado(g,m,3).
ligado(k,34).
ligado(l,o,3).
ligado(i,f,10).

caminho(I,F,[F]) :- ligado(I,F).
caminho(I,F,[K|T]) :- ligado(I,K), I \= F, caminho(K,F,T).