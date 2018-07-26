:- initialization(main).

%
%% IMPLEMENTAÇÕES FRONT
%

%
%% FATOS
%
champion("Science", "Spider-Man", 200, 33, 50, 31).
champion("Skill", "Black Panther", 220, 38, 57, 30).
champion("Skill", "Winter Soldier", 240, 43, 65, 29).
champion("Science", "Captain America", 260, 48, 72, 28).
champion("Tech", "Iron Man", 280, 53, 80, 27).
champion("Mutant", "Wolverine", 300, 58, 87, 26).
champion("Mutant", "Deadpool", 320, 63, 95, 25).
champion("Mystic", "Loki", 340, 68, 102, 24).
champion("Tech", "Ultron", 360, 73, 110, 23).
champion("Mystic", "Doctor_Strange", 380, 78, 117, 22).
champion("Cosmic", "Thanos", 400, 83, 125, 21).
champion("Cosmic", "Thor", 420, 88, 132, 20).

% Ocorrências de vantagem
advantage("Mutant","Skill").
advantage("Skill","Science").
advantage("Science","Mystic").
advantage("Mystic","Cosmic").
advantage("Cosmic","Tech").
advantage("Tech","Mutant").

% Condição de derrota
battleLost(0,0,0).

%
%% IMPLEMENTAÇÕES DE MANIPULAÇÃO DE LISTAS
%

% Adiciona um campeão em uma lista.
addChampionBegin(X, L, [X|L]).
addChampionEnd(T, [H], L):- addChampionBegin(H, [T], L).
addChampionEnd(N, [H|T], L):- addChampionEnd(N, T, X), addChampionBegin(H, X, L).

% Remove um campeão de uma lista.
removeChampion(Y, [Y], []).
removeChampion(X, [X|List1], List1).
removeChampion(X, [Y|List], [Y|List1]):- removeChampion(X, List, List1).

% Obtém o campeão em uma lista a partir de um índice.
getElement(0, [H|_], H):- !.
getElement(Ind, [_|T], C):- Z is Ind - 1, getElement(Z, T, C).

% Obtém o índice de um campeão em uma lista.
getIndex(E, [E|_], 0):- !.
getIndex(E, [_|T], Ind):- getIndex(E, T, X), Ind is X + 1.

% Obtém o tamanho de uma lista.
tamL([_], 1):- !.
tamL([_|L], Tamanho) :- tamL(L, X), Tamanho is X+1.

%
%% IMPLEMENTAÇÕES BACK
%

% Cria a lista `champions`
createChampions(Champions) :-
    Champions = [
                "Spider-Man",
                "Black Panther",
                "Winter Soldier",
                "Captain America",
                "Iron Man",
                "Wolverine",
                "Deadpool",
                "Loki",
                "Ultron",
                "Doctor Strange",
                "Thanos",
                "Thor"
                ].

% Cria a lista `team` baseando-se na lista `champions`
% List5: lista `team`
% List6: lista `champions` após a remoção dos teammates
createTeam([], []).
createTeam(List, List5, List6) :-
    % Escolha do primeiro teammate aleatório
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elem),
    
    addChampionBegin(Elem, [], List1),
    removeChampion(Elem, List, List2),
    
    % Escolha do segundo teammate aleatório
    length(List2, Length2),
    random(0, Length2, Index2),
    nth0(Index2, List2, Elem2),
    
    addChampionEnd(Elem2, List1, List3),
    removeChampion(Elem2, List2, List4),

    % Escolha do terceiro teammate aleatório
    length(List4, Length4),
    random(0, Length4, Index4),
    nth0(Index4, List4, Elem4),
    
    addChampionEnd(Elem4, List3, List5),
    removeChampion(Elem4, List4, List6).

% Cria a lista `enemy` baseando-se na lista `champions`
% List1: lista `enemy`
% List2: lista `champions` após a remoção do inimigo
createEnemy([], []).
createEnemy(List, List1, List2) :-
    % Escolha do inimigo aleatório
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elem),
    
    addChampionBegin(Elem, [], List1),
    removeChampion(Elem, List, List2).

% Cálculo do dano do atacante, considerando a defesa do defensor e a relacao de vantagem entre classes
calDamage(Damage, Defense, Atk, Def, Result) :- 
    Adv is Damage / 4, 
    calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv),
    Result is DamageAdv - Defense.

calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv) :-
    advantage(Atk,Def) -> DamageAdv is Damage + Adv ; DamageAdv is Damage.

% Recebe a lista de campeões e verifica se ela está com todos os 12 (vitória).
checkFinalVictory(Party, Result):-
    tamL(Party, Lenght),
    Lenght =:= 12 -> Result = true ; Result = false.

% Recebe o HP do campeão inimigo e verifica se ele estiver morto.
checkPartialVictory(ChampionHP, Result):-
    ChampionHP=< 0 -> Result = true ; Result = false.

% Recebe os três HPS dos campeões da party e verifica se todos estão derrotados
checkBattleLost(ChampHP1,ChampHP2,ChampHP3,Result):-
    battleLost(ChampHP1,ChampHP2,ChampHP3) -> Result = true ; Result = false.

main :-
    createChampions(Champions),
    write("Champions : "), write(Champions), nl,
    
    createTeam(Champions, Team, Champions1),
    write("Team      : "), write(Team), nl,
    write("Champions1: "), write(Champions1), nl,
    
    createEnemy(Champions1, Enemy, Champions2),
    write("Enemy     : "), write(Enemy), nl,
    write("Champions2: "), write(Champions2), nl.