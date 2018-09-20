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


private _title = MLOC(RearmVehicle);
private _iconIdle = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa";
private _iconProgress = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa";
private _condition = {
    vehicle CLib_player != CLib_player && {driver vehicle player == CLib_player} &&
    {[format [QGVAR(nearAmmoSource_%1), vehicle CLib_player], {
        if ((_this getVariable [QGVAR(supplyData), [[]]]) select 0 isEqualTo []) exitWith {false};
        private _nearestObjects = nearestObjects [_this, ["All"], 20, true];
        DUMP(_nearestObjects);
        private _supplyIdx = _nearestObjects findIf {
            _x != _this && ((_x getVariable ["supplyType", []]) findIf {_x in ["AmmoVehicle", "Ammo"]}) != -1 &&
            {
                toLower (_x getVariable ["side", str sideUnknown]) isEqualTo toLower str side group CLib_player
                && {_x getVariable ["supplyPoints", 0] > 0}
            }
        };

        DUMP(_supplyIdx);

        if (_supplyIdx != -1) then {
            GVAR(nearestAmmo) = _nearestObjects select _supplyIdx;
            GVAR(targetVehicle) = _this;
            true;
        } else {
            GVAR(nearestAmmo) = objNull;
            false;
        };
    }, vehicle CLib_player, 1] call CFUNC(cachedCall)}
};
GVAR(nearestAmmo) = objNull;
GVAR(targetVehicle) = objNull;
private _onStart = {
    params ["_target", "_caller"];

    private _jobData = [];

    (GVAR(targetVehicle) getVariable [QGVAR(supplyData), [[], []]]) params ["_supplyDataNames", "_supplyData", "_supplyCost"];

    private _currentSupplyData = GVAR(targetVehicle) call FUNC(generateSupplyDataVehicle);

    private _jobData = [];
    {
        _x params ["_type", "_name", "_count"];
        private _idx = (_currentSupplyData select 0) find _name;
        private _currentCount = [];

        if (_idx >= 0) then {
            ((_currentSupplyData select 1) select _idx) params ["_type", "_name", "_count"];
            _currentCount = _count;
        };
        _idx = 0;
        private _jobDataElement = _count apply {
            private _n = if (count _currentCount > _idx) then {
                (_currentCount select _idx);
            } else {
                0
            };
            _idx = _idx + 1;
            [(_supplyCost select _forEachIndex)*(_x - _n), _n, _x];
        };
        _jobDataElement sort true;
        private _totalSupplyCost = 0;
        {
            _totalSupplyCost = _totalSupplyCost + (_supplyCost select _forEachIndex)*_x
        } count _count;

        _jobData pushBack [_type, _name, _jobDataElement, _totalSupplyCost];
    } forEach _supplyData;

    GVAR(targetVehicle) setVariable [QGVAR(JobData), _jobData];
    GVAR(targetVehicle) setVariable [QGVAR(ResupplyTime), time];
};

[QGVAR(CollectVehicleSupplies), {
    (_this select 0) params ["_source", "_target", ["_points", 0]];

    private _jobData = GVAR(targetVehicle) getVariable [QGVAR(JobData), []];
    private _collectedSupplies = GVAR(targetVehicle) getVariable [QGVAR(CollectedSupplies), []];
    private _resupplyTime = GVAR(targetVehicle) getVariable [QGVAR(ResupplyTime), -1];

    DUMP("_collectedSupplies = "+ str _collectedSupplies);
    DUMP("_resupplyTime = "+ str _resupplyTime);
    DUMP("_jobData = "+ str _jobData);



    private _amount = _jobData apply {
        _x params ["_type", "_name", "_elements", "_tsc"];
        private _cost = 0;
        {
            _cost = _cost + (_x select 0);
        } count _elements;
        _cost;
    };

    {
        _amount set [_forEachIndex, (_x - (_collectedSupplies select _forEachIndex)) max 0];
    } forEach _amount;

    while {abs _points > 0.001} do {
        DUMP("_amount = "+ str _amount);

        private _sumAmount = 0;
        {
            _sumAmount = _sumAmount + _x;
            nil
        } count _amount;

        DUMP("_sumAmount = "+ str _sumAmount);

        private _distributedSupplies = _collectedSupplies apply {0};

        if (_sumAmount <= 0) exitWith {
            _distributedSupplies = _amount apply {
                (_points/count(_amount));
            };
            {
                _collectedSupplies set [_forEachIndex, (_collectedSupplies select _forEachIndex) + _x];
            } forEach _distributedSupplies;
        };

        _distributedSupplies = _amount apply {
            (_x/_sumAmount)*_points;
        };

        DUMP("_distributedSupplies = "+ str _distributedSupplies);
        _sumAmount = 0;
        {
            private _value = (_distributedSupplies select _forEachIndex) min _x;
            _amount set [_forEachIndex, _x - _value];
            _points = _points - _value;
        } forEach _amount;

        {
            _collectedSupplies set [_forEachIndex, (_collectedSupplies select _forEachIndex) + _x];
        } forEach _distributedSupplies;
    };



    DUMP("_collectedSupplies = "+ str _collectedSupplies);
    private _take = false;
    {
        _x params ["_type", "_name", "_elements", "_tsc"];
        private _availableSupplies = _collectedSupplies select _forEachIndex;
        _elements = _elements apply {
            _x params ["_cost", "_currentCount", "_desiredCount"];
            if (_cost <= _availableSupplies && _cost > 0) then {
                _take = true;
                _availableSupplies = _availableSupplies - _cost;
                [0, _desiredCount, _desiredCount];
            } else {
                _x;
            };
        };
        _jobData set [_forEachIndex, [_type, _name, _elements, _tsc]];
        _collectedSupplies set [_forEachIndex, _availableSupplies];
    } forEach _jobData;

    if (_take) then {
        playSound "rearm";
    };

    DUMP("_collectedSupplies = "+ str _collectedSupplies);
    DUMP("_jobData = "+ str _jobData);

    GVAR(targetVehicle) setVariable [QGVAR(CollectedSupplies), _collectedSupplies, true];
    GVAR(targetVehicle) setVariable [QGVAR(JobData), _jobData];


    if (_resupplyTime == -1) then {
        DUMP("APPLY LOADOUT!");

        [QGVAR(ApplyVehicleLoadout), GVAR(targetVehicle), [GVAR(targetVehicle), _jobData]] call CFUNC(targetEvent);
    };
}] call CFUNC(addEventHandler);

private _onProgress = {
    params ["_target", "_caller"];

    private _startTime = GVAR(targetVehicle) getVariable [QGVAR(ResupplyTime), time];

    private _jobData = GVAR(targetVehicle) getVariable [QGVAR(JobData), []];
    private _collectedSupplies = GVAR(targetVehicle) getVariable [QGVAR(CollectedSupplies), []];

    private _currentSupplyCost = 0;
    private _totalSupplyCost = 0;
    {
        _x params ["_type", "_name", "_elements", "_tsc"];
        private _cost = 0;
        {
            _cost = _cost + (_x select 0);
        } count _elements;
        _currentSupplyCost = _currentSupplyCost + ((_cost - (_collectedSupplies select _forEachIndex)) max 0);
        _totalSupplyCost = _totalSupplyCost + _tsc;

    } forEach _jobData;
    _currentSupplyCost = ceil _currentSupplyCost;

    if (time - _startTime >= 0.5) then {
        [QGVAR(RequestSupplies), [GVAR(nearestAmmo), CLib_player, 5 min (_currentSupplyCost), true]] call CFUNC(serverEvent);
        GVAR(targetVehicle) setVariable [QGVAR(ResupplyTime), time];
    };

    (_totalSupplyCost -_currentSupplyCost) / _totalSupplyCost;

};

private _onComplete = {

    params ["_target", "_caller"];

    GVAR(targetVehicle) setVariable [QGVAR(ResupplyTime), -1];

    [QGVAR(CollectVehicleSupplies), [GVAR(nearestAmmo), CLib_player]] call CFUNC(localEvent);




};

private _onInterruption = _onComplete;

[CLib_player, _title, _iconIdle, _iconProgress, _condition, _condition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, false, ["isNotInVehicle"]] call CFUNC(addHoldAction);
