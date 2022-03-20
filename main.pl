:- dynamic 
    rooms_gui/0,
    tenants_gui/0,
    persons_gui/0,
    inputInt/1.

:- [src/gui_rooms].
:- [src/gui_tenants].
:- [src/gui_persons].
:- [src/utils].

menuParser(1):-
    rooms_gui(),
    start().
menuParser(2):-
    tenants_gui(),
    start().
menuParser(3):-
    persons_gui(),
    start().
menuParser(4).
menuParser(_):-
    writeln('Unknown operation').

start():-
    nl,nl,
    writeln('1. Rooms'),
    writeln('2. Tenants'),
    writeln('3. Clients'),
    writeln('4. Exit'),
    inputInt(Number),
    menuParser(Number).

    