:- use_module(library(clpfd)).

testGeost([X1,X2,X3,Y1,Y2,Y3]) :-
    domain([X1,X2,X3,Y1,Y2,Y3],1,4), 
    S1 in 1..4, 
    S2 in 5..6, 
    S3 in 7..8,
    geost([ object(1,S1,[X1,Y1]), 
            object(2,S2,[X2,Y2]), 
            object(3,S3,[X3,Y3]) ],
        [ sbox(1,[0,0],[2,1]), sbox(1,[0,1],[1,2]),  sbox(1,[1,2],[3,1]), % first object, shape S1
            sbox(2,[0,0],[3,1]), sbox(2,[0,1],[1,3]), sbox(2,[2,1],[1,1]), %first object, shape S2
            sbox(3,[0,0],[2,1]), sbox(3,[1,1],[1,2]), sbox(3,[2,2],[3,1]), % first object, shape S3
            sbox(4,[0,0],[3,1]), sbox(4,[0,1],[1,1]), sbox(4,[2,1],[1,3]), % first object, shape S4
            sbox(5,[0,0],[2,1]), sbox(5,[1,1],[1,1]), sbox(5,[0,2],[2,1]), % second object, shape S5
            sbox(6,[0,0],[3,1]), sbox(6,[0,1],[1,1]), sbox(6,[2,1],[1,1]), % second object, shape S6
            sbox(7,[0,0],[3,2]), % third object, shape S7
            sbox(8,[0,0],[2,3])]), % third object, shape S8
    labeling([],[X1,X2,X3,Y1,Y2,Y3]).