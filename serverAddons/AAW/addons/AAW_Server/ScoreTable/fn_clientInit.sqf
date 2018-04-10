#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Client Init for ScoreTable System

    Parameter(s):
    None

    Returns:
    None
*/

GVAR(maxTickets) = getNumber (missionConfigFile >> QPREFIX >> "tickets");

private _ppBlur = ppEffectCreate ["DynamicBlur", 999];
private _ppColor = ppEffectCreate ["ColorCorrections", 1502];
/*

["missionStarted", {
    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["_display"];
        private _handled = false;
        if (inputAction "NetworkStats" > 0) then {
            private _scoreTableDisplay = _display createDisplay "RscDisplayEmpty";
            [UIVAR(ScoreTable_onLoad), _scoreTableDisplay] call CFUNC(localEvent);
            [QGVAR(ScoreUpdate)] call CFUNC(localEvent);
            _handled = true;
        };
        _handled
    }];

}] call CFUNC(addEventhandler);
*/

[UIVAR(ScoreTable_onLoad), {
    params ["_data", "_ppEffects"];
    _data params ["_display", ["_endScreen", false]];
    _ppEffects params ["_ppBlur", "_ppColor"];
    uiNamespace setVariable [QGVAR(scoreTable), _display];

    private _enemySide = (EGVAR(Common,competingSides) - [playerSide]) select 0;
    private _friendSide = playerSide;

    if (CLib_Player call EFUNC(Common,isSpectator)) then {
        _endScreen = true;
        _enemySide = EGVAR(Common,competingSides) select 1;
        _friendSide = EGVAR(Common,competingSides) select 0;
    };

    // Enable all ppEffects
    _ppBlur ppEffectEnable true;
    _ppBlur ppEffectAdjust [8];
    _ppBlur ppEffectCommit 0.2;

    // Register keybind to close the score table
    _display displayAddEventHandler ["KeyDown", {
        params ["_display"];
        private _handled = false;
        if (inputAction "NetworkStats" > 0) then {
            _display closeDisplay 1;
            [UIVAR(ScoreTable_onUnload)] call CFUNC(localEvent);
            _handled = true;
        };
        _handled
    }];

    // Create the score table controls
    private _globalBackground = _display ctrlCreate ["RscPicture", -1];
    _globalBackground ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, safeZoneH];
    _globalBackground ctrlSetText "#(argb,8,8,3)color(0.3,0.3,0.3,0.4)";
    _globalBackground ctrlSetFade 1;
    _globalBackground ctrlCommit 0;
    _globalBackground ctrlSetFade 0;
    _globalBackground ctrlCommit 0.2;

    // Create the score table controls
    private _headerBackground = _display ctrlCreate ["RscPicture", -1];
    _headerBackground ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, PY(15.5)];
    _headerBackground ctrlSetText "#(argb,8,8,3)color(0.5,0.5,0.5,0.2)";
    _headerBackground ctrlCommit 0;

    private _globalGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", 1000];
    _globalGroup ctrlSetPosition ([[0.5 - PX(60), safeZoneY, safeZoneW, safeZoneH], [0.5 - PX(70), safeZoneY, safeZoneW, safeZoneH]] select _endScreen);
    _globalGroup ctrlCommit 0;

    private _title = _display ctrlCreate ["RscTitle", 1001, _globalGroup];
    _title ctrlSetFontHeight PY(3.2);
    _title ctrlSetFont "RobotoCondensedBold";
    _title ctrlSetPosition [0, PY(10.5), PX(20), PY(4)];
    _title ctrlSetText "SCOREBOARD";
    _title ctrlCommit 0;

    // They controls for the own side
    private _sideWidth = [79, 69] select _endScreen;
    private _friendlyHeaderBg = _display ctrlCreate ["RscPicture", 1002, _globalGroup];
    _friendlyHeaderBg ctrlSetPosition [0, PY(17), PX(_sideWidth), PY(7)];
    _friendlyHeaderBg ctrlSetText "#(argb,8,8,3)color(0.0,0.4,0.8,1)";
    _friendlyHeaderBg ctrlCommit 0;

    private _friendlyFlag = _display ctrlCreate ["RscPictureKeepAspect", 1003, _globalGroup];
    _friendlyFlag ctrlSetPosition [PX(0.5), PY(17.5), PX(6), PY(6)];
    _friendlyFlag ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,Flag_%1), _friendSide], "#(argb,8,8,3)color(0.5,0.5,0.5,1)"]);
    _friendlyFlag ctrlCommit 0;

    private _friendlySideName = _display ctrlCreate ["RscTitle", 1004, _globalGroup];
    _friendlySideName ctrlSetFontHeight PY(3.3);
    _friendlySideName ctrlSetFont "RobotoCondensedBold";
    _friendlySideName ctrlSetPosition [PX(7), PY(17), PX(30), PY(4)];
    _friendlySideName ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,sideName_%1), _friendSide], ""]);
    _friendlySideName ctrlCommit 0;

    private _friendlyTicketCount = _display ctrlCreate ["RscTextNoShadow", 1005, _globalGroup];
    _friendlyTicketCount ctrlSetFontHeight PY(3.3);
    _friendlyTicketCount ctrlSetFont "RobotoCondensedBold";
    _friendlyTicketCount ctrlSetPosition [PX(_sideWidth - 7), PY(17), PX(6), PY(4)];
    _friendlyTicketCount ctrlSetText str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), _friendSide], GVAR(maxTickets)]);
    _friendlyTicketCount ctrlCommit 0;

    private _friendlyPlayerCount = _display ctrlCreate ["RscTitle", 1006, _globalGroup];
    _friendlyPlayerCount ctrlSetFontHeight PY(2.2);
    _friendlyPlayerCount ctrlSetFont "RobotoCondensed";
    _friendlyPlayerCount ctrlSetPosition [PX(7), PY(20), PX(30), PY(4)];
    _friendlyPlayerCount ctrlSetText toUpper format ["%1 PLAYERS", {_friendSide == side group _x} count allPlayers];
    _friendlyPlayerCount ctrlCommit 0;

    private _friendlyKillHeader = _display ctrlCreate ["RscTextNoShadow", 1007, _globalGroup];
    _friendlyKillHeader ctrlSetFontHeight PY(2.2);
    _friendlyKillHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyKillHeader ctrlSetPosition [PX(_sideWidth - 36), PY(20), PX(6), PY(4)];
    _friendlyKillHeader ctrlSetText "KILLS";
    _friendlyKillHeader ctrlCommit 0;

    private _friendlyVehicleKillHeader = _display ctrlCreate ["RscPictureKeepAspect", 1008, _globalGroup];
    _friendlyVehicleKillHeader ctrlSetFontHeight PY(2.2);
    _friendlyVehicleKillHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyVehicleKillHeader ctrlSetPosition [PX(_sideWidth - 30), PY(21), PX(6), PY(2)];
    _friendlyVehicleKillHeader ctrlSetText "\A3\ui_f\data\gui\rsc\rscdisplaygarage\car_ca.paa";
    _friendlyVehicleKillHeader ctrlCommit 0;

    private _friendlyDeathHeader = _display ctrlCreate ["RscTextNoShadow", 1009, _globalGroup];
    _friendlyDeathHeader ctrlSetFontHeight PY(2.2);
    _friendlyDeathHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyDeathHeader ctrlSetPosition [PX(_sideWidth - 24), PY(20), PX(6), PY(4)];
    _friendlyDeathHeader ctrlSetText "DEATHS";
    _friendlyDeathHeader ctrlCommit 0;

    private _friendlyMedicalHeader = _display ctrlCreate ["RscPictureKeepAspect", 1010, _globalGroup];
    _friendlyMedicalHeader ctrlSetFontHeight PY(2.2);
    _friendlyMedicalHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyMedicalHeader ctrlSetPosition [PX(_sideWidth - 18), PY(21), PX(6), PY(2)];
    _friendlyMedicalHeader ctrlSetText "\A3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa";
    _friendlyMedicalHeader ctrlCommit 0;

    private _friendlyCapturedHeader = _display ctrlCreate ["RscPictureKeepAspect", 1011, _globalGroup];
    _friendlyCapturedHeader ctrlSetFontHeight PY(2.2);
    _friendlyCapturedHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyCapturedHeader ctrlSetPosition [PX(_sideWidth - 12), PY(21), PX(6), PY(2)];
    _friendlyCapturedHeader ctrlSetText "\A3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa";
    _friendlyCapturedHeader ctrlCommit 0;

    private _friendlyScoreHeader = _display ctrlCreate ["RscTextNoShadow", 1012, _globalGroup];
    _friendlyScoreHeader ctrlSetFontHeight PY(2.2);
    _friendlyScoreHeader ctrlSetFont "RobotoCondensedBold";
    _friendlyScoreHeader ctrlSetPosition [PX(_sideWidth - 6), PY(20), PX(6), PY(4)];
    _friendlyScoreHeader ctrlSetText "SCORE";
    _friendlyScoreHeader ctrlCommit 0;

    // The group with contains all score entries
    private _friendlyPlayerListGroup = _display ctrlCreate ["RscControlsGroupNoHScrollbars", 1100, _globalGroup];
    _friendlyPlayerListGroup ctrlSetPosition [0, PY(25), PX(_sideWidth+1), PY(70)];
    _friendlyPlayerListGroup ctrlCommit 0;

    // The controls for enemy side
    private _startPosition = [81, 71] select _endScreen;
    _sideWidth = [39, 69] select _endScreen;
    private _enemyHeaderBg = _display ctrlCreate ["RscPicture", 1012, _globalGroup];
    _enemyHeaderBg ctrlSetPosition [PX(_startPosition), PY(17), PX(_sideWidth), PY(7)];
    _enemyHeaderBg ctrlSetText "#(argb,8,8,3)color(0.6,0,0,1)";
    _enemyHeaderBg ctrlCommit 0;

    private _enemyFlag = _display ctrlCreate ["RscPictureKeepAspect", 1013, _globalGroup];
    _enemyFlag ctrlSetPosition [PX(_startPosition+0.5), PY(17.5), PX(6), PY(6)];
    _enemyFlag ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,Flag_%1), _enemySide], "#(argb,8,8,3)color(0.5,0.5,0.5,1)"]);
    _enemyFlag ctrlCommit 0;

    private _enemySideName = _display ctrlCreate ["RscTitle", 1014, _globalGroup];
    _enemySideName ctrlSetFontHeight PY(3.3);
    _enemySideName ctrlSetFont "RobotoCondensedBold";
    _enemySideName ctrlSetPosition [PX(_startPosition+7), PY(17), PX(30), PY(4)];
    _enemySideName ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,sideName_%1), _enemySide], ""]);
    _enemySideName ctrlCommit 0;

    private _enemyPlayerCount = _display ctrlCreate ["RscTitle", 1015, _globalGroup];
    _enemyPlayerCount ctrlSetFontHeight PY(2.2);
    _enemyPlayerCount ctrlSetFont "RobotoCondensed";
    _enemyPlayerCount ctrlSetPosition [PX(_startPosition +7), PY(20), PX(30), PY(4)];
    _enemyPlayerCount ctrlSetText toUpper format ["%1 PLAYERS", {_enemySide == side group _x} count allPlayers];
    _enemyPlayerCount ctrlCommit 0;

    if (_endScreen) then {
        private _enemyTicketCount = _display ctrlCreate ["RscTextNoShadow", 1016, _globalGroup];
        _enemyTicketCount ctrlSetFontHeight PY(3.3);
        _enemyTicketCount ctrlSetFont "RobotoCondensedBold";
        _enemyTicketCount ctrlSetPosition [PX(_startPosition + _sideWidth - 7), PY(17), PX(6), PY(4)];
        _enemyTicketCount ctrlSetText str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), _enemySide], GVAR(maxTickets)]);
        _enemyTicketCount ctrlCommit 0;

        private _enemyKillHeader = _display ctrlCreate ["RscTextNoShadow", -1, _globalGroup];
        _enemyKillHeader ctrlSetFontHeight PY(2.2);
        _enemyKillHeader ctrlSetFont "RobotoCondensedBold";
        _enemyKillHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 36), PY(20), PX(6), PY(4)];
        _enemyKillHeader ctrlSetText "KILLS";
        _enemyKillHeader ctrlCommit 0;

        private _enemyVehicleKillHeader = _display ctrlCreate ["RscPictureKeepAspect", -1, _globalGroup];
        _enemyVehicleKillHeader ctrlSetFontHeight PY(2.2);
        _enemyVehicleKillHeader ctrlSetFont "RobotoCondensedBold";
        _enemyVehicleKillHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 30), PY(21), PX(6), PY(2)];
        _enemyVehicleKillHeader ctrlSetText "\A3\ui_f\data\gui\rsc\rscdisplaygarage\car_ca.paa";
        _enemyVehicleKillHeader ctrlCommit 0;

        private _enemyDeathHeader = _display ctrlCreate ["RscTextNoShadow", -1, _globalGroup];
        _enemyDeathHeader ctrlSetFontHeight PY(2.2);
        _enemyDeathHeader ctrlSetFont "RobotoCondensedBold";
        _enemyDeathHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 24), PY(20), PX(6), PY(4)];
        _enemyDeathHeader ctrlSetText "DEATHS";
        _enemyDeathHeader ctrlCommit 0;

        private _enemyMedicalHeader = _display ctrlCreate ["RscPictureKeepAspect", -1, _globalGroup];
        _enemyMedicalHeader ctrlSetFontHeight PY(2.2);
        _enemyMedicalHeader ctrlSetFont "RobotoCondensedBold";
        _enemyMedicalHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 18), PY(21), PX(6), PY(2)];
        _enemyMedicalHeader ctrlSetText "\A3\ui_f\data\igui\cfg\simpletasks\types\heal_ca.paa";
        _enemyMedicalHeader ctrlCommit 0;

        private _enemyCapturedHeader = _display ctrlCreate ["RscPictureKeepAspect", -1, _globalGroup];
        _enemyCapturedHeader ctrlSetFontHeight PY(2.2);
        _enemyCapturedHeader ctrlSetFont "RobotoCondensedBold";
        _enemyCapturedHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 12), PY(21), PX(6), PY(2)];
        _enemyCapturedHeader ctrlSetText "\A3\ui_f\data\igui\cfg\simpletasks\types\attack_ca.paa";
        _enemyCapturedHeader ctrlCommit 0;

        private _enemyScoreHeader = _display ctrlCreate ["RscTextNoShadow", -1, _globalGroup];
        _enemyScoreHeader ctrlSetFontHeight PY(2.2);
        _enemyScoreHeader ctrlSetFont "RobotoCondensedBold";
        _enemyScoreHeader ctrlSetPosition [PX(_startPosition + _sideWidth - 6), PY(20), PX(6), PY(4)];
        _enemyScoreHeader ctrlSetText "SCORE";
        _enemyScoreHeader ctrlCommit 0;
    };

    // The group which contains the enemy scores
    private _enemyPlayerListGroup = _display ctrlCreate ["RscControlsGroupNoHScrollbars", 1300, _globalGroup];
    _enemyPlayerListGroup ctrlSetPosition [PX(_startPosition), PY(25), PX(_sideWidth+1), PY(70)];
    _enemyPlayerListGroup ctrlCommit 0;

}, [_ppBlur, _ppColor]] call CFUNC(addEventhandler);

[UIVAR(ScoreTable_onUnload), {
    (_this select 1) params ["_ppBlur", "_ppColor"];
    // Remove all ppEffects
    _ppColor ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.7, 0.2, 0.1, 0.0]];
    _ppColor ppEffectCommit 0.3;
    _ppBlur ppEffectAdjust [0];
    _ppBlur ppEffectCommit 0.3;
}, [_ppBlur, _ppColor]] call CFUNC(addEventhandler);

// This events is trigger by the server to update the scores
if (CLib_Player call EFUNC(Common,isSpectator)) then {
    [QGVAR(ScoreUpdate), {
        private _display = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
        if (isNull _display) exitWith {};

        [_display displayCtrl 1100, EGVAR(Common,competingSides) select 0, true] call FUNC(updateList);
        [_display displayCtrl 1300, EGVAR(Common,competingSides) select 1, true] call FUNC(updateList);
    }] call CFUNC(addEventhandler);

    [QEGVAR(Common,ticketsChanged), {
        private _display = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
        if (isNull _display) exitWith {};

        (_display displayCtrl 1005) ctrlSetText str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), EGVAR(Common,competingSides) select 0], GVAR(maxTickets)]);
        (_display displayCtrl 1005) ctrlCommit 0;

        (_display displayCtrl 1016) ctrlSetText str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), EGVAR(Common,competingSides) select 1], GVAR(maxTickets)]);
        (_display displayCtrl 1016) ctrlCommit 0;
    }] call CFUNC(addEventhandler);
} else {
    [QGVAR(ScoreUpdate), {
        private _display = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
        if (isNull _display) exitWith {};

        [_display displayCtrl 1100, playerSide, true] call FUNC(updateList);
        [_display displayCtrl 1300, (EGVAR(Common,competingSides) - [playerSide]) select 0, false] call FUNC(updateList);
    }] call CFUNC(addEventhandler);

    [QEGVAR(Common,ticketsChanged), {
        private _display = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
        if (isNull _display) exitWith {};

        (_display displayCtrl 1005) ctrlSetText str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), playerSide], GVAR(maxTickets)]);
        (_display displayCtrl 1005) ctrlCommit 0;
    }] call CFUNC(addEventhandler);
};



GVAR(lastVisibleScoreTableStatus) = false;

[{

    if (!(visibleScoretable isEqualTo GVAR(lastVisibleScoreTableStatus))) then {
        GVAR(lastVisibleScoreTableStatus) = visibleScoretable;

        if (visibleScoretable) then {
            private _display = displayNull;
            {
                if (ctrlIDD _x == 175) then {
                    _display = _x;
                };
                nil;
            } count (uiNamespace getVariable "GUI_displays");
            if (!isNull _display) then {

                {
                    _x ctrlShow false;
                    nil;
                } count allControls _display;
                [UIVAR(ScoreTable_onLoad), _display] call CFUNC(localEvent);
                [QGVAR(ScoreUpdate)] call CFUNC(localEvent);
            };
        } else {
            [UIVAR(ScoreTable_onUnload)] call CFUNC(localEvent);
        };

    };

}, 0] call CFUNC(addPerFrameHandler);

["endMission", {
    private _oldDisplay = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
    if (!isNull _oldDisplay) then {
        _oldDisplay closeDisplay 1;
    };
    [{
        private _oldDisplay = uiNamespace getVariable [QGVAR(scoreTable), displayNull];
        if (!isNull _oldDisplay) then {
            _oldDisplay closeDisplay 1;
        };
        private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
        [UIVAR(ScoreTable_onLoad), [_display, true]] call CFUNC(localEvent);
        [_display displayCtrl 1100, playerSide, true] call FUNC(updateList);
        [_display displayCtrl 1300, (EGVAR(Common,competingSides) - [playerSide]) select 0, true] call FUNC(updateList);
        [{
            params ["_display"];
            _display closeDisplay 1;
        }, 20, [_display]] call CFUNC(wait);
    }, 9.9] call CFUNC(wait);
}] call CFUNC(addEventhandler);
