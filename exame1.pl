ups_and_downs(Min,Max,N,L) :-
	length(L,N),
	domain(L,Min,Max),
	ups_and_downs_restrict(L),
	labeling([],L).
	
ups_and_downs_restrict([]).
ups_and_downs_restrict([_]).
ups_and_downs_restrict([X1,X2]) :- X1 #\= X2.
ups_and_downs_restrict([X1,X2,X3|Xs]):-
	(X1 #> X2 #/\ X2 #< X3) #\/ (X1 #< X2 #/\ X2 #> X3),
	ups_and_downs_restrict([X2,X3|Xs]).


concelho(x,120,410).
concelho(y,10,800).
concelho(z,543,2387).
concelho(w,3,38).
concelho(k,234,376).

concelhos(NDias, MaxDist, ConcelhosVisitados, DistTotal, TotalEleitores) :-
	findall(Nome,concelho(Nome,_,_),ConcelhosDispNomes),
	findall(Dist,concelho(_,Dist,_),ConcelhosDispDist),
	findall(Eleit,concelho(_,_,Eleit),ConcelhosDispEleit),
	length(ConcelhosVisitadosIndex,NumConcelhos),
	length(ConcelhosDispNomes,TotalConcelhosDisp),
	domain(ConcelhosVisitadosIndex,1,TotalConcelhosDisp),
	domain(NumConcelhos,1,NDias),
	geraDados(ConcelhosDispDist,ConcelhosDispEleit,ConcelhosVisitadosIndex,DistTotal,TotalEleitores),
	DistTotal #=< MaxDist,
	all_distinct(ConcelhosVisitadosIndex),
	append(ConcelhosVisitadosIndex,[NumConcelhos],ParaLabeling),
	labeling([maximize(TotalEleitores)],ParaLabeling),
	converteEmNome(ConcelhosDispNomes,ConcelhosVisitadosIndex,ConcelhosVisitados).

geraDados(_,_,[],0,0).
geraDados(ConcelhosDispDist,ConcelhosDispEleit,[ConsIndex|RestConstIndex],DistTotal,TotalEleitores):-
	element(ConsIndex,ConcelhosDispDist,Dist),
	element(ConsIndex,ConcelhosDispEleit,Eleitores),
	DistTotal #= Dist + RestDist,
	TotalEleitores #= Eleitores + RestEleitores,
	geraDados(ConcelhosDispDist,ConcelhosDispEleit,RestConstIndex,RestDist,RestEleitores).

converteEmNome(_,[],[]).
converteEmNome(ConcelhosDispNomes,[ConsIndex|RestConstIndex],[Nome|RestNome]):-
	nth1(ConsIndex,ConcelhosDispNomes,Nome),
	converteEmNome(ConcelhosDispNomes,RestConstIndex,RestNome).