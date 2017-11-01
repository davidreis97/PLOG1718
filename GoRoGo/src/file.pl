/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

initBoard([[1,2,1,0,0],
           [3,0,3,0,0],
           [0,2,0,0,1],
           [2,1,2,0,0],
           [0,2,1,3,0]]).

/*
  0- Empty Space
  1- White Piece
  2- Black Piece
  3- Mixed Piece
*/

/*
        TODO:
        - No need to check the whole board for removed pieces, just check the 4 surrounding positions. (Helps with UI as well)
*/

playerInput(0,PlayerNo,Est,Linha,Coluna,Tipo). /* Player controlled move decision */

playerInput(1,PlayerNo,Est,Linha,Coluna,Tipo) :- /* CPU controlled move decision */
        

play(Player1,Player2,Board,EatenPieces) :- /*0 if Player controlled, 1 if AI*/
        playerInput(Player1,1,Board,Linha1,Coluna1,Tipo1),
        movePlayer(Linha1,Coluna1, Board, Board1, Tipo1), /* Assumes success in movePlayer */
        removeEaten(0,0,Board1,Board2,EatenPieces,EatenPieces1),
        printBoard(Board2),
        playerInput(Player2,1,Board2,Linha2,Coluna2,Tipo2),
        movePlayer(Linha2,Coluna2, Board2, Board3, Tipo2), /* Assumes success in movePlayer */
        removeEaten(0,0,Board3,Board4,EatenPieces1,EatenPieces2),
        printBoard(Board4),
        play(Player1,Player2,Board4,EatenPieces2). /* Check victory conditions */


printBoardLine([]) :- 
        print('|').
printBoardLine([0|R]) :-
        print('|'),
        print(' '),
        printBoardLine(R).
printBoardLine([1|R]) :-
        print('|'), 
        print('W'),
        printBoardLine(R).
printBoardLine([2|R]) :-
        print('|'), 
        print('B'),
        printBoardLine(R).
printBoardLine([3|R]) :-
        print('|'), 
        print('M'),
        printBoardLine(R).

printBoard([]) :- print('-----------').
printBoard([L|R]) :-
        print('-----------'),
        print('\n'),
        printBoardLine(L),
        print('\n'),
        printBoard(R).

/*
  Fornecido pelo prof na aula teorica a 4/10
*/
replace(Old,New,[Old|Rest],[New|Rest]).
replace(Old,New,[Some|Rest1],[Some|Rest2]) :- 
        Old \= Some, replace(Old,New,Rest1,Rest2).

removePiece(0,0,[[_|LR]|R],[[0|LR]|R]).
removePiece(0, Coluna, [[L|LR]|R], [[L|LR1]|R1]) :-
        Coluna \= 0,
        ColunaNova is Coluna-1,
        removePiece(0, ColunaNova, [LR|R], [LR1|R1]).
removePiece(Linha,Coluna,[L|R],[L|R1]) :-
        Linha \= 0,
        LinhaNova is Linha-1,
        removePiece(LinhaNova,Coluna,R,R1).

movePlayer(0,0,[[0|LR]|R],[[Tipo|LR]|R], Tipo). /* Add check if surrounded */
movePlayer(0, Coluna, [[L|LR]|R], [[L|LR1]|R1], Tipo) :-
        Coluna \= 0,
        ColunaNova is Coluna-1,
        movePlayer(0, ColunaNova, [LR|R], [LR1|R1], Tipo).
movePlayer(Linha,Coluna,[L|R],[L|R1], Tipo) :-
        Linha \= 0,
        LinhaNova is Linha-1,
        movePlayer(LinhaNova,Coluna,R,R1,Tipo).

getPos(N,P,_,3) :-
        (N < 0 ; N > 4); 
        (P < 0 ; P > 4).
getPos(0,0,[[Peca|_]|_], Peca).
getPos(0,Coluna,[[_|R]|RR],Peca) :-
        Coluna > 0,
        ColunaNova is Coluna-1,
        getPos(0,ColunaNova,[R|RR],Peca).
getPos(Linha,Coluna,[_|R],Peca) :-
        Linha > 0,
        LinhaNova is Linha-1,
        getPos(LinhaNova,Coluna,R,Peca).

surrounded(Linha,Coluna,Est) :-
        getPos(Linha,Coluna,Est,1),
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 2);getPos(LinhaAcima,Coluna, Est, 3)),
        (getPos(LinhaAbaixo,Coluna, Est, 2);getPos(LinhaAbaixo,Coluna, Est, 3)),
        (getPos(Linha,ColunaFrente, Est, 2);getPos(Linha,ColunaFrente, Est, 3)),
        (getPos(Linha,ColunaTras, Est, 2);getPos(Linha,ColunaTras, Est, 3)).

surrounded(Linha,Coluna,Est) :-
        getPos(Linha,Coluna,Est,2),
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 1); getPos(LinhaAcima,Coluna, Est, 3)),
        (getPos(LinhaAbaixo,Coluna, Est, 1); getPos(LinhaAbaixo,Coluna, Est, 3)),
        (getPos(Linha,ColunaFrente, Est, 1); getPos(Linha,ColunaFrente, Est, 3)),
        (getPos(Linha,ColunaTras, Est, 1); getPos(Linha,ColunaTras, Est, 3)).

removeEaten(5,0,New,New,EatenPiecesNew,EatenPiecesNew).
removeEaten(Linha,5,Old,New,EatenPiecesOld,EatenPiecesNew):-
        Linha < 5,
        LinhaNova is Linha+1,
        removeEaten(LinhaNova,0,Old,New,EatenPiecesOld,EatenPiecesNew).
removeEaten(Linha,Coluna,Old,NewNew,EatenPiecesOld,EatenPiecesNew) :- 
        Linha < 5,
        Coluna < 5,
        surrounded(Linha,Coluna,Old),
        removePiece(Linha,Coluna,Old,New),
        ColunaNova is Coluna+1,
        EatenPiecesInc is EatenPiecesOld + 1,
        removeEaten(Linha,ColunaNova,New,NewNew,EatenPiecesInc,EatenPiecesNew).
removeEaten(Linha,Coluna,Old,New,EatenPiecesOld,EatenPiecesNew) :- 
        Linha < 5,
        Coluna < 5,
        \+ surrounded(Linha,Coluna,Old),
        ColunaNova is Coluna+1,
        removeEaten(Linha,ColunaNova,Old,New,EatenPiecesOld,EatenPiecesNew).
        
        
        


        