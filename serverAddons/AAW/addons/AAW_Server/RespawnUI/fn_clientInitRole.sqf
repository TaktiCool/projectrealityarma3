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

// ["missionStarted", {
//    ["Role Screen", CLib_Player, 0, {isNull (uiNamespace getVariable [QGVAR(roleDisplay), displayNull])}, {
//        (findDisplay 46) createDisplay UIVAR(RoleScreen);
//    }] call CFUNC(addAction);
// }] call CFUNC(addEventHandler);

[UIVAR(RoleScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(roleDisplay), _display];

    // The dialog needs one frame until access to controls is possible
    [{
        params ["_display"];

        // Update the values of the UI elements
        UIVAR(RespawnScreen_RoleManagement_update) call CFUNC(localEvent);

        // Fade the control in
        (_display displayCtrl 300) call FUNC(fadeControl);
    }, _display] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

// When player changes the group update the role management for his old and his new group
["groupChanged", {
    [UIVAR(RespawnScreen_RoleManagement_update), _this select 0] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

["leaderChanged", {
    [UIVAR(RespawnScreen_RoleManagement_update)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_RoleManagement_update), {
    private _display = uiNamespace getVariable [QGVAR(roleDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _side = side group CLib_Player;
    private _selectedKit = CLib_Player getVariable [QEGVAR(Kit,kit), ""];

    // Check if selected kit is still available
    private _usableKitCount = [CLib_Player, _selectedKit] call EFUNC(Kit,getUsableKitCount);
    if (_usableKitCount <= 0) then {
        _selectedKit = "";
    };

    // Prepare the data for the lnb
    private _lnbData = [];
    {
        private _kitName = _x;

        // Only list usable kits
        private _usableKitCount = [CLib_Player, _kitName] call EFUNC(Kit,getUsableKitCount);

        if (!isNil "_usableKitCount") then {
            // Get the required details
            private _kitDetails = [_kitName, _side, [["displayName", ""], ["UIIcon", ""]]] call EFUNC(Kit,getKitDetails);
            _kitDetails params ["_displayName", "_UIIcon"];

            private _usedKits = {_x getVariable [QEGVAR(Kit,kit), ""] == _kitName} count ([group CLib_Player] call CFUNC(groupPlayers));
            private _color = [1, 1, 1, 1];
            private _numberKitsString = format ["%1 / %2", _usedKits, _usedKits + _usableKitCount - ([0, 1] select (_selectedKit == _kitName))];

            if (_usableKitCount <= 0) then {
                _color = [0.3, 0.3, 0.3, 1];
            };
            _lnbData pushBack [[_displayName, _numberKitsString], _kitName, _UIIcon, _color];
        };
        nil
    } count ([_side] call EFUNC(Kit,getAllKits));

    // Update the lnb
    [_display displayCtrl 303, _lnbData, _selectedKit] call FUNC(updateListNBox); // This may trigger an lbSelChanged event
}] call CFUNC(addEventHandler);

// When the selected entry changed update the weapon tab content
[UIVAR(RespawnScreen_RoleList_onLBSelChanged), {
    private _display = uiNamespace getVariable [QGVAR(roleDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the selected value
    private _control = _display displayCtrl 303;
    private _selectedEntry = lnbCurSelRow _control;
    if (_selectedEntry == -1) exitWith {};

    private _previousSelectedKit = CLib_Player getVariable [QEGVAR(Kit,kit), ""];
    private _selectedKit = [_control, [_selectedEntry, 0]] call CFUNC(lnbLoad);

    private _usableKitCount = [CLib_Player, _selectedKit] call EFUNC(Kit,getUsableKitCount);
    if (isNil "_usableKitCount") exitWith {};
    _usableKitCount params ["_availableKitCount", "_usedKitsFromGroup"];
    if (_usableKitCount <= 0) exitWith {
        [UIVAR(RespawnScreen_RoleManagement_update)] call CFUNC(localEvent);
    };

    // Instantly assign the kit (do not apply) if changed
    if (_previousSelectedKit != _selectedKit) then {
        CLib_Player setVariable [QEGVAR(Kit,kit), _selectedKit, true];
        [UIVAR(RespawnScreen_RoleManagement_update), group CLib_Player] call CFUNC(targetEvent);
        [QGVAR(KitChanged)] call CFUNC(localEvent);
    };
    UIVAR(RespawnScreen_WeaponTabs_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

// When the selected tab changed update the weapon tab content
[UIVAR(RespawnScreen_WeaponTabs_onToolBoxSelChanged), {
    UIVAR(RespawnScreen_WeaponTabs_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_WeaponTabs_update), {
    private _display = uiNamespace getVariable [QGVAR(roleDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the selected value
    private _control = _display displayCtrl 303;
    private _selectedEntry = lnbCurSelRow _control;
    if (_selectedEntry == -1) exitWith {};
    private _selectedKit = [_control, [_selectedEntry, 0]] call CFUNC(lnbLoad);

    // Get the kit data
    private _selectedTabIndex = lbCurSel (_display displayCtrl 304);
    private _selectedKitDetails = [_selectedKit, side group CLib_Player, [[["primaryWeapon", "handGunWeapon", "secondaryWeapon"] select _selectedTabIndex, ""]]] call EFUNC(Kit,getKitDetails);

    // WeaponPicture
    (_display displayCtrl 306) ctrlSetText (getText (configFile >> "CfgWeapons" >> _selectedKitDetails select 0 >> "picture"));

    // WeaponName
    (_display displayCtrl 307) ctrlSetText (getText (configFile >> "CfgWeapons" >> _selectedKitDetails select 0 >> "displayName"));
}] call CFUNC(addEventHandler);
