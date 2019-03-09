#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Registers a Map Control for MapGraphics

    Parameter(s):
    0: Map <Control>

    Returns:
    None
*/
params ["_map"];
// make sure that the control not already have a draw function
if (_map in GVAR(MapControls)) exitWith {nil};

private _mcEHId = _map ctrlAddEventHandler ["MouseButtonClick", {_this call FUNC(mouseButtonClick);[QGVAR(MouseButtonClick), _this] call CFUNC(localEvent);}];
private _mdcEHId = _map ctrlAddEventHandler ["MouseButtonDblClick", {[QGVAR(MouseButtonDblClick), _this] call CFUNC(localEvent);}];

_map setVariable [QGVAR(MouseButtonClickEHId), _mcEHId];
_map setVariable [QGVAR(MouseButtonDblClickEHId), _mdcEHId];

GVAR(MapControls) pushBackUnique _map;

nil
