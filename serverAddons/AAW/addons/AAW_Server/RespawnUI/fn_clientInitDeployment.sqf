#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Initializes the deployment part of the respawn screen.

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

GVAR(lastDeploymentPoint) = "";
GVAR(selectedDeploymentPoint) = "";
GVAR(firstRespawn) = true;

[UIVAR(DeploymentScreen_onLoad), {
    (_this select 0) params ["_display"];
    uiNamespace setVariable [QGVAR(deploymentDisplay), _display];

    GVAR(lastSelectedPoint) = "";

    // The dialog needs one frame until access to controls is possible
    [{
        params ["_display"];

        // Update the deploy button
        UIVAR(RespawnScreen_DeploymentButton_update) call CFUNC(localEvent);

        // Update the values of the UI elements
        UIVAR(RespawnScreen_DeploymentManagement_update) call CFUNC(localEvent);

        [QEGVAR(Common,DeploymentPointSelected), GVAR(lastDeploymentPoint)] call CFUNC(localEvent);

        // Fade the control in
        (_display displayCtrl 400) call FUNC(fadeControl);
    }, _display] call CFUNC(execNextFrame);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_DeploymentButton_update), {
    private _display = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _control = _display displayCtrl 404;

    // Calculate the respawn timer if necessary
    if (!(alive CLib_Player) || (CLib_Player getVariable [QEGVAR(Common,tempUnit), false])) then {
        // Disable the button and start the timer
        _control ctrlEnable false;
        private _minRespawnTime = time;

        if (GVAR(firstRespawn)) then {
            _minRespawnTime = _minRespawnTime + (EGVAR(Common,missionStartTime) - (daytime * 60 * 60));
        } else {
            if (EGVAR(Revive,UnconsciousSince) > -1) then {
                _minRespawnTime = EGVAR(Revive,UnconsciousSince);
                EGVAR(Revive,UnconsciousSince) = -1;
            };

            _minRespawnTime = _minRespawnTime + ([QUOTE(PREFIX/CfgRespawn/respawnCountdown), 0] call CFUNC(getSetting));
        };

        [{
            params ["_params", "_id"];
            _params params ["_control", "_respawnTime"];

            // If the display has closed exit the PFH
            if (isNull GVAR(deploymentDisplay)) exitWith {
                _id call CFUNC(removePerFrameHandler);
            };

            // If the timer is up enabled deploying
            if (time >= _respawnTime) exitWith {
                GVAR(firstRespawn) = false;
                _control ctrlSetText "DEPLOY";
                _control ctrlEnable true;

                _id call CFUNC(removePerFrameHandler);
            };

            // Update the text on the button
            private _time = _respawnTime - time;
            _control ctrlSetText format ["%1 s", _time toFixed 1];
        }, 0.05, [_control, _minRespawnTime]] call CFUNC(addPerFrameHandler);
    } else {
        _control ctrlSetText "Close";
    };
}] call CFUNC(addEventHandler);

// Handle the deploy button
[UIVAR(RespawnScreen_DeployButton_action), {
    private _deploymentDisplay = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    private _roleDisplay = uiNamespace getVariable [QGVAR(roleDisplay), displayNull];
    if (isNull _deploymentDisplay || isNull _roleDisplay) exitWith {};

    if (alive CLib_Player && !(CLib_Player getVariable [QEGVAR(Common,tempUnit), false])) exitWith {
        _deploymentDisplay closeDisplay 1;
    };

    // We use the mutex to prevent race conditions
    [{
        params ["_deploymentDisplay", "_roleDisplay"];

        // Check squad
        if (!((groupId group CLib_Player) in EGVAR(Squad,squadIds))) exitWith {
            [MLOC(JoinASquad)] call EFUNC(Common,displayHint);
        };

        // Check kit
        private _currentRoleSelection = lnbCurSelRow (_roleDisplay displayCtrl 303);
        if (_currentRoleSelection < 0) exitWith {
            [MLOC(ChooseARole)] call EFUNC(Common,displayHint);
        };

        // Check deployment
        private _controlDeploymentList = _deploymentDisplay displayCtrl 403;
        private _currentDeploymentPointSelection = lnbCurSelRow _controlDeploymentList;
        if (_currentDeploymentPointSelection < 0) exitWith {
            [MLOC(selectSpawn)] call EFUNC(Common,displayHint);
        };

        // Get position
        _currentDeploymentPointSelection = [_controlDeploymentList, [_currentDeploymentPointSelection, 0]] call CFUNC(lnbLoad);

        if !(_currentDeploymentPointSelection call EFUNC(Common,isValidDeploymentPoint)) exitWith {
            ["Respawn Point Don't Exist anymore"] call EFUNC(Common,displayHint);
        };

        private _spawnTime = [_currentDeploymentPointSelection, "spawnTime", 0] call EFUNC(Common,getDeploymentPointData);
        if ([_currentDeploymentPointSelection, "spawnPointLocked", 0] call EFUNC(Common,getDeploymentPointData) == 1) exitWith {
            ["RESPAWN POINT LOCKED!", ["Unlocked in %1 sec.", round (_spawnTime - serverTime)]] call EFUNC(Common,displayHint);
        };

        if ([_currentDeploymentPointSelection, "spawnPointBlocked", 0] call EFUNC(Common,getDeploymentPointData) == 1) exitWith {
            ["RESPAWN POINT BLOCKED!", "Too many enemies nearby!"] call EFUNC(Common,displayHint);
        };

        if ([_currentDeploymentPointSelection, "counterActive", 0] call EFUNC(Common,getDeploymentPointData) == 1) then {
            ["RESPAWN POINT BLOCKED!", "The enemy has placed a bomb!"] call EFUNC(Common,displayHint);
        };

        private _deployPosition = [_currentDeploymentPointSelection] call EFUNC(Common,prepareSpawn);
        GVAR(lastDeploymentPoint) = _currentDeploymentPointSelection;
        _deploymentDisplay closeDisplay 1;

        [{
            params ["_deployPosition"];

            // Spawn
            [AGLToASL ([_deployPosition, 5, 0, typeOf CLib_Player] call CFUNC(findSavePosition))] call EFUNC(Common,respawn);

            [{
                // Fix issue that player spawn Prone
                ["switchMove", [CLib_Player, ""]] call CFUNC(globalEvent);

                // Apply selected kit
                [CLib_Player, CLib_Player getVariable [QEGVAR(Kit,kit), ""]] call EFUNC(Kit,applyKit);
            }] call CFUNC(execNextFrame);
        }, [_deployPosition]] call CFUNC(execNextFrame);
    }, [_deploymentDisplay, _roleDisplay], "respawn"] call CFUNC(mutex);
}] call CFUNC(addEventHandler);

// When the group changes the rally might change too so update the list
["groupChanged", {
    UIVAR(RespawnScreen_DeploymentManagement_update) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[QEGVAR(Common,deploymentPointAdded), {
    [UIVAR(RespawnScreen_DeploymentManagement_update), group CLib_Player] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);
[QEGVAR(Common,deploymentPointRemoved), {
    [UIVAR(RespawnScreen_DeploymentManagement_update), group CLib_Player] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);
[QEGVAR(Common,ticketsChanged), {
    [UIVAR(RespawnScreen_DeploymentManagement_update), group CLib_Player] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);
["DeploymentPointDataChanged", {
    [UIVAR(RespawnScreen_DeploymentManagement_update), group CLib_Player] call CFUNC(targetEvent);
}] call CFUNC(addEventHandler);

// This EH updates the deployment list
[UIVAR(RespawnScreen_DeploymentManagement_update), {
    private _display = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Prepare the data for the lnb
    private _lnbData = [];
    {
        private _pointDetails = [_x, ["name", "spawntickets", "icon", "type"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params ["_name", "_tickets", "_icon", "_type"];
        private _color = [1, 1, 1, 1];

        if ([_x, "spawnPointLocked", 0] call EFUNC(Common,getDeploymentPointData) == 1) then {
            _color = [0.3, 0.3, 0.3, 1];
        };

        if ([_x, "spawnPointBlocked", 0] call EFUNC(Common,getDeploymentPointData) == 1) then {
            _color = [0.6, 0, 0, 1];
        };

        if ([_x, "counterActive", 0] call EFUNC(Common,getDeploymentPointData) == 1) then {
            _color = [0.6, 0, 0, 1];
        };

        if (_tickets > 0) then {
            _name = format ["%1 (%2)", _name, _tickets];
        };

        _lnbData pushBack [[_name], _x, _icon, _color];
        nil
    } count ([CLib_Player] call EFUNC(Common,getAvailableDeploymentPoints)); // TODO use current position if deployment is deactivated

    // Update the lnb
    [_display displayCtrl 403, _lnbData] call FUNC(updateListNBox); // This may trigger an lbSelChanged event
}] call CFUNC(addEventHandler);

// When the selected entry changed animate the map
[UIVAR(RespawnScreen_SpawnPointList_onLBSelChanged), {
    private _display = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    private _control = _display displayCtrl 403;
    GVAR(selectedDeploymentPoint) = [_control, [lnbCurSelRow _control, 0]] call CFUNC(lnbLoad);
    UIVAR(RespawnScreen_DeploymentManagement_animateMap) call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[UIVAR(RespawnScreen_DeploymentManagement_animateMap), {
    private _display = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    if (isNull _display) exitWith {};

    // Get the selected value
    private _control = _display displayCtrl 403;
    private _selectedEntry = lnbCurSelRow _control;
    if (_selectedEntry == -1) exitWith {};
    private _selectedPoint = [_control, [_selectedEntry, 0]] call CFUNC(lnbLoad);
    if (_selectedPoint == GVAR(lastSelectedPoint)) exitWith {};
    GVAR(lastSelectedPoint) = _selectedPoint;

    // Get the point data
    private _position = [_selectedPoint, "position"] call EFUNC(Common,getDeploymentPointData);

    // Animate the map
    private _controlMap = _display displayCtrl 800;
    private _scale = ctrlMapScale _controlMap;
    _controlMap ctrlMapAnimAdd [0.2, _scale, _position]; // Dialog syntax can not be used
    ctrlMapAnimCommit _controlMap;
}] call CFUNC(addEventHandler);

[QEGVAR(Common,DeploymentPointSelected), {
    private _display = uiNamespace getVariable [QGVAR(deploymentDisplay), displayNull];
    if (isNull _display) exitWith {};

    private _deploymentPointId = _this select 0;
    private _control = _display displayCtrl 403;
    private _size = lnbSize _control;
    for "_idx" from 0 to ((_size select 0) - 1) do {
        private _data = [_control, [_idx, 0]] call CFUNC(lnbLoad);
        if (toLower _data == toLower _deploymentPointId && _idx != lnbCurSelRow _control) exitWith {
            _control lnbSetCurSelRow _idx;
            _control ctrlCommit 0;

        }
    };

}] call CFUNC(addEventHandler);
