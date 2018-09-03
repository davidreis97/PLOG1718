/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

a.

homem(joao).
homem(david).
homem(pedro).
homem(augusto).
homem(filipe).
homem(serra).
homem(toze).

mulher(lina).
mulher(mariana).
mulher(silvia).
mulher(ana).
mulher(ines).
mulher(mafalda).
mulher(leonor).
mulher(augusta).

pais(toze,ana,ines).
pais(serra,lina,filipe).
pais(serra,lina,ana).
pais(augusto,augusta, lina).
pais(augusto,augusta, silvia).
pais(pedro,silvia,david).
pais(pedro,silvia,mariana).
pais(filipe,leonor,mafalda).

pai(P,F) :- pais(P,_,F). /* P é pai de F SE houver pais(P,*qualquer mae*,F) */
pai(P) :- pais(P,_,_). /* P é pai se houver pais(P,*qualquer mae*, *qualquer filho*) */

mae(M,F) :- pais(_,M,F).
mae(M) :- pais(_,M,_).

filho(X, F) :- pai(X,F), homem(F).
filho(X, F) :- mae(X,F), homem(F). /* X tanto pode ser pai como mae, logo inserem-se duas cenas, se uma nao der dá a segunda*/

filha(X, F) :- pai(X,F), mulher(F).
filha(X, F) :- mae(X,F), mulher(F).
        
irmao(F1, F2) :- pais(P,M,F1), pais(P,M,F2), homem(F1), F1 \= F2. /*F1 e irmao de F2*/
irma(F1, F2) :- pais(P,M,F1), pais(P,M,F2), mulher(F1), F1 \= F2. /*F1 e irma de F2*/

irmaos(F1, F2) :- pais(P,M,F1), pais(P,M,F2), F1 \= F2, homem(F1). /*Um deles precisa de ser homem (senao sao irmas, e nao irmaos)*/
irmaos(F1, F2) :- pais(P,M,F1), pais(P,M,F2), F1 \= F2, homem(F2).

avom(AM,F) :- mae(AM,P), pai(P,F).
avom(AM,F) :- mae(AM,M), mae(M,F).

avoh(AH,F) :- pai(AH,P), pai(P,F).
avoh(AH,F) :- pai(AH,M), mae(M,F).

bisavoh(BH, F) :- pai(BH,AH), avoh(AH,F).
bisavoh(BH, F) :- pai(BH,AM), avom(AM,F).

bisavom(BM, F) :- mae(BM,AH), avoh(AH,F).
bisavom(BM, F) :- mae(BM,AM), avom(AM,F).

tio(TH,F) :- irmao(TH,P), pai(P,F).
tio(TH,F) :- irmao(TH,M), mae(M,F).

tia(TM,F) :- irma(TM,P), pai(P,F).
tia(TM,F) :- irma(TM,M), mae(M,F).

sobrinho(S, F) :- tio(F, S), homem(S).
sobrinho(S, F) :- tia(F, S), homem(S).

sobrinha(S, F) :- tio(F, S), mulher(S).
sobrinha(S, F) :- tia(F, S), mulher(S).

antepassado(A, D) :- pai(A,D) ; mae(A,D). /* ; = ou */
antepassado(A, D) :- (pai(A,F) ; mae(A,F)),  antepassado(F,D). /* ATENCAO: Sem ponto e virgula, prolog identifica a segunda clausula como o resto da linha (incluindo antepassado()) */







