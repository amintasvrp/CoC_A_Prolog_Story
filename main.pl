:- initialization(main).

%
%% IMPLEMENTAÇÕES FRONT
%

main :-
    Champions = ["Spider-Man","Black Panther","Winter Soldier","Captain America","Iron Man","Wolverine","Deadpool","Loki","Ultron","Doctor Strange","Thanos","Thor"],
    Party = [],
    createTeam(Champions, Team, Champions1),
    createEnemy(Champions1, Enemy, Champions2),
    intro,
    thisIsYourTeam(Champions2, Team, Party, Enemy).

% Cabeçalho
intro :-
    writeln("Welcome to the Colosseum of Champions!!!"),
    writeln("Get ready for a great adventure that could"),
    writeln("result in your glory..."),
    writeln("...or in your oblivion..."), nl.
    
% Mostrar Team
thisIsYourTeam(Champions, Team, Party, Enemy) :-
    writeln("(TEAM)"),
    printList(1, Team), nl,
    selectYourParty(Champions, Team, Party, Enemy).

%Escolher Ordem da Party
selectYourParty(Champions, Team, Party, Enemy) :-
    writeln("Select your party:"),
    read(First),
    read(Second),
    read(Third),
    FirstIndex is First - 1,
    SecondIndex is Second - 1,
    ThirdIndex is Third - 1,
    getElement(FirstIndex, Team, Champ1),
    getElement(SecondIndex, Team, Champ2),
    getElement(ThirdIndex, Team, Champ3),
    addChampion(Champ1, Party, Party1),
    addChampion(Champ2, Party1, Party2),
    addChampion(Champ3, Party2, Party3),
    nl, writeln("(PARTY)"),
    printList(1, Party3), nl,
    yourEnemy(Champions, Team, Party3, Enemy).

%Mostrar Inimigo
yourEnemy(Champions, Team, Party, Enemy) :-
    writeln("(ENEMY)"),
    printList(Enemy), nl,
    battleBegin(Champions, Team, Party, Enemy).

battleBegin(Champions, Team, [Attacker|Party], [Enemy|_]) :-
    writeln("Let the battle begin!"),
    champion(_,Attacker,AttackerHP,_,_,_),
    champion(_,Enemy,EnemyHP,_,_,_),
    attack(Champions, Team, Party, Attacker, AttackerHP, 0, Enemy, EnemyHP, 0).

attack(Champions, Team, Party, Attacker, AttackerHP, AttackerSpecial, Enemy, EnemyHP, EnemySpecial) :-
    write("(YOU) "), write(Attacker), write(" | "), write("HP: "), write(AttackerHP), write(" | "), write("Special: "), write(AttackerSpecial), write("/5"), nl,
    write("(ENEMY) "), write(Enemy), write(" | "), write("HP: "), write(EnemyHP), write(" | "), write("Special: "), write(EnemySpecial), write("/5"), nl, nl,
    
    writeln("Choose your Attack:"),
    write("1 - Normal"), nl,
    write("2 - Special"), nl,
    read(Attack),
    
    ((Attack =:= 1) -> 
    champion(AttackerClass,Attacker,_,_,_,_),
    champion(_,Attacker,_,AttackerNormalAttack,_,_), 
    champion(EnemyClass,Enemy,_,_,_,_),
    champion(_,Enemy,_,_,_,EnemyDef),
    calDamage(AttackerNormalAttack, EnemyDef, AttackerClass, EnemyClass, Damage),
    NewEnemyHP is EnemyHP - Damage,
    AttackerSpecial < 5 -> (NewAttackerSpecial is AttackerSpecial + 1 ; NewAttackerSpecial is 5),
    nl, write(Attacker), write(" caused "), write(Damage), write(" damage."), nl, nl,
    verifyWin(Champions, Team, Party, Attacker, AttackerHP, NewAttackerSpecial, Enemy, NewEnemyHP, EnemySpecial);
    
    (Attack =:= 2, AttackerSpecial =:= 5) -> 
    champion(AttackerClass,Attacker,_,_,_,_),
    champion(_,Attacker,_,_,AttackerSpecialAttack,_),
    champion(EnemyClass,Enemy,_,_,_,_),
    champion(_,Enemy,_,_,_,EnemyDef),
    calDamage(AttackerSpecialAttack, EnemyDef, AttackerClass, EnemyClass, Damage),
    NewEnemyHP is EnemyHP - Damage,
    write(Attacker), write(" caused "), write(Damage), write(" damage."), nl, nl,
    verifyWin(Champions, Team, Party, Attacker, AttackerHP, 0, Enemy, NewEnemyHP, EnemySpecial);

    (Attack =:= 2, AttackerSpecial =\= 5) -> nl, writeln("This action is unavailable, please try again..."), nl, attack(Champions, Team, Party, Attacker, AttackerHP, AttackerSpecial, Enemy, EnemyHP, EnemySpecial); 
    
    writeln("Wrong answer, please try again..."), attack(Champions, Team, Party, Attacker, AttackerHP, AttackerSpecial, Enemy, EnemyHP, EnemySpecial)).

verifyWin(Champions, Team, Party, Attacker, AttackerHP, AttackerSpecial, Enemy, EnemyHP, EnemySpecial) :-
    EnemyHP =< 0 -> writeln("Congratulations, you win!"), nl, newTeammate(Champions, Team, Enemy);
    defend(Champions, Team, Party, Attacker, AttackerHP, AttackerSpecial, Enemy, EnemyHP, EnemySpecial).

newTeammate(Champions, Team, Enemy):-
    addChampion(Enemy, Team, NewTeam),
    tamL(NewTeam,LengthNewTeam),
    
    ((LengthNewTeam =:= 12) -> youWin ;
    createEnemy(Champions, NewEnemy, NewChampions),
    thisIsYourTeam(NewChampions, NewTeam, [], NewEnemy)).

youWin :- writeln("Mission Complete: Congratulations, you got the grace of the champions.").

defend(Champions, Team, Party, Defender, DefenderHP, DefenderSpecial, Enemy, EnemyHP, EnemySpecial):-
    EnemySpecial =\= 5 -> 
    champion(DefenderClass,Defender,_,_,_,_),
    champion(_,Defender,_,_,_,DefenderDef),
    champion(EnemyClass,Enemy,_,_,_,_),
    champion(_,Enemy,_,EnemyNormalAttack,_,_),
    calDamage(EnemyNormalAttack, DefenderDef, EnemyClass, DefenderClass, Damage),
    NewDefenderHP is DefenderHP - Damage,
    NewEnemySpecial is EnemySpecial + 1,
    write(Enemy), write(" caused "), write(Damage), write(" damage."), nl, nl,
    verifyLose(Champions, Team, Party, Defender, NewDefenderHP, DefenderSpecial, Enemy, EnemyHP, NewEnemySpecial);
    
    champion(DefenderClass,Defender,_,_,_,_),
    champion(_,Defender,_,_,_,DefenderDef),
    champion(EnemyClass,Enemy,_,_,_,_),
    champion(_,Enemy,_,_,EnemySpecialAttack,_),
    calDamage(EnemySpecialAttack, DefenderDef, EnemyClass, DefenderClass, Damage),
    NewDefenderHP is DefenderHP - Damage,
    write(Enemy), write(" caused "), write(Damage), write(" damage."), nl, nl,
    verifyLose(Champions, Team, Party, Defender, NewDefenderHP, DefenderSpecial, Enemy, EnemyHP, 0).
    
verifyLose(Champions, Team, Party, Defender, DefenderHP, DefenderSpecial, Enemy, EnemyHP, EnemySpecial) :-
    DefenderHP =< 0 -> write(Defender), writeln(" was defeated."), nl, verifyParty(Champions, Team, Party, Defender, Enemy, EnemyHP, EnemySpecial);
    attack(Champions, Team, Party, Defender, DefenderHP, DefenderSpecial, Enemy, EnemyHP, EnemySpecial).

verifyParty(Champions, Team, Party, Defender, Enemy, EnemyHP, EnemySpecial) :-
    removeChampion(Defender, Party, NewParty),
    tamL(NewParty,LengthNewParty),
    
    LengthNewParty =:= 0 -> youLose ;
    
    getElement(0, NewParty, NewAttacker),
    champion(_,NewAttacker,NewAttackerHP,_,_,_),
    attack(Champions, Team, NewParty, NewAttacker, NewAttackerHP, 0, Enemy, EnemyHP, EnemySpecial).

youLose :- writeln("Mission Failed: Game Over").


% Printar todos os elementos de uma lista, enumerados
printList([H]) :- champion(C, H, _, _, _, _), write("["), write(C), write("]"), write(" "), writeln(H).
printList(N, [H]) :- write(N), write(" - "), champion(C, H, _, _, _, _), write("["), write(C), write("]"), write(" "), writeln(H).
printList(N, [H|T]) :- write(N), write(" - "), champion(C, H, _, _, _, _), write("["), write(C), write("]"), write(" "), writeln(H), NewN is N + 1, printList(NewN,T).

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
addChampionBegin(Champ, Lista, [Champ|Lista]).
addChampion(Champ, [], [Champ]).
addChampion(Champ,[Head],[Head|[Champ]]).
addChampion(Champ, [Head|Tail], Result) :- addChampion(Champ, Tail, ResultTail), addChampionBegin(Head, ResultTail, Result).

% Remove um campeão de uma lista.
removeChampion(Y, [Y], []).
removeChampion(X, [X|List1], List1).
removeChampion(X, [Y|List], [Y|List1]) :- removeChampion(X, List, List1).

% Obtém o campeão em uma lista a partir de um índice.
getElement(0, [H|_], H) :- !.
getElement(Ind, [_|T], C) :- Z is Ind - 1, getElement(Z, T, C).

% Obtém o índice de um campeão em uma lista.
getIndex(E, [E|_], 0) :- !.
getIndex(E, [_|T], Ind) :- getIndex(E, T, X), Ind is X + 1.

% Obtém o tamanho de uma lista.
tamL([], 0).
tamL([_|Tail], Tamanho) :- tamL(Tail, Result), Tamanho is Result+1.


%
%% IMPLEMENTAÇÕES BACK
%

% Cria a lista `team` baseando-se na lista `champions`
createTeam([], []).
createTeam(Champions, Team, NewChampions) :-
    % Escolha do primeiro teammate aleatório
    random_between(0, 5, Index),
    nth0(Index, Champions, Elem),
    
    addChampion(Elem, [], List1),
    removeChampion(Elem, Champions, List2),
    
    % Escolha do segundo teammate aleatório
    random_between(0, 4, Index2),
    nth0(Index2, List2, Elem2),
    
    addChampion(Elem2, List1, List3),
    removeChampion(Elem2, List2, List4),

    % Escolha do terceiro teammate aleatório
    random_between(0, 3, Index4),
    nth0(Index4, List4, Elem4),
    
    addChampion(Elem4, List3, Team),
    removeChampion(Elem4, List4, NewChampions).

% Cria a lista `enemy` baseando-se na lista `champions`
createEnemy([], []).
createEnemy(Champions, Enemy, NewChampions) :-
    % Escolha do inimigo aleatório
    length(Champions, Length),
    random(0, Length, Index),
    nth0(Index, Champions, Elem),
    
    addChampionBegin(Elem, [], Enemy),
    removeChampion(Elem, Champions, NewChampions).

% Cálculo do dano do atacante, considerando a defesa do defensor e a relacao de vantagem entre classes
calDamage(Damage, Defense, Atk, Def, Result) :- 
    Adv is Damage / 4, 
    calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv),
    Result is DamageAdv - Defense.

calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv) :-
    advantage(Atk,Def) -> DamageAdv is Damage + Adv ; DamageAdv is Damage.

% Recebe a lista de campeões e verifica se ela está com todos os 12 (vitória).
checkFinalVictory(Party, Result) :-
    tamL(Party, Lenght),
    Lenght =:= 12 -> Result = true ; Result = false.

% Recebe o HP do campeão inimigo e verifica se ele estiver morto.
checkPartialVictory(ChampionHP, Result) :-
    ChampionHP=< 0 -> Result = true ; Result = false.

% Recebe os três HPS dos campeões da party e verifica se todos estão derrotados
checkBattleLost(ChampHP1,ChampHP2,ChampHP3,Result) :-
    battleLost(ChampHP1,ChampHP2,ChampHP3) -> Result = true ; Result = false.
