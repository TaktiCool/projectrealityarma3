#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, NetFusion

    Description:
    Init rally system

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

[QGVAR(deploymentPointRemoved), {
    (_this select 0) params ["_pointId"];
    DUMP(_this);

    if (((group CLib_Player) getVariable [QGVAR(rallyId), ""]) == _pointId) then {
        (group CLib_Player) setVariable [QGVAR(rallyId), nil, true];
    };
}] call CFUNC(addEventHandler);

/*
 * ACTIONS
 */
[QLSTRING(CreateRally), CLib_Player, 0, {
    ((leader CLib_Player) == CLib_Player) && (CLib_Player getVariable [QEGVAR(Kit,isLeader), false]) && (isNull objectParent CLib_Player)
}, {
    call FUNC(place);
}, ["showWindow", false]] call CFUNC(addAction);

call FUNC(destroyAction);
