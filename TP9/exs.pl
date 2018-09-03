:- use_module(library(clpfd)).

primeiroCarro(CoresTamanhos) :-
    Cores = [C1,C2,C3,C4],
    domain(Cores,1,4),  % 1-Azul, 2-Verde, 3-Azul, 4-Preto
    Tamanhos = [T1,T2,T3,T4], % 1 < 2 < 3 < 4
    domain(Tamanhos,1,4),
    all_different(Cores),
    all_different(Tamanhos),
    %(C2 #= 3 #/\ T1 #< T3) #\/ (C3 #= 3 #/\ T2 #< T4), %HARDCODED; NOT GOOD
    element(PosAzul,Cores,3),
    PosAntesAzul #= PosAzul-1,
    PosDepoisAzul #= PosAzul+1,
    element(PosAntesAzul,Tamanhos,TamanhoAntesAzul),
    element(PosDepoisAzul,Tamanhos,TamanhoDepoisAzul),
    TamanhoAntesAzul #< TamanhoDepoisAzul,
    element(PosVerde,Cores,2),
    element(PosVerde,Tamanhos,1),
    PosVerde #> PosAzul,
    element(PosAmarelo,Cores,1),
    element(PosPreto,Cores,4),
    PosAmarelo #> PosPreto,
    append(Cores,Tamanhos,CoresTamanhos),
    labeling([],CoresTamanhos).

primeiroCarroDominio(CoresTamanhos) :-
    Cores = [Amarelo,Azul,Preto,Verde], % 1-Posicao do Amarelo, 2-Posicao do Azul, 3-Posicao do Preto, 4-Posicao do Verde
    domain(Cores,1,4),
    Tamanhos = [Pos1,Pos2,Pos3,Pos4], % 1-Posicao do 1, 2-Posicao do 2, 3-Posicao do 3, 4-Posicao do 4
    domain(Tamanhos,1,4),
    all_different(Cores),
    all_different(Tamanhos),
    PosDpsAzul #= Azul + 1,
    PosAntAzul #= Azul - 1,
    element(TamAntAzul,Tamanhos,PosAntAzul),
    element(TamDpsAzul,Tamanhos,PosDpsAzul),
    TamAntAzul #< TamDpsAzul,
    element(TamVerde, Tamanhos, Verde),
    TamVerde #= 1,
    Verde #> Azul,
    Amarelo #> Preto,
    append(Cores,Tamanhos,CoresTamanhos),
    labeling([],CoresTamanhos).

dozeCarros(Carros) :-
    length(Carros, 12),
    domain(Carros,1,4), %1-Amarelo 2-Verde 3-Vermelho 4-Azul
    count(1,Carros,#=,4), % Deprecated - Use global_cardinality(Cores,[1-4,2-2,3-3,4-3,%%%%%Chave-NumOcorrencias%%%%%%]).
    count(2,Carros,#=,2),
    count(3,Carros,#=,3),
    count(4,Carros,#=,3),
    element(1,Carros,COR1),
    element(12,Carros,COR1),
    element(2,Carros,COR2),
    element(11,Carros,COR2),
    element(5,Carros,4),
    trios(Carros),
    quadras(Carros,M),
    count(1,M,#=,1),
    labeling([],Carros),
    print(Carros).

quadras([A,B,C,D|R],[M|Ms]) :- 
    A #= 1 #/\ B #= 2 #/\ C #= 3 #/\ D #= 4 #<=> M, % #<=> -> Variavel M é 1 se valor logico for 1 e 0 se o valor logico for 0
    quadras([B,C,D|R],Ms).
quadras([_,_,_],[]).


trios([A,B,C|R]) :-
    all_different([A,B,C]),
    trios([B,C|R]).
trios([_,_]).




    