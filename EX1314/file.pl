
stat(ana, thresh, 1000, 200).
stat(ana, evelyn, 150, 200).
stat(joao, ezreal, 300, 40).
stat(joao, wukong, 100, 40).
stat(carlos, nidalee, 56, 60).
stat(carlos, thresh, 70, 6).

pref(ana, thresh).
pref(joao, wukong).
pref(carlos, nidalee).

samePref(Jog1,Jog2):-
    pref(Jog1,Char),
    pref(Jog2,Char).

mostWinsWith(Char, JogadorMax, WinsMax) :-
    findall(Jogador-Wins,stat(Jogador,Char,Wins,_),Stats),
    mostWinsWithStats(Stats, 0, 0, JogadorMax, WinsMax).

mostWinsWithStats([],Jogador,Wins,Jogador,Wins).
mostWinsWithStats([Jogador-Wins | Xs], _ , CurrWins, JogadorMax, WinsMax) :-
    Wins > CurrWins,
    mostWinsWithStats(Xs, Jogador, Wins, JogadorMax, WinsMax).
mostWinsWithStats([_-Wins | Xs], CurrJogador, CurrWins, JogadorMax, WinsMax) :-
    \+ Wins > CurrWins,
    mostWinsWithStats(Xs, CurrJogador, CurrWins, JogadorMax, WinsMax).

ratio(Jogador,Char,Ratio) :-
    stat(Jogador,Char,Wins,Losses),
    Ratio is Wins/Losses.

getMaxRatio([],Char-Ratio,Char-Ratio).
getMaxRatio([Char-Ratio | Xs], _-CurrRatio, FinalChar-FinalRatio) :-
    Ratio > CurrRatio,
    getMaxRatio(Xs,Char-Ratio,FinalChar-FinalRatio).
getMaxRatio([_-Ratio | Xs], CurrChar-CurrRatio, FinalChar-FinalRatio) :-
    Ratio =< CurrRatio,
    getMaxRatio(Xs,CurrChar-CurrRatio,FinalChar-FinalRatio).

rightChoice(J) :-
    pref(J,Fav),
    ratio(J,Fav,RatioFav),
    findall(Char-Ratio,(stat(J,Char,_,_),ratio(J,Char,Ratio)),Ratios),
    getMaxRatio(Ratios,0-0,Fav-RatioFav).

teamOfGoodChoices([]).
teamOfGoodChoices([X|Xs]) :- rightChoice(X), teamOfGoodChoices(Xs).

teamPrefs([],Char,Char).
teamPrefs([Player|PlayerRest],CurrChars, FinalChar):-
    playerBestChoice(Player,Char),
    append(CurrChars,[Char],NewCurrChar),
    teamPrefs(PlayerRest,NewCurrChar, FinalChar).

playerBestChoice(J,BC) :-
    findall(Char-Ratio,(stat(J,Char,_,_),ratio(J,Char,Ratio)),Ratios),
    getMaxRatio(Ratios,0-0,BC-_).
    
differentPrefs(Players) :-
    teamPrefs(Players,[],Chars),
    length(Chars,K),
    sort(Chars,NewChars),
    length(NewChars,NewK),
    K == NewK.