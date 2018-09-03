
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X+2, YNovo is Y-1.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X+2, YNovo is Y+1.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X-2, YNovo is Y-1.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X-2, YNovo is Y+1.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X+1, YNovo is Y+2.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X-1, YNovo is Y+2.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X+1, YNovo is Y-2.
possibleMove(X/Y,XNovo/YNovo) :-
    XNovo is X-1, YNovo is Y-2.

validMove(X/Y) :-  
    X > 0, X < 9,
    Y > 0, Y < 9.

move(X/Y,Celulas):-
    findall(XNovo/YNovo,(possibleMove(X/Y,XNovo/YNovo),validMove(XNovo/YNovo)),Celulas).

podeMoverEmN(X/Y,N,Celulas):-
    podeMoverLista([X/Y],N,Possible),
    once(select(X/Y,Possible,PossibleNoInitial)), %Remove uma instancia de X/Y originais - caso apenas seja o inicial sera removido
    sort(PossibleNoInitial,Celulas). %Remove repetidos, afeta a ordem mas neste caso a ordem nao é relevante.

moveList([],Moves,Moves).
moveList([X/Y|Xs],CurrMoves,FinMoves) :-
    move(X/Y,Celulas),
    append(CurrMoves,Celulas,NextMoves),
    moveList(Xs,NextMoves,FinMoves).

podeMoverLista(Celulas,0,Celulas).
podeMoverLista(Pos, N, Celulas) :-
    N > 0,
    moveList(Pos,[],Moves),
    append(Pos,Moves,NewList),
    NewN is N-1,
    podeMoverLista(NewList,NewN,Celulas).

minJogadas(Xi/Yi,Xf/Yf,N) :-
    podeMoverEmN(Xi/Yi,N,Celulas),
    member(Xf/Yf,Celulas),!.
