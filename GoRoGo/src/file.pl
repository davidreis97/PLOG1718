/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

initBoard([[0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0]]).

/*
  0- Empty Space
  1- White Piece
  2- Black Piece
  3- Mixed Piece
*/

pieceAllowed(1,1,WPieces,_,_,_) :-
        WPieces > 0.
pieceAllowed(1,3,_,WMixed,_,_) :-
        WMixed > 0.

pieceAllowed(2,2,_,_,BPieces,_) :-
        BPieces > 0.
pieceAllowed(2,3,_,_,_,BMixed) :-
        BMixed > 0.


playerInput(0,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- /* Player controlled move decision */
        repeat, 
                print('Type of piece: '),
                read(Tipo), 
                pieceAllowed(PlayerNo,Tipo,WPieces,WMixed,BPieces,BMixed), !,
        repeat,
                print('Line: '),
                read(Linha),
                Linha > -1,
                Linha < 5,
                print('Column: '),
                read(Coluna),
                Coluna > -1,
                Coluna < 5,
                getPos(Linha,Coluna,Est,0),
                \+ surrounded(Linha,Coluna,Est), !.
                
        
playerInput(1,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- /* CPU controlled move decision, for now it's random */
        use_module(library(random)),
        repeat,
                random(1,4,Tipo),
                pieceAllowed(PlayerNo,Tipo,WPieces,WMixed,BPieces,BMixed), !,
        repeat,
                random(0,5,Linha),
                random(0,5,Coluna),
                getPos(Linha,Coluna,Est,0),
                \+ surrounded(Linha,Coluna,Est), !.

countPieces(1,1,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1) :- 
        WPieces1 is WPieces - 1,
        WMixed1 is WMixed,
        BPieces1 is BPieces,
        BMixed1 is BMixed.

countPieces(1,3,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1) :- 
        WPieces1 is WPieces,
        WMixed1 is WMixed - 1,
        BPieces1 is BPieces,
        BMixed1 is BMixed.

countPieces(2,2,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1) :- 
        WPieces1 is WPieces,
        WMixed1 is WMixed,
        BPieces1 is BPieces - 1,
        BMixed1 is BMixed.

countPieces(2,3,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1) :- 
        WPieces1 is WPieces,
        WMixed1 is WMixed,
        BPieces1 is BPieces,
        BMixed1 is BMixed - 1.
        

play(Player1,Player2) :-
        initBoard(Board),
        play(Player1,Player2,Board,0,5,3,5,3).
        
play(Player1,Player2,Board,EatenPieces,WPieces,WMixed,BPieces,BMixed) :- /*0 if Player controlled, 1 if AI*/
        playerInput(Player1,1,Board,Linha1,Coluna1,Tipo1,WPieces,WMixed,BPieces,BMixed),
        movePlayer(Linha1,Coluna1, Board, Board1, Tipo1), /* Assumes success in movePlayer */
        countPieces(1,Tipo1,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1),
        removeEaten(0,0,Board1,Board2,EatenPieces,EatenPieces1),
        printBoard(Board2),
        playerInput(Player2,2,Board2,Linha2,Coluna2,Tipo2,WPieces,WMixed,BPieces,BMixed),
        movePlayer(Linha2,Coluna2, Board2, Board3, Tipo2), /* Assumes success in movePlayer */
        countPieces(2,Tipo2,WPieces1,WMixed1,BPieces1,BMixed1,WPieces2,WMixed2,BPieces2,BMixed2),
        removeEaten(0,0,Board3,Board4,EatenPieces1,EatenPieces2),
        printBoard(Board4),
        (endGame(Board4,WPieces2,WMixed2,BPieces2,BMixed2, 0) ; play(Player1,Player2,Board4,EatenPieces2,WPieces2,WMixed2,BPieces2,BMixed2)). /* Check victory conditions */

endGame([],0,0,0,0,Count) :-
        Count > 0,
        print('Whites win!').
endGame([],0,0,0,0,Count) :-
        Count < 0,
        print('Blacks win!').
endGame([],0,0,0,0,0) :-
        print('Tie!').
endGame([[]|Xs],0,0,0,0,Count) :-
        endGame(Xs,0,0,0,0, Count).
endGame([[1|Xs]|Xss],0,0,0,0, Count) :- 
        !,
        NewCount is Count+1,
        endGame([Xs|Xss],0,0,0,0, NewCount).
endGame([[2|Xs]|Xss],0,0,0,0, Count) :- 
        !,
        NewCount is Count-1,
        endGame([Xs|Xss],0,0,0,0, NewCount).
endGame([[_|Xs]|Xss],0,0,0,0, Count) :-
        endGame([Xs|Xss],0,0,0,0, Count).

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
        print('H'),
        printBoardLine(R).

printBoard([]) :- print('-----------'), nl.
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

movePlayer(0,0,[[0|LR]|R],[[Tipo|LR]|R], Tipo). /* Assumes not surrounded */
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
        print('Piece Eaten'),
        removeEaten(Linha,ColunaNova,New,NewNew,EatenPiecesInc,EatenPiecesNew).
removeEaten(Linha,Coluna,Old,New,EatenPiecesOld,EatenPiecesNew) :- 
        Linha < 5,
        Coluna < 5,
        \+ surrounded(Linha,Coluna,Old),
        ColunaNova is Coluna+1,
        removeEaten(Linha,ColunaNova,Old,New,EatenPiecesOld,EatenPiecesNew).
        
        
        


        