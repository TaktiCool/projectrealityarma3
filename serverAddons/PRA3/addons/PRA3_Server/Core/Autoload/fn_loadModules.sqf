#include "macros.hpp"
/*
    Project Reality ArmA 3 - Autoload\fn_loadModules.sqf

    Author: NetFusion

    Description:
    Entry point for module loading. Must be called within mission script for client and server. Start transfer of functions.

    Parameter(s):
    - ARRAY - the names of the requested modules

    Returns:
    -

    Example:
    ["Module1", "Module2"] call AME_Core_fnc_loadModules; <= in mission script
*/

// The client waits for the player to be available. This makes sure the player variable is initialized in every script later.
if (hasInterface) then {
    waitUntil {!isNull player};
    PRA3_Player = player;
};
GVAR(allowFunctionsLog) = (getNumber (missionConfigFile >> "allowFunctionsLog") isEqualTo 1);
// If the machine has AME running exit and call all requested modules.
if (isClass (configFile >> "CfgPatches" >> "PRA3_Server")) exitWith { _this call FUNC(loadModulesServer); };

// Start the loading screen on the client to prevent a drawing lag while loading. Disable input too to prevent unintended movement after spawn.
["pra3_core_fnc_loadModules"] call bis_fnc_startLoadingScreen;
disableUserInput true;

// Bind EH on client to compile the received function code. Collect all functions names to determine which need to be called later in an array.
GVAR(requiredFunctions) = [];
QGVAR(receiveFunction) addPublicVariableEventHandler {
    (_this select 1) params ["_functionVarName", "_functionCode", "_progress"];
    DUMP("Function Recieved: " + _functionVarName)
    // Compile the function code and assign it.
    #ifdef isDev
        _functionCode = compile _functionCode;
    #else
        _functionCode = compileFinal _functionCode;
    #endif
    {
        _x setVariable [_functionVarName, _functionCode];
        nil
    } count [missionNamespace,uiNamespace,parsingNamespace];

    // Update the loading screen with the progress.
    _progress call bis_fnc_progressloadingscreen;

    // Store the function name.
    GVAR(requiredFunctions) pushBack _functionVarName;

    // If the progress is 1 the last function code is received.
    if (_progress >= 1) then {
        // End the loading screen and enable input for the user.
        ["pra3_core_fnc_loadModules"] call bis_fnc_endLoadingScreen;
        disableUserInput false;
        DUMP("All Function Recieved, now call then")
        // Call all modules.
        call FUNC(callModules);
    };
};

// Register client at the server to start transmission of function codes.
GVAR(registerClient) = player;
publicVariableServer QGVAR(registerClient);
