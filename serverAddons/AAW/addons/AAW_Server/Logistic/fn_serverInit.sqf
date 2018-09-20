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

DFUNC(setLogisticVariables) = {
    params ["_entity"];

    private _cargoCapacity = _entity getVariable ["cargoCapacity", 0];

    if (_cargoCapacity > 0) then {

        private _className = typeOf _entity;
        private _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
        private _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
        private _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
        private _isCargo = (_tb > 0 || _tm > 0 || _tw > 0);

        _entity setVariable ["hasInventory", _isCargo, true];
        _entity addEventhandler ["Killed", {
            params ["_entity"];
            private _cargo = _entity getVariable [QGVAR(CargoItems), []];
            {
                deleteVehicle _x;
                nil
            } count _cargo;
            _entity setVariable [QGVAR(CargoItems), nil, true];
        }];
    };
};
["entityCreated", {
    (_this select 0) call FUNC(setLogisticVariables);
}] call CFUNC(addEventHandler);

["spawnCrate", FUNC(spawnCrate)] call CFUNC(addEventHandler);

[QGVAR(RequestSupplies), {
    (_this select 0) params ["_source", "_target", ["_points", 5], ["_isVehicle", false]];

    private _totalSupplyPoints = _source getVariable ["supplyPoints", 0];

    private _addedSupplyPoints = _points min _totalSupplyPoints;

    _totalSupplyPoints = _totalSupplyPoints - _addedSupplyPoints;

    _source setVariable ["supplyPoints", _totalSupplyPoints, true];

    if (_isVehicle) then {
        [QGVAR(CollectVehicleSupplies), _target, [_source, _target, _addedSupplyPoints]] call CFUNC(targetEvent);
    } else {
        [QGVAR(CollectSupplies), _target, [_source, _target, _addedSupplyPoints]] call CFUNC(targetEvent);
    };

}] call CFUNC(addEventHandler);

[QGVAR(RefillSuppliesBase), {
    (_this select 0) params ["_target", ["_points", 50]];



    private _supplyCapacity = _target getVariable ["supplyCapacity", 0];
    if (_supplyCapacity == 0) exitWith {};

    private _side = _target getVariable ["side", str sideUnknown];
    private _totalSupplyPoints = missionNamespace getVariable [format [QEGVAR(Logistic,supplyPoints_%1), _side], 0];

    if (_totalSupplyPoints == 0) exitWith {};

    private _supplyPoints = _target getVariable ["supplyPoints", 0];


    private _addedSupplyPoints = _points min (_totalSupplyPoints min (_supplyCapacity-_supplyPoints));

    _supplyPoints = _supplyPoints + _addedSupplyPoints;
    _totalSupplyPoints = _totalSupplyPoints - _addedSupplyPoints;

    _target setVariable ["supplyPoints", _supplyPoints, true];
    missionNamespace setVariable [format [QEGVAR(Logistic,supplyPoints_%1), _side], _totalSupplyPoints, true];
    ["supplyPointsChanged", _side] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

[QGVAR(RefillSupplies), {
    (_this select 0) params ["_source", "_target", ["_points", 50]];

    private _supplyCapacity = _target getVariable ["supplyCapacity", 0];
    if (_supplyCapacity == 0) exitWith {};

    private _availableSupplyPoints = _source getVariable ["supplyPoints", 0];
    if (_availableSupplyPoints == 0) exitWith {};

    private _supplyPoints = _target getVariable ["supplyPoints", 0];

    private _addedSupplyPoints = _points min (_availableSupplyPoints min (_supplyCapacity-_supplyPoints));

    if (_addedSupplyPoints == 0) exitWith {};

    _supplyPoints = _supplyPoints + _addedSupplyPoints;
    _availableSupplyPoints = _availableSupplyPoints - _addedSupplyPoints;

    _target setVariable ["supplyPoints", _supplyPoints, true];
    _source setVariable ["supplyPoints", _availableSupplyPoints, true];
}] call CFUNC(addEventHandler);

["missionStarted", {
    {
        private _cfg = QUOTE(PREFIX/CfgLogistics/) + ([format [QUOTE(PREFIX/Sides/%1/logistics), _x], ""] call CFUNC(getSetting));
        private _supplyPoints = [_cfg + "/supplyPoints", 100] call CFUNC(getSetting);
        private _supplyPointsGrowth = [_cfg + "/supplyPointsGrowth", [1, 12]] call CFUNC(getSetting);
        missionNamespace setVariable [format [QGVAR(supplyPoints_%1), _x], _supplyPoints, true];
        [{
            (_this select 0) params ["_supplyPointsGrowth", "_side"];
            private _supplyPoints = missionNamespace getVariable [format [QGVAR(supplyPoints_%1), _side], 0];
            _supplyPoints = _supplyPoints + (_supplyPointsGrowth select 0);
            missionNamespace setVariable [format [QGVAR(supplyPoints_%1), _side], _supplyPoints, true];
            ["supplyPointsChanged", _side] call CFUNC(targetEvent);
        }, _supplyPointsGrowth select 1, [_supplyPointsGrowth, _x]] call CFUNC(addPerFrameHandler);
        nil;
    } count EGVAR(Common,competingSides);
    nil;
}] call CFUNC(addEventHandler);


["entityCreated", {
    (_this select 0) params ["_entity"];
    [{
        params ["_entity"];
        [{
            params ["_entity"];
            private _supplyData = _entity call FUNC(generateSupplyDataVehicle);
            if (_supplyData select 0 isEqualTo []) exitWith {};
            private _supplyCost = (_supplyData select 1) apply {
                if (_x select 0 == ST_MAGAZINE) then {
                    private _cfgMagazine = configFile >> "CfgMagazines" >> (_x select 1) select 0;
                    private _ammoCount = [_cfgMagazine >> "count"] call CFUNC(getConfigDataCached);
                    private _ammoType = [_cfgMagazine >> "ammo"] call CFUNC(getConfigDataCached);
                    private _ammoCost = [configFile >> "CfgAmmo" >> _ammoType >> "cost"] call CFUNC(getConfigDataCached);
                    sqrt (_ammoCost*_ammoCount)/_ammoCount;
                } else {
                    10;
                };
            };
            private _collectedSupplies = (_supplyData select 0) apply {0};
            _supplyData pushBack _supplyCost;
            _entity setVariable [QGVAR(SupplyData), _supplyData, true];
            _entity setVariable [QGVAR(CollectedSupplies), _collectedSupplies, true];
        }, [_entity]] call CFUNC(execNextFrame);
    }, [_entity]] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);
