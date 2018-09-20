#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Builds the "RESOURCE REQUEST" Display

    Parameter(s):
    None

    Returns:
    None
*/
params ["_target"];

private _display = (findDisplay 46) createDisplay "RscDisplayEmpty";

_display setVariable [QGVAR(target), _target];

CGVAR(Interaction_DisablePrevAction) = true;
CGVAR(Interaction_DisableNextAction) = true;
CGVAR(Interaction_DisableAction) = true;

GVAR(LastPlayerPosition) = getPos CLib_player;

_display displayAddEventHandler ["KeyDown",  {
    params ["_display", "_dikCode", "_shift", "_ctrl", "_alt"];
    private _handled = false;
    if (_dikCode == 1 || GVAR(LastPlayerPosition) distance CLib_player > 0.5) then {
        _display closeDisplay 1;
        _handled = true;
    };

    _handled;
}];

_display displayAddEventHandler ["Unload",  {
    params ["_display", "_exitCode"];
    GVAR(ppColor) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.7, 0.2, 0.1, 0.0]];
    GVAR(ppColor) ppEffectCommit 0.3;
    GVAR(ppBlur) ppEffectAdjust [0];
    GVAR(ppBlur) ppEffectCommit 0.3;

    CGVAR(Interaction_DisablePrevAction) = false;
    CGVAR(Interaction_DisableNextAction) = false;
    CGVAR(Interaction_DisableAction) = false;

    private _eventId = _display getVariable [QGVAR(resourceChangedEventHandler), -1];
    if (_eventId != -1) then {
        ["supplyPointsChanged", _eventId] call CFUNC(removeEventHandler);
    };
}];

GVAR(ppColor) ppEffectEnable true;
GVAR(ppColor) ppEffectAdjust [0.7, 0.7, 0.1, [0, 0, 0, 0], [1, 1, 1, 1], [0.7, 0.2, 0.1, 0.0]];
GVAR(ppColor) ppEffectCommit 0.2;

GVAR(ppBlur) ppEffectAdjust [8];
GVAR(ppBlur) ppEffectEnable true;
GVAR(ppBlur) ppEffectCommit 0.2;

private _headerBg = _display ctrlCreate ["RscText", -1];
_headerBg ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW, PY(15.5)];
_headerBg ctrlSetBackgroundColor [0.5,0.5,0.5,0.3];
_headerBg ctrlCommit 0;

private _globalGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_globalGroup ctrlSetPosition [0.5-PX(60), safeZoneY, safeZoneW, safeZoneH];
_globalGroup ctrlCommit 0;


private _title = _display ctrlCreate ["RscTitle", -1, _globalGroup];
_title ctrlSetFontHeight PY(3.2);
_title ctrlSetFont "RobotoCondensedBold";
_title ctrlSetPosition [0, PY(10.5), PX(60), PY(4)];
_title ctrlSetText "BUILD";
_title ctrlCommit 0;

private _resourcePicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _globalGroup];
_resourcePicture ctrlSetPosition [PX(109), PY(10.5), PX(4), PY(4)];
_resourcePicture ctrlSetText "\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa";
_resourcePicture ctrlCommit 0;

private _resourcePoints = _display ctrlCreate ["RscTitle", -1, _globalGroup];
_resourcePoints ctrlSetFontHeight PY(3.2);
_resourcePoints ctrlSetFont "RobotoCondensedBold";
_resourcePoints ctrlSetPosition [PX(114), PY(10.5), PX(6), PY(4)];
_resourcePoints ctrlSetText "---";
_resourcePoints ctrlCommit 0;

private _contentGroup = _display ctrlCreate ["RscControlsGroupNoHScrollbars", -1, _globalGroup];
_contentGroup ctrlSetPosition [0, PY(20), safeZoneW, safeZoneH - PY(40)];
_contentGroup ctrlCommit 0;

private _resourceChangedEventHandler = ["supplyPointsChanged", {(_this select 1) call FUNC(updateResourcesDisplay);} ,[_display, _contentGroup, _resourcePoints]] call CFUNC(addEventHandler);
_display setVariable [QGVAR(resourceChangedEventHandler), _resourceChangedEventHandler];

[_display, _contentGroup, _resourcePoints] call FUNC(updateResourcesDisplay);
