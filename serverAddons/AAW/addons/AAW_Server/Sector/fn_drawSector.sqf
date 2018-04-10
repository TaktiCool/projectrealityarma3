#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Draws a sector marker

    Parameter(s):
    0: SectorId <String> or Sector <Logic>

    Returns:
    None
*/

params ["_sector"];

private _marker = _sector getVariable ["marker", ""];
private _designator = _sector getVariable ["designator", ""];
private _fullname = _sector getVariable ["fullname", ""];
private _side = _sector getVariable ["side", sideUnknown];
private _position = getMarkerPos _marker;

if (isServer) then {
    if (_marker != "") then {
        _marker setMarkerColor format ["Color%1", _side];
        _marker setMarkerAlpha 0;
    };
};

if (hasInterface) then {
    private _friendlySide = side group CLib_player;

    if (CLib_Player call EFUNC(Common,isSpectator)) then {
        _friendlySide = EGVAR(Common,competingSides) select 0;
    };

    private _color = [
        [0.6, 0, 0, 0.6],
        [0, 0.4, 0.8, 0.6]
    ] select (_side isEqualTo _friendlySide);

    if (_side isEqualTo sideUnknown) then {
        _color = [0.93, 0.7, 0.01, 0.6];
    };

    private _designatorIconPath = "";
    private _designatorSize = 18;
    if (toLower _designator == "hq") then {
        _designatorIconPath = "A3\ui_f\data\gui\cfg\ranks\colonel_gs.paa";
        _designatorSize = 20;
    } else {
        _designatorIconPath = format ["A3\ui_f\data\igui\cfg\simpletasks\letters\%1_ca.paa", toLower _designator];
    };
    private _borderIconPath = ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_empty_ca.paa", "A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_empty_ca.paa"] select (_side isEqualTo _friendlySide || _side isEqualTo sideUnknown);
    private _backgroundIconPath = ["A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_opfor_ca.paa", "A3\ui_f\data\gui\rsc\rscdisplaymultiplayersetup\flag_civil_ca.paa"] select (_side isEqualTo _friendlySide || _side isEqualTo sideUnknown);

    private _id = format [QGVAR(ID_%1), _marker];

    private _activeSides = [];
    {
        _activeSides pushBackUnique (([_x] call FUNC(getSector)) getVariable ["side", sideUnknown]);
        nil
    } count (_sector getVariable ["dependency", []]);

    private _icon = [];
    private _shadow = 0;

    [_marker] call EFUNC(CompassUI,removeLineMarker);
    if (count _activeSides > 1 && (playerSide in _activeSides || _isSpectator)) then {
        if (playerSide == _side) then {
            if (_sector call FUNC(isCaptureable)) then {
                _icon pushBack ["ICON", _borderIconPath, [1, 1, 1, 1], _position, 70, 35];
                _color set [3, 1];
                _shadow = 2;
                [_marker, [0, 0.4, 0.8, 1], _position] call EFUNC(CompassUI,addLineMarker);
            };
        } else {
            _icon pushBack ["ICON", _borderIconPath, [1, 1, 1, 1], _position, 70, 35];
            _color set [3, 1];
            _shadow = 2;
            [_marker, [0.6, 0, 0, 1], getMarkerPos _marker] call EFUNC(CompassUI,addLineMarker);
        };
    };

    _icon pushBack ["ICON", _designatorIconPath, [1, 1, 1, 1], _position, _designatorSize, _designatorSize];
    _icon pushBack ["ICON", _backgroundIconPath, _color, _position, 70, 35, 0, "", _shadow];
    reverse _icon;

    [
        _id,
        +_icon,
        "normal",
        1000
    ] call CFUNC(addMapGraphicsGroup);


    private _markerSize = getMarkerSize _marker;
    private _markerShape = markerShape _marker;
    private _markerDir = markerDir _marker;
    private _fillColor = +_color;
    _fillColor set [3, 0.2];
    private _hoverIcon = [];
    _hoverIcon pushBack [_markerShape, _position, _markerSize select 0, _markerSize select 1, _markerDir, +_fillColor, "#(rgb,8,8,3)color(1,1,1,1)"];
    _fillColor set [3, 0.1];
    _hoverIcon pushBack [_markerShape, _position, _markerSize select 0, _markerSize select 1, _markerDir, _fillColor, "\A3\3den\data\displays\display3deneditattributes\backgrounddisable_ca.paa"];
    _hoverIcon append _icon;
    _hoverIcon pushBack ["ICON", "a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1, 1, 1, 1], [_position, [0, 25]], 25, 25, 0, _fullname, 2, 0.07, "RobotoCondensedBold", "center"];

    [
        _id,
        _hoverIcon,
        "hover",
        1000
    ] call CFUNC(addMapGraphicsGroup);
};
