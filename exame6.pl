:- use_module(library(clpfd)).
:- use_module(library(lists)).

docente(pedro,m,3,6).
docente(joana,f,3,4).
docente(ana,f,2,5).
docente(joao,m,2,4).
docente(david,m,3,4).
docente(maria,f,1,6).

escolhe:-
	findall(Nome,docente(Nome,_,_,_),Nomes),
	findall(Sexo,docente(_,Sexo,_,_),Sexos),
	findall(HInicial,docente(_,_,HInicial,_),HIniciais),
	findall(HFinal,docente(_,_,_,HFinal),HFinais),
	
	length(Nomes,L),
	min_member(MinHora,HIniciais),
	max_member(MaxHora,HFinais),
	length(HoraDoc,L),
	domain(HoraDoc,MinHora,MaxHora),
	
	all_distinct(HoraDoc),
	
	distribuiDocentes(HoraDoc,HIniciais,HFinais),
	mulheresMaisCedo(HoraDoc,Sexos,Score),
	
	labeling([minimize(Score)],HoraDoc),
	printResults(Nomes,HoraDoc).
	
distribuiDocentes([],_,_).
distribuiDocentes([HoraDoc|RI],[MinHora|HIns],[MaxHora|HFins]) :-
	(HoraDoc #>= MinHora) #/\ (HoraDoc #=< MaxHora),
	distribuiDocentes(RI,HIns,HFins).
	
mulheresMaisCedo([],[],0).
mulheresMaisCedo([HoraDoc|RI],[Sexo|RS],Score) :-
	((Sexo == f, Score #= RestScore + HoraDoc) ; (Score #= RestScore)),
	mulheresMaisCedo(RI,RS,RestScore).
	
printResults([],[]).
printResults([Nome|RN],[Hora|RH]):-
	print(Nome-Hora),nl,
	printResults(RN,RH).