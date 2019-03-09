#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Init of respawn UI stuff.

    Parameter(s):
    None

    Returns:
    None
*/
if (side CLib_player == sideLogic && {CLib_player isKindOf "VirtualSpectator_F"}) exitWith {};

// When player dies show respawn UI
["Killed", {
    [[-10000, -10000, 50], true] call EFUNC(Common,respawn);

    [{
        // Respawn screen may already open by user action
        if (!(isNull (uiNamespace getVariable [QGVAR(respawnDisplay), displayNull]))) exitWith {
            [UIVAR(RespawnScreen_onLoad), GVAR(respawnDisplay)] call CFUNC(localEvent);
        };

        (findDisplay 46) createDisplay UIVAR(RespawnScreen);
    }] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_onLoad), {
    showHUD [true, true, true, true, true, true, false, true];
    [UIVAR(RespawnScreen), true] call CFUNC(blurScreen);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_onUnload), {
    showHUD [true, true, true, true, true, true, true, true];
    [UIVAR(RespawnScreen), false] call CFUNC(blurScreen);
}] call CFUNC(addEventHandler);

// Wait for the mission start first.
["missionStarted", {
    // Choose the initial side for the player before showing the respawn screen.
    [QGVAR(SideSelection)] call BIS_fnc_startLoadingScreen;

    // We need a mutex to ensure the player detects the side with fewest players correctly
    [{
        50 call BIS_fnc_progressLoadingScreen;

        // Calculate the side with fewest players
        private _leastPlayerSide = sideUnknown;
        private _leastPlayerCount = 999;
        {
            private _side = _x;
            private _playerCount = {side group _x == _side} count allPlayers;
            if (_playerCount < _leastPlayerCount) then {
                _leastPlayerSide = _side;
                _leastPlayerCount = _playerCount;
            };
            nil
        } count EGVAR(Common,competingSides);

        // Move the player to the side
        private _initialUnit = CLib_Player;
        [[-1000, -1000, 10], _leastPlayerSide] call EFUNC(Common,respawnNewSide);
        deleteVehicle _initialUnit;

        // Open the respawn UI
        [{
            [QGVAR(SideSelection)] call BIS_fnc_endLoadingScreen;

            private _welcomeScreenDisplay = (findDisplay 46) createDisplay "RscDisplayLoadMission";
            [UIVAR(WelcomeScreen_onLoad), _welcomeScreenDisplay] call CFUNC(localEvent);
        }] call CFUNC(execNextFrame);

    }, [], "respawn"] call CFUNC(mutex);
}] call CFUNC(addEventHandler);

[UIVAR(WelcomeScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(welcomeDisplay), _display];

    // Disable esc button
    _display displayAddEventHandler ["KeyDown", {_this select 1 == 1}];

    // Hide the mission info and chat
    (_display displayCtrl 2300) ctrlShow false;
    showChat false;

    // Create welcome controls
    private _background = _display ctrlCreate ["RscText", 6000];
    _background ctrlSetPosition [0.5 - PX(40), 0.5 - PY(20), PX(80), PY(40)];
    _background ctrlSetBackgroundColor [0, 0, 0, 0.7];
    _background ctrlCommit 0;
    private _content = _display ctrlCreate ["RscHTML", 6001];
    _content ctrlSetPosition [0.5 - PX(39), 0.5 - PY(19), PX(78), PY(38)];
    _content ctrlCommit 0;
    _content htmlLoad format ["https://www.atwar-mod.com/popup/%1/%2", EGVAR(Common,VersionInfo) select 1 select 0, CLib_Player call CFUNC(name)];
    private _continueButton = _display ctrlCreate ["RscButtonMenu", 6002];
    _continueButton ctrlSetPosition [0.5 - PX(40), 0.5 + PY(20.5), PX(80), (((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25];
    _continueButton ctrlSetText "CONTINUE";
    _continueButton ctrlAddEventHandler ["ButtonClick", {
        [{
            showChat true;
            (findDisplay 46) createDisplay UIVAR(RespawnScreen);
        }] call CFUNC(execNextFrame);
        false
    }];
    _continueButton ctrlCommit 0;
    ctrlSetFocus _continueButton;
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(respawnDisplay), _display];

    // Load the different screens
    [UIVAR(TeamInfoScreen_onLoad), _display] call CFUNC(localEvent);
    [UIVAR(SquadScreen_onLoad), _display] call CFUNC(localEvent);
    [UIVAR(RoleScreen_onLoad), _display] call CFUNC(localEvent);
    [UIVAR(DeploymentScreen_onLoad), _display] call CFUNC(localEvent);

    // The dialog needs one frame until access to controls is possible
    [{
        params ["_display"];

        // Register the map for the marker system
        [_display displayCtrl 800] call CFUNC(registerMapControl);
        [_display, [-PX(40), 0]] call EFUNC(Common,registerDisplayNotification);
        [_display displayCtrl 800] call EFUNC(MapInteractions,registerMapControl);

        if (!(alive CLib_Player) || (CLib_Player getVariable [QEGVAR(Common,tempUnit), false])) then {
            // Catch the escape key
            _display displayAddEventHandler ["KeyDown", FUNC(showDisplayInterruptEH)];
        };

        // Update the MissionName Text
        (_display displayCtrl 501) ctrlSetStructuredText parseText (getText (missionConfigFile >> "onLoadMission"));

        // Update Tickets
        private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
        private _firstSide = EGVAR(Common,competingSides) select 0;
        private _secondSide = EGVAR(Common,competingSides) select 1;

        (_display displayCtrl 601) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,Flag_%1), _firstSide], "#(argb,8,8,3)color(0.5,0.5,0.5,1)"]);

        (_display displayCtrl 603) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,sideName_%1), _firstSide], ""]);
        private _pos = ctrlPosition (_display displayCtrl 603);
        _pos set [1, PY(3.875)];
        (_display displayCtrl 603) ctrlSetPosition _pos;
        (_display displayCtrl 603) ctrlCommit 0;

        (_display displayCtrl 605) ctrlSetText str ({_firstSide == side group _x} count allPlayers);
        _pos = ctrlPosition (_display displayCtrl 605);
        _pos set [1, PY(7.5)];
        (_display displayCtrl 605) ctrlSetPosition _pos;
        (_display displayCtrl 605) ctrlCommit 0;

        (_display displayCtrl 602) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,Flag_%1), _secondSide], "#(argb,8,8,3)color(0.5,0.5,0.5,1)"]);

        (_display displayCtrl 604) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,sideName_%1), _secondSide], ""]);
        _pos = ctrlPosition (_display displayCtrl 604);
        _pos set [1, PY(3.875)];
        (_display displayCtrl 604) ctrlSetPosition _pos;
        (_display displayCtrl 604) ctrlCommit 0;

        (_display displayCtrl 606) ctrlSetText str ({_secondSide == side group _x} count allPlayers);
        _pos = ctrlPosition (_display displayCtrl 606);
        _pos set [1, PY(7.5)];
        (_display displayCtrl 606) ctrlSetPosition _pos;
        (_display displayCtrl 606) ctrlCommit 0;

        private _captionPlayer = _display ctrlCreate ["RscTextNoShadow", 607, (_display displayCtrl 600)];
        _captionPlayer ctrlSetFontHeight PY(2);
        _captionPlayer ctrlSetFont "PuristaMedium";
        _captionPlayer ctrlSetText "PLAYER";
        _captionPlayer ctrlSetPosition [PX(20-4), PY(7.5), PX(8), PY(2)];
        _captionPlayer ctrlCommit 0;

        private _captionTickets = _display ctrlCreate ["RscTextNoShadow", 608, (_display displayCtrl 600)];
        _captionTickets ctrlSetFontHeight PY(2);
        _captionTickets ctrlSetFont "PuristaSemiBold";
        _captionTickets ctrlSetText (str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), playerSide], _startTickets]) + " TICKETS AVAILABLE");
        _captionTickets ctrlSetPosition [PX(20-10), PY(9.5), PX(20), PY(2)];
        _captionTickets ctrlCommit 0;


        {
            private _pos = ctrlPosition (_display displayCtrl _x);
            _pos set [1, (_pos select 1) - PY(2)];
            (_display displayCtrl _x) ctrlSetPosition _pos;
            (_display displayCtrl _x) ctrlCommit 0;
            nil
        } count [601, 602, 603, 604, 605, 606, 607, 608];

        [{
            private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];

            if (isNull _display) exitWith {
                (_this select 1) call CFUNC(removePerFrameHandler);
            };

            private _firstSide = EGVAR(Common,competingSides) select 0;
            private _secondSide = EGVAR(Common,competingSides) select 1;

            private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
            (_display displayCtrl 605) ctrlSetText str ({_firstSide == side group _x} count allPlayers);
            (_display displayCtrl 606) ctrlSetText str ({_secondSide == side group _x} count allPlayers);

            {
                (_display displayCtrl _x) ctrlCommit 0;
                nil;
            } count [605, 606];
        }, 1] call CFUNC(addPerFrameHandler);

        (_display displayCtrl 500) call FUNC(fadeControl); // MissionName
        (_display displayCtrl 600) call FUNC(fadeControl); // Tickets
    }, _display] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

["ticketsChanged", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    if (isNull _display || EGVAR(Tickets,deactivateTicketSystem)) exitWith {};

    private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
    (_display displayCtrl 608) ctrlSetText (str (missionNamespace getVariable [format [QEGVAR(Tickets,sideTickets_%1), playerSide], _startTickets]) + " TICKETS AVAILABLE");
    (_display displayCtrl 608) ctrlCommit 0;

}] call CFUNC(addEventHandler);

["playerSideChanged", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _firstSide = EGVAR(Common,competingSides) select 0;
    private _secondSide = EGVAR(Common,competingSides) select 1;

    private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
    (_display displayCtrl 605) ctrlSetText str ({_firstSide == side group _x} count allPlayers);
    (_display displayCtrl 606) ctrlSetText str ({_secondSide == side group _x} count allPlayers);

    {
        (_display displayCtrl _x) ctrlCommit 0;
        nil;
    } count [605, 606];
}] call CFUNC(addEventHandler);

["endMission", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    _display closeDisplay 1;
}] call CFUNC(addEventHandler);

addMissionEventHandler ["Ended", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    _display closeDisplay 1;
}];


// Alternative notification display
["notificationDisplayed", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    if (isNull _display || dialog) exitWith {};

    (_this select 0) params ["_priority", "_timeAdded", "_text", "_color", "_time", "_condition"];

    // Center and zero width
    private _controlGroup = _display displayCtrl 700;
    private _groupPos = ctrlPosition _controlGroup;
    private _oldGroupPos = +_groupPos;
    _groupPos set [0, 0.5];
    _groupPos set [2, 0];
    _controlGroup ctrlSetPosition _groupPos;

    // Background
    private _controlBackground = _display displayCtrl 799;
    _controlBackground ctrlSetTextColor _color;
    private _bgPos = ctrlPosition _controlBackground;
    _bgPos set [0, -(_bgPos select 2) / 2];
    _controlBackground ctrlSetPosition _bgPos;
    _bgPos set [0, 0];

    // Text
    private _controlText = _display displayCtrl 701;
    _controlText ctrlSetStructuredText parseText format ["%1", _text];
    private _txtPos = ctrlPosition _controlText;
    _txtPos set [0, -(_txtPos select 2) / 2];
    _controlText ctrlSetPosition _txtPos;
    _txtPos set [0, 0];

    // Commit initial positions
    _controlGroup ctrlCommit 0;
    _controlBackground ctrlCommit 0;
    _controlText ctrlCommit 0;

    // Prepare animation
    _controlGroup ctrlSetPosition _oldGroupPos;
    _controlGroup ctrlSetFade 0;
    _controlGroup ctrlShow true;
    _controlBackground ctrlSetPosition _bgPos;
    _controlText ctrlSetPosition _txtPos;

    // Commit animation
    _controlGroup ctrlCommit 0.2;
    _controlBackground ctrlCommit 0.2;
    _controlText ctrlCommit 0.2;
}] call CFUNC(addEventHandler);

["notificationHidden", {
    private _display = uiNamespace getVariable [QGVAR(respawnDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _controlGroup = _display displayCtrl 700;
    _controlGroup ctrlSetFade 1;
    _controlGroup ctrlShow false;
    _controlGroup ctrlCommit 0.2;
}] call CFUNC(addEventHandler);
