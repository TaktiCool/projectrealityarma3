#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Generates Supply data structure (for vehicle)

    Parameter(s):
    0: vehicle (OBJECT)

    Returns:
    None
*/
private _supplyType = [];
private _supplyNames = [];
private _supplyCount = [];
private _supplyCost = [];

{
    private _supplyId = [(_x select 0), (_x select 1)];
    private _idx = _supplyNames pushBackUnique _supplyId;
    private _count = [];
    if (_idx == -1) then {
        _idx = _supplyNames find _supplyId;
        _count = _supplyCount select _idx;
    };

    _count pushBack (_x select 2);

    _supplyCount set [_idx, _count];
    _supplyType set [_idx, ST_MAGAZINE];
    nil;
} count magazinesAllTurrets  _this;

private _supplyData = [];

{
    _supplyData pushback [
        _supplyType select _forEachIndex,
        _x,
        _supplyCount select _forEachIndex
    ];
} forEach _supplyNames;

[_supplyNames, _supplyData];
