:- use_module(library(clpfd)).

puzzle([S,E,N,D,M,O,R,Y]):- 
    domain([S,E,N,D,M,O,R,Y],0,9),
    S #> 0,
    M #> 0,
    all_different([S,E,N,D,M,O,R,Y]),
    S * 1000 + E * 100 + N * 10 + D + 
    M * 1000 + O * 100 + R * 10 + E #=
    M * 10000 + O * 1000 + N * 100 + E * 10 + Y,
    labeling([],[S,E,N,D,M,O,R,Y]).

fechadura([A,B,C]) :-
    domain([A,B,C],1,50),
    A1 in 0..5, A2 in 0..9,
    B1 in 0..5, B2 in 0..9,
    B #= 2*A,
    C #= B+10,
    A + B #> 10,
    A #= A1*10 + A2,
    A1 mod 2 #\= A2 mod 2,
    B #= B1*10 + B2,
    B1 mod 2 #= B2 mod 2,
    labeling([],[A,B,C]).

guardas(L):-
    length(L,12),
    domain(L,0,5),
    sum(L,#=,12),
    L = [S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12],
    sum([S1,S2,S3,S4],#=,5),
    sum([S4,S5,S6,S7],#=,5),
    sum([S7,S8,S9,S10],#=,5),
    sum([S10,S11,S12,S1],#=,5),
    labeling([],L).

quadrado(L):-
    length(L,3),
    length(L1,3),
    length(L2,3),
    length(L3,3),
    L = [L1,L2,L3],
    domain(L1,1,3),
    domain(L2,1,3),
    domain(L3,1,3),
    sum(L1,#=,L1S),
    sum(L2,#=,L2S),
    sum(L3,#=,L3S),
    L1 = [L1A,_,L1C],
    L2 = [_,L2B,_],
    L3 = [L3A,_,L3C],
    sum([L1A,L2B,L3C], #=, LD1S),
    sum([L1C,L2B,L3A], #=, LD2S),
    L1S #= L2S,
    L2S #= L3S,
    L3S #= LD1S,
    L3S #= LD2S,
    labeling([],L1),
    labeling([],L2),
    labeling([],L3).