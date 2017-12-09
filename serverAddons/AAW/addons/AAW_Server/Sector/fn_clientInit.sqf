#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Initialize the Sector Module on Client

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(currentSector) = objNull;

["missionStarted", {
    [QGVAR(LoadingScreen)] call BIS_fnc_startLoadingScreen;
    [{
        [QGVAR(LoadingScreen)] call BIS_fnc_endLoadingScreen;
    }, {
        !isNil QEGVAR(Sector,ServerInitDone) && {EGVAR(Sector,ServerInitDone)}
    }] call CFUNC(waitUntil);
}] call CFUNC(addEventhandler);

["sectorEntered", {
    params ["_args"];
    _args params ["_unit", "_sector"];
    [true, _sector] call FUNC(showCaptureStatus);

}] call CFUNC(addEventHandler);

["sectorLeaved", {
    [false, _this select 1] call FUNC(showCaptureStatus);
    GVAR(currentSector) = objNull;
}] call CFUNC(addEventHandler);

["sectorSideChanged", {
    params ["_args"];
    _args params ["_sector", "_oldSide", "_newSide"];

    private _sectorName = _sector getVariable ["fullName", ""];
    private _designator = _sector getVariable ["designator", ""];

    if ((side group CLib_Player) isEqualTo _newSide) exitWith {
        [QLSTRING(SECTORCAPTURED), _sectorName, [
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_ca.paa", 1, [0, 0.4, 0.8, 1], 1],
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_empty_ca.paa"],
            [format ["A3\ui_f\data\igui\cfg\simpletasks\letters\%1_ca.paa", toLower _designator], 0.57]
        ]] call EFUNC(Common,displayNotification);
    };

    if ((side group CLib_Player) isEqualTo _oldSide) exitWith {
        [QLSTRING(SECTORLOST), _sectorName, [
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_ca.paa", 1, [0.6, 0, 0, 1], 1],
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_empty_ca.paa"],
            [format ["A3\ui_f\data\igui\cfg\simpletasks\letters\%1_ca.paa", toLower _designator], 0.57]
        ]] call EFUNC(Common,displayNotification);
    };

    if (sideUnknown isEqualTo _newSide && !((side group CLib_Player) isEqualTo _oldSide)) exitWith {
        [QLSTRING(SECTORNEUTRALIZED), _sectorName, [
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_ca.paa", 1,  [0.93, 0.7, 0.01,0.6], 1],
            ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_empty_ca.paa"],
            [format ["A3\ui_f\data\igui\cfg\simpletasks\letters\%1_ca.paa", toLower _designator], 0.57]
        ]] call EFUNC(Common,displayNotification);
    };
}] call CFUNC(addEventHandler);

[{
    if (isNil QGVAR(allSectorsArray)) exitWith {};
    scopeName "MAIN";
    if (alive CLib_Player) then {
        {
            private _marker = _x getVariable ["marker", ""];
            if (_marker != "") then {
                if (CLib_Player inArea _marker) then {
                    if (GVAR(currentSector) != _x) then {
                        if (!isNull GVAR(currentSector)) then {
                            if (!isServer) then {
                                ["sectorLeaved", [CLib_Player, GVAR(currentSector)]] call CFUNC(serverEvent);
                            };
                            ["sectorLeaved", [CLib_Player, GVAR(currentSector)]] call CFUNC(localEvent);
                        };

                        GVAR(currentSector) = _x;

                        if (!isServer) then {
                            ["sectorEntered", [CLib_Player, GVAR(currentSector)]] call CFUNC(serverEvent);
                        };
                        ["sectorEntered", [CLib_Player, GVAR(currentSector)]] call CFUNC(localEvent);

                    };
                    breakOut "MAIN";
                };
            };
            nil;
        } count GVAR(allSectorsArray);
    };

    if (!isNull GVAR(currentSector)) then {
        if (!isServer) then {
            ["sectorLeaved", [CLib_Player, GVAR(currentSector)]] call CFUNC(serverEvent);
        };
        ["sectorLeaved", [CLib_Player, GVAR(currentSector)]] call CFUNC(localEvent);
    };

}, 0.1, []] call CFUNC(addPerFrameHandler);
