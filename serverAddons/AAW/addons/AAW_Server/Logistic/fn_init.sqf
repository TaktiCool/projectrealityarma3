#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Logistic system

    Parameter(s):
    None

    Returns:
    None
*/

[QGVAR(ApplyVehicleLoadout), {
    (_this select 0) params ["_target", "_jobData"];
    {
        _x params ["_type", "_name", "_elements", "_tsc"];
        if (_type == ST_MAGAZINE) then {
            _target removeMagazinesTurret _name;
            {
                if ((_x select 0) == 0 && (_x select 1) > 0) then {
                    _target addMagazineTurret [_name select 0, _name select 1, _x select 1];
                };
            } forEach _elements;
        };
    } forEach _jobData;
}] call CFUNC(addEventhandler);
