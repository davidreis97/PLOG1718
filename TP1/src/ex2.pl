/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

piloto(lamb).
piloto(besenyei).
piloto(chambliss).
piloto(maclean).
piloto(mangold).
piloto(jones).
piloto(bonhomme).

equipa(breitling, lamb).
equipa(redbull, besenyei).
equipa(redbull, chambliss).
equipa(medracing, maclean).
equipa(cobra, mangold).
equipa(matador, jones).
equipa(madator, bonhomme).

aviao(mx2, lamb).
aviao(edge540, besenyei).
aviao(edge540, chambliss).
aviao(edge540, maclean).
aviao(edge540, mangold).
aviao(edge540, jones).
aviao(edge540, bonhomme).

circuito(istanbul, 9). /* Numero de gates pode ser declarado aqui?? */
circuito(budapest, 6).
circuito(porto, 5).

pilotovencedor(porto, jones).
pilotovencedor(budapest, mangold).
pilotovencedor(istanbul, mangold).

equipavencedora(E,C) :- pilotovencedor(C,P), equipa(E,P).

/* Interrogacoes:
a) pilotovencedor(porto,P).
b) equipavencedora(E,porto).
c) pilotovencedor(C1, P), pilotovencedor(C2, P), C1 \= C2.
d) circuito(C,G), G > 8.
e) aviao(A, P), A \= edge540.
*/











