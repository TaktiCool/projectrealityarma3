#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Client Init for Vehicle Respawn System to show Notification

    Parameter(s):
    None

    Returns:
    None
*/
[QGVAR(vehicleRespawnAvailable), {
    params ["_args"];
    _args params ["_vehicle"];

    private _vehicleConfig = configFile >> "CfgVehicles" >> typeOf _vehicle;
    [
        QLSTRING(NewVehicleAvailable),
        getText (_vehicleConfig >> "displayName"),
        [
            ["\A3\ui_f_curator\data\rsccommon\rscattributerespawnvehicle\start_ca.paa", 1.2, [1,1,1,1],1],
            [getText (_vehicleConfig >> "picture"), 0.3, [1,1,1,1],1]
        ]
    ] call EFUNC(Common,displayNotification);
}] call CFUNC(addEventHandler);

// bug Fix for JIP and VehicleVarName
{
    if (vehicleVarName _x == "") then {
        private _varName = _x getVariable [QGVAR(vehicleVarName), ""];
        if (_varName != "") then {
            _x setVehicleVarName _varName;
        };
    };
    nil
} count (((entities "") - allUnits) + allUnits);
