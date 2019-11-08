/**
* Isai Lopez Rodas
* ilopezro
* CSE112: Comparative Programming Languages
* November 4th 2019
* Program 2: Flights
*/

/**
* Haversine formula
*
* dlon = lon2 - lon1   
* dlat = lat2 - lat1  
* a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2  
* c = 2 * atan2(sqrt(a), sqrt(1-a))   
* d = R * c
*
*/

# haversine(Lat1, Lat2, Long1, Long2, Distance) :- 
#     degrees_to_radians(Long2, Long2Radians),
#     degrees_to_radians(Long1, Long1Radians),
#     degrees_to_radians(Lat2, Lat2Radians),
#     degrees_to_radians(Lat1, Lat1Radians),
#     Dlong is Long2Radians - Long1Radians, 
#     Dlat is Lat2Radians - Lat1Radians, 
#     A is sin(Dlat/2)**2 + cos(Lat1) * cos(Lat2) * sin(Dlong/2)**2, 
#     C is 2 * atan( sqrt(A), sqrt(1-A) ), 
#     Distance is C * 3956.

/**
*
* Convert Degrees into Radians
*
* beginning = lat + long divided by 60 turns degmin() into degrees completely
* beginning * pi divided by 180 turns degrees into radians
* 
*/

degToRad(D,M,Rad) :- 
    InitOperation is M rdiv 60,
    Addition is D+InitOperation,
    Numerator is Addition*pi,
    Rad is Numerator rdiv 180 + 0.00.

print_trip( Action, Code, Name, time( Hour, Minute)) :-   
    upcase_atom( Code, Upper_code),   format( "~6s  ~3s  ~s~26|  ~02d:~02d",
    [Action, Upper_code, Name, Hour, Minute]),   nl.

test :- print_trip( depart, nyc, 'New York City', time( 9, 3)),
        print_trip( arrive, lax, 'Los Angeles', time( 14, 22)).
        
doSomething(nyc,lax) :- test.

main :- read(input).


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

