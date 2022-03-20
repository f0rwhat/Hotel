:- consult(db_room_types).

concatRoomTypes([], _, _, _, _, _, _):-!.
concatRoomTypes(_, [], _, _, _, _, _):-!.
concatRoomTypes(_, _, [], _, _, _, _):-!.
concatRoomTypes(_, _, _, [], _, _, _):-!.
concatRoomTypes(_, _, _, _, [], _, _):-!.
concatRoomTypes(_, _, _, _, _, [], _):-!.
concatRoomTypes([TypeName], [SleepingPlaces], [Beds], [HasBathroom], [HasKitchen], [HasTv], [(TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)]).
concatRoomTypes([TypeName|TypeNameList], [SleepingPlaces|SleepingPlacesList], [Beds|BedsList], [HasBathroom|HasBathroomList], [HasKitchen|HasKitchenList], [HasTv|HasTvList], [(TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)|OtherConcat]):-
    concatRoomTypes(TypeNameList, SleepingPlacesList, BedsList, HasBathroomList, HasKitchenList, HasTvList, OtherConcat).

getRoomTypesList(Result):-
    findall(TypeName, room_types(TypeName, _, _, _, _, _), TypeNameList),
    findall(SleepingPlaces, room_types(_, SleepingPlaces, _, _, _, _), SleepingPlacesList),
    findall(Beds, room_types(_, _, Beds, _, _, _), BedsList),
    findall(HasBathroom, room_types(_, _, _, HasBathroom, _, _), HasBathroomList),
    findall(HasKitchen, room_types(_, _, _, _, HasKitchen, _), HasKitchenList),
    findall(HasTv, room_types(_, _, _, _, _, HasTv), HasTvList),
    concatRoomTypes(TypeNameList, SleepingPlacesList, BedsList, HasBathroomList, HasKitchenList, HasTvList, Result).

getRoomType(TypeName, (TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)):-
    room_types(TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv).
getRoomType(_, _):-
    writeln('Room type with provided type name was not found'),
    false.