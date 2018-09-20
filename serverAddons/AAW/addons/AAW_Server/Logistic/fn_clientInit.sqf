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
if (side CLib_player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};

GVAR(DraggableClasses) = ["Thing"];
GVAR(CargoClasses) = ["AllVehicles", "Thing"];

GVAR(ppBlur) = ppEffectCreate ["DynamicBlur", 999];
GVAR(ppColor) = ppEffectCreate ["colorCorrections", 1502];

GVAR(supplySourceObjects) = [];

["missionStarted", {
    {
        private _side = _x;
        private _cfg = QUOTE(PREFIX/CfgLogistics/) + ([format [QUOTE(PREFIX/Sides/%1/logistics), _side], ""] call CFUNC(getSetting));
        //private _cfg = (missionConfigFile >> QPREFIX >> "Sides" >> _side >> "cfgLogistic");
        private _objects = [_cfg + "/supplySourceObjects"] call CFUNC(getSetting);

        GVAR(supplySourceObjects) append (_objects apply {
            private _obj = missionNamespace getVariable [_x, objNull];
            // dont allow Loading in the Create Crate Objects
            _obj setVariable ["side", _side];
            _obj
        });

        nil
    } count ([QUOTE(PREFIX/Sides)] call CFUNC(getSettingSubClasses));
}] call CFUNC(addEventHandler);

["respawn", {
    [{
        [{
            private _supplyData =  call FUNC(generateSupplyData);
            private _supplyCost = (_supplyData select 1) apply {
                if (_x select 0 == ST_MAGAZINE) then {
                    private _cfgMagazine = configFile >> "CfgMagazines" >> _x select 1;
                    private _ammoCount = [_cfgMagazine >> "count"] call CFUNC(getConfigDataCached);
                    private _ammoType = [_cfgMagazine >> "ammo"] call CFUNC(getConfigDataCached);
                    private _ammoCost = [configFile >> "CfgAmmo" >> _ammoType >> "cost"] call CFUNC(getConfigDataCached);
                    sqrt (_ammoCost*_ammoCount)/_ammoCount;
                } else {
                    if (_x select 0 == ST_AMMOBOX) then {
                        1
                    } else {
                        10;
                    }
                };
            };
            private _collectedSupplies = (_supplyData select 0) apply {0};
            _supplyData pushBack _supplyCost;
            CLib_player setVariable [QGVAR(SupplyData), _supplyData];
            CLib_player setVariable [QGVAR(CollectedSupplies), _collectedSupplies];
        }] call CFUNC(execNextFrame);
    }] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

[
    "Build",
    "All",
    3,
    //compile format ["(str playerside) == ""%1"" && ((leader CLib_Player) == CLib_Player) && (CLib_Player getVariable [""%2"", false])", _side, QEGVAR(Kit,isLeader)],
    {toLower (_target getVariable ["side", str sideUnknown]) isEqualTo toLower str side group CLib_player
        && _target getVariable ["constructionVehicle", 0] == 1
    },
    FUNC(buildResourcesDisplay),
    ["onActionAdded", {
        params ["_id", "_target"];
        _target setUserActionText [_id, "Build", "<img size='3' shadow='0' color='#ffffff' image='\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa' shadow=2/><br/><br/>Build"];
    }, "priority", 1000, "showWindow", true]
] call CFUNC(addAction);

["unconsciousnessChanged", {
    if (!isNull (CLib_Player getVariable [QGVAR(Item), objNull])) then {
        CLib_Player call FUNC(dropObject);
    };
}] call CFUNC(addEventhandler);

["isNotDragging", {
    params ["_caller", "_target"];
    isNull (_caller getVariable [QGVAR(Item), objNull])
     && isNull (_target getVariable [QGVAR(Item), objNull])
}] call CFUNC(addCanInteractWith);

["isNotDragged", {
    params ["", "_target"];
    isNull (_target getVariable [QGVAR(Dragger), objNull])
}] call CFUNC(addCanInteractWith);
