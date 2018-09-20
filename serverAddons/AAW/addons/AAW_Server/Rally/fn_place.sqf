#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Place rally

    Parameter(s):
    None

    Returns:
    None
*/
[{
    if (!(call FUNC(canPlace))) exitWith {};

    private _position = CLib_Player modelToWorld [0, 1.5, 0];
    if (CLib_Player distance _position >= 20) exitWith {
        ["RALLY POINT NOT PLACEABLE", "Not enough space available!"] call EFUNC(Common,displayHint);
    };

    [group CLib_Player] call FUNC(destroy);

    (group CLib_Player) setVariable [QGVAR(lastRallyPlaced), serverTime, true];
    private _text = format ["RP %1", groupId group CLib_Player];
    private _spawnCount = [CFGSRP(spawnCount), 1] call CFUNC(getSetting);
    private _pointId = [_text, "RALLY", _position, group CLib_Player, _spawnCount, "A3\ui_f\data\map\groupicons\badge_simple.paa", "A3\ui_f\data\map\groupicons\badge_simple.paa"] call EFUNC(Common,addDeploymentPoint);
    private _composition = getText (missionConfigFile >> QPREFIX >> "Sides" >> (str playerSide) >> "RallyComposition");
    private _dirVector = vectorDirVisual CLib_Player;

    [_pointId, _composition, _position, _dirVector, CLib_player, objNull, [CLib_player, {
        params ["_uid"];

        {
            ["enableSimulation", _x, [_x, false]] call CFUNC(targetEvent);
            _x setVariable ["side", str side group CLib_player, true];
            _x setVariable [QGVAR(rallyId), _uid, true];
            nil;
        } count (CLib_SimpleObjectFramework_compNamespace getVariable [_uid, []]);
    }]] call CFUNC(createSimpleObjectComp);
    [_pointId, "pointObjects", _pointId] call EFUNC(Common,setDeploymentPointData);

    (group CLib_Player) setVariable [QGVAR(rallyId), _pointId, true];

    [_pointId, "spawnPointLocked", 0] call EFUNC(Common,setDeploymentPointData);

    [QGVAR(placed), _pointId] call CFUNC(globalEvent);

    ["displayNotification", group CLib_player, [
        "NEW RALLY POINT AVAILABLE",
        "near " + ([_position] call EFUNC(Common,getNearestLocationName)),
        [["A3\ui_f\data\map\respawn\respawn_background_ca.paa", 1, [0.13, 0.54, 0.21, 1],1],["A3\ui_f\data\map\groupicons\badge_simple.paa", 0.8]]
    ]] call CFUNC(targetEvent);
}, [], "respawn"] call CFUNC(mutex);
