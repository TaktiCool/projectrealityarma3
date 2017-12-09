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
    {
        private _displayName = _target getVariable [QGVAR(displayName), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")];
        format [MLOC(Drag), _displayName]
    },
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
    {
        private _displayName = _target getVariable [QGVAR(displayName), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")];
        format [MLOC(loadItem), _displayName]
    },
    GVAR(CargoClasses),
    10,
    {
        !(isNull (CLib_Player getVariable [QGVAR(Item), objNull]))
         && !((CLib_Player getVariable [QGVAR(Item), objNull]) isEqualTo _target)
         && !(_target isKindOf "CAManBase")
    },
    {
        params ["_vehicle"];
        [{
            params ["_vehicle"];
            private _draggedObject = CLib_Player getVariable [QGVAR(Item), objNull];

            private _cargoSize = _draggedObject getVariable ["cargoSize", 0];
            private _ItemArray = _vehicle getVariable [QGVAR(CargoItems), []];
            private _cargoCapacity = _vehicle getVariable ["cargoCapacity", 0];
            {
                _cargoCapacity = _cargoCapacity - (_x getVariable ["cargoSize", 0]);
            } count _ItemArray;

            if (_cargoCapacity < _cargoSize) exitWith {
                [toUpper MLOC(noCargoSpace)] call EFUNC(Common,displayHint);
            };

            detach _draggedObject;
            CLib_Player playAction "released";

            ["allowDamage", _draggedObject, [_draggedObject, false]] call CFUNC(targetEvent);
            ["hideObject", [_draggedObject, true]] call CFUNC(serverEvent);
            ["enableSimulation", [_draggedObject, false]] call CFUNC(serverEvent);

            _draggedObject setPos [0, 0, 0];

            _ItemArray pushBack _draggedObject;
            _vehicle setVariable [QGVAR(CargoItems), _ItemArray, true];

            CLib_Player setVariable [QGVAR(Item), objNull, true];
            _draggedObject setVariable [QGVAR(Dragger), objNull, true];

            ["forceWalk", "Logistic", false] call CFUNC(setStatusEffect);

            CLib_Player action ["SwitchWeapon", CLib_Player, CLib_Player, 0];
        }, _vehicle, "logistic"] call CFUNC(mutex);
    },
    ["ignoredCanInteractConditions", ["isNotDragging"], "priority", 3000]
] call CFUNC(addAction);

[
    {
        private _displayName = _target getVariable [QGVAR(displayName), getText (configFile >> "CfgVehicles" >> typeOf _target >> "displayName")];
        format [MLOC(UnloadItem), _displayName]
    },
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
