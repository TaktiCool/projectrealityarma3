#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Initialization of drag action

    Parameter(s):
    None

    Returns:
    None
*/

DFUNC(dropPlayer) = {
    params ["_unit"];
    private _draggedObject = _unit getVariable [QGVAR(draggedPlayer), objNull];
    detach _draggedObject;
    _unit playAction "released";
    ["switchMove", [_draggedObject, "unconsciousrevivedefault"]] call CFUNC(globalEvent);
    //[QGVAR(stopGettingDraggedAnimation),[_draggedObject]] call CFUNC(globalEvent);

    if (isNull _draggedObject) exitWith {};
    ["enableSimulation", [_draggedObject, true]] call CFUNC(serverEvent);
    _unit setVariable [QGVAR(draggedPlayer), objNull, true];
    _draggedObject setVariable [QGVAR(draggedBy), objNull, true];
    _draggedObject call CFUNC(fixPosition);
};

[
    {format [MLOC(Drag), name _target]},
    "CAManBase",
    2,
    {
        alive _target && _target getVariable [QGVAR(isUnconscious), false] && (side group _target == side group CLib_Player);
    },
    {
        params ["_draggedUnit"];
        [{
            params ["_draggedUnit", "_unit"];

            private _position = getPos _unit;
            _draggedUnit setPos _position;
            private _attachPoint = [0, 0, 0];
            _unit setVariable [QGVAR(draggedPlayer), _draggedUnit, true];
            _draggedUnit setVariable [QGVAR(draggedBy), _unit, true];

            _attachPoint = [0, 1.1, ((_draggedUnit modelToWorld [0, 0, 0]) select 2) - ((_unit modelToWorld [0, 0, 0]) select 2)];

            _attachPoint = _attachPoint vectorAdd (_draggedUnit getVariable ["logisticOffset", [0, 0, 0]]);
            _draggedUnit attachTo [_unit, _attachPoint];

            _unit playActionNow "grabDrag";

            ["switchMove", [_draggedUnit, "AinjPpneMrunSnonWnonDb_grab"]] call CFUNC(globalEvent);
            [QGVAR(startGettingDraggedAnimation), _draggedUnit] call CFUNC(targetEvent);

            [{
                params ["_args", "_id"];
                _args params ["_draggedUnit", "_unit"];
                if (!isNull objectParent _unit || !alive _draggedUnit || !alive _unit || (_unit getVariable [QGVAR(isUnconscious), false]) || !(_draggedUnit getVariable [QGVAR(isUnconscious), false])) then {
                    [_unit] call FUNC(dropPlayer);
                    [_id] call CFUNC(removePerFrameHandler);
                };
            }, 1, [_draggedUnit, _unit]] call CFUNC(addPerFrameHandler);
        }, [_draggedUnit, CLib_Player], "logistic"] call CFUNC(mutex);
    }
] call CFUNC(addAction);

[QGVAR(startGettingDraggedAnimation), {
    CLib_Player setDir 180;
}] call CFUNC(addEventhandler);

[
    "Drop",
    CLib_Player,
    0,
    {!(isNull (CLib_Player getVariable [QGVAR(draggedPlayer), objNull]))},
    {
        [CLib_Player] call FUNC(dropPlayer);
    },
    ["ignoredCanInteractConditions", ["isNotPlayerDragging"]]
] call CFUNC(addAction);

["isNotPlayerDragging", {
    isNull (_caller getVariable [QGVAR(draggedPlayer), objNull])
     && isNull (_target getVariable [QGVAR(draggedPlayer), objNull])
}] call CFUNC(addCanInteractWith);
