:- consult(db_tenants).
:- consult(db_bookings).

:- dynamic
    compareStamps/4,
    compareStamps2/2.

:- [utils].

%BOOKINGS_SECTION
formBookingsList([], _):-!.
formBookingsList([RoomNumber], [(RoomNumber, DatePair, ClientPassport)]):-
    bookings(RoomNumber, DatePair, ClientPassport).
formBookingsList([RoomNumber|Other], [(RoomNumber, DatePair, ClientPassport)|OtherConcat]):-
    bookings(RoomNumber, DatePair, ClientPassport),
    formBookingsList(Other, OtherConcat).

getBookingsList(Result):-
    findall(RoomNumber, bookings(RoomNumber, _, _), RoomNumbers),
    formBookingsList(RoomNumbers, Result).

getBookingOfRoom(Number, (InYear, InMonth, InDay), (EjYear, EjMonth, EjDay), Passport):-
    bookings(Number, (date(InYear, InMonth, InDay), date(EjYear, EjMonth, EjDay)), Passport).

p_checkInBookings([], _, _):-false.
p_checkInBookings([(date(YBI,MBI,DBI), date(YBO,MBO,DBO))|OtherDates], DI, DO):-
    compareStamps(DI, DO, (YBI,MBI,DBI), (YBO,MBO,DBO)),!,
    p_checkInBookings(OtherDates, DI, DO);
    true.

isBookedForPeriod(Number, MoveInDate, EjectionDate):-
    findall(DatePair, bookings(Number, DatePair, _), DatePairs),
    p_checkInBookings(DatePairs, MoveInDate, EjectionDate).

addBooking(Number, MoveInDate, MoveInDate, _):-
    isBookedForPeriod(Number, MoveInDate, EjectionDate),
    writeln('Room is busy in this dates!').
addBooking(Number, MoveInDate, _, _):-
    isRoomBusyInDate(Number, MoveInDate),
    writeln('Room is busy in this dates!').
addBooking(Number, (InYear, InMonth, InDay), (EjYear, EjMonth, EjDay), Passport):-
    asserta(bookings(Number, (date(InYear, InMonth, InDay), date(EjYear, EjMonth, EjDay)), Passport)),
    tell('src/db_bookings.pl'), listing(bookings), told,
    writeln('Insert was successfull!').

cancelBooking(Number, (InYear, InMonth, InDay), (EjYear, EjMonth, EjDay)):-
    bookings(Number, (date(InYear, InMonth, InDay), date(EjYear, EjMonth, EjDay)), _),
    retract(bookings(Number, (date(InYear, InMonth, InDay), date(EjYear, EjMonth, EjDay)), _)),
    tell('src/db_bookings.pl'), listing(bookings), told,
    writeln('Booking was deleted!'),
    true.
cancelBooking(_,_,_):-
    writeln('Noone booking on this room for this dates!').

%MOVE_IN_SECTION
formTenantsList([], _):-!.
formTenantsList([RoomNumber], [(RoomNumber, DatePair, ClientPassport)]):-
    tenants(RoomNumber, DatePair, ClientPassport).
formTenantsList([RoomNumber|Other], [(RoomNumber, DatePair, ClientPassport)|OtherConcat]):-
    tenants(RoomNumber, DatePair, ClientPassport),
    formTenantsList(Other, OtherConcat).

getTenantsList(Result):-
    findall(RoomNumber, tenants(RoomNumber, _, _), RoomNumbers),
    formTenantsList(RoomNumbers, Result).

getTenantOfRoom(Number, (DatePair, Passport)):-
    tenants(Number, DatePair, Passport).

checkIfRoomBusy(Number, Result):-
    tenants(Number, _, _),!,
    Result = true;
    Result = false.

isRoomBusyInDate(Number, DI):-
    tenants(Number, (_, date(A,B,C)), _),
    not(compareStamps2(DI, (A,B,C))).

addTenant(Number, _, _):-
    tenants(Number, _, _),
    writeln('Room is busy already!').
addTenant(Number, (EjYear, EjMonth, EjDay), _):-
    get_time(TdStamp),
    date_time_stamp(date(EjYear,EjMonth,EjDay,0,0,0,0,-,-), EjStamp),
    TdStamp >= EjStamp,
    writeln('Dates are incorrect. Try again with correct ejectment dates').
addTenant(Number, (EjYear, EjMonth, EjDay), _):-
    get_time(Stamp), 
    stamp_date_time(Stamp, D, 0), 
    date_time_value(date, D, date(InYear, InMonth, InDay)),
    isBookedForPeriod(Number, (InYear, InMonth, InDay), (EjYear, EjMonth, EjDay)),
    writeln('Room is booked for this period').
addTenant(Number, (EjYear, EjMonth, EjDay), Passport):-
    get_time(Stamp), 
    stamp_date_time(Stamp, D, 0), 
    date_time_value(date, D, TodayDate),
    asserta(tenants(Number, (TodayDate, date(EjYear, EjMonth, EjDay)), Passport)),
    tell('src/db_tenants.pl'), listing(tenants), told,
    writeln('Settlement was successfull!').

ejectTenant(Number):-
    tenants(Number, _, _),
    retract(tenants(Number, _, _)),
    tell('src/db_tenants.pl'), listing(tenants), told,
    writeln('Ejection was successfull!'),
    true.
ejectTenant(_):-
    writeln('Noone lives in this room!').