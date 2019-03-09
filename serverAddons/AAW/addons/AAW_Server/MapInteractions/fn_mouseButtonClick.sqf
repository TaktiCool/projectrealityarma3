#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Handles a mouse button click event

    Parameter(s):
    0: Control <Control>
    1: Mouse button <Number>
    2: Mouse x position <Number>
    3: Mouse y position <Number>
    4: shift state <Number>
    5: ctrl state <Number>
    6: alt state <Number>

    Returns:
    None
*/


params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

if (!isNull (_control getVariable [QGVAR(ContextMenuGroup), controlNull])) then {
    ctrlDelete (_control getVariable [QGVAR(ContextMenuGroup), controlNull]);
    [
        QGVAR(CursorMarker)
    ] call CFUNC(removeMapGraphicsGroup);
    GVAR(CurrentContextPosition) = [];
};

if (_button == 1) then {
    GVAR(CurrentContextPosition) = _control ctrlMapScreenToWorld [_xPos, _yPos];
    [
        QGVAR(CursorMarker),
        [
            ["ICON", "a3\ui_f\data\map\mapcontrol\waypointeditor_ca.paa", [0, 0, 0, 0.7], GVAR(CurrentContextPosition), 22, 22],
            ["ICON", "a3\ui_f\data\map\mapcontrol\waypointeditor_ca.paa", [1, 1, 1, 1], GVAR(CurrentContextPosition), 20, 20]
        ]
    ] call CFUNC(addMapGraphicsGroup);

    [_control, "", _xPos, _yPos] call FUNC(openContextMenu);

};

true;
