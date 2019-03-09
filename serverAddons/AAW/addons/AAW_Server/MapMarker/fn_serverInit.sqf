#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Server Init of Map Marker System

    Parameter(s):
    None

    Returns:
    None
*/

["createMarker", {
    (_this select 0) call FUNC(createMapMarker);
}] call CFUNC(addEventhandler);
