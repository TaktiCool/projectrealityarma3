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
private _title = QLSTRING(Destroy);
private _iconIdle = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _iconProgress = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\cargoput_ca.paa";
private _showCondition = {
    call {
        scopeName "ActionCondition";
        {
            private _pointDetails = [_x, ["type", "position", "availablefor"]] call EFUNC(Common,getDeploymentPointData);
            _pointDetails params [["_type", ""], ["_position", [0, 0, 0]], ["_availableFor", grpNull]];

            if (_type == "RALLY" && {CLib_Player distance _position <= 5 && side _availableFor != side group CLib_Player}) then {
                GVAR(currentRally) = _x;
                private _inView = [CLib_Player, _position, 1] call CFUNC(inFOV);
                _inView breakOut "ActionCondition";
            };
        } count (call EFUNC(Common,getAllDeploymentPoints));
        false
    };
};

GVAR(destroyRallyStartTime) = -1;
GVAR(currentRally) = "";
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
    private _group = [GVAR(currentRally), "availablefor", grpNull] call EFUNC(Common,getDeploymentPointData);

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

[CLib_Player, _title, _iconIdle, _iconProgress, _showCondition, _showCondition, _onStart, _onProgress, _onComplete, _onInterruption, [], 5000, true, true] call CFUNC(addHoldAction);
