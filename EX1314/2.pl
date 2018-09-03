
childOf(mira,luis). 
childOf(maria,carla).
childOf(maria,marco). 
childOf(jose,marco).
childOf(jose,teresa). 
childOf(marco,miguel).
childOf(joao,teresa). 
childOf(joao,miguel).

saveallPart(List):-
    saveAllPart([],List).

saveAllPart(Ls,List):-
    participant(X,_,_),
    nonmember(X,Ls),
    saveAllPart([X|Ls], List).

saveAllPart(Ls,List):-
    List=Ls.