#include "macros.hpp"
/*
    Arma At War - AAW

    Author: BadGuy

    Description:
    Server Init

    Parameter(s):
    -

    Returns:
    -
*/

GVAR(namespace) = false call CFUNC(createNamespace);

[QGVAR(startDestroyTimer), {
    (_this select 0) params ["_pointId"];
    private _pfhId = [{
        (_this select 0) params ["_pointId", "_timerValue"];

        private _data = GVAR(namespace) getVariable [_pointId, []];
        _data params ["_pfhId", ["_timerValue", 0]];

        private _counterStopped = [_pointId, "counterStopped", 0] call EFUNC(Common,getDeploymentPointData);

        if (_counterStopped == 1) exitWith {};

        _timerValue = _timerValue + 0.1;
        GVAR(namespace) setVariable [_pointId, [_pfhId, _timerValue]];

        private _pos = [_pointId, "position"] call EFUNC(Common,getDeploymentPointData);

        private _speed = 10;

        if (_timerValue >= 15) then {
            _speed = 5;
        };

        if (_timerValue >= 20) then {
            _speed = 2;
        };

        if (_timerValue >= 25) then {
            _speed = 1;
        };

        if ((round (_timerValue * 10) mod _speed) == 0) then {
            playSound3D ["a3\sounds_f\sfx\beep_target.wss", objNull, false, AGLToASL _pos, 10, 0.5, 40];
        };

        if (_timerValue < 30) exitWith {};

        [{
            params ["_pos"];
            private _bomb = createVehicle ["M_Mo_82mm_AT_LG", [0, 0, 0], [], 0, "CAN_COLLIDE"];
            _bomb setPos _pos;
            _bomb setDamage 1;
        }, [_pos]] call CFUNC(execNextFrame);

        private _availablefor = [_pointId, "availablefor"] call EFUNC(Common,getDeploymentPointData);

        [_pointId] call EFUNC(Common,removeDeploymentPoint);

        (_this select 1) call CFUNC(removePerFrameHandler);

        private _ticketValue = [CFGFOB(ticketValue), 20] call CFUNC(getSetting);

        [_availablefor, -_ticketValue] call EFUNC(Tickets,addTickets);

    }, 0.1, [_pointId]] call CFUNC(addPerFrameHandler);
    GVAR(namespace) setVariable [_pointId, [_pfhId, 0]];

    [_pointId, "counterActive", 1] call EFUNC(Common,setDeploymentPointData);
}] call CFUNC(addEventhandler);

[QGVAR(resetDestroyTimer), {
    (_this select 0) params ["_pointId"];
    private _data = GVAR(namespace) getVariable [_pointId, []];
    _data params ["_pfhId"];
    _pfhId call CFUNC(removePerFrameHandler);
    GVAR(namespace) setVariable [_pointId, nil];

    [_pointId, "counterActive", 0] call EFUNC(Common,setDeploymentPointData);
    [_pointId, "counterStopped", 0] call EFUNC(Common,setDeploymentPointData);
    _pointId call FUNC(playRadioSound);
}] call CFUNC(addEventhandler);

[QGVAR(stopDestroyTimer), {
    (_this select 0) params ["_pointId"];
    [_pointId, "counterStopped", 1] call EFUNC(Common,setDeploymentPointData);
}] call CFUNC(addEventhandler);

[QGVAR(continueDestroyTimer), {
    (_this select 0) params ["_pointId"];
    [_pointId, "counterStopped", 0] call EFUNC(Common,setDeploymentPointData);
}] call CFUNC(addEventhandler);

GVAR(soundList) = [
    ["radio\ambient_radio2", 10],
    ["radio\ambient_radio3", 11],
    ["radio\ambient_radio4", 7],
    ["radio\ambient_radio5", 9],
    ["radio\ambient_radio6", 7],
    ["radio\ambient_radio7", 5],
    ["radio\ambient_radio8", 12],
    ["radio\ambient_radio9", 8],
    ["radio\ambient_radio10", 11],
    ["radio\ambient_radio11", 6],
    ["radio\ambient_radio13", 6],
    ["radio\ambient_radio14", 7],
    ["radio\ambient_radio15", 8],
    ["radio\ambient_radio16", 11],
    ["radio\ambient_radio17", 6],
    ["radio\ambient_radio18", 10],
    ["radio\ambient_radio19", 10],
    ["radio\ambient_radio20", 6],
    ["radio\ambient_radio21", 4],
    ["radio\ambient_radio22", 5],
    ["radio\ambient_radio23", 8],
    ["radio\ambient_radio24", 8],
    ["radio\ambient_radio25", 10],
    ["radio\ambient_radio26", 8],
    ["radio\ambient_radio30", 9],
    ["UI\uav\UAV_01", 4, 4.5],
    ["UI\uav\UAV_02", 11, 4.5],
    ["UI\uav\UAV_03", 5, 4.5],
    ["UI\uav\UAV_04", 8, 4.5],
    ["UI\uav\UAV_05", 8, 4.5],
    ["UI\uav\UAV_06", 17, 4.5],
    ["UI\uav\UAV_07", 10, 4.5]
];

DFUNC(shuffleSoundArray) = {
    GVAR(soundList) = GVAR(soundList) call CFUNC(shuffleArray);
    [FUNC(shuffleSoundArray), 300] call CFUNC(wait);
};

call FUNC(shuffleSoundArray);

DFUNC(playRadioSound) = {
    params ["_pointId"];
    private _soundWaitIsRunning = [_pointId, "soundWaitIsRunning", 0] call EFUNC(Common,getDeploymentPointData);
    if (_soundWaitIsRunning == 0) then {
        [_pointId, _soundWaitIsRunning] call FUNC(playRadioSoundLoop);
    };
};

DFUNC(playRadioSoundLoop) = {
    params ["_pointId", "_soundWaitIsRunning"];
    private _obj = [_pointId, "pointobjects"] call EFUNC(Common,getDeploymentPointData);
    private _pos = [_pointId, "position"] call EFUNC(Common,getDeploymentPointData);
    _obj = selectRandom _obj;
    private _counterActive = [_pointId, "counterActive", 0] call EFUNC(Common,getDeploymentPointData);
    if (isNull _obj || _counterActive == 1) exitWith {
        [_pointId, "soundWaitIsRunning", 0] call EFUNC(Common,setDeploymentPointData);
    };
    private _data = selectRandom GVAR(soundList);
    _data params ["_soundPath", "_length", ["_volume", 1]];
    _soundPath = format ["a3\sounds_f\sfx\%1.wss", _soundPath];

    playSound3D [_soundPath, objNull, false, AGLToASL _pos, (_volume * 4), 1, 40];
    [FUNC(playRadioSound), (_length + random 5), _pointId] call CFUNC(wait);
    if (_soundWaitIsRunning == 0) then {
        [_pointId, "soundWaitIsRunning", 1] call EFUNC(Common,setDeploymentPointData);
    };
};

[QGVAR(placed), {
    (_this select 0) params ["_pointId"];
    _pointId call FUNC(playRadioSound);
    [{
        params ["_pointId"];
        [_pointId, "spawnPointLocked", 0] call EFUNC(Common,setDeploymentPointData);
    }, [CFGFOB(waitTimeAfterPlacement), 300] call CFUNC(getSetting), _pointId] call CFUNC(wait);
}] call CFUNC(addEventhandler);


[{
    {
        private _pointDetails = [_x, ["position", "availablefor", "type"]] call EFUNC(Common,getDeploymentPointData);
        _pointDetails params ["_position", "_availableFor", "_type"];
        // For FOBs only
        if (_type == "FOB") then {

            private _maxEnemyCount =  [CFGFOB(maxEnemyCount), 1] call CFUNC(getSetting);
            private _maxEnemyCountRadius = [CFGFOB(maxEnemyCountRadius), 10] call CFUNC(getSetting);

            private _enemyCount = {(side group _x != sideUnknown) && {(side group _x) != _availableFor}} count (_position nearObjects ["CAManBase", _maxEnemyCountRadius]);

            private _currentStatus = [_x, "spawnPointBlocked", 0] call EFUNC(Common,getDeploymentPointData);

            private _newStatus = [0, 1] select (_enemyCount >= _maxEnemyCount);
            if (_currentStatus != _newStatus) then {
                [_x, "spawnPointBlocked", _newStatus] call EFUNC(Common,setDeploymentPointData);
            };
        };
        nil
    } count (call EFUNC(Common,getAllDeploymentPoints));
}, 0.2] call CFUNC(addPerFrameHandler);

[QGVAR(createSOBComp), {
    (_this select 0) params ["_composition", "_position", "_dirVector", "_pointId"];
    private _value = [_composition, _position, _dirVector] call CFUNC(createSimpleObjectComp);
    [_pointId, "pointObjects", _value] call EFUNC(Common,setDeploymentPointData);
}] call CFUNC(addEventhandler);
