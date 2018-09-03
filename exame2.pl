:- use_module(library(clpfd)).
:- use_module(library(lists)).

concelho(x,120,410).
concelho(y,10,800).
concelho(z,543,2387).
concelho(w,3,38).
concelho(k,234,376).

concelhos(NDias, MaxDist, ConselhosVisitados, DistTotal, TotalEleitores):-
	findall(N, concelho(N,_,_), Nomes),
	findall(D, concelho(_,D,_), Distancias),
	findall(N, concelho(_,_,N), NEleitores),

	length(Nomes,L),

	length(Vars,L),
	domain(Vars,0,1),

	scalar_product(Distancias,Vars,#=,DistTotal),
	scalar_product(NEleitores,Vars,#=,TotalEleitores),
	sum(Vars,#=<,NDias),

	DistTotal #=< MaxDist,
	labeling(maximize(TotalEleitores),Vars),
	getConcelhos(Vars,Nomes,ConselhosVisitados).

getConcelhos([],[],[]).
getConcelhos([1 | Rest ], [Nome | Resto], ConselhosVisitados):-
	getConcelhos(Rest,Resto,NewConselhosVisitados),
	ConselhosVisitados = [Nome | NewConselhosVisitados].
getConcelhos([0 | Rest ], [_ | Resto], NewConselhosVisitados):-
	getConcelhos(Rest,Resto,NewConselhosVisitados).