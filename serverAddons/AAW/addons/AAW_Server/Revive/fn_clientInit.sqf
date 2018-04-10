#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy, joko // Jonas

    Description:
    Client Init of Revive Module

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

GVAR(UnconsciousFrame) = -1;
GVAR(UnconsciousSince) = -1;

["playerChanged", {
    (_this select 0) params ["_newPlayer", "_oldPlayer"];
    private _oldId = _oldPlayer getVariable [QGVAR(HandleDamageId), -1];
    if (_oldId >= 0) then {
        _oldPlayer removeEventHandler ["HandleDamage", _oldId];
    };
    private _id = _newPlayer addEventHandler ["HandleDamage", {_this call FUNC(damageHandler)}];
    _newPlayer setVariable [QGVAR(HandleDamageId), _id];
}] call CFUNC(addEventhandler);

["Respawn", {
    (_this select 0) params ["_newUnit"];

    _newUnit setVariable [QGVAR(bleedingRate), 0];
    _newUnit setVariable [QGVAR(bloodLevel), 1];
    _newUnit setVariable [QGVAR(isUnconscious), false, true];
}] call CFUNC(addEventHandler);

GVAR(draw3dIcons) = false;

[{
    if !(CLib_Player getVariable [QEGVAR(Kit,isMedic), false]) exitWith {
        if (GVAR(draw3dIcons)) then {
            [QGVAR(Icons)] call CFUNC(remove3dGraphics);
        };
        GVAR(draw3dIcons) = false;
    };
    GVAR(draw3dIcons) = true;
    private _nearUnits = [positionCameraToWorld [0, 0, 0], 100] call CFUNC(getNearUnits);

    private _icons = [];
    {
        private _targetSide = side (group _x);

        #ifdef ISDEV
            #define ISDEVCONDIONREVIVE alive _x && playerSide getFriend _targetSide >= 0.6
        #else
            #define ISDEVCONDIONREVIVE _x != CLib_Player && alive _x && playerSide getFriend _targetSide >= 0.6
        #endif
        // Check if the unit is not the player himself, alive and a friend of player.
        if (ISDEVCONDIONREVIVE) then {
            // The position of the nameTag is above the head.
            if ((_x getVariable [QGVAR(isUnconscious), false]) || damage _x >= 0.1) then {
                _icons pushBack ["ICON", "\A3\Ui_f\data\IGUI\Cfg\HoldActions\progress\progress_0_ca.paa", [0, 0, 0, 1], [_x, "pelvis", [0, 0, 0]], 1, 1, 0, "", 0, 0.05, "PuristaSemiBold", "center", false, {
                    private _unit = (_position select 0);
                    private _cameraPosASL = AGLToASL (_cameraPosition);
                    private _pelvisPositionAGL = _unit modelToWorldVisual (_unit selectionPosition "pilot");
                    private _pelvisPositionASL = AGLToASL _pelvisPositionAGL;

                    if (!((lineIntersectsSurfaces [_cameraPosASL, _pelvisPositionASL, CLib_Player, _unit]) isEqualTo [])) exitWith {false};

                    private _distance = _cameraPosASL vectorDistance _pelvisPositionASL;

                    if (_distance > 100 || _distance < 2) exitWith {false};
                    private _size = 1;
                    private _alpha = 1;
                    if (_distance >= 7) then {
                        _size = (7 / _distance) ^ 0.7;
                        _alpha = _size;

                        if (_distance >= 30) then {
                            // linear fade out
                            _alpha = (1 - (_distance - 30) / 20) * _alpha;
                        };
                    };

                    _size = _size * _fov;
                    _width = _size * _width;
                    _height = _size * _height;

                    _color set [3, _alpha];

                    true;
                }];
                private _icon = "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa";
                _icons pushBack ["ICON", _icon, [1, 1, 1, 1], [_x, "pelvis", [0, 0, 0]], 1, 1, 0, "", 0, 0.05, "PuristaSemiBold", "center", false, {
                    private _unit = (_position select 0);
                    private _cameraPosASL = AGLToASL (_cameraPosition);
                    private _pelvisPositionAGL = _unit modelToWorldVisual (_unit selectionPosition "pilot");
                    private _pelvisPositionASL = AGLToASL _pelvisPositionAGL;

                    if (!((lineIntersectsSurfaces [_cameraPosASL, _pelvisPositionASL, CLib_Player, _unit]) isEqualTo [])) exitWith {false};

                    private _distance = _cameraPosASL vectorDistance _pelvisPositionASL;

                    if (_distance > 100 || _distance < 2) exitWith {false};

                    if (_unit getVariable [QGVAR(isUnconscious), false]) then {
                        private _iconFormat = "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\%1_ca.paa";
                        private _iconAnimation = ["u50", "u75", "u100", "u75", "u50", "r50", "r75", "r100", "r75", "r50"];
                        if (_unit getVariable [QGVAR(bloodLevel), 1] < 0.2) then {
                            _iconAnimation = ["u50", "u75", "u100", "u75", "u50", "d50", "d75", "d100", "d75", "d50"];
                        };

                        _texture = format [_iconFormat, _iconAnimation select floor ((time mod 1) * (count _iconAnimation))];
                    } else {
                        _texture = "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\r100_ca.paa";
                    };

                    private _size = 1;
                    private _alpha = 1;

                    if (_distance >= 7) then {
                        _size = (7 / _distance) ^ 0.7;
                        _alpha = _size;

                        if (_distance >= 30) then {
                            // linear fade out
                            _alpha = (1 - (_distance - 30) / 20) * _alpha;
                        };
                    };

                    _size = _size * _fov;
                    _width = _size * _width;
                    _height = _size * _height;

                    _color set [3, _alpha];

                    true;
                }];
            };

            private _color = [1, 1, 1, 1];

            private _icon = _x getVariable [QEGVAR(Kit,kitIcon), "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa"];
        };
        nil
    } count _nearUnits;
    [QGVAR(Icons), _icons] call CFUNC(add3dGraphics);
}, 1] call CFUNC(addPerFrameHandler);

private _hndl = ppEffectCreate ["DynamicBlur", 998];
_hndl ppEffectEnable false;
_hndl ppEffectAdjust [1];
GVAR(UnconsciousnessEffects) = [_hndl];

["unconsciousnessChanged", {
    (_this select 0) params ["_state"];
    if (_state) then {
        {
            _x ppEffectEnable true;
            _x ppEffectCommit 1;
        } count GVAR(UnconsciousnessEffects);
    } else {
        {
            _x ppEffectEnable false;
            _x ppEffectCommit 3;
        } count GVAR(UnconsciousnessEffects);
    };

}] call CFUNC(addEventhandler);

["Respawn", {
    {
        _x ppEffectEnable false;
        _x ppEffectCommit 1;
    } count GVAR(UnconsciousnessEffects);
}] call CFUNC(addEventHandler);

["isNotUnconscious", {
    params ["_caller"];
    !(_caller getVariable [QGVAR(isUnconscious), false])
}] call CFUNC(addCanInteractWith);

call FUNC(bleedOut);
call FUNC(forceRespawnAction);
call FUNC(healAction);
call FUNC(reviveAction);
call FUNC(dragAction);
call FUNC(unloadAction);
