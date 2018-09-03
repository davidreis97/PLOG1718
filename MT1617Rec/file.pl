%film(Title, Categories, Duration, AvgClassification). 
film('Doctor Strange', [action, adventure, fantasy], 115, 7.6). 
film('Hacksaw Ridge', [biography, drama, romance], 131, 8.7). 
film('Inferno', [action, adventure, crime], 121, 6.4). 
film('Arrival', [drama, mystery, scifi], 116, 8.5). 
film('The Accountant', [action, crime, drama], 127, 7.6). 
film('The Girl on the Train', [drama, mystery, thriller], 112, 6.7). 

%user(Username, YearOfBirth, Country) 
user(john, 1992, 'USA'). 
user(jack, 1989, 'UK'). 
user(peter, 1983, 'Portugal'). 
user(harry, 1993, 'USA'). 
user(richard, 1982, 'USA'). 

:- dynamic vote/2.


%vote(Username, List_of_Film-Rating) 
vote(john, ['Inferno'-7, 'Doctor Strange'-9, 'The Accountant'-6]). 
vote(jack, ['Inferno'-8, 'Doctor Strange'-8, 'The Accountant'-7]). 
vote(peter, ['The Accountant'-4, 'Hacksaw Ridge'-7, 'The Girl on the Train'-3]). 
vote(harry, ['Inferno'-7, 'The Accountant'-6]). 
vote(richard, ['Inferno'-10, 'Hacksaw Ridge'-10, 'Arrival'-9]).

raro(Movie) :-
    film(Movie,_,Dur,_),
    Dur < 60.

raro(Movie) :-
    film(Movie,_,Dur,_),
    Dur > 60.

getAvgRating([],Count,Total,Avg) :-
    Avg is Total/Count.
getAvgRating([_-V|Xs],Count,Total,Avg) :-
    NewTotal is Total+V,
    NewCount is Count+1,
    getAvgRating(Xs,NewCount,NewTotal,Avg).
    
happierGuy(User1,User2,User1) :-
    vote(User1,Votes1),
    vote(User2,Votes2),
    getAvgRating(Votes1,0,0,Avg1),
    getAvgRating(Votes2,0,0,Avg2),
    Avg1 > Avg2.

happierGuy(User1,User2,User2) :-
    vote(User1,Votes1),
    vote(User2,Votes2),
    getAvgRating(Votes1,0,0,Avg1),
    getAvgRating(Votes2,0,0,Avg2),
    Avg2 > Avg1.

getMaxRating([],Max,Max).
getMaxRating([_-V|Xs],CurrMax,Max) :-
    V > CurrMax,
    NewCurrMax is V,
    getMaxRating(Xs,NewCurrMax,Max).
getMaxRating([_-V|Xs],CurrMax,Max) :-
    V =< CurrMax,
    getMaxRating(Xs,CurrMax,Max).

likedBetter(User1,User2) :-
    vote(User1,Votes1),
    vote(User2,Votes2),
    getMaxRating(Votes1,0,Max1),
    getMaxRating(Votes2,0,Max2),
    Max1 > Max2.

getNotSeenMovie(_,[],_) :- fail.
getNotSeenMovie(Votes1,[M-_|_],M):-
    \+ member(M-_,Votes1).
getNotSeenMovie(Votes1,[M-_|Xs],Movie):-
    member(M-_,Votes1),
    getNotSeenMovie(Votes1,Xs,Movie).

sawSameMovies([],_).
sawSameMovies([M-_|Xs], Votes2) :-
    member(M-_,Votes2),
    sawSameMovies(Xs,Votes2).

getMovies([],[]).
getMovies([M-_|Xxs],[M|Xs]) :-
    getMovies(Xxs,Xs).

recommends(User1,Movie) :- 
    vote(User1,Votes1),
    vote(User2,Votes2),
    User1 \= User2,
    sawSameMovies(Votes1,Votes2),
    getNotSeenMovie(Votes1,Votes2,Movie).

intersect([],_,[]).
intersect([X|Xs], L2, [X|Xss]):-
    member(X,L2),
    intersect(Xs, L2, Xss).
intersect([X|Xs], L2, LI):-
    \+ member(X,L2),
    intersect(Xs, L2, LI).

subtract([],_,[]).
subtract([X|Xs], L2, [X|Xss]):-
    \+ member(X,L2),
    subtract(Xs, L2, Xss).
subtract([X|Xs], L2, LI):-
    member(X,L2),
    subtract(Xs, L2, LI).

onlyOne(User1, User2, OnlyOneList) :-
    vote(User1,Votes1),
    vote(User2,Votes2),
    getMovies(Votes1,Movies1),
    getMovies(Votes2,Movies2),
    append(Movies1,Movies2,AllMovies),
    intersect(Movies1,Movies2,BothMovies),
    subtract(AllMovies,BothMovies,OnlyOneList).

getVoteFromList(_,[],_) :- fail.
getVoteFromList(M,[M-V|_],V).
getVoteFromList(M,[K-_|Xs],V) :-
    M \= K,
    getVoteFromList(M,Xs,V).

getVote(User,Movie,Vote) :-
    film(Movie,_,_,_),
    vote(User, Votes),
    getVoteFromList(Movie,Votes,Vote).

filmVoting :-
    film(Movie,_,_,_),
    findall(User-Vote, getVote(User,Movie,Vote), UserVotes),
    append([filmUserVotes,Movie],[UserVotes],Final),
    write(Final),nl,
    asserta(filmUserVotes(Movie,UserVotes)),
    fail.
filmVoting.

nNumeros(Lista, QuantosSao) :-
    nNumeros(Lista, 0, QuantosSao).

nNumeros([],QuantosSao,QuantosSao).
nNumeros([Lower - Upper| Rest], Count, QuantosSao) :-
    NewCount is Count + (Upper - Lower) + 1,
    nNumeros(Rest,NewCount,QuantosSao).

intersetamSimple(_,[]) :- fail.
intersetamSimple(Lower1-Upper1, [Lower2-Upper2 | _]):-
    \+ Upper1 < Lower2,
    \+ Lower1 > Upper2.
intersetamSimple(Lower1-Upper1, [_|Rest]):-
    intersetamSimple(Lower1-Upper1, Rest).

intersetam([],_) :- fail.
intersetam([Lower1-Upper1| _],List2) :-
    intersetamSimple(Lower1-Upper1,List2).
intersetam([_|Rest1], List2) :-
    intersetam(Rest1,List2).