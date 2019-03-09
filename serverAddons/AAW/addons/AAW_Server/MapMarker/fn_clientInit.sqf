#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Map Marker

    Parameter(s):
    None

    Returns:
    None
*/

["", "list", ["Marker", [{
    params ["_contextMenuGrp"];
    private _mapControl = _contextMenuGrp getVariable ["mapControl", controlNull];
    [_mapControl, QUOTE(MODULE)] call EFUNC(MapInteractions,openContextMenu);
    false;
},[]]]] call EFUNC(MapInteractions,addMenuEntry);

GVAR(persistance) = [CFGMARKER + "/persistance", 300] call CFUNC(getSetting);
GVAR(blendoutTime) = [CFGMARKER + "/blendoutTime", 60] call CFUNC(getSetting);

[QUOTE(MODULE), "header", ["Marker"]] call EFUNC(MapInteractions,addMenuEntry);

{
    private _categorySetting = CFGMARKER+"/"+_x;
    {
        private _markerSetting = _categorySetting + "/" + _x;
        private _icons = +([_markerSetting + "/icons", []] call CFUNC(getSetting));
        {
            _x set [1, 0.6*(_x select 1)];
            true;
        } count _icons;
        [QUOTE(MODULE), "imageStackButton", [_icons, [{
            params ["_currentCtxMenu", "_attributes"];
            _attributes params ["_type"];
            private _mapMarkerPosition = EGVAR(MapInteractions,CurrentContextPosition);
            if (_mapMarkerPosition isEqualTo []) exitWith {};
            ["createMarker", [_type, _mapMarkerPosition, CLib_player, serverTime]] call CFUNC(serverEvent);
            true;
        },[_markerSetting]]]] call EFUNC(MapInteractions,addMenuEntry);
        true;
    } count ([_categorySetting] call CFUNC(getSettingSubClasses));
    true;
} count ([CFGMARKER] call CFUNC(getSettingSubClasses));

["markerUpdated", {
    [] call FUNC(updateMarker);
}] call CFUNC(addEventhandler);

[QEGVAR(MapInteractions,MouseButtonDblClick), {
    (_this select 0) params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    GVAR(timeout) = time + 2;

    [{}, {
        private _nbrClosed = {
            if (ctrlIDD _x == 54 && !isNull _x) then {
                _x closeDisplay 0;
                true;
            } else {
                false;
            };
        } count (uiNamespace getVariable "GUI_displays");
        _nbrClosed > 0 || GVAR(timeout) < time;
    }] call CFUNC(waitUntil);

    if (_button == 0) then {
        EGVAR(MapInteractions,CurrentContextPosition) = _control ctrlMapScreenToWorld [_xPos, _yPos];
        [
            QEGVAR(MapInteractions,CursorMarker),
            [
                ["ICON", "a3\ui_f\data\map\mapcontrol\waypointeditor_ca.paa", [0, 0, 0, 0.7], EGVAR(MapInteractions,CurrentContextPosition), 22, 22],
                ["ICON", "a3\ui_f\data\map\mapcontrol\waypointeditor_ca.paa", [1, 1, 1, 1], EGVAR(MapInteractions,CurrentContextPosition), 20, 20]
            ]
        ] call CFUNC(addMapGraphicsGroup);

        [_control, QUOTE(MODULE), _xPos, _yPos] call EFUNC(MapInteractions,openContextMenu);

    };
}] call CFUNC(addEventhandler);
