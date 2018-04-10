#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    -

    Parameter(s):
    None

    Returns:
    None
*/



//GVAR(squadIds) = ("true" configClasses (configFile >> "CfgWorlds" >> "GroupCompany")) apply {getText (_x >> "name")};
GVAR(squadIds) = [
    "Alpha",
    "Bravo",
    "Charlie",
    "Delta",
    "Echo",
    "Foxtrot",
    "Golf",
    "Hotel",
    "India",
    "Juliet",
    "Kilo",
    "Lima",
    "Mike",
    "November",
    "Oscar",
    "Papa",
    "Quebec",
    "Romeo",
    "Sierra",
    "Tango",
    "Uniform",
    "Victor",
    "Whiskey",
    "Xray",
    "Yankee",
    "Zulu"
];

if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

GVAR(minSideSwitchTime) = getNumber (missionConfigFile >> QPREFIX >> "minSideSwitchTime");
GVAR(isTimeUnlocked) = 0;
