#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Create a Map Marker (server side function)

    Parameter(s):
    None

    Returns:
    None
*/
params ["_type", "_position", "_owner", "_time"];
private _side = sideUnknown;
private _ownerId = str _owner;
private _group = grpNull;
if (_owner isEqualType sideUnknown) then {
    _side = _owner;
} else {
    _side = side _owner;
    _group = group _owner;
    if (_owner in allPlayers) then {
        _ownerId = getPlayerUID _owner;
    };
};

private _id = format ["%1_%2_%3_%4", _side, _type, _position, _ownerId];

private _markerNamespaceName = QGVAR(allMarker_) + str _side;
private _markerNamespace = missionNamespace getVariable [_markerNamespaceName, objNull];
if (isNull _markerNamespace) then {
    _markerNamespace = true call CFUNC(createNamespace);
    missionNamespace setVariable [_markerNamespaceName, _markerNamespace];
};

private _markerData = [_type, _position, _time, [_owner] call CFUNC(name), _ownerId, _owner, _group, _side];
_markerNamespace setVariable [_id, _markerData, true];
["markerUpdated", _side,  [_id, _markerData]] call CFUNC(targetEvent);
