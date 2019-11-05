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
    Dlong is Long2 - Long1, 
    Dlat is Lat2 - Lat1, 
    A is sin(Dlat/2)**2 + cos(Lat1) * cos(Lat2) * sin(Dlong/2)**2, 
    C is 2 * atan( sqrt(A), sqrt(1-A) ), 
    Distance is C * 3956.

/**
*
* Convert Degrees into Radians
*
*/

convert_degrees_to_radians

print_trip( Action, Code, Name, time( Hour, Minute)) :-   
    upcase_atom( Code, Upper_code),   format( "~6s  ~3s  ~s~26|  ~02d:~02d",
    [Action, Upper_code, Name, Hour, Minute]),   nl.

test :- print_trip( depart, nyc, 'New York City', time( 9, 3)),
        print_trip( arrive, lax, 'Los Angeles', time( 14, 22)).
        
doSomething(nyc,lax) :- test.

main :- read(A),read(B), doSomething(A,B).