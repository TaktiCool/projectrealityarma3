#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class AAW {
        path = "\tc\AAW\addons\AAW_Server"; // TODO add Simplifyed Macro for this
        dependency[] = {"CLib"};

        // Base protection
        MODULE(BaseProtection) {
            dependency[] = {"AAW/Sector"};
            FNC(clientInit);
            FNC(serverInit);
        };

        // Common
        MODULE(Common) {
            // Init
            FNC(init);
            FNC(serverInit);

            // Misc
            FNC(getSideInfo);
            FNC(getNearestLocationName);
            FNC(isAlive);
            FNC(endMission);


            MODULE(Deployment) {
                // Inits
                FNC(initDeployment);
                FNC(serverInitDeployment);
                FNC(clientInitDeployment);

                // DataManagement
                FNC(setDeploymentPointData);
                FNC(getDeploymentPointData);

                // Misc
                FNC(getAvailableDeploymentPoints);
                FNC(getAllDeploymentPoints);
                FNC(getDeploymentPointsPerSide);
                FNC(removeDeploymentPoint);
                FNC(addDeploymentPoint);
                FNC(isValidDeploymentPoint);

                // Callback System
                FNC(callDeploymentPointCallback);
                FNCSERVER(registerDeploymentPointTypeCallback);

                MODULE(Callbacks) {
                    FNC(isAvailableFor);
                    FNC(isLocked);
                    FNC(onDeploy);
                    FNC(onDestroy);
                    FNC(onPlaced);
                    FNC(onPrepare);
                    FNC(onSpawn);
                };
            };

            //Entity Variables
            MODULE(EntityVariables) {
                FNC(initEntityVariables);
            };

            // Respawn
            MODULE(Respawn) {
                FNC(respawn);
                FNC(respawnNewSide);
            };

            // Notification
            MODULE(Notification) {
                FNC(clientInitNotification);
                FNC(displayNotification);
                FNC(displayHint);
                FNC(drawNotification);
                FNC(drawHint);
                FNC(registerDisplayNotification);
            };

            // Performance Info
            MODULE(PerformanceInfo) {
                FNC(clientInitPerformance);
                FNC(serverInitPerformance);
            };
        };

        // CompassUI
        MODULE(CompassUI) {
            dependency[] = {"AAW/Common"};

            FNC(clientInit);
            FNC(removeLineMarker);
            FNC(addLineMarker);
        };

        // ScoreTable
        MODULE(ScoreTable) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(serverInit);
            FNC(updateList);
        };

        // Rally System
        MODULE(Rally) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(place);
            FNC(destroy);
            FNC(destroyAction);
            FNC(canPlace);
            FNC(serverInit);
        };

        // FOB system
        MODULE(FOB) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(serverInit);
            FNC(place);
            FNC(destroyAction);
            FNC(defuseAction);
            FNC(dismantleAction);
            FNC(buildAction);
            FNC(canPlace);
        };

        // SquadRespawn system
        /* MODULE(SquadPlayerRespawn) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
        };*/

        // Supply system
        MODULE(Supply) {
            FNC(clientInit);
        };

        // Kit
        MODULE(Kit) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(getAllKits);
            FNC(getKitDetails);
            FNC(getUsableKitCount);
            FNC(applyKit);
            FNC(getLoadoutDetails);
        };

        // Logistic
        MODULE(Logistic) {
            dependency[] = {"AAW/Common"};
            FNC(serverInit);
            FNC(clientInit);
            FNC(clientInitActions);
            FNC(clientInitCargoInventory);
            FNC(getWeight);
            FNC(dragObject);
            FNC(dropObject);
            FNC(spawnCrate);
            FNC(buildResourcesDisplay);
            FNC(updateResourcesDisplay);
        };

        // MapInteractions
        MODULE(MapInteractions) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(mouseButtonClick);
            FNC(registerMapControl);
            FNC(addMenuEntry);
            FNC(openContextMenu);
            FNC(buildHeaderElement);
            FNC(buildLabelElement);
            FNC(buildImageStackButton);
            FNC(buildListElement);
        };

        // MapMarker
        MODULE(MapMarker) {
            dependency[] = {"AAW/Common", "AAW/MapInteractions"};
            FNC(clientInit);
            FNC(serverInit);
            FNC(createMapMarker);
            FNC(updateMarker);
        };

        // Mortar
        MODULE(Mortar) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
        };

        // Nametags
        MODULE(Nametags) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
        };

        // RespawnUI
        MODULE(RespawnUI) {
            dependency[] = {"AAW/Common", "AAW/Kit", "AAW/Squad", "AAW/Sector"};
            FNC(clientInit);
            FNC(clientInitDeployment);
            FNC(clientInitRole);
            FNC(clientInitSquad);
            FNC(clientInitCamera);
            FNC(showDisplayInterruptEH);
            FNC(updateListNBox);
            FNC(fadeControl);
        };

        // Revive
        MODULE(Revive) {
            dependency[] = {"AAW/Common"};
            // General
            FNC(setUnconscious);
            FNC(clientInit);
            FNC(bloodEffect);
            FNC(bleedOut);
            FNC(damageHandler);
            FNC(dragAction);
            FNC(healAction);
            FNC(forceRespawnAction);
            FNC(reviveAction);
            FNC(unloadAction);
        };

        // Sector
        MODULE(Sector) {
            dependency[] = {"AAW/Common"};
            FNC(init);
            FNC(clientInit);
            FNC(serverInit);
            FNC(createSectorLogic);
            FNC(drawSector);
            FNC(getSector);
            FNC(isCaptureable);
            FNC(sectorUpdatePFH);
            FNC(showCaptureStatus);
            FNC(updateDependencies);
        };

        // Spectator
        MODULE(Spectator) {
            dependency[] = {"AAW/Common", "AAW/Sector"};
            FNC(clientInit);
            FNC(clientInitSector);
            FNC(cameraUpdateLoop);
            FNC(draw3dEH);
            FNC(keyDownEH);
            FNC(keyUpEH);
            FNC(mouseMovingEH);
            FNC(mouseWheelEH);
        };

        // Squad
        MODULE(Squad) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(getNextSquadId);
            FNC(canUseSquadType);
            FNC(switchSide);
            FNC(createSquad);
            FNC(joinSquad);
            FNC(leaveSquad);
            FNC(kickMember);
            FNC(promoteMember);
            FNC(canSwitchSide);
        };

        // Tickets
        MODULE(Tickets) {
            dependency[] = {"AAW/Common", "AAW/Sector"};
            FNC(init);
            FNC(addTickets);
        };

        // UnitTracker
        MODULE(UnitTracker) {
            dependency[] = {"AAW/Common"};
            FNC(clientInit);
            FNC(addUnitToTracker);
            FNC(addGroupToTracker);
            FNC(addVehicleToTracker);
        };

        // VehicleRespawn
        MODULE(VehicleRespawn) {
            dependency[] = {"AAW/Common"};
            FNC(serverInit);
            FNC(clientInit);
            FNC(performVehicleRespawn);
        };

        MODULE(AAS) {
            dependency[] = {"AAW/BaseProtection",
                "AAW/CompassUI",
                "AAW/FOB",
                "AAW/Kit",
                "AAW/Logistic",
                "AAW/Nametags",
                "AAW/Rally",
                "AAW/RespawnUI",
                "AAW/Revive",
                "AAW/ScoreTable",
                "AAW/Sector",
                "AAW/Spectator",
                "AAW/Squad",
                "AAW/Supply",
                "AAW/Tickets",
                "AAW/UnitTracker",
                "AAW/VehicleRespawn"};
            FNC(serverInit);
        };
    };
};
