:- use_module(library(clpfd)).
:- use_module(library(lists)).

attend(FilmList,Goings,TotalWorth):-
	extractData(FilmList,Starts,Durations,Worths),
	
	length(FilmList,Length),
	length(Goings,Length),
	domain(Goings,0,1),
	
	generateTasks(Starts,Durations,Goings,Tasks),
	Machines = [machine(1,1),machine(0,1000)],
	
	cumulatives(Tasks,Machines,[bound(upper)]),
	
	scalar_product(Worths,Goings,#=,TotalWorth),
	
	labeling([maximize(TotalWorth)],Goings).
	
extractData([],[],[],[]).
extractData([(Start,Duration,Worth)|RestFilmList],[Start|RestStart],[Duration|RestDuration],[Worth|RestWorth]) :-
	extractData(RestFilmList,RestStart,RestDuration,RestWorth).

generateTasks([],[],[],[]).
generateTasks([S|RS],[D|RD],[G|RG],[task(S,D,_,G,G)|RT]):-
	generateTasks(RS,RD,RG,RT).