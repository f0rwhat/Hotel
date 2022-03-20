:- dynamic 
    getPersonsList/1,
    addPerson/5,
    deletePerson/1,
    commitPersons/0,
    inputInt/1.

:- [manager_persons].
:- [utils].

printPersonsTable(Persons):-
    swritef(S, '%15L%15L%15L%15L%w', ['Name', 'SecondName', 'LastName', 'PhoneNumber', 'Passport']),
    writeln(S),
    recursive_printPersonsTable(Persons).
    
recursive_printPersonsTable([]):-!.
recursive_printPersonsTable([(Name, SecondName, LastName, PhoneNumber, Passport)|Other]):-
    swritef(S, '%15L%15L%15L%15L%w', [Name, SecondName, LastName, PhoneNumber, Passport]),
    writeln(S),
    recursive_printPersonsTable(Other).

personsMenuParser(1):-
    getPersonsList(Persons),
    printPersonsTable(Persons),
    persons_gui().
personsMenuParser(2).
personsMenuParser(_):-
    writeln('Unknown operation'),
    persons_gui().

persons_gui():-
    nl,nl,
    writeln('1. Get persons List'),
    writeln('2. Back'),
    inputInt(Number),
    personsMenuParser(Number).