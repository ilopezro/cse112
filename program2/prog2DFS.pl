/**
* Airport db
*/

airport( atl, 'Atlanta         ', degmin(  33,39 ), degmin(  84,25 ) ).
airport( bos, 'Boston-Logan    ', degmin(  42,22 ), degmin(  71, 2 ) ).
airport( chi, 'Chicago         ', degmin(  42, 0 ), degmin(  87,53 ) ).
airport( den, 'Denver-Stapleton', degmin(  39,45 ), degmin( 104,52 ) ).
airport( dfw, 'Dallas-Ft.Worth ', degmin(  32,54 ), degmin(  97, 2 ) ).
airport( lax, 'Los Angeles     ', degmin(  33,57 ), degmin( 118,24 ) ).
airport( mia, 'Miami           ', degmin(  25,49 ), degmin(  80,17 ) ).
airport( nyc, 'New York City   ', degmin(  40,46 ), degmin(  73,59 ) ).
airport( sea, 'Seattle-Tacoma  ', degmin(  47,27 ), degmin( 122,17 ) ).
airport( sfo, 'San Francisco   ', degmin(  37,37 ), degmin( 122,23 ) ).
airport( sjc, 'San Jose        ', degmin(  37,22 ), degmin( 121,56 ) ).


flight( bos, nyc, time( 7,30 ) ).
flight( dfw, den, time( 8, 0 ) ).
flight( atl, lax, time( 8,30 ) ).
flight( chi, den, time( 8,45 ) ).
flight( mia, atl, time( 9, 0 ) ).
flight( sfo, lax, time( 9, 0 ) ).
flight( sea, den, time( 10, 0 ) ).
flight( nyc, chi, time( 11, 0 ) ).
flight( sea, lax, time( 11, 0 ) ).
flight( den, dfw, time( 11,15 ) ).
flight( sjc, lax, time( 11,15 ) ).
flight( atl, lax, time( 11,30 ) ).
flight( atl, mia, time( 11,30 ) ).
flight( chi, nyc, time( 12, 0 ) ).
flight( lax, atl, time( 12, 0 ) ).
flight( lax, sfo, time( 12, 0 ) ).
flight( lax, sjc, time( 12, 15 ) ).
flight( nyc, bos, time( 12,15 ) ).
flight( bos, nyc, time( 12,30 ) ).
flight( den, chi, time( 12,30 ) ).
flight( dfw, den, time( 12,30 ) ).
flight( mia, atl, time( 13, 0 ) ).
flight( sjc, lax, time( 13,15 ) ).
flight( lax, sea, time( 13,30 ) ).
flight( chi, den, time( 14, 0 ) ).
flight( lax, nyc, time( 14, 0 ) ).
flight( sfo, lax, time( 14, 0 ) ).
flight( atl, lax, time( 14,30 ) ).
flight( lax, atl, time( 15, 0 ) ).
flight( nyc, chi, time( 15, 0 ) ).
flight( nyc, lax, time( 15, 0 ) ).
flight( den, dfw, time( 15,15 ) ).
flight( lax, sjc, time( 15,30 ) ).
flight( chi, nyc, time( 18, 0 ) ).
flight( lax, atl, time( 18, 0 ) ).
flight( lax, sfo, time( 18, 0 ) ).
flight( nyc, bos, time( 18, 0 ) ).
flight( sfo, lax, time( 18, 0 ) ).
flight( sjc, lax, time( 18,15 ) ).
flight( atl, mia, time( 18,30 ) ).
flight( den, chi, time( 18,30 ) ).
flight( lax, sjc, time( 19,30 ) ).
flight( lax, sfo, time( 20, 0 ) ).
flight( lax, sea, time( 22,30 ) ).


/**
* main method that gets start and end destination from console and calls the two functions
* findFlights, printFlights
*/
main :- read(Start), read(Destination), findFlights(Start, Destination, FlightPath), printItinerary(FlightPath).

/**
* Haversine formula
*
* dlon = lon2 - lon1   
* dlat = lat2 - lat1  
* a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2  
* c = 2 * atan2(sqrt(a), sqrt(1-a))   
* d = R * c
*/

haversine(LatD1, LatM1, LatD2, LatM2, LonD1, LonM1, LonD2, LonM2, Distance) :-
    degToRad(LatD1, LatM1, Lat1),
    degToRad(LatD2, LatM2, Lat2),
    degToRad(LonD1, LonM1, Lon1),
    degToRad(LonD2, LonM2, Lon2),
    Lon3 is Lon2 - Lon1,
    Lat3 is Lat2 - Lat1,
    A is sin(Lat3/2)**2 + cos(Lat1) * cos(Lat2) * sin(Lon3/2)**2,
    C is 2 * atan( sqrt(A), sqrt(1-A) ),
    Distance is (C * 3956).

/**
* convertToTime(Dis, Time, Hours, Minutes) converts the distance into time
**/

convertToTime(D, T, H, M) :- T is (D/500), H is truncate(T), M is truncate(float_fractional_part(T) * 60).


checkTime(H, M, FH, FM) :- 
    (M > 60),
    FH is H + 1,
    FM is M - 60.

/**
* Convert Degrees into Radians
*
* beginning = lat + long divided by 60 turns degmin() into degrees completely
* beginning * pi divided by 180 turns degrees into radians
*/

degToRad(D,M,Rad) :- 
    InitOperation is M rdiv 60,
    Addition is D+InitOperation,
    Numerator is Addition*pi,
    Rad is Numerator rdiv 180 + 0.00.

/**
* prints trip itinerary
*/
print_trip( Action, Code, Name, time( Hour, Minute)) :-   
    upcase_atom( Code, Upper_code),   format( "~6s  ~3s  ~s~26|  ~`0t~d~30|:~`0t~d~33|",           
    [Action, Upper_code, Name, Hour, Minute]),   
    nl.

/**
* findFlights(ArrivalAirport, DepartureAirport, [list of flights]) is the driver for the program 
* that will call FindFlights(Curr, Next, [], []) to get a list of airports 
*/

findFlights(A, B, [flight(A, C, T) | TailOfFlightList]) :- 
    flight(A, C, T), findFlights(C, B, [flight(A, C, T)], TailOfFlightList).


findFlights( Airport, Airport, _, [] ).

/**
* findFlights(A, B, [], []) will recursively look for a path between start to end
*/

findFlights(A, B, [flight( PreviousA, PreviousB, time( Hour1, Minute1)) | PreviousFlights], [flight( A, NextDest, time( Hour2, Minute2))| NextDestinations]) :-
    \+ (A = B), 
    flight(A, NextDest, time(Hour2, Minute2)), 
    airport(PreviousA, _, degmin( Deg, Min), degmin(Deg2, Min2)),
    airport(PreviousB, _, degmin( Deg3, Min3), degmin(Deg4, Min4)),
    haversine(Deg, Min, Deg3, Min3, Deg2, Min2, Deg4, Min4, Z), 
    convertToTime(Z, T, Hours, Minutes), 
    ArrivalTime is T + Hour1 + (Minute1/60), 
    DepartureTime is Hour2 + (Minute2/60), 
    AcceptableDepartureTime is ArrivalTime + 0.50, 
    AcceptableDepartureTime =< DepartureTime, 
    airport(A, _, degmin( Deg5, Min5), degmin(Deg6, Min6)),
    airport(NextDest, _, degmin( Deg7, Min7), degmin(Deg8, Min8)),
    haversine(Deg5, Min5, Deg7, Min7, Deg6, Min6, Deg8, Min8, DistanceTwo), 
    convertToTime(DistanceTwo, TimeTwo, Hours2, Minutes2), 
    NewPreviousFlights = append([flight( PreviousA,PreviousB, time(Hour1,Minute1) )],PreviousFlights),
    \+ (member( NextDest, NewPreviousFlights )),
    \+ ( NextDest = PreviousB ),
    \+ ( PreviousA = NextDest),
    findFlights( NextDest, End, [flight( A, NextDest, time(Hour2,Minute2) )| NewPreviousFlights], NextDestinations).

/**
* printItinerary will take in the list of destinations and will output to console
*/

printItinerary([flight( CurrAirport, NextAirport, time( Hours, Minutes))| RestOfTrip]) :- 
    airport(CurrAirport, Leaving, degmin( Deg, Min), degmin(Deg2, Min2)),
    airport(NextAirport, Arriving, degmin( Deg3, Min3), degmin(Deg4, Min4)),
    print_trip(depart, CurrAirport, Leaving, time(Hours, Minutes)), nl,
    haversine(Deg, Min, Deg3, Min3, Deg2, Min2, Deg4, Min4, Z), 
    convertToTime(Z, _, Hours1, Minutes1),
    TotalHours is Hours + Hours1, 
    TotalMinutes is Minutes + Minutes1, 
    checkTime(TotalHours, TotalMinutes, FinalHours, FinalMinutes),
    print_trip(arrive, NextAirport, Arriving, time(FinalHours, FinalMinutes)), 
    printItinerary(RestOfTrip).

printItinerary([]) :- nl.
