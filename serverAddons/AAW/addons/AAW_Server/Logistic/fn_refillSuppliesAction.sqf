#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Adds the Infantery Resupply Action

    Parameter(s):
    None

    Returns:
    None
*/


private _title = MLOC(RefillSupplies);
private _iconIdle = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa";
private _iconProgress = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa";
private _condition = {
    call {
        _target = [cursorTarget, vehicle CLib_player] select (vehicle CLib_player != CLib_player && {driver vehicle CLib_player == CLib_player});
        ([_target, 3] call CFUNC(inRange) || {vehicle player == _target}) &&
        {_target getVariable ["supplyCapacity", 0] > (_target getVariable ["supplyPoints", 0])} && {
            [format [QGVAR(nearSupplySource_%1), _target], {
                if (GVAR(supplySourceObjects) findIf {
                    _x distance _this <= 50 &&
                    {toLower (_this getVariable ["side", str sideUnknown]) isEqualTo toLower str side group CLib_player}
                } != -1) exitWith {
                    GVAR(nearestSupply) = str side group CLib_player;
                    true
                };

                private _nearestObjects = nearestObjects [_this, ["AllVehicles"], 20, true];
                private _supplyVehicleIdx = _nearestObjects findIf {
                    _x getVariable ["constructionVehicle", 0] == 1 &&
                    {
                        toLower (_x getVariable ["side", str sideUnknown]) isEqualTo toLower str side group CLib_player
                        && {_x getVariable ["supplyPoints", 0] > 0}
                    }
                };
                if (_supplyVehicleIdx!=-1 && {(_nearestObjects select _supplyVehicleIdx) != _this}) then {
                    GVAR(nearestSupply) = _nearestObjects select _supplyVehicleIdx;
                    true;
                } else {
                    GVAR(nearestSupply) = objNull;
                    false;
                };
            }, _target, 1] call CFUNC(cachedCall);
        };
    };
};

private _onStart = {
    CLib_player setVariable[QGVAR(ResupplySupplyActionTime), time + 1];
};

GVAR(nearestSupply) = objNull;

private _onProgress = {
    params ["_target"];
    private _supplyCapacity = _target getVariable ["supplyCapacity", 0];
    private _supplyPoints = _target getVariable ["supplyPoints", 0];

    if (_supplyPoints == _supplyCapacity) exitWith {1};


    private _time = CLib_player getVariable[QGVAR(ResupplySupplyActionTime), time];

    if (_time <= time) then {
        if (GVAR(nearestSupply) isEqualType "") then {
            [QGVAR(refillSuppliesBase), [_target, 1000]] call CFUNC(serverEvent);
        } else {
            [QGVAR(refillSupplies), [GVAR(nearestSupply), _target, 1000]] call CFUNC(serverEvent);
        };

        CLib_player setVariable[QGVAR(ResupplySupplyActionTime), time+1];
    };

    _supplyPoints/_supplyCapacity;
};

private _onComplete = {



};

private _onInterruption = _onComplete;

[CLib_player, _title, _iconIdle, _iconProgress, _condition, _condition, _onStart, _onProgress, _onComplete, _onInterruption, [], 4000, true, false, ["isNotInVehicle"]] call CFUNC(addHoldAction);
