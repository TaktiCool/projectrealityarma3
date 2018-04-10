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
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

GVAR(DraggableClasses) = ["Thing"];
GVAR(CargoClasses) = ["AllVehicles", "Thing"];

GVAR(ppBlur) = ppEffectCreate ["DynamicBlur", 999];
GVAR(ppColor) = ppEffectCreate ["colorCorrections", 1502];

["missionStarted", {
    {
        private _side = _x;
        private _cfg = QUOTE(PREFIX/CfgLogistics/) + ([format [QUOTE(PREFIX/Sides/%1/logistics), _side], ""] call CFUNC(getSetting));
        //private _cfg = (missionConfigFile >> QPREFIX >> "Sides" >> _side >> "cfgLogistic");
        private _objects = [_cfg + "/objectToSpawn"] call CFUNC(getSetting);

        _objects = _objects apply {
            private _obj = missionNamespace getVariable [_x, objNull];
            // dont allow Loading in the Create Crate Objects
            _obj setVariable ["cargoCapacity", 0];
            _obj
        };


        [
            "Request Resources",
            _objects,
            3,
            compile format ["(str playerside) == ""%1"" && ((leader CLib_Player) == CLib_Player) && (CLib_Player getVariable [""%2"", false])", _side, QEGVAR(Kit,isLeader)],
            FUNC(buildResourcesDisplay),
            ["onActionAdded", {
                params ["_id", "_target"];
                _target setUserActionText [_id, "Request Resources", "<img size='3' shadow='0' color='#ffffff' image='\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa' shadow=2/><br/><br/>Request Resources"];
            }, "priority", 1000, "showWindow", true]
        ] call CFUNC(addAction);

        nil
    } count ([QUOTE(PREFIX/Sides)] call CFUNC(getSettingSubClasses));
}] call CFUNC(addEventHandler);

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
