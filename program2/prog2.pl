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

haversine(Lat1, Lat2, Long1, Long2, Distance) :- 
    degrees_to_radians(Long2, Long2Radians),
    degrees_to_radians(Long1, Long1Radians),
    degrees_to_radians(Lat2, Lat2Radians),
    degrees_to_radians(Lat1, Lat1Radians),
    Dlong is Long2Radians - Long1Radians, 
    Dlat is Lat2Radians - Lat1Radians, 
    A is sin(Dlat/2)**2 + cos(Lat1) * cos(Lat2) * sin(Dlong/2)**2, 
    C is 2 * atan( sqrt(A), sqrt(1-A) ), 
    Distance is C * 3956.

/**
*
* Convert Degrees into Radians
*
* beginning = lat + long divided by 60 turns degmin() into degrees completely
* beginning * pi divided by 180 turns degrees into radians
* 
*/

degrees_to_radians(degmin(degrees, minutes), output) :- 
    output is (((degrees + minutes)/60) * pi )/180.

print_trip( Action, Code, Name, time( Hour, Minute)) :-   
    upcase_atom( Code, Upper_code),   format( "~6s  ~3s  ~s~26|  ~02d:~02d",
    [Action, Upper_code, Name, Hour, Minute]),   nl.

test :- print_trip( depart, nyc, 'New York City', time( 9, 3)),
        print_trip( arrive, lax, 'Los Angeles', time( 14, 22)).
        
doSomething(nyc,lax) :- test.

main :- degrees_to_radians(degmin(33,39), output), 
        format("~6s"), [output], nl.