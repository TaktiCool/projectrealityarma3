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
private _title = QLSTRING(Destroy);
private _iconIdle = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _iconProgress = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _showCondition = {
    call {
        scopeName "ActionCondition";
        {
            private _pointDetails = [_x, ["type", "position", "availablefor", "counterActive"]] call EFUNC(Common,getDeploymentPointData);
            _pointDetails params [["_type", ""], ["_position", [0, 0, 0]], ["_availableFor", sideUnknown], ["_counterActive", 0]];

            if (_type == "FOB" && {CLib_Player distance _position <= 5 && _counterActive == 0 && _availableFor != side group CLib_Player}) then {
                GVAR(currentFob) = _x;
                private _inVew = [CLib_Player, _position, 1.55] call CFUNC(inFOV);
                _inVew breakOut "ActionCondition";
            };
        } count (call EFUNC(Common,getAllDeploymentPoints));
        false
    };
};

GVAR(destroyFOBStartTime) = -1;
GVAR(currentFob) = "";
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
    [QGVAR(startDestroyTimer), [GVAR(currentFob)]] call CFUNC(serverEvent);
};

private _onInterruption = {
    params ["_target", "_caller"];

    GVAR(destroyFOBStartTime) = -1;
};

[CLib_Player, _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
