#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Opens a specific context menu

    Parameter(s):
    0: map control <Control>
    1: menu id ("") <String>
    2: screen x position (-1) <Number>
    3: screen y position (-1) <Number>

    Returns:
    None
*/
params ["_mapControl", ["_menuId", ""], ["_xPos", -1], ["_yPos", -1]];
private _display = ctrlParent _mapControl;
private _contextMenuGrp = _mapControl getVariable [QGVAR(ContextMenuGroup), controlNull];
private _contextMenuBackground = controlNull;
private _animDirection = 1;
if (isNull _contextMenuGrp) then {
    _contextMenuGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
    _contextMenuGrp ctrlAddEventHandler ["Unload", {
        GVAR(CurrentContextPosition) = [];
        [
            QGVAR(CursorMarker)
        ] call CFUNC(removeMapGraphicsGroup);
    }];
    _contextMenuBackground = _display ctrlCreate ["RscPicture", -1, _contextMenuGrp];
    _xPos = _xPos+PX(2);
    _contextMenuGrp ctrlSetPosition [_xPos, _yPos, CTXMENU_WIDTH, 0];
    _contextMenuGrp ctrlCommit 0;
    _contextMenuGrp setVariable ["mapControl", _mapControl];
    _contextMenuGrp setVariable ["history", []];
} else {
    _contextMenuBackground = _contextMenuGrp getVariable ["background", _contextMenuBackground];
    // Calculate Position
    private _pos = ctrlPosition _contextMenuGrp;
    _xPos = _pos select 0;
    _yPos = (_pos select 1) + (_pos select 3)/2;
    private _history = _contextMenuGrp getVariable ["history", []];
    private _contextMenuItemsGrp = _contextMenuGrp getVariable ["contextMenuItemsGroup", controlNull];
    private _currentMenuId = _contextMenuItemsGrp getVariable ["menuId", ""];
    private _c = _history find _menuId;
    if (_c >= 0) then { // Go back
        _history resize _c;
        _animDirection = -1;
    } else { // Go forward
        _history pushBack _currentMenuId;
    };

    _contextMenuItemsGrp ctrlSetPosition [-_animDirection*CTXMENU_WIDTH, 0];
    _contextMenuItemsGrp ctrlCommit 0.2;
    [{
        ctrlDelete _this;
    }, 0.2, _contextMenuItemsGrp] call CFUNC(wait);

    _contextMenuGrp setVariable ["history", _history];
};


private _contextMenuItemsGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _contextMenuGrp];
_contextMenuItemsGrp ctrlCommit 0;
_contextMenuItemsGrp setVariable ["currentPosition", [0, 0]];
_contextMenuItemsGrp setVariable ["currentSize", [CTXMENU_WIDTH, 0]];
_contextMenuItemsGrp setVariable ["menuId", _menuId];
_contextMenuItemsGrp setVariable ["mapControl", _mapControl];

_contextMenuGrp setVariable ["contextMenuItemsGroup", _contextMenuItemsGrp];

private _nbrElements = {
    _x params ["_type", "_arguments"];
    if (_type == "header") then {
        [_contextMenuItemsGrp, _arguments] call FUNC(buildHeaderElement);
    };
    if (_type == "list") then {
        [_contextMenuItemsGrp, _arguments] call FUNC(buildListElement);
    };
    if (_type == "label") then {
        [_contextMenuItemsGrp, _arguments] call FUNC(buildLabelElement);
    };
    if (_type == "imageStackButton") then {
        [_contextMenuItemsGrp, _arguments] call FUNC(buildImageStackButton);
    };

    true;
} count (GVAR(ContextMenuEntries) getVariable ["ContextMenu_" + _menuId, []]);

private _currentSize = _contextMenuItemsGrp getVariable ["currentSize", [0, 0]];

_contextMenuBackground ctrlSetText "#(argb,8,8,3)color(0.2,0.2,0.2,0.6)";
_contextMenuBackground ctrlSetPosition [0, 0, _currentSize select 0, _currentSize select 1];
_contextMenuBackground ctrlCommit 0;

_contextMenuGrp ctrlSetPosition [_xPos, _yPos-(_currentSize select 1)/2, _currentSize select 0, _currentSize select 1];
_contextMenuGrp ctrlCommit 0.2;

_contextMenuItemsGrp ctrlSetPosition [_animDirection*(_currentSize select 0), 0, _currentSize select 0, _currentSize select 1];
_contextMenuItemsGrp ctrlCommit 0;
_contextMenuItemsGrp ctrlSetPosition [0, 0];
_contextMenuItemsGrp ctrlCommit 0.2;

_mapControl setVariable [QGVAR(ContextMenuGroup), _contextMenuGrp];
_contextMenuGrp setVariable ["background", _contextMenuBackground];
