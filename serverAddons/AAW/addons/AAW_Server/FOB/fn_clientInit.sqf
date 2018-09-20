#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, NetFusion

    Description:
    Init FOB system

    Parameter(s):
    None

    Returns:
    None
*/
if (side CLib_player == sideLogic && {player isKindOf "VirtualSpectator_F"}) exitWith {};
GVAR(sideNamespace) = false call CFUNC(createNamespace);

[QGVAR(placed), {QGVAR(ClearFOBPlaceable) call CFUNC(localEvent)}] call CFUNC(addEventhandler); // clear Cached Call Space

/*
 * ACTIONS
*/

call FUNC(buildAction);
call FUNC(dismantleAction);
call FUNC(destroyAction);
call FUNC(defuseAction);
