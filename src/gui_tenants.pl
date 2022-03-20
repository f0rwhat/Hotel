:- dynamic 
    getTenantsList/1,
    getBookingsList/1,
    getTenantOfRoom/2,
    addTenant/3,
    getPerson/5,
    ejectTenant/1,
    getChoise/2,
    inputDate/3,
    inputInt/1,
    inputStr/1,
    inputStr/2,
    cancelBooking/3,
    getDatesDif/2,
    getRoomPrice/2.

:- [manager_tenants].
:- [manager_persons].
:- [utils].


printTenants(Tenants):-
    swritef(S, '%7L%12L%12L%w', ['Room', 'Passport', 'Move in', 'Ejection']),
    writeln(S),
    r_printTenants(Tenants).
r_printTenants([]):-!.
r_printTenants([(Room, (MovedInDate, EjectionDate), Passport)|Other]):-
    format_time(string(MovedIn),"%d.%m.%Y",MovedInDate),
    format_time(string(Ejection),"%d.%m.%Y",EjectionDate),
    swritef(S, '%7L%12L%12L%w', [Room, Passport, MovedIn, Ejection]),
    writeln(S),
    r_printTenants(Other).

registerTenant(Passport):-
    getPerson(Passport, (Name, SecondName, LastName, PhoneNumber, Passport)),
    writeln('Client with such passport was found in clients base.'),
    swritef(S, 'Name: %w, Second name: %w, Third name: %w, Phone number: %w', [Name, SecondName, LastName, PhoneNumber]),
    writeln(S).
registerTenant(Passport):-
    writeln("This is client is new!"),
    writeln("Input clients first name:"),
    inputStr(FirstName),
    writeln("Input clients second name:"),
    inputStr(SecondName),
    writeln("Input clients third name:"),
    inputStr(ThirdName),
    writeln("Input clients phone number:"),
    inputStr(11, PhoneNumber),
    addPerson(FirstName, SecondName, ThirdName, PhoneNumber, Passport).

switchConfirmEjection(y, RoomNumber):-
    ejectTenant(RoomNumber).
switchConfirmEjection(_, _).
performEjection(RoomNumber):-
    not(getTenantOfRoom(RoomNumber, ((_, EjectionDate), Passport))),
    writeln('Noone lives in this room!').
performEjection(RoomNumber):-
    getTenantOfRoom(RoomNumber, ((_, EjectionDate), Passport)),
    format_time(string(Ejection),"%d.%m.%Y",EjectionDate),
    swritef(S, 'Room number: %w, Planned ejection date: %w, Client passport: %w.', [RoomNumber, Ejection, Passport]),
    writeln(S),
    writeln('Are you sure to proceed? [y/n]'),
    getChoise([y,n], Confirm),
    switchConfirmEjection(Confirm, RoomNumber).

switchConfirmCancelBooking(y, RoomNumber, MoveInDate, EjectionDate):-
    cancelBooking(RoomNumber, (YI, MI, DI), (YO, MO, DO)).
switchConfirmCancelBooking(_, _, _, _).
performCancelBooking(RoomNumber, (YI, MI, DI), (YO, MO, DO)):-
    not(getBookingOfRoom(RoomNumber, (YI, MI, DI), (YO, MO, DO), Passport)),
    writeln('No booking with specified dates found').
performCancelBooking(RoomNumber, (YI, MI, DI), (YO, MO, DO)):-
    getBookingOfRoom(RoomNumber, (YI, MI, DI), (YO, MO, DO), Passport),
    swritef(S, 'Room number: %w, Planned move in date: %w.%w.%w, Planned ejection date: %w.%w.%w, Client passport: %W.', [RoomNumber, DI, MI, YI, YO, MO, DO, Passport]),
    writeln(S),
    writeln('Are you sure to proceed? [y/n]'),
    getChoise([y,n], Confirm),
    switchConfirmCancelBooking(Confirm, RoomNumber, (YI, MI, DI), (YO, MO, DO)).

switchSettlement(y, RoomNumber, EjectionDate):-
    writeln('Input client passport (10 digits):'),
    inputStr(10, Passport),
    registerTenant(Passport),
    addTenant(RoomNumber, EjectionDate, Passport).
switchSettlement(n, _, _).
performSettlement(RoomNumber, EjectionDate):-
    not(getRoom(RoomNumber, _)),
    writeln('Room with provided number was not found').
performSettlement(RoomNumber, EjectionDate):-
    getRoomPrice(RoomNumber, PricePerNight),
    get_time(Stamp), 
    stamp_date_time(Stamp, X, 0), 
    date_time_value(date, X, date(InYear, InMonth, InDay)),
    getDatesDif((InYear, InMonth, InDay), EjectionDate, Dif),
    Price is PricePerNight * Dif,
    write('Price will be:'), writeln(Price),
    writeln('Are you sure to proceed? [y/n]'),
    getChoise([y,n], Confirm),
    switchSettlement(Confirm, RoomNumber, EjectionDate).

switchBooking(y, RoomNumber, MoveInDate, EjectionDate):-
    writeln('Input client passport (10 digits):'),
    inputStr(10, Passport),
    registerTenant(Passport),
    addBooking(RoomNumber, MoveInDate, EjectionDate, Passport).
switchBooking(n, _, _, _).
performBooking(RoomNumber, MoveInDate, EjectionDate):-
    not(getRoom(RoomNumber, _)),
    writeln('Room with provided number was not found').
performBooking(RoomNumber, MoveInDate, EjectionDate):-
    getRoomPrice(RoomNumber, PricePerNight),
    getDatesDif(MoveInDate, EjectionDate, Dif),
    Price is PricePerNight * Dif,
    write('Price will be:'), writeln(Price),
    writeln('Are you sure to proceed? [y/n]'),
    getChoise([y,n], Confirm),
    switchBooking(Confirm, RoomNumber, MoveInDate, EjectionDate).

tenantsMenuParser(1):-
    getTenantsList(Tenants),
    printTenants(Tenants),
    tenants_gui().
tenantsMenuParser(2):-
    getBookingsList(Tenants),
    printTenants(Tenants),
    tenants_gui().
tenantsMenuParser(3):-
    writeln('Input room number:'),
    inputInt(RoomNumber),
    writeln('Input ejection date in DD-MM-YYYY format:'),
    inputDate(D,M,Y),
    performSettlement(RoomNumber, (Y,M,D)),
    tenants_gui().
tenantsMenuParser(4):-
    writeln('Input room number:'),
    inputInt(RoomNumber),
    performEjection(RoomNumber),
    tenants_gui().
tenantsMenuParser(5):-
    writeln('Input room number:'),
    inputInt(RoomNumber),
    writeln('Input move in date in DD-MM-YYYY format'),
    inputDate(DI,MI,YI),
    writeln('Input ejection date in DD-MM-YYYY format:'),
    inputDate(DO,MO,YO),
    performBooking(RoomNumber, (YI, MI, DI), (YO, MO, DO)),
    tenants_gui().
tenantsMenuParser(6):-
    writeln('Input room number:'),
    inputInt(RoomNumber),
    writeln('Input move in date in DD-MM-YYYY format'),
    inputDate(DI,MI,YI),
    writeln('Input ejection date in DD-MM-YYYY format:'),
    inputDate(DO,MO,YO),
    performCancelBooking(RoomNumber, (YI, MI, DI), (YO, MO, DO)),
    tenants_gui().
tenantsMenuParser(7).
tenantsMenuParser(_):-
    writeln('Unknown operation'),
    tenants_gui().

tenants_gui():-
    nl,nl,
    writeln('1. List all tenants'),
    writeln('2. List all bookings'),
    writeln('3. Settle client in'),
    writeln('4. Eject client'),
    writeln('5. Add booking'),
    writeln('6. Remove booking'),
    writeln('7. Back'),
    inputInt(Number),
    tenantsMenuParser(Number).