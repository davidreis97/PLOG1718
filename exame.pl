constroi(NEmb,Orcamento,EmbPorObjeto,CustoPorObjeto,EmbUsadas,Objetos):-
	length(Objetos,4),
	length(EmbPorObjeto,NumObjetos),
	domain(Objetos,1,NumObjetos),
	all_distinct(Objetos),
	getSumIndex(EmbPorObjeto,Objetos,EmbUsadas),
	getSumIndex(CustoPorObjeto,Objetos,CustoTotal),
	EmbUsadas #=< NEmb,
	CustoTotal #=< Orcamento,
	labeling([maximize(EmbUsadas)],Objetos).
	
getSumIndex(_,[],0).
getSumIndex(List,[Index|Xs],Sum) :-
	element(Index,List,Value),
	Sum #= Value + RestOfSum,
	getSumIndex(List,Xs,RestOfSum).
	