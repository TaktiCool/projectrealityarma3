#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, BadGuy

    Description:
    Logistic system

    Parameter(s):
    None

    Returns:
    None
*/

[
    {format [MLOC(Drag), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")]},
    GVAR(DraggableClasses),
    3,
    {
        isNull assignedGunner _target
         && isNull (CLib_Player getVariable [QGVAR(Item), objNull])
         && isNull (_target getVariable [QGVAR(Dragger), objNull])
         && (_target getVariable ["isDraggable", 0] == 1)
    },
    {
        params ["_draggedObject"];
        [FUNC(dragObject), [_draggedObject, CLib_Player], "logistic"] call CFUNC(mutex);
    }
] call CFUNC(addAction);

[
    QLSTRING(Drop),
    CLib_Player,
    0,
    {!(isNull (CLib_Player getVariable [QGVAR(Item), objNull]))},
    {
        [CLib_Player] call FUNC(dropObject);
    },
    ["ignoredCanInteractConditions", ["isNotDragging"], "priority", 2000]
] call CFUNC(addAction);

[
    {format [MLOC(loadItem), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")]},
    "AllVehicles",
    5,
    {
        !(isNull (CLib_Player getVariable [QGVAR(Item), objNull]))
         && {!((CLib_Player getVariable [QGVAR(Item), objNull]) isEqualTo _target)}
         && {(_target getVariable ["constructionVehicle", 0]) == 1}
    },
    {
        params ["_vehicle"];
        [{
            params ["_vehicle"];
            private _draggedObject = CLib_Player getVariable [QGVAR(Item), objNull];



            private _supplyPoints = _draggedObject getVariable ["supplyPoints", 0];
            private _supplyPointsTarget = _vehicle getVariable ["supplyPoints", 0];
            private _supplyCapacityTarget = _vehicle getVariable ["supplyCapacity", 0];

            if (_supplyPoints > (_supplyCapacityTarget - _supplyPointsTarget)) exitWith {
                [toUpper MLOC(noCargoSpace)] call EFUNC(Common,displayHint);
            };

            detach _draggedObject;
            CLib_Player playAction "released";

            CLib_Player setVariable [QGVAR(Item), objNull, true];
            _draggedObject setVariable [QGVAR(Dragger), objNull, true];

            [CLib_Player, "forceWalk", "Logistic", false] call CFUNC(setStatusEffect);

            CLib_Player action ["SwitchWeapon", CLib_Player, CLib_Player, 0];

            [QGVAR(refillSupplies), [_draggedObject, _vehicle, _supplyPoints]] call CFUNC(serverEvent);

            [{
                params ["_timeOut", "_obj"];
                _obj getVariable ["supplyPoints", 0] == 0 || _timeOut < time;
            }, {
                params ["_timeOut", "_obj"];
                if (_timeOut > time) then {
                    deleteVehicle _obj;
                };
            }, [time+5, _draggedObject]] call CFUNC(waitUntil);
        }, _vehicle, "logistic"] call CFUNC(mutex);
    },
    ["ignoredCanInteractConditions", ["isNotDragging"], "priority", 3000]
] call CFUNC(addAction);

[
    QLSTRING(DropAmmoBox),
    CLib_Player,
    0,
    {CLib_Player getVariable ["ammoBox", []] findIf {_x > 0} > -1},
    {
        private _ammoBoxData = CLib_Player getVariable ["ammoBox", []];

        if (_ammoBoxData isEqualTo []) exitWith {};

        _ammoBoxData sort false;

        if (_ammoBoxData select 0 <= 0) exitWith {};

        private _ammoBox = createVehicle ["Land_Ammobox_rounds_F", CLib_player modelToWorld [0, 1, 0], [], 0, "CAN_COLLIDE"];
        _ammoBox setVariable ["supplyType", ["AmmoInfantrySmall"], true];
        _ammoBox setVariable ["supplyPoints", _ammoBoxData select 0, true];
        _ammoBox setVariable ["ammoBoxOwner", CLib_player, true];
        _ammoBox setVariable ["side", str side group CLib_player, true];
        _ammoBoxData set [0, 0];

        CLib_player setVariable ["ammoBox", _ammoBoxData];

        CLib_player playAction "PutDown";
    },
    ["priority", 2000]
] call CFUNC(addAction);

[
    QLSTRING(TakeAmmoBox),
    "Land_Ammobox_rounds_F",
    3,
    {_target getVariable ["ammoBoxOwner", objNull] isEqualTo CLib_player && CLib_Player getVariable ["ammoBox", []] findIf {_x == 0} > -1},
    {
        params ["_ammoBox"];
        private _ammoBoxData = CLib_Player getVariable ["ammoBox", []];

        if (_ammoBoxData isEqualTo []) exitWith {};

        _ammoBoxData sort true;

        if (_ammoBoxData select 0 > 0) exitWith {};

        if !(_ammoBox getVariable ["ammoBoxOwner", objNull] isEqualTo CLib_player) exitWith {};

        _ammoBoxData set [0, _ammoBox getVariable ["supplyPoints", 0]];

        deleteVehicle _ammoBox;

        CLib_player playAction "PutDown";
    },
    ["priority", 2100]
] call CFUNC(addAction);
/*
[
    {format [MLOC(UnloadItem), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")]},
    GVAR(CargoClasses),
    10,
    {
        isNull (CLib_Player getVariable [QGVAR(Item), objNull]) && !((_target getVariable [QGVAR(CargoItems), []]) isEqualTo []) && isNull objectParent CLib_Player
    },
    {
        params ["_vehicle"];
        [{
            params ["_vehicle"];
            private _draggedObjectArray = _vehicle getVariable [QGVAR(CargoItems), [objNull]];
            private _draggedObject = _draggedObjectArray deleteAt 0;
            ["allowDamage", _draggedObject, [_draggedObject, true]] call CFUNC(targetEvent);
            ["hideObject", [_draggedObject, false]] call CFUNC(serverEvent);
            ["enableSimulation", [_draggedObject, true]] call CFUNC(serverEvent);
            [_draggedObject, CLib_Player] call FUNC(dragObject);
            _vehicle setVariable [QGVAR(CargoItems), _draggedObjectArray, true];
        }, _vehicle, "logistic"] call CFUNC(mutex);
    }
] call CFUNC(addAction);
*/
call FUNC(infantryResupplyAction);
call FUNC(vehicleRearmAction);
call FUNC(refillSuppliesAction);
