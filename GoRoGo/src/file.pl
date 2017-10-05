/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

initBoard([[0,0,0,0,0],
           [0,0,0,0,0],
           [0,1,0,0,0],
           [0,0,0,3,0],
           [0,0,0,0,0]]).

/*
  0- Empty Space
  1- White Piece
  2- Black Piece
  3- Mixed Piece
*/

printBoardLine([]).
printBoardLine([0|R]) :- 
        print('E'),
        printBoardLine(R).
printBoardLine([1|R]) :- 
        print('W'),
        printBoardLine(R).
printBoardLine([2|R]) :- 
        print('B'),
        printBoardLine(R).
printBoardLine([3|R]) :- 
        print('M'),
        printBoardLine(R).

printBoard([]).
printBoard([L|R]) :-
        printBoardLine(L),
        print('\n'),
        printBoard(R).

/*
  Fornecido pelo prof na aula teorica a 4/10
*/
replace(Old,New,[Old|Rest],[New|Rest]).
replace(Old,New,[Some|Rest1],[Some|Rest2]) :- 
        Old \= Some, replace(Old,New,Rest1,Rest2).


movePlayer(0,0,[[0|LR]|R],[[Tipo|LR]|R], Tipo).
movePlayer(0, Coluna, [[L|LR]|R], [[L|LR1]|R1], Tipo) :-
        Coluna \= 0,
        ColunaNova is Coluna-1,
        movePlayer(0, ColunaNova, [LR|R], [LR1|R1], Tipo).
movePlayer(Linha,Coluna,[L|R],[L|R1], Tipo) :-
        Linha \= 0,
        Coluna \= 0,
        LinhaNova is Linha-1,
        movePlayer(LinhaNova,Coluna,R,R1,Tipo).




        