class CfgMapMarker {
    persistance = 300; // Marker persistance in seconds
    blendoutTime = 60; // How long it takes to blend out the marker;
    class EnemyUnits {
        name = "";
        class Infantery {
            name = "Infantery";
            icons[] = {{"A3\ui_f\data\map\markers\nato\o_inf.paa", 1, {0.6, 0, 0, 1}}};
        };
        class MechInf {
            name = "Mechanized Infantery";
            icons[] = {{"A3\ui_f\data\map\markers\nato\o_mech_inf.paa", 1, {0.6, 0, 0, 1}}};
        };
        class Armored {
            name = "Armored";
            icons[] = {{"A3\ui_f\data\map\markers\nato\o_armor.paa", 1, {0.6, 0, 0, 1}}};
        };
    };
};
