#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas

    Description:
    Init Squad Spawn system (currently just for fun and testing :D)

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};
GVAR(oldSpawns) = [];
[{
    {
        if (!(_x call EFUNC(Common,isAlive)) && !(simulationEnabled _x) && !(isObjectHidden _x)) then {
            _x call EFUNC(Common,removeDeploymentPoint);
        };
        nil
    } count GVAR(oldSpawns);

    {
        if (_x getVariable [QGVAR(hasRespawnPointAttached), false]) then {
            GVAR(oldSpawns) pushBack ["Player " + name _x, "SQUAD", getPos _x, playerSide, -1, "ui\media\fob_ca.paa", "ui\media\fob_ca.paa", []] call EFUNC(Common,addDeploymentPoint);
        };
        nil
    } count units CLib_Player;
}, 0] call CFUNC(addPerFrameHandler);

//["playerChanged", {
//
//}] call CFUNC(addEventhandler);
