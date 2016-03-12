#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy, joko // Jonas

    Description:
    Initialize the

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(competingSides) = [];
GVAR(captureStatusPFH) = -1;
GVAR(currentSector) = objNull;
{
    GVAR(competingSides) pushBack configName _x;
    missionNamespace setVariable [format ["%1_%2",QGVAR(Flag),configName _x], getText (_x >> "flag")];
    missionNamespace setVariable [format ["%1_%2",QGVAR(SideColor),configName _x], getArray (_x >> "color")];
    missionNamespace setVariable [format ["%1_%2",QGVAR(SideName),configName _x], getText (_x >> "name")];
    nil;
} count ("true" configClasses (missionConfigFile >> "PRA3" >> "sides"));

if (isServer) then {
    {_x setMarkerAlpha 0} count allMapMarkers;
    [{
        GVAR(allSectors) = (call CFUNC(getLogicGroup)) createUnit ["Logic", [0,0,0], [], 0, "NONE"];
        publicVariable QGVAR(allSectors);
        GVAR(allSectorsArray) = [];
        GVAR(FirstCaptureTime) = getArray (missionConfigFile >> "PRA3" >> "CfgSectors" >> "firstCaptureTime");
        private _sectors = "true" configClasses (missionConfigFile >> "PRA3" >> "CfgSectors");

        {
            if ((configName _x find "base") >= 0) then {
                [configName _x, getArray(_x >> "dependency"), getNumber(_x >> "ticketBleed"), getNumber(_x >> "minUnits"), getArray(_x >> "captureTime"),getArray(_x >> "firstCaptureTime"), getText(_x >> "designator"), getText(_x >> "isLastSector")] call FUNC(createSectorLogic);
            };
            nil;
        } count _sectors;

        private _path = selectRandom ("true" configClasses (missionConfigFile >> "PRA3" >> "CfgSectors" >> "CfgSectorPath"));

        {
            [configName _x, getArray (_x >> "dependency"),getNumber (_x >> "ticketBleed"),getNumber (_x >> "minUnits"),getArray (_x >> "captureTime"), getText (_x >> "designator")] call FUNC(createSectorLogic);
            nil;
        } count ("true" configClasses _path);

        publicVariable QGVAR(FirstCaptureTime);
        publicVariable QGVAR(allSectorsArray);
        GVAR(sectorCreationDone) = true;
        publicVariable QGVAR(sectorCreationDone);

    }, 3,[]] call CFUNC(wait);
};

[{
    {
        [_x] call FUNC(createSectorTrigger);
        nil;
    } count GVAR(allSectorsArray);
    if (isServer) then {
        GVAR(sectorLoopCounter) = 0;
        [FUNC(loop), 0.1, []] call CFUNC(addPerFrameHandler);
        ["sector_side_changed", {
            (_this select 0) params ["_sector", "_oldSide", "_newSide"];

            private _marker = _sector getVariable ["marker",""];

            if (_marker != "") then {
                _marker setMarkerColor format["Color%1",_newSide];
            };

            private _infoMarker = _sector getVariable ["informationMarker", ""];
            if (_infoMarker != "") then {
                _infoMarker setMarkerType SelectSideMarker(_newSide);
                _infoMarker setMarkerColor format["Color%1",_newSide];
            };
        }] call CFUNC(addEventHandler);
    };

    if (hasInterface) then {
        ["sector_entered", {[true,_this select 0] call FUNC(showCaptureStatus); GVAR(currentSector) = [_this select 0] call FUNC(getSector);}] call CFUNC(addEventHandler);

        ["sector_leaved", {[false,_this select 0] call FUNC(showCaptureStatus); GVAR(currentSector) = objNull;}] call CFUNC(addEventHandler);

        ["sector_side_changed", {
            params ["_args"];
            _args params ["_sector", "_oldSide", "_newSide"];
            // Dont use playerSide the player side dont change if chaning the side
            private _sectorName = _sector getVariable ["fullName", ""];
            if ((side player) isEqualTo _oldSide) then {
                ["PRA3_SectorLost", [format["Your team lost sector %1", _sectorName]]] call BIS_fnc_showNotification;
            } else {
                if (GVAR(currentSector) isEqualTo _sector) then {
                    ["PRA3_SectorCaptured", [format["You captured sector %1", _sectorName]]] call BIS_fnc_showNotification;
                } else {
                    ["PRA3_SectorCaptured", [format["Your team captured sector %1", _sectorName]]] call BIS_fnc_showNotification;
                };
            };

            //hint format ["SECTOR %1 SIDE CHANGED FROM %2 TO %3",_this select 0 select 0,_this select 0 select 1,_this select 0 select 2];

        }] call CFUNC(addEventHandler);

    };
}, {
    !isNil QGVAR(sectorCreationDone)
},[]] call CFUNC(waitUntil);
