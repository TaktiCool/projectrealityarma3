#include "macros.hpp"
/*
    Arma At War - AAW

    Author: joko // Jonas, NetFusion

    Description:
    Init for Nametags

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

// Use the missionStarted EH to prevent unnecessary executions.
["missionStarted", {
    [{
        PERFORMANCECOUNTER_START(Nametags);
        // Use the camera position as center for nearby player detection.
        private _cameraPosAGL = positionCameraToWorld [0, 0, 0];
        private _cameraPosASL = AGLToASL _cameraPosAGL;
        private _fov = (call CFUNC(getFOV)) * 3;

        // Cycle through all nearby players and display their nameTag.
        private _nearUnits = [positionCameraToWorld [0, 0, 0], 100] call CFUNC(getNearUnits);
        //_nearUnits pushBackUnique CLib_Player;
        private _icons = [];
        {
            private _targetSide = side (group _x);

            // Check if the unit is not the player himself, alive and a friend of player.
            #ifdef ISDEV
                #define ISDEVCONDIONNAMETAGS alive _x && playerSide getFriend _targetSide >= 0.6
            #else
                #define ISDEVCONDIONNAMETAGS _x != CLib_Player && alive _x && playerSide getFriend _targetSide >= 0.6
            #endif
            if (ISDEVCONDIONNAMETAGS) then {
                // The position of the nameTag is above the head.

                private _color = if (group _x == group CLib_Player) then {

                    // we need to check if _index is -1 because if the player controll a drone and try to get assignedTeam from player return Nil
                    private _index = ["MAIN", "RED", "GREEN", "BLUE", "YELLOW"] find (assignedTeam _x);
                    [
                        [1, 1, 1, 1], // Main
                        [1, 0, 0.1, 1], // Red
                        [0.1, 1, 0, 1], // Green
                        [0.1, 0, 1, 1], // Blue
                        [1, 1, 0.1, 1] // Yellow
                    ] param [_index, [1, 1, 1, 1]];
                } else {
                    [0.77, 0.51, 0.08, 1]
                };

                private _icon = _x getVariable [QEGVAR(Kit,kitIcon), "\a3\ui_f\data\IGUI\Cfg\Actions\clear_empty_ca.paa"];
                private _text = format ["%1", _x call CFUNC(name)];

                _icons pushBack ["ICON", _icon, _color, [_x, "pilot", [0, 0, 0.45]], 1, 1, 0, _text, 2, 0.05, "PuristaSemiBold", "center", false, {
                    private _unit = (_position select 0);
                    private _cameraPosASL = AGLToASL (_cameraPosition);
                    private _facePositionAGL = _unit modelToWorldVisual (_unit selectionPosition "pilot");
                    private _facePositionASL = AGLToASL _facePositionAGL;

                    if (!((lineIntersectsSurfaces [_cameraPosASL, _facePositionASL, CLib_Player, _unit]) isEqualTo [])) exitWith {false};

                    private _distance = _cameraPosASL vectorDistance _facePositionASL;

                    if (_distance > 100 || _distance == 0) exitWith {false};

                    private _size = 1;
                    private _alpha = 1;
                    private _offset = [0, 0, 0.45];

                    if (_distance < 7) then {
                        _offset set [2, (_offset select 2) * ((3 + _distance) / 10)];
                    } else {
                        _size = (7 / _distance) ^ 0.7;
                        _alpha = _size;

                        _offset set [2, (_offset select 2) * (1 / _size) ^ 0.3];

                        if (_distance >= 30) then {
                            // linear fade out
                            _alpha = (1 - (_distance - 30) / 20) * _alpha;
                        };

                        private _currentTime = time;
                        if (_unit == cursorTarget) then {
                            _unit setVariable [QGVAR(lastTimeInFocus), _currentTime];
                        };

                        private _diffTime = _currentTime - (_unit getVariable [QGVAR(lastTimeInFocus), 0]);

                        if (_diffTime < 3) then {
                            private _tempAlpha = 1 - sqrt (_diffTime / 3);
                            if (_alpha < _tempAlpha) then {
                                _alpha = _tempAlpha;
                            };
                        };
                    };

                    if (_alpha <= 0) exitWith {false};

                    _size = _size * _fov;
                    _width = _size * _width;
                    _height = _size * _height;
                    _textSize = _size * _textSize;
                    _position set [2, _offset];
                    _color set [3, _alpha];
                    if (_unit call CFUNC(isSpeaking)) then {
                        _texture = "a3\ui_f\data\igui\rscingameui\rscdisplayvoicechat\microphone_ca.paa";
                    };
                    true;
                }];
            };
            nil
        } count _nearUnits;

        [QGVAR(Icons), _icons] call CFUNC(add3dGraphics);
        PERFORMANCECOUNTER_END(Nametags);
    }, 1.6] call CFUNC(addPerFrameHandler);
}] call CFUNC(addEventHandler);
