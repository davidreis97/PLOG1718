:- use_module(library(clpfd)).
:- use_module(library(lists)).

sweet_recipes(MaxTime, NEggs, RecipeTimes, RecipeEggs, Cookings, Eggs):-
    length(Cookings, 3),
    length(RecipeTimes, Size),
    domain(Cookings,1,Size),
    all_distinct(Cookings),
    eggsUsed(Cookings,RecipeEggs,EggsList),
    sum(EggsList,#=,Eggs),
    Eggs #=< NEggs,
    eggsUsed(Cookings,RecipeTimes,TimeList),
    sum(TimeList,#=,Time),
    Time #=< MaxTime,
    labeling([maximize(Eggs)],Cookings).

eggsUsed([],_,[]).
eggsUsed([Cooking|Rest],RecipeEggs,[Egg|RestOfEggs]) :-
    element(Cooking,RecipeEggs,Egg),
    eggsUsed(Rest,RecipeEggs,RestOfEggs).


%sweet_recipes(120,30,[20,50,10,20,15],[6,4,12,20,6],Cookings,Eggs).

cut(Shelves,Boards,SelectedBoards) :-
    length(Shelves,ShelvesSize),
    length(Boards,BoardsSize),
    length(SelectedBoards,ShelvesSize),
    domain(SelectedBoards,1,BoardsSize),
    calculateLeftOversBoards(Shelves,Boards,SelectedBoards,LeftOvers),

calculateLeftOvers([],L,[],L).
calculateLeftOvers([Shelf|SRest], Boards, [SelectedBoard|RBoards], LO):-
    element