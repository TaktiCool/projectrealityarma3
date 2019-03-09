#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Builds a List Button element

    Parameter(s):
    0: Context Menu Group <Control>
    1: Element specific arguments <Array>
        0: Text <String>
        1: button action <Array>
            0: Code <Code> // if Code returns false, menu will close
            1: custom arguments ([]) <Array>

    Returns:
    None
*/
params ["_grp", "_args"];
_args params ["_text", "_action"];

private _display = ctrlParent _grp;

private _currentPosition = _grp getVariable ["currentPosition", [0, 0]];
private _currentSize = _grp getVariable ["currentSize", [0, 0]];
private _yOffset = _currentPosition select 1;
private _grpPos = ctrlPosition _grp;
private _ctxMenuWidth = _grpPos select 2;

private _itemGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _grp];
_itemGrp ctrlSetPosition [0, _yOffset, _ctxMenuWidth, ITEM_HEIGHT];

private _itemBackground = _display ctrlCreate ["RscPicture", -1,_itemGrp];
_itemBackground ctrlSetText "#(argb,8,8,3)color(0.5,0.5,0.5,0.5)";
_itemBackground ctrlSetFade 1;

private _itemText = _display ctrlCreate ["RscTitle", -1, _itemGrp];
_itemText ctrlSetText toUpper _text;
_itemText ctrlSetFontHeight PY(2.2);
_itemText ctrlSetFont "RobotoCondensed";

private _itemActiveArea = _display ctrlCreate ["RscButton", -1, _itemGrp];
_itemActiveArea ctrlSetActiveColor [0,0,0,0];
_itemActiveArea ctrlSetBackgroundColor [0,0,0,0];
_itemActiveArea ctrlSetFade 1;
_itemActiveArea ctrlAddEventHandler ["MouseEnter", {
    params ["_ctrl"];
    _ctrl = _ctrl getVariable ["background", controlNull];
    if (!isNull _ctrl) then {
        _ctrl ctrlSetFade 0;
        _ctrl ctrlCommit 0.2;
    };
}];
_itemActiveArea ctrlAddEventHandler ["MouseExit", {
    params ["_ctrl"];
    _ctrl = _ctrl getVariable ["background", controlNull];
    if (!isNull _ctrl) then {
        _ctrl ctrlSetFade 1;
        _ctrl ctrlCommit 0.2;
    };
}];
_itemActiveArea ctrlAddEventHandler ["ButtonClick", {
    params ["_ctrl"];
    (_ctrl getVariable ["action", []]) params [["_code", {}], ["_attributes", []]];
    private _contextMenu = ctrlParentControlsGroup ctrlParentControlsGroup _ctrl;
    private _return = [_contextMenu, _attributes, _this] call _code;
    if (isNil "_return" || {_return}) then {
        [
            QGVAR(CursorMarker)
        ] call CFUNC(removeMapGraphicsGroup);
        GVAR(CurrentContextPosition) = [];
        ctrlDelete ctrlParentControlsGroup _contextMenu;
    };
}];
_itemActiveArea setVariable ["background", _itemBackground];
_itemActiveArea setVariable ["action", _action];

{
    _x ctrlSetPosition [0, 0, _ctxMenuWidth, ITEM_HEIGHT];
    _x ctrlCommit 0;
    false;
} count [_itemBackground, _itemText, _itemActiveArea];
_itemGrp ctrlCommit 0;

_grp setVariable ["currentPosition", [0, _yOffset + ITEM_HEIGHT]];
_grp setVariable ["currentSize", [_currentSize select 0, (_yOffset + ITEM_HEIGHT) max (_currentSize select 1)]];
