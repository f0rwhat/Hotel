:- consult(db_rooms).

concatRooms([], _, _, _, _):-!.
concatRooms(_, [], _, _, _):-!.
concatRooms(_, _, [], _, _):-!.
concatRooms(_, _, _, [], _):-!.
concatRooms([Number], [Price], [Description], [TypeName], [(Number, Price, Description, TypeName)]).
concatRooms([Number|Numbers], [Price|Prices], [Description|Descriptions], [TypeName|TypeNames], [(Number, Price, Description, TypeName)|OtherConcat]):-
    concatRooms(Numbers, Prices, Descriptions, TypeNames, OtherConcat).

getRoomsList(Result):-
    findall(Number, rooms(Number, _, _, _), Numbers),
    findall(Price, rooms(_, Price, _, _), Prices),
    findall(Description, rooms(_, _, Description, _), Descriptions),
    findall(TypeName, rooms(_, _, _, TypeName), TypeNames),
    concatRooms(Numbers, Prices, Descriptions, TypeNames, Result).

getRoom(Number, (Number, Price, Description, TypeName)):-
    rooms(Number, Price, Description, TypeName).

getRoomPrice(Number, Price):-
    rooms(Number, Price, _, _).