#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Map Interactions

    Parameter(s):
    None

    Returns:
    None
*/


GVAR(MapControls) = [];
GVAR(ContextMenuEntries) = false call CFUNC(createNamespace);
GVAR(CurrentContextPosition) = [];

[{
    ((findDisplay 12) displayCtrl 51) call FUNC(registerMapControl);
}, {!(isNull ((findDisplay 12) displayCtrl 51))}] call CFUNC(waitUntil);
