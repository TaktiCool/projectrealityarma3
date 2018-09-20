#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Spawn a Crate at a Position

    Remark:
    Only Execute on Server

    Parameter(s):
    0: Object Arguments <Array>
        0: Object Classname <String>
        1: Content of the Object <Array>(Default: [])
    1: Spawn Position <Array>

    Returns:
    None
*/

(_this select 0) params ["_args", "_spawnPos", ["_side", sideUnknown]];
//_args params ["_crateType", ["_content", []], "_clearOnSpawn", "_displayName", "_supplyPoints"];
_args params ["_target", "_cfg"];
private _content = [_cfg + "/content"] call CFUNC(getSetting);
private _crateType = [_cfg + "/classname"] call CFUNC(getSetting);
private _clearOnSpawn = ([_cfg + "/removeDefaultLoadout"] call CFUNC(getSetting)) > 0;
private _displayName = [_cfg + "/displayName"] call CFUNC(getSetting);
private _supplyCost = [_cfg + "/supplyCost", 0] call CFUNC(getSetting);
private _picture = [_cfg + "/picture", "\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa"] call CFUNC(getSetting);

if !(isClass (configFile >> "CfgVehicles" >> _crateType)) exitWith {
    DUMP("Crate Classname Dont Exist: " + _crateType)
};

private _supplyPoints = _target getVariable ["supplyPoints", 0];
if (_supplyPoints < _supplyCost) exitWith {};
_supplyPoints = _supplyPoints - _supplyCost;
_target setVariable ["supplyPoints", _supplyPoints, true];
["supplyPointsChanged", _side] call CFUNC(targetEvent);


private _spawnPos = [_spawnPos, 10, 0, _crateType] call CFUNC(findSavePosition);
private _crateObject = createVehicle [_crateType, [0, 0, 0], [], 0, "CAN_COLLIDE"];
_crateObject setPos _spawnPos;
if (_displayName != "") then {
    _crateObject setVariable [QGVAR(displayName), _displayName, true];
};

// hideObject until the Cargo is Filled up
_crateObject hideObjectGlobal true;

if (_clearOnSpawn) then {
    // clear the Cargo
    clearWeaponCargoGlobal _crateObject;
    clearMagazineCargoGlobal _crateObject;
    clearItemCargoGlobal _crateObject;
    clearBackpackCargoGlobal _crateObject;
};

if !(_content isEqualTo []) then {

    // Refill the Cargo
    {
        call {
            if ((_x select 0) isKindOf ["ItemCore", configFile >> "CfgWeapons"]) exitWith {
                _crateObject addItemCargoGlobal _x;
            };

            if (isClass (configFile >> "CfgMagazines" >> (_x select 0))) exitWith {
                _crateObject addMagazineCargoGlobal _x;
            };

            if ((_x select 0) isKindOf "Bag_Base") exitWith {
                _crateObject addBackpackCargoGlobal _x;
            };

            if (isClass (configFile >> "CfgWeapons" >> (_x select 0))) exitWith {
                _crateObject addWeaponCargoGlobal _x;
            };
        };
        nil
    } count _content;

};

if ("Attributes" in ([_cfg] call CFUNC(getSettingSubClasses))) then {
    private _subcfg = _cfg + "/Attributes";
    {
        _crateObject setVariable [_x, [format ["%1/%2", _subcfg, _x]] call CFUNC(getSetting), true];
    } count ([_subcfg] call CFUNC(getSettings));
};

_crateObject call FUNC(setLogisticVariables);

// Unhide the Cargo after Filling
_crateObject hideObjectGlobal false;
