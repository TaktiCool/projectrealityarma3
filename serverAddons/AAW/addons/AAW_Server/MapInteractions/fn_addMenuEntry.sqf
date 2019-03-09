#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Adds a Context Menu Entry

    Parameter(s):
    0: Map <Control>

    Returns:
    None
*/
params ["_menuId", "_type", ["_attributes", []]];
// make sure that the control not already have a draw function

private _currentEntry = GVAR(ContextMenuEntries) getVariable ["ContextMenu_"+_menuId, []];
private _idx = _currentEntry pushBack [_type, _attributes];
GVAR(ContextMenuEntries) setVariable ["ContextMenu_"+_menuId, _currentEntry];
_idx
