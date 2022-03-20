:- [db_persons].

concatPersons([], _, _, _, _, _):-!.
concatPersons(_, [], _, _, _, _):-!.
concatPersons(_, _, [], _, _, _):-!.
concatPersons(_, _, _, [], _, _):-!.
concatPersons(_, _, _, _, [], _):-!.
concatPersons([Name], [SecondName], [LastName], [PhoneNumber], [Passport], [(Name, SecondName, LastName, PhoneNumber, Passport)]).
concatPersons([Name|Names], [SecondName|SecondNames], [LastName|LastNames], [PhoneNumber|PhoneNumbers], [Passport|Passports], [(Name, SecondName, LastName, PhoneNumber, Passport)|OtherConcat]):-
    concatPersons(Names, SecondNames, LastNames, PhoneNumbers, Passports, OtherConcat).

getPersonsList(Result):-
    findall(Name, persons(Name, _, _, _, _), Names),
    findall(SecondName, persons(_, SecondName, _, _, _), SecondNames),
    findall(LastName, persons(_, _, LastName, _, _), LastNames),
    findall(PhoneNumber, persons(_, _, _, PhoneNumber, _), PhoneNumbers),
    findall(Passport, persons(_, _, _, _, Passport), Passports),
    concatPersons(Names, SecondNames, LastNames, PhoneNumbers, Passports, Result).

checkIfPersonInfoExist(Passport):-
    persons(_, _, _, _, Passport).

getPerson(Passport, (Name, SecondName, LastName, PhoneNumber, Passport)):-
    persons(Name, SecondName, LastName, PhoneNumber, Passport).
getPerson(_, _):-
    writeln('Person with provided passport was not found'),
    false.

addPerson(Name, SecondName, LastName, PhoneNumber, Passport):-
    persons(Name, SecondName, LastName, PhoneNumber, Passport),
    writeln('Already in DB').
addPerson(Name, SecondName, LastName, PhoneNumber, Passport):-
    asserta(persons(Name, SecondName, LastName, PhoneNumber, Passport)),
    tell('src/db_persons.pl'), listing(persons), told,
    writeln('Person was saved!').

updatePerson(Passport, NewName, NewSecondName, NewLastName, NewPhoneNumber, NewPassport):-
    persons(Name, SecondName, LastName, PhoneNumber, Passport),
    retract(persons(Name, SecondName, LastName, PhoneNumber, Passport)),
    asserta(persons(NewName, NewSecondName, NewLastName, NewPhoneNumber, NewPassport)),
    writeln('Person edition was successfull!').
updatePerson(_, _, _, _, _, _):-
    writeln('Provided person was not found.').
