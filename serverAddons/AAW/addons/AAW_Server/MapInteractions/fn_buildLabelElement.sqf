#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Builds a label element

    Parameter(s):
    0: Context Menu Group <Control>
    1: Element specific arguments <Array>
        0: Text <String>

    Returns:
    None
*/
params ["_grp", "_args"];
_args params ["_text"];

private _display = ctrlParent _grp;

private _currentPosition = _grp getVariable ["currentPosition", [0, 0]];
private _currentSize = _grp getVariable ["currentSize", [0, 0]];
private _yOffset = _currentPosition select 1;
private _grpPos = ctrlPosition _grp;
private _ctxMenuWidth = _grpPos select 2;

private _itemText = _display ctrlCreate ["RscTitle", -1, _grp];
_itemText ctrlSetText toUpper _text;
_itemText ctrlSetFontHeight PY(2);
_itemText ctrlSetFont "RobotoCondensed";
_itemText ctrlSetPosition [0, _currentPosition select 1, _ctxMenuWidth, ITEM_HEIGHT];
_itemText ctrlCommit 0;

_grp setVariable ["currentPosition", [0, _yOffset + ITEM_HEIGHT]];
_grp setVariable ["currentSize", [_currentSize select 0, (_yOffset + ITEM_HEIGHT) max (_currentSize select 1)]];
