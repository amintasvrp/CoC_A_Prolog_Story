%
%% IMPLEMENTAÇÕES FRONT
%


%
%% IMPLEMENTAÇÕES BACK
%

% Ocorrências de vantagem (fatos)

advantage("Mutant","Skill").
advantage("Skill","Science").
advantage("Science","Mystic").
advantage("Mystic","Cosmic").
advantage("Cosmic","Tech").
advantage("Tech","Mutant").

% Cálculo do dano do atacante, considerando a defesa do defensor e a relacao de vantagem entre classes

calDamage(Damage, Defense, Atk, Def, Result) :- 
    Adv is Damage / 4, 
    calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv),
    Result is DamageAdv - Defense.

calDamageAdvantage(Damage,Adv,Atk,Def,DamageAdv) :-
    advantage(Atk,Def) -> DamageAdv is Damage + Adv ; DamageAdv is Damage.

% Auxiliar para cálculo do tamanho da lista sem erros.
tamL([_], 1):- !.
tamL([_|L], T) :- tamL(L, X), T is X+1.

% Recebe a lista de campeões e verifica se ela está com todos os 12 (vitória).
checkFinalVictory(Party, Result):-
    tamL(Party, Lenght),
    Lenght =:= 12 -> Result = true ; Result = false.

% Recebe o HP do campeão inimigo e retorna true se ele estiver morto.
checkPartialVictory(ChampionHP, Result):-
    ChampionHP=< 0 -> Result = true ; Result = false.

% Fatos do battlelost
battleLost(0,0,0).

% Recebe os três HPS dos campeões da party e retorna true se todos estiverem mortos
checkBattleLost(ChampHP1,ChampHP2,ChampHP3,Result):-
    battleLost(ChampHP1,ChampHP2,ChampHP3) -> Result = true ; Result = false.


