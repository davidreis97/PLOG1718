/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */
:- dynamic film/4.

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

%vote(Username, List_of_Film-Rating) 
vote(john, ['Inferno'-7, 'Doctor Strange'-9, 'The Accountant'-6]). 
vote(jack, ['Inferno'-8, 'Doctor Strange'-8, 'The Accountant'-7]). 
vote(peter, ['The Accountant'-4, 'Hacksaw Ridge'-7, 'The Girl on the Train'-3]). 
vote(harry, ['Inferno'-7, 'The Accountant'-6]). 
vote(richard, ['Inferno'-10, 'Hacksaw Ridge'-10, 'Arrival'-9]).

curto(Title) :- film(Title,_,K,_), K < 125.

getVote(_,[],_) :- fail.
getVote(Film,[Film-Vote|_],Vote).
getVote(Film,[_|Xs],Vote) :-
        getVote(Film,Xs,Vote).
   
diff(User1, User2, Difference, Film) :-
        vote(User1,List1),
        vote(User2,List2),
        getVote(Film,List1,Vote1),
        getVote(Film,List2,Vote2),
        Difference is abs(Vote1-Vote2).

niceGuy(User) :-
        vote(User,List),
        getVote(Film1,List,Vote1),
        getVote(Film2,List,Vote2),
        Film1 \= Film2,
        Vote1 >= 8,
        Vote2 >= 8.

isIn(_,[]) :- fail.
isIn(Elem,[Elem|_]).
isIn(Elem,[_|Xs]) :-
        isIn(Elem,Xs).

elemsComuns(L1,C,L2):-
        elemsComuns(L1,[],C,L2).
elemsComuns([],Common,Common,_).
elemsComuns([X|Xs],Common,FCommon,List2) :-
        isIn(X,List2), !,
        \+ isIn(X,Common),
        append(Common,[X],NewCommon),
        elemsComuns(Xs,NewCommon,FCommon,List2).
elemsComuns([_|Xs],Common,FCommon,List2) :-
        elemsComuns(Xs,Common,FCommon,List2).

elemsTotal(L1,C,L2):-
        elemsTotal(L1,[],C,L2).
elemsTotal([],Common,Common,[]).
elemsTotal([],Common,FCommon,[X|Xs]) :-
         \+ isIn(X,Common),
        append(Common,[X],NewCommon),
        elemsTotal([],NewCommon,FCommon,Xs).
elemsTotal([X|Xs],Common,FCommon,List2) :-
        \+ isIn(X,Common),
        append(Common,[X],NewCommon),
        elemsTotal(Xs,NewCommon,FCommon,List2).
elemsTotal([],Common,FCommon,[_|Xs]) :-
        elemsTotal([],Common,FCommon,Xs).
elemsTotal([_|Xs],Common,FCommon,List2) :-
        elemsTotal(Xs,Common,FCommon,List2).
                  
printCategory(Category) :-
        film(Name,Categories,Duration,AvgRat),
        isIn(Category,Categories),
        write(Name), write(' ('),write(Duration), write('min, '), write(AvgRat), write('/10)'), nl,
        fail.
printCategory(_).

getAvg([],Count,Avg, FnlAvg) :- FnlAvg is (Avg/Count).
getAvg([X|Xs], Count, Avg, FnlAvg) :-
        NewAvg is Avg + X,
        NewCount is Count+1,
        getAvg(Xs,NewCount,NewAvg,FnlAvg).

   
durDiff(Film1,Film2,DurDiff) :-
        film(Film1,_,Dur1,_),
        film(Film2,_,Dur2,_),
        DurDiff is abs(Dur1-Dur2).

scoreDiff(Film1,Film2,ScoreDiff) :-
        film(Film1,_,_,Score1),
        film(Film2,_,_,Score2),
        ScoreDiff is abs(Score1-Score2).

percentCommonCat(Film1,Film2,PercentCommonCat) :-
        film(Film1, Cats1, _, _),
        film(Film2, Cats2, _, _), 
        elemsComuns(Cats1,Common,Cats2),
        elemsTotal(Cats1,Total,Cats2),
        length(Common,SizeCommon),
        length(Total,SizeTotal),
        PercentCommonCat is (SizeCommon*100/SizeTotal).

similarity(Film1,Film2,Similarity) :-
        percentCommonCat(Film1,Film2,PercentCommonCat),
        scoreDiff(Film1,Film2,ScoreDiff),
        durDiff(Film1,Film2,DurDiff),
        Similarity is (PercentCommonCat - 3*DurDiff - 5*ScoreDiff).
        
maxSim([],Films,SimilarityMax,SimilarityMax,Films).

maxSim([Film-Similarity|Xs],Films,SimilarityMax,CurrMaxSim,_) :-
        Similarity > CurrMaxSim, !,
        maxSim(Xs,Films,SimilarityMax,Similarity,[Film]).

maxSim([Film-Similarity|Xs],Films,SimilarityMax,CurrMaxSim,PrevMaxFilms) :-
        Similarity == CurrMaxSim, !,
        append(PrevMaxFilms,[Film],NewMaxFilms),
        maxSim(Xs,Films,SimilarityMax,Similarity,NewMaxFilms).

maxSim([_|Xs],Films,SimilarityMax,CurrMaxSim,PrevMaxFilms) :-
        maxSim(Xs,Films,SimilarityMax,CurrMaxSim,PrevMaxFilms).

mostSimilar(Film1,SimilarityMax,Films) :-
        findall(Film2-Similarity2,similarityAux(Film1,Film2,Similarity2),FilmsAndSimilarity),
        maxSim(FilmsAndSimilarity,Films,SimilarityMax,0,[]).

similarityAux(Film1, Film2, Similarity) :-
        film(Film2,_,_,_),
        Film1 \= Film2,
        similarity(Film1, Film2, Similarity).

getScores(User1,User2,Score1,Score2):-
        film(Film,_,_,_),
        
        

getScoreDiffs(User1,User2,ScoreDiff,FilmScores1,FilmScores2) :-        

avgScoreDiff(User1,User2,AvgScoreDiff) :-
        vote(User1,FilmScores1),
        vote(User2,FilmScores2),
        findall(ScoreDiff,getScoreDiffs(User1,User2,ScoreDiff,FilmScores1,FilmScores2),ScoreDiffs),
        getAvg(ScoreDiffs, 0 , 0 , AvgScoreDiff).

distancia(User1,Distancia,User2) :- 














                  