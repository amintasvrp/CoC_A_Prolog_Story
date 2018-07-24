%Testando os métodos do back pra commitar resto

% Usa-se "!" para o programa não ir mais atrás de outra regra condicional.
if(Condition,Then,Else) :- Condition, !, Then.
if(_,_,Else) :- Else.

printSeparator():- write("-------------------------------------------------------------"),nl.

gameOver() :- write("
██████╗  █████╗ ███╗   ███╗███████╗
██╔════╝ ██╔══██╗████╗ ████║██╔════╝
██║  ███╗███████║██╔████╔██║█████╗
██║   ██║██╔══██║██║╚██╔╝██║██╔══╝
╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝

██████╗ ██╗   ██╗███████╗██████╗
██╔═══██╗██║   ██║██╔════╝██╔══██╗
██║   ██║██║   ██║█████╗  ██████╔╝
██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗
╚██████╔╝ ╚████╔╝ ███████╗██║  ██║
╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝").

:- initialization(menu).
menu :- 
write('Welcome to the Colosseum of Champions!!!'), nl,
write('Get ready for a great adventure that could'), nl, 
write('result in your glory...'), nl,
write('...or in your oblivion...'), nl,

write('\nDo you want to play?\n(1) Yes\n(2) No\nOption'), read(Nome).
