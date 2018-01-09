#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, NetFusion

    Description:
    Init for deployment system

    Parameter(s):
    None

    Returns:
    None
*/
["groupChanged", {
    [QGVAR(updateMapIcons)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[QGVAR(deploymentPointAdded), {
    [QGVAR(updateMapIcons)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[QGVAR(deploymentPointRemoved), {
    [QGVAR(updateMapIcons)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

[QGVAR(ticketsChanged), {
    [QGVAR(updateMapIcons)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

["DeploymentPointDataChanged", {
    [QGVAR(updateMapIcons)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

GVAR(pointMarkerIds) = [];
[QGVAR(updateMapIcons), {
    private _availablePoints = [side group CLib_Player] call FUNC(getDeploymentPointsPerSide);
    private _existingMapIconPoints = GVAR(pointMarkerIds) arrayIntersect _availablePoints;

    private _sideColor = +(missionNamespace getVariable format [QMGVAR(SideColor_%1), playerSide]);

    {
        [_x] call CFUNC(removeMapGraphicsGroup);
        [_x] call CFUNC(removeMapGraphicsEventHandler);
        nil
    } count (GVAR(pointMarkerIds) - _existingMapIconPoints);

    {
        private _pointData = [_x, ["name", "type", "position", "availableFor", "spawnTickets", "icon", "mapIcon"]] call FUNC(getDeploymentPointData);
        _pointData params ["_name", "", "_position", "_availableFor", "_spawnTickets", "", "_mapIcon"];

        if (_mapIcon != "") then {
            private _color = _sideColor;
            private _bgIcon = ["ICON", "A3\ui_f\data\igui\cfg\holdactions\progress\progress_0_ca.paa", [1, 1, 1, 1], _position, 30, 30];
            private _bgIconHover = ["ICON", "A3\ui_f\data\igui\cfg\holdactions\progress\progress_0_ca.paa", [1, 1, 1, 1], _position, 30, 30];
            if ((_availableFor isEqualType playerSide && {playerSide == _availableFor}) || (_availableFor isEqualType grpNull && {group CLib_Player == _availableFor})) then {
                _color = [[0.13, 0.54, 0.21, 1], [0, 0.4, 0.8, 1]] select (_availableFor isEqualType playerSide && {playerSide == _availableFor});

                if ([_x, "spawnPointLocked", 0] call FUNC(getDeploymentPointData) == 1) then {
                    _color = [0.5, 0.5, 0.5, 1];
                };

                if ([_x, "spawnPointBlocked", 0] call FUNC(getDeploymentPointData) == 1) then {
                    _color = [0.6, 0, 0, 1];
                };

                if ([_x, "counterActive", 0] call FUNC(getDeploymentPointData) == 1) then {
                    _color = [0.6, 0, 0, 1];
                };

                _bgIcon = ["ICON", "A3\ui_f\data\map\respawn\respawn_background_ca.paa", _color, _position, 35, 35];
                _bgIconHover = ["ICON", "A3\ui_f\data\map\respawn\respawn_backgroundhover_ca.paa", _color, _position, 35, 35];
            };
            private _selectedIcon = ["ICON", "A3\ui_f\data\map\groupicons\selector_selectedmission_ca.paa", [1,1,1,0], _position, 40, 40, 0, "", 0, 0.08, "RobotoCondensedBold", "center", {
                if (_groupId isEqualTo EGVAR(RespawnUI,selectedDeploymentPoint)) then {
                    _color = [1,1,1,1];
                };
            }];
            private _icon = ["ICON", _mapIcon, [1,1,1,1], _position, 25, 25];
            private _normalText = ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], [_position,[0,27]], 25, 25, 0, format ["%1", _name], 2, 0.08, "RobotoCondensedBold", "center"];
            [_x, [_bgIcon, _icon, _normalText, _selectedIcon], "normal", 2000] call CFUNC(addMapGraphicsGroup);
            private _onHoverText = ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], [_position, [0,27]], 25, 25, 0, format [MLOC(SpawnsRemaining), _name, _spawnTickets], 2, 0.08, "RobotoCondensedBold", "center"];
            if (_spawnTickets <= 0) then {
                _onHoverText = _normalText;
            };


            [_x, [_bgIconHover, _icon, _onHoverText, _selectedIcon], "hover", 2000] call CFUNC(addMapGraphicsGroup);

            [
                _x,
                "clicked",
                {
                    (_this select 1) params ["_deploymentPointId"];

                    [QGVAR(DeploymentPointSelected), _deploymentPointId] call CFUNC(localEvent);

                },
                _x
            ] call CFUNC(addMapGraphicsEventHandler);


        };

        nil
    } count _availablePoints;

    GVAR(pointMarkerIds) = _availablePoints;
}] call CFUNC(addEventHandler);
