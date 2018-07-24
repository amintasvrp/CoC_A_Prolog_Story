%Testando os métodos do back pra commitar resto

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
