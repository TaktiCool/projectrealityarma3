#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Event handler for the HandleDamage event

    Parameter(s):
    0: Unit <Object>
    1: selectionName <String>
    2: damage <Number>
    3: source <Object>
    4: projectile <String>
    5: hitPartIndex <Number>

    Returns:
    0: resulting damage <Number>
*/

params ["_unit", "_selectionName", "_damage", "_source", "_projectile", "_hitPartIndex"];
if (!(local _unit || {alive _unit})) exitWith {};
//DUMP(_this);
//DUMP(getAllHitPointsDamage PRA3_player select 2);
//DUMP(damage PRA3_player);
private _returnedDamage = _damage;
private _damageReceived = 0;
private _maxDamage = 0.95;

if (_hitPartIndex >= 0) then {
    private _lastDamage = PRA3_Player getHit _selectionName;
    _damageReceived = (_damage - _lastDamage) max 0;
    if (_damageReceived < 0.1) then {
        _returnedDamage = _lastDamage;
    } else {
        [_damageReceived] call FUNC(bloodEffect);
    };

};

if (_hitPartIndex <= 7) then {
    if (_damage >= 1) then {
        //if (_unit == vehicle _unit) then {
            [true] call FUNC(setUnconscious);
            PRA3_player setVariable [QGVAR(bleedingRate), (PRA3_player getVariable [QGVAR(bleedingRate),0]) + (_damageReceived min 1)];
        //} else {
            //_maxDamage = _damage;
        //};
    };
};


_returnedDamage min _maxDamage;
