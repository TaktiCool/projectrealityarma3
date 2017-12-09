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
    getText (configFile >> "CfgActions" >> "Gear" >> "text"),
    GVAR(CargoClasses),
    5,
    {!(_target getVariable ["hasInventory", true])},
    {
        params ["_vehicle"];
        CLib_Player action ["Gear", objNull];
    },
    ["onActionAdded", {
        params ["_id", "_object", "_args"];
        _args params ["_title"];
        _object setUserActionText [_id, _title, "<img image='\A3\ui_f\data\igui\cfg\actions\gear_ca.paa' size='2.5' shadow=2 />"];
    }, "shortcut", "Gear"]
] call CFUNC(addAction);

["InventoryOpened", {
    (_this select 0) params ["_unit", "_container"];

    if ((typeOf _container) == "GroundWeaponHolder") then {
        private _cursorTarget = cursorTarget;
        if (!(_cursorTarget getVariable ["hasInventory", true]) && ((CLib_Player distance _cursorTarget) < 5)) then {
            _container = _cursorTarget;
        };
    };

    if (_container getVariable ["cargoCapacity", 0] == 0) exitWith {};
    GVAR(currentContainer) = _container;
    [{
        params ["_unit", "_container"];

        private _display = (findDisplay 602);
        private _gY = ((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25);
        private _gX = (((safeZoneW / safeZoneH) min 1.2) / 40);

        private _xOffset = [1, -5.25] select (_container getVariable ["hasInventory", true]);

        if (_container getVariable ["hasInventory", true]) then {
            {
                private _pos = ctrlPosition _x;

                _x ctrlSetPosition [
                    (_pos select 0) + 6.25 * _gX,
                    (_pos select 1)
                ];
                _x ctrlCommit 0;
                nil
            } count allControls _display;
        } else {
            {
                (_display displayCtrl _x) ctrlSetFade 1;
                (_display displayCtrl _x) ctrlCommit 0;
                nil
            } count [1001, 632, 6554, 6307, 6385, 6321];
        };

        private _group = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
        _group ctrlSetPosition [_xOffset * _gX + (safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2)) / 2), _gY + (safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2)) / 2), 12 * _gX, 25 * _gY];
        _group ctrlCommit 0;

        private _bg = _display ctrlCreate ["RscBackground", -1, _group];
        _bg ctrlSetPosition [0, 0, 12 * _gX, 23 * _gY];
        _bg ctrlSetBackgroundColor [0.05, 0.05, 0.05, 0.7];
        _bg ctrlCommit 0;

        private _header = _display ctrlCreate ["RscText", -1, _group];
        _header ctrlSetPosition [0.5 * _gX, 0.5 * _gY, 11 * _gX, 1.1 * _gY];
        _header ctrlSetBackgroundColor [0, 0, 0, 1];
        _header ctrlSetText "Cargo";
        _header ctrlCommit 0;

        with uiNamespace do {
            GVAR(CargoListBox) = _display ctrlCreate ["RscListBox", -1, _group];
            GVAR(CargoListBox) ctrlSetPosition [0.5 * _gX, 1.7 * _gY, 11 * _gX, 17.8 * _gY];
            GVAR(CargoListBox) ctrlSetBackgroundColor [0, 0, 0, 0];
            GVAR(CargoListBox) ctrlCommit 0;
        };

        private _unloadBtn = _display ctrlCreate ["RscButton", -1, _group];
        _unloadBtn ctrlSetPosition [0.5 * _gX, 20 * _gY, 5.5 * _gX, 1 * _gY];
        _unloadBtn ctrlSetText "UNLOAD";
        _unloadBtn ctrlAddEventHandler ["ButtonClick", {
            if !(isNull (objectParent CLib_Player)) exitWith {
                [MLOC(UnableToUnload)] call EFUNC(Common,displayHint);
            };
            [{
                params ["_vehicle"];
                private _index = lbCurSel (uiNamespace getVariable QGVAR(CargoListBox));
                if (_index == -1) exitWith {};

                closeDialog 602;
                private _draggedObjectArray = _vehicle getVariable [QGVAR(CargoItems), [ObjNull]];
                private _draggedObject = _draggedObjectArray deleteAt _index;
                ["allowDamage", _draggedObject, [_draggedObject, true]] call CFUNC(targetEvent);
                ["hideObject", [_draggedObject, false]] call CFUNC(serverEvent);
                ["enableSimulation", [_draggedObject, true]] call CFUNC(serverEvent);
                [_draggedObject, CLib_Player] call FUNC(dragObject);
                _vehicle setVariable [QGVAR(CargoItems), _draggedObjectArray, true];
            }, GVAR(currentContainer), "logistic"] call CFUNC(mutex);
        }];
        _unloadBtn ctrlCommit 0;

        private _loadBarFrame = _display ctrlCreate ["RscFrame", -1, _group];
        _loadBarFrame ctrlSetPosition [0.5 * _gX, 21.5 * _gY, 11 * _gX, 1 * _gY];
        _loadBarFrame ctrlSetTextColor [0.9, 0.9, 0.9, 0.5];
        _loadBarFrame ctrlCommit 0;

        with uiNamespace do {
            GVAR(CargoLoadBar) = _display ctrlCreate ["RscProgress", -1, _group];
            GVAR(CargoLoadBar) ctrlSetPosition [0.5 * _gX, 21.5 * _gY, 11 * _gX, 1 * _gY];
            GVAR(CargoLoadBar) ctrlSetTextColor [0.9, 0.9, 0.9, 0.9];
            GVAR(CargoLoadBar) progressSetPosition 0;
            GVAR(CargoLoadBar) ctrlCommit 0;
        };

        // UPDATE LOOP
        [{
            params ["_args", "_id"];

            if (isNull (findDisplay 602)) exitWith {
                [_id] call CFUNC(removePerFrameHandler);
            };

            _args params ["_container"];
            private _cargoItems = _container getVariable [QGVAR(CargoItems), []];
            with uiNamespace do {
                lbClear GVAR(CargoListBox);

                {
                    GVAR(CargoListBox) lbAdd (_x getVariable [QGVAR(displayName), getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName")]);
                    nil
                } count _cargoItems;
            };

            private _cargoCapacity = _container getVariable ["cargoCapacity", 0];
            private _usedCargoCapacity = 0;
            {
                _usedCargoCapacity = _usedCargoCapacity + (_x getVariable ["cargoSize", 0]);
            } count _cargoItems;

            with uiNamespace do {
                GVAR(CargoLoadBar) progressSetPosition (_usedCargoCapacity / _cargoCapacity);
            };

        }, 1, [_container]] call CFUNC(addPerFrameHandler);
    }, {!isNull (findDisplay 602)}, [_unit, _container]] call CFUNC(waitUntil);
}] call CFUNC(addEventHandler);
