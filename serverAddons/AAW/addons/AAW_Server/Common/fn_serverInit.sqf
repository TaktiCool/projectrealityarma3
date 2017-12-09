#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    server Init for the Common Module

    Parameter(s):
    None

    Returns:
    None
*/

[{
    private _side1 = GVAR(competingSides) select 0;
    private _side2 = GVAR(competingSides) select 1;
    private _side1Count = _side1 countSide allPlayers;
    private _side2Count = _side2 countSide allPlayers;
    if (_side1Count == _side2Count) exitWith {};

    private _diff = abs (_side1Count - _side2Count);

    if (_diff < GVAR(maxPlayerCountDifference)) exitWith {};
    private _side = [_side1, _side2] select (_side1Count < _side2Count);
    private _icon = missionNamespace getVariable [format [QGVAR(Flag_%1), _side], "#(argb,8,8,3)color(0.5,0.5,0.5,1)"];

    ["displayNotification", _side, [
        QLSTRING(SIDESUNBALANCED),
        QLSTRING(changeSide),
        [_icon]
    ]] call CFUNC(targetEvent);
}, 120] call CFUNC(addPerFrameHandler);

missionNamespace setVariable [QGVAR(MissionStartTime), (daytime * 60 * 60) + ([QUOTE(PREFIX/CfgRespawn/matchStartCountdown), 0] call CFUNC(getSetting)), true];
