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
	
tamL([_], 1):- !.
tamL([_|L], T) :- tamL(L, X), T is X+1.

checkFinalVictory(P, R):-
    tamL(P, T),
    T =:= 12 -> R = true ; R = false.

checkPartialVictory(P, R):-
    P=< 0 -> R = true ; R = false.

checkBattleLost(A,B,C,R):-
    A =< 0 ; B =< 0 ; C =< 0 -> R = true ; R = false.


