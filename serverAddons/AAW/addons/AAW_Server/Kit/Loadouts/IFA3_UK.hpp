// ------------------------------------
// IFA3_UK
// ------------------------------------

class IFA3_UK_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"LIB_Colt_M1911"};
    magazines[] = {{"LIB_7Rnd_45ACP",1}};
    handgunLoadedMagazine[] = {"LIB_7Rnd_45ACP"};
};

class IFA3_UK_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"LIB_LeeEnfield_No4"};
    magazines[] = {{"LIB_10Rnd_770x56", 9}};
    primaryWeaponLoadedMagazine[] = {"LIB_10Rnd_770x56"};
};

class IFA3_UK_StandardGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_US_Mk_2",1}, {"LIB_US_M18", 2}};
};

class IFA3_UK_SignalGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_US_M18",2}};
};

class IFA3_UK_GrenadierGrenades : CfgCLibLoadoutsClassBase {
    class StandardGrenades : IFA3_UK_StandardGrenades {};
    items[] = {"LIB_US_Mk_2", {"LIB_1Rnd_G_MillsBomb", 6}};
};


class IFA3_UK_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_LIB_UK_Soldier"};
    vest[] = {"V_LIB_UK_P37_Rifleman"};
    backpack[] = {"B_LIB_UK_HSack"};
    headgear[] = {"H_LIB_UK_Helmet_Mk2", "H_LIB_UK_Helmet_Mk2", "H_LIB_UK_Helmet_Mk2_Cover", "H_LIB_UK_Helmet_Mk2_Camo", "H_LIB_UK_Helmet_Mk2_FAK_Camo", "H_LIB_UK_Helmet_Mk2_FAK", "H_LIB_UK_Helmet_Mk2_Net", "H_LIB_UK_Helmet_Mk3", "H_LIB_UK_Helmet_Mk3_Camo", "H_LIB_UK_Helmet_Mk3_Net"};

    class HandgunClass : IFA3_UK_StandardHandgun {};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {};
    class GrenadesClass : IFA3_UK_StandardGrenades {};
    class BasicItemsClass : IFA3_BasicItems {};
};

class IFA3_UK_Rifleman : IFA3_UK_StandardSoldier {
    items[] = {"LIB_US_Mk_2"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class IFA3_UK_SquadLeader : IFA3_UK_StandardSoldier {
    binocular[] = {"Binocular"};
    vest[] = {"V_LIB_UK_P37_Officer"};

    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_Sten_Mk5"};
        magazines[] = {{"LIB_32Rnd_9x19_Sten", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19_Sten"};
    };

    class SignalGrenadesClass : IFA3_UK_SignalGrenades {};
};

class IFA3_UK_Medic : IFA3_UK_StandardSoldier {
    vest[] = {"V_LIB_UK_P37_Heavy"};
    headgear[] = {"H_LIB_UK_Para_Helmet_Mk2"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : IFA3_UK_SignalGrenades {};
};

class IFA3_UK_AutomaticRifleman : IFA3_UK_StandardSoldier {
    vest[] = {"V_LIB_UK_P37_Heavy"};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_Bren_Mk2"};
        magazines[] = {{"LIB_30Rnd_770x56", 9}};
        primaryWeaponLoadedMagazine[] = {"LIB_30Rnd_770x56"};
    };
};

class IFA3_UK_Grenadier : IFA3_UK_StandardSoldier {
    class GrenadesClass : IFA3_UK_GrenadierGrenades {};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryAttachments[] = {"LIB_ACC_GL_Enfield_CUP_Empty"};
    };
};

class IFA3_UK_Marksman : IFA3_UK_StandardSoldier {
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_LeeEnfield_No4_Scoped"};
        magazines[] = {{"LIB_10Rnd_770x56", 7}};
        primaryWeaponLoadedMagazine[] = {"LIB_10Rnd_770x56"};
    };
};

class IFA3_UK_LightAntiTank : IFA3_UK_StandardSoldier {
    backpack[] = {"B_LIB_UK_HSack"};
    secondaryWeapon[] = {"LIB_M1A1_Bazooka"};
    magazines[] = {{"LIB_1Rnd_60mm_M6", 1}};
    secondaryWeaponLoadedMagazine[] = {"LIB_1Rnd_60mm_M6"};
};

class IFA3_UK_MachineGunner : IFA3_UK_StandardSoldier {
    vest[] = {"V_LIB_UK_P37_Heavy"};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1919A4"};
        magazines[] = {{"LIB_50Rnd_762x63", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_50Rnd_762x63"};
    };
};


class IFA3_UK_Crewman : IFA3_UK_StandardSoldier {
    uniform[] = {"U_LIB_UK_Soldier"};
    headgear[] = {"H_LIB_UK_Beret_Tankist"};
    vest[] = {"V_LIB_UK_P37_Crew"};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MP40"};
        magazines[] = {{"LIB_32Rnd_9x19", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19"};
    };
};

class IFA3_UK_Pilot : IFA3_UK_Crewman {
    uniform[] = {"U_LIB_UK_Soldier"};
    headgear[] = {"H_LIB_UK_Pilot_Cap"};
    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_Sten_Mk2"};
        magazines[] = {{"LIB_32Rnd_9x19_Sten", 3}};
    };
};

class IFA3_UK_Sniper : IFA3_UK_StandardSoldier {

    class PrimaryWeaponClass : IFA3_UK_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_LeeEnfield_No4_Scoped"};
        magazines[] = {{"LIB_10Rnd_770x56", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_10Rnd_770x56"};
    };
};

class IFA3_UK_Spotter : IFA3_UK_StandardSoldier {
    binocular[] = {"Binocular"};
};
