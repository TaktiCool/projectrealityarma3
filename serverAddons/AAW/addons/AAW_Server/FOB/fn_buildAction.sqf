#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Build a FOB

    Parameter(s):
    0: Types <String,Object,Array>

    Returns:
    None
*/
params ["_types"];
private _title = QLSTRING(BUILD);
private _iconIdle = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\map_ca.paa";
private _iconProgress = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\map_ca.paa";
private _showCondition = {
    CLib_Player distance _target <= 5 && simulationEnabled _target
     && {[QGVAR(isFOBPlaceable), FUNC(canPlace), [_target], 5, QGVAR(ClearFOBPlaceable)] call CFUNC(cachedCall)}
     && {(GVAR(sideNamespace) getVariable (toLower str side group CLib_Player)) == typeOf _target}
};

GVAR(buildStartTime) = -1;
GVAR(currentFob) = "";
private _onStart = {
    params ["_target", "_caller"];

    GVAR(buildStartTime) = time;
};

private _onProgress = {
    (time - GVAR(buildStartTime)) / 5;
};

private _onComplete = {
    params ["_target"];
    [_target] call FUNC(place);
    GVAR(buildStartTime) = -1;
};

private _onInterruption = {

    GVAR(buildStartTime) = -1;
};

[_types, _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
