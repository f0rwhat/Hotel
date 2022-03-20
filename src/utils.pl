p_check(_, [], _):-
    writeln('Undefined input'),
    false.
p_check(Choise, [ThisChoise|OtherChoises], Result):-
    ThisChoise == Choise,!,
    Result = Choise;
    p_check(Choise, OtherChoises, Result).

getChoise([], _):-
    writeln('No choises provided!'),
    !.
getChoise(Choises, Result):-
    read(Choise),
    p_check(Choise, Choises, Result).
getChoise(Choises, Result):-
    getChoise(Choises, Result).

inputDate(D, M, Y):-
    read(D-M-Y),
    integer(D),
    integer(M),
    integer(Y).
inputDate(D, M, Y):-
    writeln('Date is incorrect.'),
    inputDate(D, M, Y).

inputStr(Result):-
    read(Result),
    string(Result).
inputStr(Result):-
    writeln('This is not string.'),
    inputStr(Result).

inputStr(Length, Result):-
    read(Result),
    string(Result),
    string_length(Result, StrLength),
    Length == StrLength.
inputStr(Length, Result):-
    writeln('This is not string or size is incorrect.'),
    inputStr(Length, Result).

inputInt(Result):-
    read(Result),
    integer(Result).
inputInt(Result):-
    writeln('This is not number.'),
    inputInt(Result).

p_compareStamps(IStamp, OStamp, IBStamp, _):-
    IStamp < IBStamp,
    OStamp < IBStamp.
p_compareStamps(IStamp, OStamp, _, OBStamp):-
    IStamp > OBStamp,
    OStamp > OBStamp.

compareStamps((YI,MI,DI), (YO,MO,DO), (YBI,MBI,DBI), (YBO,MBO,DBO)):-
    date_time_stamp(date(YI,MI,DI,0,0,0,0,-,-), IStamp),
    date_time_stamp(date(YO,MO,DO,0,0,0,0,-,-), OStamp),
    date_time_stamp(date(YBI,MBI,DBI,0,0,0,0,-,-), IBStamp),
    date_time_stamp(date(YBO,MBO,DBO,0,0,0,0,-,-), OBStamp),
    p_compareStamps(IStamp, OStamp, IBStamp, OBStamp).

compareStamps2((YI,MI,DI), (YO,MO,DO)):-
    date_time_stamp(date(YI,MI,DI,0,0,0,0,-,-), IStamp),
    date_time_stamp(date(YO,MO,DO,0,0,0,0,-,-), OStamp),
    IStamp > OStamp.

getDatesDif((YI,MI,DI), (YO,MO,DO), Dif):-
    date_time_stamp(date(YI,MI,DI,0,0,0,0,-,-), IStamp),
    date_time_stamp(date(YO,MO,DO,0,0,0,0,-,-), OStamp),
    StampDif is OStamp - IStamp, 
    Dif is StampDif / 86400.