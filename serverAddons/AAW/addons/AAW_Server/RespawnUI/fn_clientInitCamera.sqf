#include "macros.hpp"
/*
    Arma At War - AAW

    Author: NetFusion

    Description:
    Initializes the camera path background in respawn screen.
    TODO this currently works only if sector module is running

    Parameter(s):
    None

    Returns:
    None
*/
if (CLib_Player call EFUNC(Common,isSpectator)) exitWith {};

[QGVAR(UpdateCameraTarget), 0] call CFUNC(addIgnoredEventLog);

// When respawn screen is opened caused by death or upon startup init the camera
[UIVAR(RespawnScreen_onLoad), {
    if (!(alive CLib_Player) || (CLib_Player getVariable [QEGVAR(Common,tempUnit), false])) then {
        [QGVAR(initCamera)] call CFUNC(localEvent);
    };
}] call CFUNC(addEventHandler);

// When player changes the side reinitialize the camera
["playerSideChanged", {
    if (isNull GVAR(camera)) exitWith {};

    [QGVAR(destroyCamera)] call CFUNC(localEvent);
    [QGVAR(initCamera)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

// Destroy the camera when the screen is closed
[UIVAR(RespawnScreen_onUnload), {
    [QGVAR(destroyCamera)] call CFUNC(localEvent);
}] call CFUNC(addEventHandler);

// If a sector changed its side it might be our current camera target
["sectorSideChanged", {
    (_this select 0) params ["_sector"];

    // Update the camera target if the affected sector was the camera target
    if (_sector isEqualTo GVAR(currentCameraTarget)) then {
        [QGVAR(updateCameraTarget)] call CFUNC(localEvent);
    };
}] call CFUNC(addEventHandler);

// This initializes the camera
[QGVAR(initCamera), {
    // Wait for sectors to be initialized first
    [{
        // Start above the base
        GVAR(currentCameraTarget) = (format ["base_%1", playerSide]) call EFUNC(Sector,getSector);
        private _basePosition = getPos GVAR(currentCameraTarget);
        _basePosition set [2, 10];

        // Create the camera
        GVAR(camera) = "camera" camCreate _basePosition;
        GVAR(camera) cameraEffect ["INTERNAL", "BACK"];
        showCinemaBorder false;

        // Update the cam position every second to make it move along terrain heights
        GVAR(updatePositionPFH) = [{
            private _speed = 5; // The camera speed in meter per second
            private _height = 10; // The camera height above the ground

            // Determine where the cam should go
            private _targetPosition = getPos GVAR(currentCameraTarget);
            _targetPosition set [2, _height];
            private _currentPosition = getPos GVAR(camera);

            // Determine the next position of the camera
            private _vectorDiff = _targetPosition vectorDiff _currentPosition;
            private _newPosition = _currentPosition vectorAdd ((vectorNormalized _vectorDiff) vectorMultiply _speed);
            _newPosition set [2, _height]; // Stay 10m above the ground

            // If next pos is behind the target go to the target instead
            private _distanceToTarget = _currentPosition distance _targetPosition;
            if ((_currentPosition distance _newPosition) >= _distanceToTarget) then {
                _newPosition = _targetPosition;

                // Check if there is a new target available
                [QGVAR(updateCameraTarget)] call CFUNC(localEvent);
            };
            private _distanceToNewPos = _currentPosition distance _newPosition;
            if (_distanceToNewPos == 0) exitWith {};

            // Move the camera over time
            GVAR(camera) camSetPos _newPosition;
            GVAR(camera) camCommit (_speed / _distanceToNewPos);
        }, 1] call CFUNC(addPerFrameHandler);
    }, {
        !isNil QEGVAR(Sector,ServerInitDone) && {EGVAR(Sector,ServerInitDone)}
    }] call CFUNC(waitUntil);
}] call CFUNC(addEventHandler);

// Check where the camera has to go
[QGVAR(updateCameraTarget), {
    // We need all sectors which have the side of the player and have our current target as a dependency
    private _possibleTargets = (EGVAR(Sector,allSectorsArray) select {
        _x getVariable ["side", sideUnknown] == playerSide
         && GVAR(currentCameraTarget) in ((_x getVariable ["dependency", []]) apply {_x call EFUNC(Sector,getSector)})
    });

    if (!(_possibleTargets isEqualTo [])) then {
        GVAR(currentCameraTarget) = selectRandom _possibleTargets;

        // Now we have to make sure that the camera points 90deg left/right of out movement path dependent on world center
        // This is done by comparing the bearings from the current cam position to either the target and the world center
        private _currentPosition = getPos GVAR(camera);
        private _currentCameraTargetPosition = getPos GVAR(currentCameraTarget);
        private _relativeVectorToTarget = _currentCameraTargetPosition vectorDiff _currentPosition;
        private _relativeVectorToCenter = [worldSize / 2, worldSize / 2, 0] vectorDiff _currentPosition;

        private _angleToTarget = ((_relativeVectorToTarget select 0) atan2 (_relativeVectorToTarget select 1) + 360) % 360;
        private _angleToCenter = ((_relativeVectorToCenter select 0) atan2 (_relativeVectorToCenter select 1) + 360) % 360;

        private _angleDiff = (((_angleToTarget - _angleToCenter) + 180) % 360) - 180;

        GVAR(camera) setDir ([_angleToTarget - 90, _angleToTarget + 90] select (_angleDiff < 0));
    };
}] call CFUNC(addEventHandler);

// Destroy the cam
[QGVAR(destroyCamera), {
    GVAR(updatePositionPFH) call CFUNC(removePerFrameHandler);

    GVAR(camera) cameraEffect ["TERMINATE", "BACK"];
    camDestroy GVAR(camera);
}] call CFUNC(addEventHandler);
