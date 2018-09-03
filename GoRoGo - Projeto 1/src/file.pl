/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

initBoard([[0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0],
           [0,0,0,0,0]]).

/*Checks if there are still enough pieces for a certain combination of Player/Piece*/
pieceAllowed(1,1,WPieces,_,_,_,Est) :-
        \+ initBoard(Est), /*White needs to start with henge*/
        WPieces > 0.
pieceAllowed(1,3,_,WMixed,_,_,_) :-
        WMixed > 0.

pieceAllowed(2,2,_,_,BPieces,_,_) :-
        BPieces > 0.
pieceAllowed(2,3,_,_,_,BMixed,_) :-
        BMixed > 0.

/*Checks if a certain coordinate is inside the board*/
insideTable(Value):-
        Value > -1,
        Value < 5.

/* Player controlled move decision */
playerInput(0,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- 
        repeat, 
                print('Type of piece: '),
                read(Tipo), 
                number(Tipo),
                pieceAllowed(PlayerNo,Tipo,WPieces,WMixed,BPieces,BMixed,Est), !,
        repeat,
                print('Line: '),
                read(Linha),
                number(Linha),
                Linha > -1,
                Linha < 5,
                print('Column: '),
                read(Coluna),
                number(Coluna),
                Coluna > -1,
                Coluna < 5,
                getPos(Linha,Coluna,Est,0),
                \+ surrounded(Linha,Coluna,Est,PlayerNo,Tipo), !.
                
/* CPU controlled move decision, used if good move available */
playerInput(3,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- 
        goodMove(0,0,Linha,Coluna,Est,PlayerNo),
        repeat,
                random(1,4,Tipo),
                pieceAllowed(PlayerNo,Tipo,WPieces,WMixed,BPieces,BMixed,Est), !.

playerInput(3,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :-
        !, playerInput(2,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed).

/* CPU controlled move decision, used by player 1 to protect his pieces*/
playerInput(2,1,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- 
        goodMove(0,0,Linha,Coluna,Est,2),
        repeat,
                random(1,4,Tipo),
                pieceAllowed(1,Tipo,WPieces,WMixed,BPieces,BMixed,Est), !.

/* CPU controlled move decision, used by player 2 to protect his pieces*/
playerInput(2,2,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- 
        goodMove(0,0,Linha,Coluna,Est,1),
        repeat,
                random(1,4,Tipo),
                pieceAllowed(2,Tipo,WPieces,WMixed,BPieces,BMixed,Est), !.

playerInput(2,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :-
        !, playerInput(1,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed).

/* CPU controlled move decision, random */
playerInput(1,PlayerNo,Est,Linha,Coluna,Tipo,WPieces,WMixed,BPieces,BMixed) :- 
        repeat,
                random(1,4,Tipo),
                pieceAllowed(PlayerNo,Tipo,WPieces,WMixed,BPieces,BMixed,Est), !,
        repeat,
                random(0,5,Linha),
                random(0,5,Coluna),
                getPos(Linha,Coluna,Est,0),
                \+ surrounded(Linha,Coluna,Est,PlayerNo,Tipo), !.

/* Updates piece counts */
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
      
/* Initial game starter call: 0- Human 1- Easy AI 2- Medium AI 3- Hard AI */
play(Player1,Player2) :-
        use_module(library(random)),        
        initBoard(Board),
        printBoard(Board),
        play(Player1,Player2,Board,0,10,3,10,2,1).
        
/* Recursive game Loop for whites */
play(Player1,Player2,Board,EatenPieces,WPieces,WMixed,BPieces,BMixed,1) :- 
        playerInput(Player1,1,Board,Linha1,Coluna1,Tipo1,WPieces,WMixed,BPieces,BMixed),
        movePlayer(Linha1,Coluna1, Board, Board1, Tipo1),
        countPieces(1,Tipo1,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1),
        removeEaten(0,0,Board1,Board2,EatenPieces,EatenPieces1,1),
        printBoard(Board2),
        (endGame(Board2,WPieces1,WMixed1,BPieces1,BMixed1, 0) ; play(Player1,Player2,Board2,EatenPieces1,WPieces1,WMixed1,BPieces1,BMixed1,2)).

/* Recursive game Loop for blacks */
play(Player1,Player2,Board,EatenPieces,WPieces,WMixed,BPieces,BMixed,2) :- /*0 if Player controlled, >1 if AI*/
        playerInput(Player2,2,Board,Linha1,Coluna1,Tipo1,WPieces,WMixed,BPieces,BMixed),
        movePlayer(Linha1,Coluna1, Board, Board1, Tipo1),
        countPieces(2,Tipo1,WPieces,WMixed,BPieces,BMixed,WPieces1,WMixed1,BPieces1,BMixed1),
        removeEaten(0,0,Board1,Board2,EatenPieces,EatenPieces1,2),
        printBoard(Board2),
        (endGame(Board2,WPieces1,WMixed1,BPieces1,BMixed1, 0) ; play(Player1,Player2,Board2,EatenPieces1,WPieces1,WMixed1,BPieces1,BMixed1,1)).

/* Checks if/Gets a move that eats a piece */
goodMove(L, C, _, _, _, _) :-
        (L > 5 ; C > 5),
        !, fail.
goodMove(5, Coluna, Linha1, Coluna1, Board, PlayerNo) :-
        ColunaNova is Coluna+1,
        goodMove(0,ColunaNova,Linha1,Coluna1, Board, PlayerNo).
goodMove(Linha, Coluna, Linha, Coluna, Board, PlayerNo) :- 
        getPos(Linha, Coluna, Board, 0),
        removeEaten(0,0,Board,_,0,N1,PlayerNo),
        movePlayer(Linha, Coluna, Board, Board1, PlayerNo),
        \+ surrounded(Linha,Coluna,Board1,PlayerNo,PlayerNo),
        removeEaten(0,0,Board1,_,0,N,PlayerNo),
        N > N1,
        print('sugested '),nl,
        print(Linha),nl,
        print(Coluna),nl.
goodMove(Linha, Coluna, Linha1, Coluna1, Board, PlayerNo) :-
        LinhaNova is Linha+1,
        goodMove(LinhaNova,Coluna,Linha1,Coluna1, Board, PlayerNo).

/* Checks if/Gets a move is valid */
validMove(L, C, _, _, _, _, _) :-
        (L > 5 ; C > 5),
        !, fail.
validMove(5, Coluna, Linha1, Coluna1, Board, PlayerNo, Type) :-
        ColunaNova is Coluna+1,
        validMove(0,ColunaNova,Linha1,Coluna1, Board, PlayerNo,Type).
validMove(Linha, Coluna, Linha, Coluna, Board, PlayerNo,Type) :- 
        getPos(Linha, Coluna, Board, 0),
        \+ surrounded(Linha,Coluna,Board,PlayerNo,Type).
validMove(Linha, Coluna, Linha1, Coluna1, Board, PlayerNo,Type) :-
        LinhaNova is Linha+1,
        validMove(LinhaNova,Coluna,Linha1,Coluna1, Board, PlayerNo, Type).

/* Checks if game ended and declares winner*/
endGame([],0,1,_,_,Count) :-
        Count > 0,
        print('Black wins! (Last piece must not be henge)').
endGame([],_,_,0,1,Count) :-
        Count > 0,
        print('White wins! (Last piece must not be henge)').
endGame([],0,0,0,0,Count) :-
        Count > 0,
        print('Whites win!').
endGame([],0,0,0,0,Count) :-
        Count < 0,
        print('Blacks win!').
endGame([],0,0,0,0,0) :-
        print('Tie! (Which means white wins!)').
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
endGame(Board,W,H,_,_,_):-
        (W > 0 ; H > 0),
        (\+ validMove(0,0,L,C,Board,1,1) ; W =< 0), (\+ validMove(0,0,L,C,Board,1,3) ; H =< 0),nl,
        print('Black wins! (White has no possible moves!)').
endGame(Board,_,_,B,H,_):-
        (B > 0 ; H > 0),
        (\+ validMove(0,0,L,C,Board,2,2) ; B =< 0), (\+ validMove(0,0,L,C,Board,2,3) ; H =< 0),nl,
        print('White wins! (Black has no possible moves!)').

/*Prints a line of the board*/
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

/*Prints the board*/
printBoard(Est) :-
        nl,
        print(' |0|1|2|3|4|'),
        nl,
        printBoard(0,Est).
printBoard(_,[]) :- print('------------'), nl.
printBoard(Linha,[L|R]) :-
        print('------------'),
        print('\n'),
        print(Linha),
        printBoardLine(L),
        print('\n'),
        LinhaNova is Linha+1,
        printBoard(LinhaNova,R).

/*Removes a piece from the board*/
removePiece(0,0,[[_|LR]|R],[[0|LR]|R]).
removePiece(0, Coluna, [[L|LR]|R], [[L|LR1]|R1]) :-
        Coluna \= 0,
        ColunaNova is Coluna-1,
        removePiece(0, ColunaNova, [LR|R], [LR1|R1]).
removePiece(Linha,Coluna,[L|R],[L|R1]) :-
        Linha \= 0,
        LinhaNova is Linha-1,
        removePiece(LinhaNova,Coluna,R,R1).

/*Moves a piece to an empty spot*/
movePlayer(0,0,[[0|LR]|R],[[Tipo|LR]|R], Tipo).
movePlayer(0, Coluna, [[L|LR]|R], [[L|LR1]|R1], Tipo) :-
        Coluna \= 0,
        ColunaNova is Coluna-1,
        movePlayer(0, ColunaNova, [LR|R], [LR1|R1], Tipo).
movePlayer(Linha,Coluna,[L|R],[L|R1], Tipo) :-
        Linha \= 0,
        LinhaNova is Linha-1,
        movePlayer(LinhaNova,Coluna,R,R1,Tipo).

/*Gets the piece on a certain position of the board*/
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

/*Checks if board position is surrounded by enemies*/
surrounded(Linha,Coluna,Est,1,1) :-
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 2) ; \+insideTable(LinhaAcima)),
        (getPos(LinhaAbaixo,Coluna, Est, 2) ; \+insideTable(LinhaAbaixo)),
        (getPos(Linha,ColunaFrente, Est, 2) ; \+insideTable(ColunaFrente)),
        (getPos(Linha,ColunaTras, Est, 2) ; \+insideTable(ColunaTras)).

surrounded(Linha,Coluna,Est,1,2) :-
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 1);getPos(LinhaAcima,Coluna, Est, 3) ; \+insideTable(LinhaAcima)),
        (getPos(LinhaAbaixo,Coluna, Est, 1);getPos(LinhaAbaixo,Coluna, Est, 3) ; \+insideTable(LinhaAbaixo)),
        (getPos(Linha,ColunaFrente, Est, 1);getPos(Linha,ColunaFrente, Est, 3) ; \+insideTable(ColunaFrente)),
        (getPos(Linha,ColunaTras, Est, 1);getPos(Linha,ColunaTras, Est, 3) ; \+insideTable(ColunaTras)).

surrounded(Linha,Coluna,Est,2,1) :-
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 2); getPos(LinhaAcima,Coluna, Est, 3) ; \+insideTable(LinhaAcima)),
        (getPos(LinhaAbaixo,Coluna, Est, 2); getPos(LinhaAbaixo,Coluna, Est, 3) ; \+insideTable(LinhaAbaixo)),
        (getPos(Linha,ColunaFrente, Est, 2); getPos(Linha,ColunaFrente, Est, 3) ; \+insideTable(ColunaFrente)),
        (getPos(Linha,ColunaTras, Est, 2); getPos(Linha,ColunaTras, Est, 3) ; \+insideTable(ColunaTras)).

surrounded(Linha,Coluna,Est,2,2) :-
        LinhaAcima is Linha - 1,
        LinhaAbaixo is Linha + 1,
        ColunaFrente is Coluna + 1,
        ColunaTras is Coluna - 1,
        (getPos(LinhaAcima,Coluna, Est, 1) ; \+insideTable(LinhaAcima)),
        (getPos(LinhaAbaixo,Coluna, Est, 1) ; \+insideTable(LinhaAbaixo)),
        (getPos(Linha,ColunaFrente, Est, 1) ; \+insideTable(ColunaFrente)),
        (getPos(Linha,ColunaTras, Est, 1) ; \+insideTable(ColunaTras)).

/*Removes all the eaten pieces from the board*/
removeEaten(5,0,New,New,EatenPiecesNew,EatenPiecesNew, _) :- !.
removeEaten(Linha,5,Old,New,EatenPiecesOld,EatenPiecesNew, PlayerNo):-
        Linha < 5,
        LinhaNova is Linha+1,
        removeEaten(LinhaNova,0,Old,New,EatenPiecesOld,EatenPiecesNew,PlayerNo).
removeEaten(Linha,Coluna,Old,NewNew,EatenPiecesOld,EatenPiecesNew, PlayerNo) :- 
        Linha < 5,
        Coluna < 5,
        getPos(Linha,Coluna,Old,Tipo),
        surrounded(Linha,Coluna,Old,PlayerNo,Tipo),
        removePiece(Linha,Coluna,Old,New),
        ColunaNova is Coluna+1,
        EatenPiecesInc is EatenPiecesOld + 1,
        removeEaten(Linha,ColunaNova,New,NewNew,EatenPiecesInc,EatenPiecesNew,PlayerNo).
removeEaten(Linha,Coluna,Old,New,EatenPiecesOld,EatenPiecesNew, PlayerNo) :- 
        Linha < 5,
        Coluna < 5,
        getPos(Linha,Coluna,Old,Tipo),
        \+ surrounded(Linha,Coluna,Old,PlayerNo,Tipo),
        ColunaNova is Coluna+1,
        removeEaten(Linha,ColunaNova,Old,New,EatenPiecesOld,EatenPiecesNew,PlayerNo).
        
        
        


        