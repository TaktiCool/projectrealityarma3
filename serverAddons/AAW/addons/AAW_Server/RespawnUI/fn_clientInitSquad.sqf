#include "macros.hpp"
/*
    Arma At War - AAW

    Author:

    Description:
    [Description]

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

/*
 * #### TEAM INFO SCREEN ####
 * TEAM INFO
 */
[UIVAR(TeamInfoScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(teamInfoDisplay), _display];

    // The dialog needs one frame until access to controls is possible
    [{
        params ["_display"];

        // Update the values of the UI elements
        UIVAR(RespawnScreen_TeamInfo_update) call CFUNC(localEvent);

        // Fade the control in
        (_display displayCtrl 100) call FUNC(fadeControl);
    }, _display] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

// When the player side changes update the team info
["playerSideChanged", {
    UIVAR(RespawnScreen_TeamInfo_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_TeamInfo_update), {
    private _display = uiNamespace getVariable [QGVAR(teamInfoDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Update the flag and text
    (_display displayCtrl 102) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,Flag_%1), playerSide], ""]);
    (_display displayCtrl 103) ctrlSetText (missionNamespace getVariable [format [QEGVAR(Common,SideName_%1), playerSide], ""]);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_ChangeSideBtn_onButtonClick), {
    call EFUNC(Squad,switchSide);
}] call CFUNC(addEventHandler);

/*
 * #### SQUAD SCREEN ####
 */
["missionStarted", {
    ["Squad Screen", CLib_Player, 0, {isNull (uiNamespace getVariable [QGVAR(squadDisplay), displayNull])}, {
        (findDisplay 46) createDisplay UIVAR(SquadScreen);
    }, ["ignoredCanInteractConditions", ["isNotInVehicle"], "showWindow", false]] call CFUNC(addAction);
}] call CFUNC(addEventHandler);

[UIVAR(SquadScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(squadDisplay), _display];

    // The dialog needs one frame until access to controls is possible
    [{
        params ["_display"];

        // Update the values of the UI elements
        UIVAR(RespawnScreen_NewSquadDesignator_update) call CFUNC(localEvent);
        UIVAR(RespawnScreen_SquadTypeCombo_update) call CFUNC(localEvent);
        UIVAR(RespawnScreen_SquadManagement_update) call CFUNC(localEvent);
        UIVAR(RespawnScreen_SquadMemberManagement_update) call CFUNC(localEvent);

        // Fade the control in
        (_display displayCtrl 200) call FUNC(fadeControl);
    }, _display] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

/*
 * NEW SQUAD DESIGNATOR
 */
// This should update on side change and when a new squad is created
["playerSideChanged", {
    (_this select 0) params ["_newSide", "_oldSide"];
    [UIVAR(RespawnScreen_NewSquadDesignator_update), _oldSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

["groupChanged", {
    [UIVAR(RespawnScreen_NewSquadDesignator_update), playerSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_NewSquadDesignator_update), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    (_display displayCtrl 203) ctrlSetText ((call EFUNC(Squad,getNextSquadId)) select [0, 1]);
}] call CFUNC(addEventHandler);

// Create Squad Description Limit
[UIVAR(RespawnScreen_SquadDescriptionInput_TextChanged), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 204;
    private _description = ctrlText _control;

    if (count _description > 14) then {
        _control ctrlSetBackgroundColor [0.77, 0.51, 0.08, 1];
        _control ctrlCommit 0;
        [{
            params ["_control"];

            _control ctrlSetBackgroundColor [0.4, 0.4, 0.4, 1];
            _control ctrlCommit 0;
        }, 1, _control] call CFUNC(wait);

        _control ctrlSetText (_description select [0, 14]);
    };
}] call CFUNC(addEventHandler);

/*
 * SQUAD TYPE COMBO
 */
// This should update on side change and when a new squad is created
["playerSideChanged", {
    (_this select 0) params ["_newSide", "_oldSide"];
    [UIVAR(RespawnScreen_SquadTypeCombo_update), _oldSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

["groupChanged", {
    [UIVAR(RespawnScreen_SquadTypeCombo_update), playerSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_SquadTypeCombo_update), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    // SquadTypeCombo
    // TODO restore focus if necessary #224
    private _control = _display displayCtrl 205;
    private _selectedGroupType = _control lbData (lbCurSel _control);
    lbClear _control;

    private _visibleGroupTypes = [];
    {
        private _groupTypeName = _x;
        if ([_groupTypeName] call EFUNC(Squad,canUseSquadType)) then {
            private _rowNumber = _control lbAdd ([format [QUOTE(PREFIX/CfgGroupTypes/%1/displayName), _groupTypeName], ""] call CFUNC(getSetting));
            _control lbSetData [_rowNumber, _groupTypeName];
            _visibleGroupTypes pushBack _groupTypeName;

            if (_groupTypeName == _selectedGroupType) then {
                _control lbSetCurSel _rowNumber;
            };
        };
        nil
    } count ([QUOTE(PREFIX/CfgGroupTypes/activeGroupTypes), []] call CFUNC(getSetting));
    if (lbSize 205 == 0) then {
        _control lbSetCurSel -1;
    } else {
        if (_selectedGroupType == "" || !(_selectedGroupType in _visibleGroupTypes)) then {
            _control lbSetCurSel 0;
        };
    };
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_CreateSquadBtn_onButtonClick), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 204;
    private _description = ctrlText _control;
    if (count _description > 14) then {
        _description = _description select [0, 14];
    };

    _control = _display displayCtrl 205;
    private _type = _control lbData (lbCurSel _control);

    [_description, _type] call EFUNC(Squad,createSquad);
}] call CFUNC(addEventHandler);

/*
 * SQUAD LIST
 */
// When the group changes update the squad list for new squad member count
// This needs to be global cause it triggers on side change too
["playerSideChanged", {
    (_this select 0) params ["_newSIde", "_oldSide"];
    [UIVAR(RespawnScreen_SquadManagement_update), _oldSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

["groupChanged", {
    [UIVAR(RespawnScreen_SquadManagement_update), playerSide] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_SquadManagement_update), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _ownGroupIndex = -1;

    private _control = _display displayCtrl 207;

    private _selectedSquad = [_control, [lnbCurSelRow _control, 0]] call CFUNC(lnbLoad);

    if (!(_selectedSquad isEqualType grpNull)) then {
        _selectedSquad = group CLib_player;
    };

    // Prepare the data for the lnb
    private _lnbData = [];
    {
        private _groupId = groupId _x;
        if (_x == group CLib_Player) then {
            _ownGroupIndex = _forEachIndex;
        };

        private _squadDesignator = _groupId select [0, 1];
        private _description = _x getVariable [QEGVAR(Squad,Description), str _x];
        private _groupType = _x getVariable [QEGVAR(Squad,Type), ""];
        private _groupTypeName = [format [QUOTE(PREFIX/CfgGroupTypes/%1/displayName), _groupType], ""] call CFUNC(getSetting);
        private _groupSize = [format [QUOTE(PREFIX/CfgGroupTypes/%1/groupSize), _groupType], 0] call CFUNC(getSetting);

        if (_description == "") then {
            _description = _groupId;
        };

        _lnbData pushBack [[_squadDesignator, _description, _groupTypeName, format ["%1 / %2", count ([_x] call CFUNC(groupPlayers)), _groupSize]], _x];
    } forEach (allGroups select {side _x == playerSide && groupId _x in EGVAR(Squad,squadIds) && count units _x > 0});

    // Update the lnb

    [_control, _lnbData, _selectedSquad] call FUNC(updateListNBox); // This may trigger an lbSelChanged event

    for "_i" from 0 to 3 do {
        _control lnbSetColor [[_ownGroupIndex, _i], [0.77, 0.51, 0.08, 1]];
    };
}] call CFUNC(addEventHandler);

/*
 * SQUAD MEMBER LIST
 */
[QGVAR(KitChanged), {
    [UIVAR(RespawnScreen_SquadMemberManagement_update), group CLib_Player] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_SquadList_onLBSelChanged), {
    UIVAR(RespawnScreen_SquadMemberManagement_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

["groupChanged", {
    [UIVAR(RespawnScreen_SquadMemberManagement_update), _this select 0] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

// SquadManagement
[UIVAR(RespawnScreen_SquadMemberManagement_update), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the controls
    private _controlSquadList = _display displayCtrl 207;
    private _controlSquadMemberListHeader = _display displayCtrl 209;
    private _controlSquadMemberList = _display displayCtrl 210;
    private _controlJoinLeaveButton = _display displayCtrl 211;

    // Get the selected value
    private _selectedEntry = lnbCurSelRow _controlSquadList;
    if (_selectedEntry == -1) exitWith {
        _controlSquadMemberListHeader ctrlSetText "SELECT A SQUAD";
        lnbClear _controlSquadMemberList;
        _controlSquadMemberList lnbSetCurSelRow -1;
        _controlJoinLeaveButton ctrlShow false;
    };
    private _selectedSquad = [_controlSquadList, [_selectedEntry, 0]] call CFUNC(lnbLoad);

    // HeadingSquadDetails
    _controlSquadMemberListHeader ctrlSetText toUpper (groupId _selectedSquad);

    // SquadMemberList
    private _lnbData = ([_selectedSquad] call CFUNC(groupPlayers)) apply {
        private _selectedKit = _x getVariable [QEGVAR(Kit,kit), ""];
        private _kitIcon = ([_selectedKit, side group _x, [["UIIcon", "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa"]]] call EFUNC(Kit,getKitDetails)) select 0;

        [[[_x] call CFUNC(name)], _x, _kitIcon]
    };
    [_controlSquadMemberList, _lnbData] call FUNC(updateListNBox); // This may trigger an lbSelChanged event

    // JoinLeaveBtn
    if (_selectedSquad == group CLib_Player) then {
        _controlJoinLeaveButton ctrlSetText "LEAVE";
        _controlJoinLeaveButton ctrlShow true;
    } else {
        private _groupType = _selectedSquad getVariable [QEGVAR(Squad,Type), ""];
        private _groupSize = [format [QUOTE(PREFIX/CfgGroupTypes/%1/groupSize), _groupType], 0] call CFUNC(getSetting);

        _controlJoinLeaveButton ctrlSetText "JOIN";
        _controlJoinLeaveButton ctrlShow ((count ([_selectedSquad] call CFUNC(groupPlayers))) < _groupSize);
    };
}] call CFUNC(addEventHandler);

/*
 * SQUAD MEMBER BUTTONS
 */
[UIVAR(RespawnScreen_SquadMemberList_onLBSelChanged), {
    UIVAR(RespawnScreen_SquadMemberButtons_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

["leaderChanged", {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the selected value
    private _control = _display displayCtrl 207;
    private _selectedEntry = lnbCurSelRow _control;
    if (_selectedEntry == -1) exitWith {};
    private _selectedSquad = [_control, [_selectedEntry, 0]] call CFUNC(lnbLoad);

    if (_selectedSquad == group CLib_Player) then {
        UIVAR(RespawnScreen_SquadMemberButtons_update) call CFUNC(localEvent);
    };
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_SquadMemberButtons_update), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the controls
    private _controlSquadMemberList = _display displayCtrl 210;
    private _controlKickButton = _display displayCtrl 212;
    private _controlPromoteButton = _display displayCtrl 213;

    // Get the selected value
    private _selectedEntry = lnbCurSelRow _controlSquadMemberList;
    if (_selectedEntry == -1) exitWith {
        _controlKickButton ctrlShow false;
        _controlPromoteButton ctrlShow false;
    };
    private _selectedGroupMember = [_controlSquadMemberList, [_selectedEntry, 0]] call CFUNC(lnbLoad);

    // KickBtn
    private _buttonsVisible = (CLib_Player == leader _selectedGroupMember && CLib_Player != _selectedGroupMember);
    _controlKickButton ctrlShow _buttonsVisible;

    // PromoteBtn
    _controlPromoteButton ctrlShow _buttonsVisible;
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_JoinLeaveBtn_onButtonClick), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 207;
    private _selectedGroup = [_control, [lnbCurSelRow _control, 0]] call CFUNC(lnbLoad);

    if (_selectedGroup == group CLib_Player) then {
        call EFUNC(Squad,leaveSquad);
    } else {
        [_selectedGroup] call EFUNC(Squad,joinSquad);
    };
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_KickBtn_onButtonClick), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 210;
    private _selectedGroupMember = [_control, [lnbCurSelRow _control, 0]] call CFUNC(lnbLoad);

    [_selectedGroupMember] call EFUNC(Squad,kickMember);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_PromoteBtn_onButtonClick), {
    private _display = uiNamespace getVariable [QGVAR(squadDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 210;
    private _selectedGroupMember = [_control, [lnbCurSelRow _control, 0]] call CFUNC(lnbLoad);

    [_selectedGroupMember] call EFUNC(Squad,promoteMember);
}] call CFUNC(addEventHandler);
