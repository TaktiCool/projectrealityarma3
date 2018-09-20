#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, BadGuy

    Description:
    init for TicketBleed System

    Parameter(s):
    None

    Returns:
    None
*/

DFUNC(checkTicketBleed) = {
    // Check for Ticket Bleed
    private _sectorOwner = EGVAR(Sector,allSectorsArray) apply {
        _x getVariable ["side", sideUnknown]
    };

    if (sideUnknown in _sectorOwner) exitWith {sideUnknown};

    private _nbrOwnedSectors = EGVAR(Common,competingSides) apply {
        private _side = _x;
        [{_x == _side} count _sectorOwner, _side];
    };

    _nbrOwnedSectors sort true;

    private _looser = _nbrOwnedSectors select 0;
    if ((_looser select 0) > 1) exitWith {sideUnknown};

    _looser select 1;
};

GVAR(deactivateTicketSystem) = false;
["playEndMusic", {
    playMusic (selectRandom (GVAR(availableTracks)));
    addMusicEventHandler ["MusicStop", {
        playMusic (selectRandom (GVAR(availableTracks)));
    }];
}] call CFUNC(addEventHandler);

[{
    GVAR(availableTracks) = getArray (missionConfigFile >> QPREFIX >> "tracks");

    if (GVAR(availableTracks) isEqualTo []) then {
        {
            GVAR(availableTracks) pushBackUnique (configName _x);
            nil
        } count ("true" configClasses (configFile >> "CfgMusic"));

        if (isClass (missionConfigFile >> "CfgMusic")) then {
            {
                GVAR(availableTracks) pushBackUnique (configName _x);
                nil
            } count ("true" configClasses (missionConfigFile >> "CfgMusic"));
        };
    };

    GVAR(musicStartTickets) = getNumber (missionConfigFile >> QPREFIX >> "musicStart");

    if (isServer) then {
        GVAR(playerTicketValue) = getNumber (missionConfigFile >> QPREFIX >> "playerTicketValue");
        GVAR(ticketBleed) = getArray (missionConfigFile >> QPREFIX >> "ticketBleed");

        private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
        {
            missionNamespace setVariable [format [QGVAR(sideTickets_%1), _x], _startTickets];
            publicVariable (format [QGVAR(sideTickets_%1), _x]);
            nil
        } count EGVAR(Common,competingSides);

        addMissionEventHandler ["EntityKilled", {
            params ["_killedEntity", "_killer"];
            if (_killedEntity getVariable ["ticketValue", 0] > 0) exitWith {
                private _ticketValue = _killedEntity getVariable ["ticketValue", 0];
                private _currentSide = _killedEntity getVariable ["side", "unknown"];
                private _tickets = missionNamespace getVariable format [QGVAR(sideTickets_%1), _currentSide];
                if !(isNil "_tickets") then {
                    _tickets = _tickets - _ticketValue;
                    missionNamespace setVariable [format [QGVAR(sideTickets_%1), _currentSide], _tickets];
                    publicVariable (format [QGVAR(sideTickets_%1), _currentSide]);
                    "ticketsChanged" call CFUNC(globalEvent);
                };
            };

            if (_killedEntity in allPlayers) exitWith {
                private _currentSide = side group _killedEntity;
                private _tickets = missionNamespace getVariable format [QGVAR(sideTickets_%1), _currentSide];
                if !(isNil "_tickets") then {
                    _tickets = _tickets - GVAR(playerTicketValue);
                    missionNamespace setVariable [format [QGVAR(sideTickets_%1), _currentSide], _tickets];
                    publicVariable (format [QGVAR(sideTickets_%1), _currentSide]);
                    "ticketsChanged" call CFUNC(globalEvent);
                };
            };
        }];

        ["sectorSideChanged", {
            (_this select 0) params ["_sector", "_oldSide", "_newSide"];
            if (_oldSide != sideUnknown) then {
                private _tickets = missionNamespace getVariable format [QGVAR(sideTickets_%1), _oldSide];
                if !(isNil "_tickets") then {
                    _tickets = _tickets - (_sector getVariable "ticketValue");
                    missionNamespace setVariable [format [QGVAR(sideTickets_%1), _oldSide], _tickets];
                    publicVariable (format [QGVAR(sideTickets_%1), _oldSide]);
                    "ticketsChanged" call CFUNC(globalEvent);
                };
            };

            // Check for Ticket Bleed
            private _looser = call FUNC(checkTicketBleed);

            if (_looser != sideUnknown) then {
                [{
                    (_this select 0) params ["_side"];
                    private _id = (_this select 1);

                    private _looser = call FUNC(checkTicketBleed);

                    if (_looser != _side) exitWith {
                        [_id] call CFUNC(removePerFrameHandler);
                    };

                    private _tickets = missionNamespace getVariable format [QGVAR(sideTickets_%1), _side];
                    _tickets = _tickets - (GVAR(ticketBleed) select 1);
                    missionNamespace setVariable [format [QGVAR(sideTickets_%1), _side], _tickets];
                    publicVariable (format [QGVAR(sideTickets_%1), _side]);
                    "ticketsChanged" call CFUNC(globalEvent);
                }, GVAR(ticketBleed) select 0, [_looser]] call CFUNC(addPerFrameHandler);

            };

        }] call CFUNC(addEventhandler);

        if (isDedicated) then {
            ["ticketsChanged", {
                if ((missionNamespace getVariable [format [QGVAR(sideTickets_%1), EGVAR(Common,competingSides) select 0], 1000]) <= 0
                 || (missionNamespace getVariable [format [QGVAR(sideTickets_%1), EGVAR(Common,competingSides) select 1], 1000]) <= 0) then {

                    endMission "END1";
                };
            }] call CFUNC(addEventHandler);
        };
    };

    if (hasInterface) then {
        UIVAR(TicketStatus) cutRsc ["RscTitleDisplayEmpty", "PLAIN", 1];
        private _display = uiNamespace getVariable ["RscTitleDisplayEmpty", displayNull];
        if (isNull _display) exitWith {};

        (_display displayCtrl 1202) ctrlSetFade 1;
        (_display displayCtrl 1202) ctrlShow false;
        (_display displayCtrl 1202) ctrlCommit 0;

        private _textSize = PY(2.2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);

        private _ctrlGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
        _ctrlGrp ctrlSetPosition [ 0.5 - PX(10.5), safeZoneY + PY(0.5), PX(21), PY(3)];
        _ctrlGrp ctrlCommit 0;



        private _ctrlBgResource = _display ctrlCreate ["RscText", -1, _ctrlGrp];
        _ctrlBgResource ctrlSetPosition [0, 0, PX(10), PY(2.5)];
        _ctrlBgResource ctrlSetBackgroundColor [0.5, 0.5, 0.5, 0.5];
        _ctrlBgResource ctrlCommit 0;

        private _ctrlResourceBar = _display ctrlCreate ["RscText", 2001, _ctrlGrp];
        _ctrlResourceBar ctrlSetPosition [0, 0, PX(10), PY(0.2)];
        _ctrlResourceBar ctrlSetBackgroundColor [0.93, 0.7, 0.01, 1];
        _ctrlResourceBar ctrlCommit 0;

        private _ctrlResourceIcon = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
        _ctrlResourceIcon ctrlSetPosition [PX(8-0.25-0.5), 0, PX(2.5), PY(2.5)];
        _ctrlResourceIcon ctrlSetText "\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa";
        _ctrlResourceIcon ctrlCommit 0;

        private _ctrlResourceText = _display ctrlCreate ["RscStructuredText", 2002, _ctrlGrp];
        _ctrlResourceText ctrlSetPosition [PX(0), PY(0.2), PX(7.5), PY(2.5)];
        _ctrlResourceText ctrlSetStructuredText parseText format ["<t size='%1' align='right' shadow=false>%2</t>", _textSize, "---"];
        _ctrlResourceText ctrlCommit 0;



        private _ctrlBgTickets = _display ctrlCreate ["RscText", -1, _ctrlGrp];
        _ctrlBgTickets ctrlSetPosition [PX(11), 0, PX(10), PY(2.5)];
        _ctrlBgTickets ctrlSetBackgroundColor [0.5, 0.5, 0.5, 0.5];
        _ctrlBgTickets ctrlCommit 0;

        private _ctrlTicketsBar = _display ctrlCreate ["RscText", 2011, _ctrlGrp];
        _ctrlTicketsBar ctrlSetPosition [PX(11), 0, PX(10), PY(0.2)];
        _ctrlTicketsBar ctrlSetBackgroundColor [0, 0.4, 0.8, 1];
        _ctrlTicketsBar ctrlCommit 0;

        private _ctrlTicketsText = _display ctrlCreate ["RscStructuredText", 2012, _ctrlGrp];
        _ctrlTicketsText ctrlSetPosition [PX(13.5), PY(0.2), PX(7.5), PY(2.5)];
        _ctrlTicketsText ctrlSetStructuredText parseText format ["<t size='%1' align='left' shadow=false>%2</t>", _textSize, "---"];
        _ctrlTicketsText ctrlCommit 0;

        private _ctrlTicketsIcon = _display ctrlCreate ["RscPicture", -1, _ctrlGrp];
        _ctrlTicketsIcon ctrlSetPosition [PX(11.5), PY(0.25), PX(2), PY(2)];
        _ctrlTicketsIcon ctrlSetText "\A3\modules_f_curator\data\portraitmissionname_ca.paa";
        _ctrlTicketsIcon ctrlCommit 0;

        uiNamespace setVariable [UIVAR(TicketStatus), _display];

        private _fncUpdateTickets = {
            if (GVAR(deactivateTicketSystem)) exitWith {};
            private _display = uiNamespace getVariable [UIVAR(TicketStatus), displayNull];
            if (isNull _display) exitWith {};

            private _textSize = PY(2.2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
            private _startTickets = getNumber (missionConfigFile >> QPREFIX >> "tickets");
            private _tickets = missionNamespace getVariable [format [QGVAR(sideTickets_%1), side group CLib_player], _startTickets];

            (_display displayCtrl 2012) ctrlSetStructuredText parseText format ["<t size='%1' align='left' shadow=false>%2</t>", _textSize, _tickets];
            (_display displayCtrl 2011) ctrlSetPosition [PX(11), 0, PX(10*(_tickets/_startTickets)), PY(0.2)];
            (_display displayCtrl 2011) ctrlCommit 0;
            (_display displayCtrl 2012) ctrlCommit 0;
        };

        private _fncUpdateSupplyPoints = {
            private _display = uiNamespace getVariable [UIVAR(TicketStatus), displayNull];
            if (isNull _display) exitWith {};

            private _cfg = QUOTE(PREFIX/CfgLogistics/) + ([format [QUOTE(PREFIX/Sides/%1/logistics), side group CLib_player], ""] call CFUNC(getSetting));
            private _maxSupplyPoints = [_cfg + "/supplyPointsMax", 500] call CFUNC(getSetting);
            private _textSize = PY(2.2) / (((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25) * 1);
            private _supplyPoints = missionNamespace getVariable [format [QEGVAR(Logistic,supplyPoints_%1), side group CLib_player], 0];

            (_display displayCtrl 2002) ctrlSetStructuredText parseText format ["<t size='%1' align='right' shadow=false>%2</t>", _textSize, _supplyPoints];
            (_display displayCtrl 2001) ctrlSetPosition [PX(10*(1-(_supplyPoints/_maxSupplyPoints))), 0, PX(10*(_supplyPoints/_maxSupplyPoints)), PY(0.2)];
            (_display displayCtrl 2001) ctrlCommit 0;
            (_display displayCtrl 2002) ctrlCommit 0;
        };

        ["playerSideChanged", _fncUpdateTickets] call CFUNC(addEventHandler);
        ["playerSideChanged", _fncUpdateSupplyPoints] call CFUNC(addEventHandler);

        ["ticketsChanged", _fncUpdateTickets] call CFUNC(addEventHandler);

        ["supplyPointsChanged", _fncUpdateSupplyPoints] call CFUNC(addEventHandler);

        {
            (format [QEGVAR(Logistic,supplyPoints_%1), _x]) addPublicVariableEventHandler {
                if ((_this select 0) != format [QEGVAR(Logistic,supplyPoints_%1), side group CLib_player]) exitWith {};
                call _fncUpdateSupplyPoints;
            };
        } count EGVAR(Common,competingSides);

        ["ticketsChanged", {
            if (GVAR(deactivateTicketSystem)) exitWith {};

            if ((missionNamespace getVariable [format [QGVAR(sideTickets_%1), EGVAR(Common,competingSides) select 0], 1000]) <= 0
             || (missionNamespace getVariable [format [QGVAR(sideTickets_%1), EGVAR(Common,competingSides) select 1], 1000]) <= 0) then {
                if ((missionNamespace getVariable [format [QGVAR(sideTickets_%1), side group CLib_Player], 1000]) <= 0) then {
                    ["LOOSER"] call EFUNC(Common,endMission);
                } else {
                    ["WINNER"] call EFUNC(Common,endMission);
                };

                GVAR(deactivateTicketSystem) = true;

            };
        }] call CFUNC(addEventHandler);

        [] call _fncUpdateTickets;
        [] call _fncUpdateSupplyPoints;
    };
}, {!isNil QEGVAR(Common,competingSides) && {!(EGVAR(Common,competingSides) isEqualTo [])}}] call CFUNC(waitUntil);
