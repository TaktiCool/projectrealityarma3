#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Dismantle a FOB

    Parameter(s):
    None

    Returns:
    None
*/
private _title = "Dismantle";
private _iconIdle = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _iconProgress = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _showCondition = {
    _target getVariable ["FOBState", 0] == 1 && {CLib_Player distance _target <= 5}
    && {
        private _pointDetails = [_target getVariable [QGVAR(fobId), ""], ["availablefor", "counterActive"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params [["_availableFor", sideUnknown], ["_counterActive", 0]];
        _counterActive == 0 && _availableFor == side group CLib_Player;
    }
};

GVAR(dismantleStartTime) = -1;
private _onStart = {
    params ["_target", "_caller"];

    GVAR(dismantleStartTime) = time;
};

private _onProgress = {
    (time - GVAR(dismantleStartTime)) / 10;
};

private _onComplete = {
    params ["_target"];
    [_target getVariable [QGVAR(fobId), ""]] call EFUNC(Common,removeDeploymentPoint);
    GVAR(dismantleStartTime) = -1;
};

private _onInterruption = {

    GVAR(dismantleStartTime) = -1;
};

["Thing", _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
