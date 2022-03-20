:- dynamic 
    getRoomsList/1,
    getRoomType/2,
    checkIfRoomBusy/1,
    getChoise/2,
    inputDate/3,
    inputInt/1,
    isBookedForPeriod/3,
    isRoomBusyInDate/2,
    compareStamps2/2.

:- [manager_rooms].
:- [manager_room_types].
:- [manager_tenants].
:- [utils].


printRooms(Rooms, Extended, Filter):-
    Extended == n,
    swritef(S, '%8L%7L%12L%w', ['Number', 'Price', 'Room type', 'Description']),
    writeln(S),
    r_printRooms(Rooms, Extended, Filter).
printRooms(Rooms, Extended, Filter):-
    Extended == y,
    swritef(S, '%8L%7L%7L%12L%18L%6L%10L%9L%7L%w', ['Number', 'Price', 'Busy', 'Room type', 'Sleeping places', 'Beds', 'Bathroom', 'Kitchen', 'TV', 'Description']),
    writeln(S),
    r_printRooms(Rooms, Extended, Filter).
    
r_printRooms([], _, _):-!.
r_printRooms([(Number, Price, Description, RoomType)|Other], n, all):- %print_all
    swritef(S, '%8L%7L%12L%w', [Number, Price, RoomType, Description]),
    writeln(S),
    r_printRooms(Other, n, all).
r_printRooms([(Number, Price, Description, RoomType)|Other], y, all):- %print_all_extended_view
    checkIfRoomBusy(Number, IsRoomBusy),
    getRoomType(RoomType, (TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)),
    swritef(S, '%8L%7L%7L%12L%18L%6L%10L%9L%7L%w', [Number, Price, IsRoomBusy, RoomType, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv, Description]),
    writeln(S),
    r_printRooms(Other, y, all).
r_printRooms([(Number, Price, Description, RoomType)|Other], n, empty):- %print_clear
    checkIfRoomBusy(Number, IsRoomBusy), IsRoomBusy == false,
    swritef(S, '%8L%7L%12L%w', [Number, Price, RoomType, Description]),
    writeln(S),
    r_printRooms(Other, n, empty).
r_printRooms([(Number, Price, Description, RoomType)|Other], y, empty):- %print_clear_extended_view
    checkIfRoomBusy(Number, IsRoomBusy), IsRoomBusy == false,
    getRoomType(RoomType, (TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)),
    swritef(S, '%8L%7L%7L%12L%18L%6L%10L%9L%7L%w', [Number, Price, IsRoomBusy, RoomType, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv, Description]),
    writeln(S),
    r_printRooms(Other, y, empty).
r_printRooms([(Number, Price, Description, RoomType)|Other], n, busy):- %print_busy
    checkIfRoomBusy(Number, IsRoomBusy), IsRoomBusy == true,
    swritef(S, '%8L%7L%12L%w', [Number, Price, RoomType, Description]),
    writeln(S),
    r_printRooms(Other, n, busy).
r_printRooms([(Number, Price, Description, RoomType)|Other], y, busy):- %print_busy_extended_view
    checkIfRoomBusy(Number, IsRoomBusy), IsRoomBusy == true,
    getRoomType(RoomType, (TypeName, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv)),
    swritef(S, '%8L%7L%7L%12L%18L%6L%10L%9L%7L%w', [Number, Price, IsRoomBusy, RoomType, SleepingPlaces, Beds, HasBathroom, HasKitchen, HasTv, Description]),
    writeln(S),
    r_printRooms(Other, y, busy).
r_printRooms([_], _, _). %skipped_element_was_last
r_printRooms([_|Other], Extended, Filter):- %skip_room
    r_printRooms(Other, Extended, Filter).

p_checkIfFree((Number, Price, Description, RoomType), MoveInDate, EjectionDate):-
    not(isBookedForPeriod(Number, MoveInDate, EjectionDate)),
    not(isRoomBusyInDate(Number, MoveInDate)).

r_getListOfEmptyRooms([], _, _, _).
r_getListOfEmptyRooms([Room|Rooms], MoveInDate, EjectionDate, [Room|OtherCorrect]):-
    p_checkIfFree(Room, MoveInDate, EjectionDate),
    r_getListOfEmptyRooms(Rooms, MoveInDate, EjectionDate, OtherCorrect).
r_getListOfEmptyRooms([_|Rooms], MoveInDate, EjectionDate, OtherCorrect):-
    r_getListOfEmptyRooms(Rooms, MoveInDate, EjectionDate, OtherCorrect).

searchForRoomsInDates(MoveInDate, EjectionDate):-
    compareStamps2(EjectionDate, MoveInDate),
    getRoomsList(Rooms),
    r_getListOfEmptyRooms(Rooms, MoveInDate, EjectionDate, CorrectRooms),
    printRooms(CorrectRooms, n, all).
searchForRoomsInDates(_, _):-
    writeln('Dates order is incorrect').

roomsMenuParser(1):-
    writeln('List with extended info? [y/n]'),
    getChoise([y,n], PrintExtended),
    writeln('Use filter? [empty/busy/all]'),
    getChoise([empty,busy,all], Filter),
    getRoomsList(Rooms),
    printRooms(Rooms, PrintExtended, Filter),
    rooms_gui().
roomsMenuParser(2):-
    writeln('Input move in date in DD-MM-YYYY format'),
    inputDate(DI,MI,YI),
    writeln('Input ejection date in DD-MM-YYYY format'),
    inputDate(DO,MO,YO),
    searchForRoomsInDates((YI,MI,DI), (YO,MO,DO)),
    rooms_gui().
roomsMenuParser(3).
roomsMenuParser(_):-
    writeln('Unknown operation'),
    rooms_gui().

rooms_gui():-
    nl,nl,
    writeln('1. List rooms'),
    writeln('2. List empty rooms for period'), 
    writeln('3. Back'),
    inputInt(Number),
    roomsMenuParser(Number).