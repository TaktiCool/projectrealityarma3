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


private _title = MLOC(Resupply);
private _iconIdle = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa";
private _iconProgress = "\a3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_unloadDevice_ca.paa";
private _condition = {
    [_target, 3] call CFUNC(inRange)
    && {((_target getVariable ["supplyType", []]) findIf {_x in ["AmmoInfantry","AmmoInfantrySmall", "Ammo","Medical"]}) != -1
    && {(_target getVariable ["supplyPoints", 0]) > 0}}
};

private _onStart = {
    params ["_target", "_caller"];

    private _jobData = [];

    (CLib_player getVariable [QGVAR(supplyData), [[], []]]) params ["_supplyDataNames", "_supplyData", "_supplyCost"];

    private _currentSupplyData = call FUNC(generateSupplyData);

    private _isAmmoBox = (_target getVariable ["supplyType", []]) findIf {_x in ["AmmoInfantry", "Ammo", "AmmoInfantrySmall"]} != -1;
    private _isMedicBox = "Medical" in (_target getVariable ["supplyType", []]);
    private _isSmall = "AmmoInfantrySmall" in (_target getVariable ["supplyType", []]);

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
        private _isCorrectBox = (_type in [ST_MAGAZINE, ST_AMMOBOX] && _isAmmoBox ) || (_name == "FirstAidKit" && _isMedicBox);
        private _jobDataElement = [];
        {
            _x params ["_c"];
            private _currentMagazineInWeapon = false;
            private _n = if (count _currentCount > _idx) then {
                _currentMagazineInWeapon = (_currentCount select _idx) select 1 > 0;
                (_currentCount select _idx) select 0;
            } else {
                0
            };
            _idx = _idx + 1;
            private _cost = [0, (_supplyCost select _forEachIndex)*(_c - _n)] select _isCorrectBox;
            _cost = [_cost, 0] select (_isSmall && _cost > 20);
            if (!_currentMagazineInWeapon) then {
                _jobDataElement pushBack [_cost, _n, _c];
            };
            nil;
        } count _count;

        _jobDataElement sort true;
        private _totalSupplyCost = 0;
        {
            _totalSupplyCost = _totalSupplyCost + (_supplyCost select _forEachIndex)*(_x select 0);
        } count _count;

        _jobData pushBack [_type, _name, _jobDataElement, _totalSupplyCost];
    } forEach _supplyData;


    CLib_player setVariable [QGVAR(JobData), _jobData];
    CLib_player setVariable [QGVAR(ResupplyTime), time];

};

[QGVAR(CollectSupplies), {
    (_this select 0) params ["_source", "_target", ["_points", 0]];

    private _jobData = CLib_player getVariable [QGVAR(JobData), []];
    private _collectedSupplies = (CLib_player getVariable [QGVAR(CollectedSupplies), []]);
    private _resupplyTime = CLib_player getVariable [QGVAR(ResupplyTime), -1];

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
        private _nbrAmount = {
            _sumAmount = _sumAmount + _x;
            _x > 0;
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
            (_nbrAmount/count(_amount))*_points;
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

    CLib_player setVariable [QGVAR(CollectedSupplies), _collectedSupplies];
    CLib_player setVariable [QGVAR(JobData), _jobData];


    if (_resupplyTime == -1) then {
        DUMP("APPLY LOADOUT!");

        {
            _x params ["_type", "_name", "_elements", "_tsc"];
            if (_type == ST_MAGAZINE) then {
                CLib_player removeMagazines _name;
                {
                    if ((_x select 0) == 0 && (_x select 1) > 0) then {
                        CLib_player addMagazine [_name, _x select 1];
                    };
                } forEach _elements;
            };

            if (_type == ST_ITEM) then {
                CLib_player removeItems _name;
                {
                    if (_x select 0 == 0 && _x select 1 > 0) then {
                        CLib_player addItem _name;
                    };
                } forEach _elements;
            };

            if (_type == ST_AMMOBOX) then {
                private _ammoBoxData = _elements apply {_x select 1};
                CLib_player setVariable ["ammoBox", _ammoBoxData];
            };
        } forEach _jobData;
    } else {
        if (_take) then {
            CLib_player playAction "PutDown";
        };

    };

}] call CFUNC(addEventHandler);

private _onProgress = {
    params ["_target", "_caller"];

    private _startTime = CLib_player getVariable [QGVAR(ResupplyTime), time];

    private _jobData = CLib_player getVariable [QGVAR(JobData), []];
    private _collectedSupplies = CLib_player getVariable [QGVAR(CollectedSupplies), []];

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
        [QGVAR(RequestSupplies), [_target, CLib_player, 5 min (_currentSupplyCost)]] call CFUNC(serverEvent);
        CLib_player setVariable [QGVAR(ResupplyTime), time];
    };

    (_totalSupplyCost -_currentSupplyCost) / _totalSupplyCost;

};

private _onComplete = {

    params ["_target", "_caller"];

    CLib_player setVariable [QGVAR(ResupplyTime), -1];

    [QGVAR(CollectSupplies), [_target, CLib_player]] call CFUNC(localEvent);




};

private _onInterruption = _onComplete;

["All", _title, _iconIdle, _iconProgress, _condition, _condition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, false] call CFUNC(addHoldAction);
