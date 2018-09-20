#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Destroy a FOB

    Parameter(s):
    None

    Returns:
    None
*/
private _title = "Destroy FOB";
private _iconIdle = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _iconProgress = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _showCondition = {
    _target getVariable ["FOBState", 0] == 1 && {CLib_Player distance _target <= 5}
    && {
        private _pointDetails = [_target getVariable [QGVAR(fobId), 0], ["availablefor", "counterActive"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params [["_availableFor", sideUnknown], ["_counterActive", 0]];
        _counterActive == 0 && _availableFor != side group CLib_Player;
    }
};

GVAR(destroyFOBStartTime) = -1;
private _onStart = {
    params ["_target", "_caller"];

    GVAR(destroyFOBStartTime) = time;
};

private _onProgress = {
    (time - GVAR(destroyFOBStartTime)) / 5;
};

private _onComplete = {
    params ["_target", "_caller"];

    GVAR(destroyFOBStartTime) = -1;
    [QGVAR(startDestroyTimer), [_target getVariable [QGVAR(fobId), ""]]] call CFUNC(serverEvent);
};

private _onInterruption = {
    params ["_target", "_caller"];

    GVAR(destroyFOBStartTime) = -1;
};

["Thing", _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
