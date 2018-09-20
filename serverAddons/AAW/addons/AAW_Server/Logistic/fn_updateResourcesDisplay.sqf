#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Updates the "RESOURCE REQUEST" Display

    Parameter(s):
    0: Display <Display>
    1: Content ControlGroup <Control>
    2: Resource Points Control <Control>

    Returns:
    None
*/

_this params ["_display", "_contentGroup", "_resourcePoints"];

private _target = _display getVariable [QGVAR(target), objNull];
if (isNull _target) exitWith {};
private _supplyPoints = _target getVariable ["supplyPoints", 0];

_resourcePoints ctrlSetText format ["%1 / %2", (_target getVariable ["supplyPoints", 0]), (_target getVariable ["supplyCapacity", 0])];

private _cfg = QUOTE(PREFIX/CfgLogistics/) + ([format [QUOTE(PREFIX/Sides/%1/logistics), side group CLib_player], ""] call CFUNC(getSetting));
private _ctrlItems = _contentGroup getVariable [QGVAR(logisticItems), []];
{
    ctrlDelete _x;
    nil
} count _ctrlItems;
_ctrlItems = [];

{
    private _subcfg = _cfg + "/" + _x;
    private _content = [_subcfg + "/content"] call CFUNC(getSetting);
    //private _className = [_subcfg + "/classname"] call CFUNC(getSetting);
    //private _clearOnSpawn = ([_subcfg + "/removeDefaultLoadout"] call CFUNC(getSetting)) > 0;
    private _displayName = [_subcfg + "/displayName"] call CFUNC(getSetting);
    private _supplyCost = [_subcfg + "/supplyCost", 0] call CFUNC(getSetting);
    private _picture = [_subcfg + "/picture", "\A3\3den\data\displays\display3den\panelright\modemodules_ca.paa"] call CFUNC(getSetting);


    if (_displayName call CFUNC(isLocalised)) then {
        _displayName = LOC(_displayName);
    };

    private _itemGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _contentGroup];
    _itemGroup ctrlSetPosition [(_forEachIndex mod 2)*PX(60), (floor (_forEachIndex/2))*PY(15), PX(59), PY(15)];
    _itemGroup ctrlCommit 0;

    private _itemBg = _display ctrlCreate ["RscText", 100, _itemGroup];
    _itemBg ctrlSetPosition [0, 0, PX(59), PY(14)];
    _itemBg ctrlSetBackgroundColor [0.3,0.3,0.3,0.3];
    _itemBg ctrlCommit 0;

    private _itemPicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _itemGroup];
    _itemPicture ctrlSetPosition [PX(1), PY(3), PX(8), PY(8)];
    _itemPicture ctrlSetText _picture;
    _itemPicture ctrlCommit 0;

    private _itemTitle = _display ctrlCreate ["RscTitle", -1, _itemGroup];
    _itemTitle ctrlSetFontHeight PY(2.6);
    _itemTitle ctrlSetFont "RobotoCondensedBold";
    _itemTitle ctrlSetPosition [PX(10), PY(1), PX(49), PY(2.5)];
    _itemTitle ctrlSetText toUpper _displayName;
    _itemTitle ctrlCommit 0;

    private _itemCosts = _display ctrlCreate ["RscTextNoShadow", -1, _itemGroup];
    _itemCosts ctrlSetFontHeight PY(4);
    _itemCosts ctrlSetFont "RobotoCondensedBold";
    _itemCosts ctrlSetPosition [PX(48), PY(1), PX(10), PY(8)];
    _itemCosts ctrlSetText str _supplyCost;
    _itemCosts ctrlSetBackgroundColor [0.13,0.54,0.21,1];
    _itemCosts ctrlCommit 0;

    if !(_content isEqualTo []) then {
        private _itemContentListGroup = _display ctrlCreate ["RscControlsGroupNoHScrollbars", -1, _itemGroup];
        _itemContentListGroup ctrlSetPosition [PX(10), PY(4), PX(37), PY(8)];
        _itemContentListGroup ctrlCommit 0;

        private _contentCount = count _content;

        {
            private _picture = "";
            private _displayName = _x select 0;

            private _posx = PX(18) * (_forEachIndex mod 1);
            private _posy = PY(2) * floor (_forEachIndex/1);

            if (isClass (configFile >> "CfgVehicles" >> (_x select 0))) then {
                _picture = getText (configFile >> "CfgVehicles" >> (_x select 0) >> "picture");
                _displayName = getText (configFile >> "CfgVehicles" >> (_x select 0) >> "displayName");
            };

            if (isClass (configFile >> "CfgMagazines" >> (_x select 0))) then {
                _picture = getText (configFile >> "CfgMagazines" >> (_x select 0) >> "picture");
                _displayName = getText (configFile >> "CfgMagazines" >> (_x select 0) >> "displayName");
            };

            if (isClass (configFile >> "CfgWeapons" >> (_x select 0))) then {
                _picture = getText (configFile >> "CfgWeapons" >> (_x select 0) >> "picture");
                _displayName = getText (configFile >> "CfgWeapons" >> (_x select 0) >> "displayName");
            };

            private _itemPicture = _display ctrlCreate ["RscPictureKeepAspect", -1, _itemContentListGroup];
            _itemPicture ctrlSetPosition [_posx, _posy, PX(2), PY(2)];
            _itemPicture ctrlSetText _picture;
            _itemPicture ctrlCommit 0;

            private _itemTitle = _display ctrlCreate ["RscTitle", -1, _itemContentListGroup];
            _itemTitle ctrlSetFontHeight PY(2);
            _itemTitle ctrlSetFont "RobotoCondensed";
            _itemTitle ctrlSetPosition [_posx + PX(2.2), _posy, PX(34), PY(2)];
            _itemTitle ctrlSetText format ["%1x %2", _x select 1, _displayName];
            _itemTitle ctrlCommit 0;
        } forEach _content;
    };

    if (_supplyPoints >= _supplyCost) then {
        private _itemRequestButton = _display ctrlCreate ["RscButton", -1, _itemGroup];
        _itemRequestButton ctrlSetPosition [PX(48), PY(10), PX(10), PY(3)];
        _itemRequestButton ctrlSetFont "RobotoCondensed";
        _itemRequestButton ctrlSetFontHeight PY(2);
        _itemRequestButton ctrlSetText "REQUEST";
        //_itemRequestButton setVariable [QGVAR(args), [_className, _content, _clearOnSpawn, _displayName, _supplyPoints]];
        _itemRequestButton setVariable [QGVAR(args), [_target, _subcfg]];
        _itemRequestButton ctrlAddEventHandler ["ButtonClick", {
            _this params ["_ctrl"];
            private _args = _ctrl getVariable [QGVAR(args), []];
            if (_args isEqualTo []) exitWith {};
            ["spawnCrate", [_args, getPos CLib_player, side group CLib_player]] call CFUNC(serverEvent);

        }];
        _itemRequestButton ctrlCommit 0;
    } else {
        private _disableBg = _display ctrlCreate ["RscText", -1, _itemGroup];
        _disableBg ctrlSetPosition [0, 0, PX(59), PY(14)];
        _disableBg ctrlSetBackgroundColor [0.3,0.3,0.3,0.5];
        _disableBg ctrlCommit 0;
        _itemCosts ctrlSetBackgroundColor [0.5,0.5,0.5,1];
        _itemCosts ctrlCommit 0;
    };



    _ctrlItems pushBack _itemGroup;

} forEach ([_cfg] call CFUNC(getSettingSubClasses));

_contentGroup setVariable [QGVAR(logisticItems), _ctrlItems];
