:- use_module(library(clpfd)).
:- use_module(library(lists)).

embrulha(Rolos,Presentes,RolosSelecionados):-
	length(Rolos,MaxDomain),
	length(Presentes,Length),
	length(RolosSelecionados,Length),
	domain(RolosSelecionados,1,MaxDomain),
	
	generateMachines(Rolos,Machines,1),
	generateTasks(Presentes,RolosSelecionados,Tasks),
	
	cumulatives(Tasks,Machines,[bound(upper)]),
	
	labeling([],RolosSelecionados).
	
generateMachines([],[],_).
generateMachines([Rolo|RR],[machine(ID,Rolo)|RM],ID):-
	NewID is ID + 1,
	generateMachines(RR,RM,NewID).
	
generateTasks([],[],[]).
generateTasks([Pres|RP],[RolSel|RS],[task(1,1,2,Pres,RolSel)|RT]) :-
	generateTasks(RP,RS,RT).