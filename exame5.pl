:- use_module(library(clpfd)).
:- use_module(library(lists)).

concelho(x,120,410).
concelho(y,10,800).
concelho(z,543,2387).
concelho(w,3,38).
concelho(k,234,376).

concelhos(NDias,MaxDist,ConcelhosVisitados,DistTotal,EleitsTotal) :-
	findall(Nome,concelho(Nome,_,_),Nomes),
	findall(Distancia,concelho(_,Distancia,_),Dists),
	findall(Eleitores,concelho(_,_,Eleitores),Eleits),
	
	length(Nomes, L),
	length(Going, L),
	length(Starts, L),
	length(Ends, L),
	
	domain(Going,0,1),
	domain(Starts,1,L),
	domain(Ends,1,L),
	
	gerarTasks(Going,Tasks,Starts,Ends),
	cumulatives(Tasks,[machine(1,1),machine(0,100000)],[bound(upper)]),
	
	global_cardinality(Going,[1-NumConc,0-_]),
	NumConc #=< NDias,
	
	scalar_product(Dists,Going,#=,DistTotal),
	DistTotal #=< MaxDist,

	scalar_product(Eleits,Going,#=,EleitsTotal),
		
	append([Going,Starts,Ends],Final),
		
	labeling([maximize(EleitsTotal)],Final),
	getConcelhos(Going,Nomes,ConcelhosVisitados).

getConcelhos([],[],[]).
getConcelhos([1 | Rest ], [Nome | Resto], ConcelhosVisitados):-
	getConcelhos(Rest,Resto,NewConcelhosVisitados),
	ConcelhosVisitados = [Nome | NewConcelhosVisitados].
getConcelhos([0 | Rest ], [_ | Resto], NewConcelhosVisitados):-
	getConcelhos(Rest,Resto,NewConcelhosVisitados).
	
gerarTasks([],[],[],[]).
gerarTasks([G|RG],[task(S,1,E,1,G)|RT],[S|RS],[E|RE]) :-
	gerarTasks(RG,RT,RS,RE).