%participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

%madeItThrough(+Participant)
madeItThrough(Participant) :-
    use_module(library(lists)),
    performance(Participant,Performance),
    nth0(_,Performance,120).

juriTime(X,Juri,Time):-
    performance(X,Times),
    nth1(Juri,Times,Time).

%juriTimes(+Participants, +JuriMember, -Times, -Total)
juriTimes(Participant,Juri,Times,Total) :-
    use_module(library(lists)),
    juriTimes(Participant,Juri,Times,Total,[],0).

juriTimes([],_,Times,Total,Times,Total).
juriTimes([X|Xs],Juri,Times,Total,TimesHelper,TotalHelper) :-
    juriTime(X,Juri,Time),
    append(TimesHelper,[Time],TimesHelperNew),
    TotalHelperNew is TotalHelper + Time,
    juriTimes(Xs,Juri,Times,Total,TimesHelperNew,TotalHelperNew).

patientJuri(Juri):-
    use_module(library(lists)),
    juriTime(P1,Juri,Time1),
    juriTime(P2,Juri,Time2),
    P1 \= P2,
    Time1 == 120,
    Time2 == 120.

%bestParticipant(+P1, +P2, -P)
bestParticipant(Part1, Part2, Part1):-
    use_module(library(lists)),
    performance(Part1, Perf1),
    performance(Part2, Perf2),
    sumlist(Perf1,TPerf1),
    sumlist(Perf2,TPerf2),
    TPerf1 > TPerf2.

bestParticipant(Part1, Part2, Part2):-
    use_module(library(lists)),
    performance(Part1, Perf1),
    performance(Part2, Perf2),
    sumlist(Perf1,TPerf1),
    sumlist(Perf2,TPerf2),
    TPerf2 > TPerf1.

allPerfs :- 
    participant(Part, _, Atua),
    performance(Part,Perf),
    write(Part),write(Atua),write(Perf),nl,
    fail.
allPerfs.

noBuzz([],PartFansList,PartFansList,_).
noBuzz([120|Xs],PartFansList,PartFansListHelper,Counter) :-
    append(PartFansListHelper,[Counter],NewPartFansListHelper),
    NewCounter is Counter+1,
    noBuzz(Xs,PartFansList,NewPartFansListHelper,NewCounter).
noBuzz([X|Xs],PartFansList,PartFansListHelper,Counter) :-
    X \= 120,
    NewCounter is Counter+1,
    noBuzz(Xs,PartFansList,PartFansListHelper,NewCounter).

noBuzz(Part) :-
    performance(Part, Perf),
    sumlist(Perf,TPerf),
    TPerf == 480.

nSuccessfulParticipants(Number) :-
    performance(Part,_),
    findall(Part,noBuzz(Part),Perfs),
    write(Perfs),
    length(Perfs,Number).

juriFansHelper(Part,PartFansList):-
    performance(Part,Perf),
    noBuzz(Perf,PartFansList,[],1).

juriFans(JuriFansList) :-
    findall(Part-PartFansList,juriFansHelper(Part,PartFansList),JuriFansList).

eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumlist(Times,TT).

getFirstN(_,0,[]).
getFirstN([],_,_) :- fail.
getFirstN([X|Xs],N,[X|Xs1]) :- 
    N1 is N - 1,
    getFirstN(Xs,N1,Xs1).

nextPhase(N, Participants) :-
    findall(TT-Part-Act,eligibleOutcome(Part,Act,TT),ParticipantsDupes),
    sort(ParticipantsDupes,ParticipantsReverse),
    reverse(ParticipantsReverse,TotalParticipantsOrdered),
    getFirstN(TotalParticipantsOrdered,N,Participants).