#include "macros.hpp"

// Version Informations
private _missionVersionAr = getArray (missionConfigFile >> QPREFIX >> "Version");
private _missionVersionStr = _missionVersionAr joinString ".";

private _serverVersionAr = [VERSION_AR];
private _serverVersionStr = _serverVersionAr joinString ".";

DUMP("Version Mission: " + _missionVersionStr + "; Version Server: " + _serverVersionStr);
GVAR(VersionInfo) = [[_missionVersionStr, _missionVersionAr], [_serverVersionStr, _serverVersionAr]];
publicVariable QGVAR(VersionInfo);

GVAR(ignoreVariables) = [
    toLower QGVAR(PlayerInteraction_Actions),
    toLower QGVAR(tempUnit),
    toLower QGVAR(isProcessed),
    toLower QEGVAR(Revive,reviveEventhandlerAdded),
    toLower QEGVAR(Revive,damageWaitIsRunning)
];

GVAR(allLocationTypes) = [];
{
    GVAR(allLocationTypes) pushBack (configName _x);
    nil
} count ("true" configClasses (configFile >> "CfgLocationTypes"));

GVAR(markerLocations) = getArray (missionConfigFile >> QPREFIX >> "markerLocation");
GVAR(markerLocations) = GVAR(markerLocations) apply {
    private _text = markerText _x;
    if (_text call CFUNC(isLocalised)) then {
        _text = LOC(_text);
    };
    [_x, getMarkerPos _x, _text]
};

if (hasInterface) then {
    ["missionStarted", {

        private _mainDisplay = findDisplay 46;

        private _ctrl = _mainDisplay ctrlCreate ["RscStructuredText", -1];
        _ctrl ctrlSetPosition [safeZoneX + safeZoneW - PX(50), safeZoneY + safeZoneH - PY(8), PX(50), PY(10)];
        _ctrl ctrlSetFade 0.4;
        _ctrl ctrlSetStructuredText parseText format [
            MLOC(IngameVersionInfo),
            PY(1.8) / 0.035,
            (GVAR(VersionInfo) select 0) select 0,
            (GVAR(VersionInfo) select 1) select 0,
            PY(1.5) / 0.035
        ];
        _ctrl ctrlCommit 0;

        uiNamespace setVariable [UIVAR(VersionInfo), _ctrl];

        _mainDisplay displayAddEventHandler ["KeyDown", {
            if ((_this select 1) == 1) then {
                [{
                    private _pauseMenuDisplay = findDisplay 49;

                    private _ctrl = _pauseMenuDisplay ctrlCreate ["RscStructuredText", -1];
                    _ctrl ctrlSetPosition [safeZoneX + safeZoneW - PX(30), safeZoneY + safeZoneH - PY(30), PX(30), PY(30)];
                    _ctrl ctrlSetFade 0;
                    _ctrl ctrlSetStructuredText parseText format [
                        MLOC(PauseVersionInfo),
                        PY(15) / 0.035,
                        PY(1.8) / 0.035,
                        (GVAR(VersionInfo) select 0) select 0,
                        (GVAR(VersionInfo) select 1) select 0,
                        PY(2.2) / 0.035,
                        "ui\media\AAWLogo_ca.paa",
                        "https://github.com/TaktiCool/ArmaAtWar/blob/master/.github/CONTRIBUTING.md"
                    ];
                    _ctrl ctrlCommit 0;
                }, {!isNull (findDisplay 49)}, []] call CFUNC(waitUntil);
                nil
            };
        }];
    }] call CFUNC(addEventhandler);

    // Disable all Radio Messages
    enableSentences false;
    enableRadio false;

    ["playerChanged", {
        (_this select 0) params ["_newPlayer"];
        _newPlayer disableConversation true;
        _newPlayer setVariable ["BIS_noCoreConversations", true];
    }] call CFUNC(addEventhandler);

    ["entityCreated", {
        params ["_args"];
        if (_args isKindOf "CAManBase") then {
            _args disableConversation true;
            _args setVariable ["BIS_noCoreConversations", true];
        };
    }] call CFUNC(addEventhandler);

    // Rating system
    ["sideChanged", {
        (_this select 0) params ["_currentSide", "_oldSide"];

        if (_currentSide == sideEnemy) then {
            private _rating = rating CLib_Player;
            CLib_Player addRating (0 - _rating);
        };
    }] call CFUNC(addEventhandler);
};

// generate Base sides and Hide all Markers
["missionStarted", {
    GVAR(maxPlayerCountDifference) = getNumber (missionConfigFile >> QPREFIX >> "maxPlayerCountDifference");
    GVAR(competingSides) = [];
    {
        private _side = switch (toUpper (configName _x)) do {
            case ("WEST"): {
                west
            };
            case ("EAST"): {
                east
            };
            case ("GUER"): {
                independent
            };
            case ("CIV"): {
                civilian
            };
            default {
                LOG("ERROR UNKNOWN SIDE DETECTED: " + configName _x);
                sideUnknown
            };
        };
        GVAR(competingSides) pushBack _side;
        missionNamespace setVariable [format [QGVAR(Flag_%1), _side], getText (_x >> "flag")];
        missionNamespace setVariable [format [QGVAR(SideColor_%1), _side], getArray (_x >> "color")];
        missionNamespace setVariable [format [QGVAR(SideName_%1), _side], getText (_x >> "name")];
        missionNamespace setVariable [format [QGVAR(SideMapIcon_%1), _side], getText (_x >> "mapIcon")];
        nil;
    } count ("true" configClasses (missionConfigFile >> QPREFIX >> "sides"));
    // Temp for Ribbon
    if (isClass (configFile >> "CfgPatches" >> "gcam")) then {
        [{
            [
                "Hide HUD (Permanent)",
                CLib_Player,
                0,
                {true},
                {
                    ([UIVAR(Compass)] call BIS_fnc_rscLayer) cutFadeOut 0;
                    ([UIVAR(TicketStatus)] call BIS_fnc_rscLayer) cutFadeOut 0;
                    ([UIVAR(CaptureStatus)] call BIS_fnc_rscLayer) cutFadeOut 0;
                    ([UIVAR(PerformanceStatus)] call BIS_fnc_rscLayer) cutFadeOut 0;
                    (uiNamespace getVariable [UIVAR(VersionInfo), controlNull]) ctrlSetFade 1;
                    // showHUD [false, false, false, false, false, false, false, false, false];

                    CGVAR(hideHUD) = true;
                }
            ] call CFUNC(addAction);

            [
                "Hide Player",
                CLib_Player,
                0,
                {true},
                {
                    ["hideObject", [CLib_Player, true]] call CFUNC(serverEvent);
                    ["enableSimulation", [CLib_Player, false]] call CFUNC(serverEvent);
                    ["allowDamage", "gcam", false] call CFUNC(setStatusEffect);
                }
            ] call CFUNC(addAction);
        }, 10] call CFUNC(wait);
    };

}] call CFUNC(addEventhandler);

["performanceCheck", 0] call CFUNC(addIgnoredEventLog);
CGVAR(hideHUD) = false;

#ifdef ISDEV
addMissionEventHandler ["MapSingleClick", {
    params ["", ["_pos", getPos player], ["_alt", true]];
    if (_alt) then {
        _pos set [2, 0];
        (vehicle CLib_Player) setPos _pos;
    };
}];
#endif
