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
private _title = "Defuse";
private _iconIdle = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _iconProgress = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _showCondition = {
    _target getVariable ["FOBState", 0] == 1 && {CLib_Player distance _target <= 5}
    && {
        private _pointDetails = [_target getVariable [QGVAR(fobId), 0], ["availablefor", "counterActive"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params [["_availableFor", sideUnknown], ["_counterActive", 0]];
        _counterActive == 1 && _availableFor == side group CLib_Player;
    }
};

GVAR(defuseStartTime) = -1;
private _onStart = {
    params ["_target", "_caller"];

    GVAR(defuseStartTime) = time;
    [QGVAR(stopDestroyTimer), [_target getVariable [QGVAR(fobId), ""]]] call CFUNC(serverEvent);
};

private _onProgress = {
    (time - GVAR(defuseStartTime)) / 5;
};

private _onComplete = {
    params ["_target", "_caller"];

    GVAR(defuseStartTime) = -1;

    [QGVAR(resetDestroyTimer), [_target getVariable [QGVAR(fobId), ""]]] call CFUNC(serverEvent);
};

private _onInterruption = {
    params ["_target", "_caller"];
    [QGVAR(continueDestroyTimer), [_target getVariable [QGVAR(fobId), ""]]] call CFUNC(serverEvent);
    GVAR(defuseStartTime) = -1;
};

["Thing", _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
