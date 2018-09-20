#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Place FOB

    Parameter(s):
    None

    Returns:
    None
*/
params ["_target"];

[{
    params ["_target"];

    if (!(call FUNC(canPlace))) exitWith {};

    private _position = _target modelToWorld [0, 0, 0];
    private _dirVector = vectorDirVisual CLib_Player;
    if (CLib_Player distance _position >= 20) exitWith {
        ["FOB NOT PLACABLE", "Not enough space available!"] call EFUNC(Common,displayHint);
    };
    deleteVehicle _target;
    [{
        params ["_position", "_dirVector"];
        private _composition = getText (missionConfigFile >> QPREFIX >> "Sides" >> (str playerSide) >> "FOBComposition");

        private _text = [_position] call EFUNC(Common,getNearestLocationName);

        private _pointId = ["FOB " + _text, "FOB", _position, playerSide, -1, "A3\ui_f\data\map\markers\military\triangle_ca.paa", "A3\ui_f\data\map\markers\military\triangle_ca.paa"] call EFUNC(Common,addDeploymentPoint);

        [_pointId, _composition, _position, _dirVector, CLib_player, objNull, [CLib_player, {
            params ["_uid"];
            {
                ["enableSimulation", _x, [_x, false]] call CFUNC(targetEvent);
                _x setVariable ["FOBState", 1, true];
                _x setVariable ["side", str side group CLib_player, true];
                _x setVariable [QGVAR(fobId), _uid, true];
                nil;
            } count (CLib_SimpleObjectFramework_compNamespace getVariable [_uid, []]);
        }]] call CFUNC(createSimpleObjectComp);

        ["displayNotification", side group CLib_player, [
            "NEW FOB PLACED",
            "near " + _text,
            [["A3\ui_f\data\map\respawn\respawn_background_ca.paa", 1, [0, 0.4, 0.8, 1],1],["A3\ui_f\data\map\markers\military\triangle_ca.paa", 0.8]]
        ]] call CFUNC(targetEvent);

        [_pointId, "pointObjects", _pointId] call EFUNC(Common,setDeploymentPointData);
        [_pointId, "spawnPointLocked", 1] call EFUNC(Common,setDeploymentPointData);
        [_pointId, "spawnPointBlocked", 0] call EFUNC(Common,setDeploymentPointData);
        [_pointId, "spawnTime", serverTime + ([CFGFOB(waitTimeAfterPlacement), 300] call CFUNC(getSetting))] call EFUNC(Common,setDeploymentPointData);

        [QGVAR(placed), _pointId] call CFUNC(globalEvent);
    }, [_position, _dirVector]] call CFUNC(execNextFrame);

}, [_target], "respawn"] call CFUNC(mutex);
