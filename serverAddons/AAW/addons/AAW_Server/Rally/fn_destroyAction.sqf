#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Destroys a Rally Point

    Parameter(s):
    None

    Returns:
    None
*/
private _title = "Destroy Rally Point";
private _iconIdle = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _iconProgress = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _showCondition = {
    CLib_Player distance _target <= 5
    && _target getVariable [QGVAR(rallyId), ""] != ""
    && {
        private _pointDetails = [_target getVariable [QGVAR(rallyId), ""], ["availablefor"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params [["_availableFor", side group CLib_Player]];
        _availableFor != side group CLib_Player;
    }
};

GVAR(destroyRallyStartTime) = -1;
private _onStart = {
    params ["_target", "_caller"];

    GVAR(destroyRallyStartTime) = time;
};

private _onProgress = {
    (time - GVAR(destroyRallyStartTime)) / 5;
};

private _onComplete = {
    params ["_target", "_caller"];

    GVAR(destroyRallyStartTime) = -1;
    private _group = [_target getVariable [QGVAR(rallyId), ""], "availablefor", grpNull] call EFUNC(Common,getDeploymentPointData);

    if (!isNull _group) then {
        [{
            params [["_group", grpNull]];
            [_group] call FUNC(destroy);
        }, [_group], "respawn"] call CFUNC(mutex);
    };
};

private _onInterruption = {
    params ["_target", "_caller"];

    GVAR(destroyRallyStartTime) = -1;
};

["Thing", _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
