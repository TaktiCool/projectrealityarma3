#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Builds a Image Stack Button element

    Parameter(s):
    0: Context Menu Group <Control>
    1: Element specific arguments <Array>
        0: Images <Array>
            0: Image Path <String>
            1: relative size (1) <Number>
            2: color ([1, 1, 1, 1]) <Array>
        1: button action <Array>
            0: Code <Code> // if Code returns false, menu will close
            1: custom arguments ([]) <Array>

    Returns:
    None
*/
params ["_grp", "_args"];
_args params ["_images", "_action"];

private _display = ctrlParent _grp;

private _currentPosition = _grp getVariable ["currentPosition", [0, 0]];
private _currentSize = _grp getVariable ["currentSize", [0, 0]];
private _grpPos = ctrlPosition _grp;
private _ctxMenuWidth = _grpPos select 2;

private _itemGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _grp];
_itemGrp ctrlSetPosition [_currentPosition select 0, _currentPosition select 1, PX(4), PY(4)];

private _itemBackground = _display ctrlCreate ["RscPicture", -1,_itemGrp];
_itemBackground ctrlSetText "#(argb,8,8,3)color(0.5,0.5,0.5,0.5)";
_itemBackground ctrlSetFade 1;

{
    _x params ["_imagePath", ["_relSize", 1], ["_color", [1,1,1,1]]];
    private _sizeX = _relSize*PX(4);
    private _sizeY = _relSize*PY(4);
    private _offsetX = (PX(4)-_sizeX)/2;
    private _offsetY = (PY(4)-_sizeY)/2;
    private _itemBackText = _display ctrlCreate ["RscPicture", -1, _itemGrp];
    _itemBackText ctrlSetText _imagePath;
    _itemBackText ctrlSetTextColor _color;
    _itemBackText ctrlSetPosition [_offsetX, _offsetY, _sizeX, _sizeY];
    _itemBackText ctrlCommit 0;
} count _images;


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
    _x ctrlSetPosition [0, 0, PX(4), PY(4)];
    _x ctrlCommit 0;
    false;
} count [_itemBackground, _itemActiveArea];
_itemGrp ctrlCommit 0;

if ((_currentPosition select 0) + PX(4) > (_grpPos select 2)) then {
    _currentPosition set [0, 0];
    _currentPosition set [1, (_currentPosition select 1) + PY(4)];
} else {
    _currentPosition set [0, (_currentPosition select 0) + PX(4)];
};

_grp setVariable ["currentPosition", _currentPosition];
_grp setVariable ["currentSize", [_currentSize select 0, ((_currentPosition select 1) + PY(4)) max (_currentSize select 1)]];
