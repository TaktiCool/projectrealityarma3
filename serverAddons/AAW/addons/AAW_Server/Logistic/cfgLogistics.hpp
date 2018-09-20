#define COST_MEDICAL_BOX 1000
#define COST_BASIC_AMMO_BOX 5000
#define COST_FOB_BOX 20000

class cfgLogistics {

    class BaseMedicalBox {
        displayName = "Medical Box";
        classname = "Box_NATO_Ammo_F";
        supplyCost = COST_MEDICAL_BOX;
        removeDefaultLoadout = 1;
        picture = "\A3\ui_f\data\map\vehicleicons\pictureheal_ca.paa";
        class Attributes {
            supplyType[] = {"Medical"};
            supplyCapacity = COST_MEDICAL_BOX;
            supplyPoints = COST_MEDICAL_BOX;
        };
    };
    class BaseBasicAmmoBox : BaseMedicalBox {
        displayName = "Ammo Box";
        picture = "\A3\ui_f\data\gui\cfg\respawnroles\assault_ca.paa";
        supplyCost = COST_BASIC_AMMO_BOX;
        class Attributes {
            supplyType[]  = {"AmmoInfantry"};
            supplyCapacity = COST_BASIC_AMMO_BOX;
            supplyPoints = COST_BASIC_AMMO_BOX;
        };
    };

    class BaseFOBBox {
        displayName = "FOB Box";
        classname = "B_CargoNet_01_ammo_F";
        removeDefaultLoadout = 1;
        supplyCost = COST_FOB_BOX;
        picture = "\A3\ui_f\data\map\mapcontrol\bunker_ca.paa";
        class Attributes {
            FOBBoxObject = 1;
        };
    };

    class BaseSide {
        supplySourceObjects[] = {};
        supplyPoints = 50000; // at Beginning of Round
        supplyPointsMax = 100000; // maximal resources
        supplyPointsGrowth[] = {1000, 20}; // [supplyPoints, per seconds]
        class MedicalBox : BaseMedicalBox {
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
        };

        class FOBBox : BaseFOBBox {
        };
    };

    class NATO : BaseSide {
        supplySourceObjects[] = {"mainBaseFlagWest"};
        class MedicalBox : BaseMedicalBox {
            classname = "Box_NATO_Ammo_F";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "Box_NATO_Ammo_F";
        };

        class FOBBox : BaseFOBBox {
            classname = "B_CargoNet_01_ammo_F";
        };
    };

    class CSAT : BaseSide {
        supplySourceObjects[] = {"mainBaseFlagEast"};
        class MedicalBox : BaseMedicalBox {
            classname = "Box_East_Ammo_F";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "Box_East_Ammo_F";
        };

        class FOBBox : BaseFOBBox {
            classname = "O_CargoNet_01_ammo_F";
        };
    };
    class AAF : BaseSide {
        supplySourceObjects[] = {"mainBaseFlagGuer"};
        class MedicalBox : BaseMedicalBox {
            classname = "Box_IND_Ammo_F";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "Box_IND_Ammo_F";
        };

        class FOBBox : BaseFOBBox {
            classname = "I_CargoNet_01_ammo_F";
        };
    };


    class GER : BaseSide {
        objectToSpawn[] = {"mainBaseFlagWest"};
        class MedicalBox : BaseMedicalBox {
            classname = "LIB_BasicWeaponsBox_GER";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "LIB_BasicWeaponsBox_GER";
        };


        class FOBBox : BaseFOBBox {
            classname = "B_supplyCrate_F";
        };
    };


    class US : BaseSide {
        objectToSpawn[] = {"mainBaseFlagWest"};
        class MedicalBox : BaseMedicalBox {
            classname = "LIB_BasicAmmunitionBox_US";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "LIB_BasicAmmunitionBox_US";
        };
        class FOBBox : BaseFOBBox {
            classname = "I_supplyCrate_F";
        };
    };

    // TODO: Correct classnames
    class SOV : BaseSide {
        objectToSpawn[] = {"mainBaseFlagGuer"};
        class MedicalBox : BaseMedicalBox {
            classname = "LIB_BasicAmmunitionBox_US";
        };

        class BasicAmmoBox : BaseBasicAmmoBox {
            classname = "LIB_BasicAmmunitionBox_US";
        };
        class FOBBox : BaseFOBBox {
            classname = "I_supplyCrate_F";
        };
    };
};
