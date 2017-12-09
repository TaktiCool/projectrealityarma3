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
private _title = QLSTRING(Dismantle);
private _iconIdle = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _iconProgress = "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa";
private _showCondition = {
    call {
        scopeName "ActionCondition";
        {
            private _pointDetails = [_x, ["type", "position", "availablefor", "counterActive"]] call EFUNC(Common,getDeploymentPointData);
            _pointDetails params [["_type", ""], ["_position", [0, 0, 0]], ["_availableFor", sideUnknown], ["_counterActive", 0]];

            if (_type == "FOB" && {CLib_Player distance _position <= 5 && _counterActive == 0 && _availableFor == side group CLib_Player}) then {
                GVAR(currentFob) = _x;
                private _inVew = [CLib_Player, _position, 1.55] call CFUNC(inFOV);
                _inVew breakOut "ActionCondition";
            };
        } count (call EFUNC(Common,getAllDeploymentPoints));
        false
    };
};

GVAR(dismantleStartTime) = -1;
GVAR(currentFob) = "";
private _onStart = {
    params ["_target", "_caller"];

    GVAR(dismantleStartTime) = time;
};

private _onProgress = {
    (time - GVAR(dismantleStartTime)) / 10;
};

private _onComplete = {
    params ["_target"];
    [GVAR(currentFob)] call EFUNC(Common,removeDeploymentPoint);
    GVAR(dismantleStartTime) = -1;
};

private _onInterruption = {

    GVAR(dismantleStartTime) = -1;
};

[CLib_Player, _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
