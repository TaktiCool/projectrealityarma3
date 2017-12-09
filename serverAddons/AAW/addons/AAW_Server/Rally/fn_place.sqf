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

    [group CLib_Player] call FUNC(destroy);

    private _pointObjects = getArray (missionConfigFile >> QPREFIX >> "Sides" >> (str playerSide) >> "squadRallyPointObjects");
    _pointObjects = _pointObjects apply {
        _x params ["_type", "_offset"];

        private _objPosition = _position vectorAdd _offset;
        private _obj = createVehicle [_type, [0, 0, 0], [], 0, "CAN_COLLIDE"];
        _obj setPos _objPosition;
        ["setVectorUp", _obj, [_obj, surfaceNormal getPos _obj]] call CFUNC(targetEvent);
        ["enableSimulation", [_obj, false]] call CFUNC(serverEvent);

        _obj
    };

    (group CLib_Player) setVariable [QGVAR(lastRallyPlaced), serverTime, true];
    private _text = format ["RP %1", groupId group CLib_Player];
    private _spawnCount = [CFGSRP(spawnCount), 1] call CFUNC(getSetting);
    private _pointId = [_text, "RALLY", _position, group CLib_Player, _spawnCount, "A3\ui_f\data\map\groupicons\badge_simple.paa", "A3\ui_f\data\map\groupicons\badge_simple.paa", _pointObjects] call EFUNC(Common,addDeploymentPoint);
    (group CLib_Player) setVariable [QGVAR(rallyId), _pointId, true];

    [_pointId, "spawnPointLocked", 0] call EFUNC(Common,setDeploymentPointData);

    [QGVAR(placed), _pointId] call CFUNC(globalEvent);

    ["displayNotification", group CLib_player, [
        QLSTRING(NewRally),
        [QLSTRING(Near), + ([_position] call EFUNC(Common,getNearestLocationName))],
        [["A3\ui_f\data\map\respawn\respawn_background_ca.paa", 1, [0.13, 0.54, 0.21, 1],1],["A3\ui_f\data\map\groupicons\badge_simple.paa", 0.8]]
    ]] call CFUNC(targetEvent);
}, [], "respawn"] call CFUNC(mutex);
