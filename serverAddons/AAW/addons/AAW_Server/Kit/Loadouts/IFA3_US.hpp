// ------------------------------------
// IFA3_US
// ------------------------------------

class IFA3_US_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"LIB_Colt_M1911"};
    magazines[] = {{"LIB_7Rnd_45ACP",1}};
    handgunLoadedMagazine[] = {"LIB_7Rnd_45ACP"};
};

class IFA3_US_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"LIB_M1_Garand"};
    magazines[] = {{"LIB_8Rnd_762x63", 9}};
    primaryWeaponLoadedMagazine[] = {"LIB_8Rnd_762x63"};
};

class IFA3_US_StandardGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_US_Mk_2",1}, {"LIB_US_M18", 2}};
};

class IFA3_US_SignalGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_US_M18",2}};
};

class IFA3_US_GrenadierGrenades : CfgCLibLoadoutsClassBase {
    class StandardGrenades : IFA3_US_StandardGrenades {};
    items[] = {"LIB_US_Mk_2", {"LIB_1Rnd_G_M9A1", 6}};
};


class IFA3_US_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_LIB_US_AB_Uniform_M42"};
    vest[] = {"V_LIB_US_AB_Vest_Garand"};
    backpack[] = {"B_LIB_US_M36"};
    headgear[] = {"H_LIB_US_AB_Helmet"};

    class HandgunClass : IFA3_US_StandardHandgun {};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {};
    class GrenadesClass : IFA3_US_StandardGrenades {};
    class BasicItemsClass : IFA3_BasicItems {};
};

class IFA3_US_Rifleman : IFA3_US_StandardSoldier {
    items[] = {"LIB_US_Mk_2"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class IFA3_US_SquadLeader : IFA3_US_StandardSoldier {
    binocular[] = {"Binocular"};
    vest[] = {"V_LIB_US_AB_Vest_Thompson"};

    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1A1_Thompson"};
        magazines[] = {{"LIB_30Rnd_45ACP", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_30Rnd_45ACP"};
    };

    class SignalGrenadesClass : IFA3_US_SignalGrenades {};
};

class IFA3_US_Medic : IFA3_US_StandardSoldier {
    vest[] = {"V_LIB_US_Vest_Medic"};
    headgear[] = {"H_LIB_US_AB_Helmet_Medic_1"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : IFA3_US_SignalGrenades {};
};

class IFA3_US_AutomaticRifleman : IFA3_US_StandardSoldier {
    vest[] = {"V_LIB_US_AB_Vest_Bar"};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1918A2_BAR"};
        magazines[] = {{"LIB_20Rnd_762x63", 9}};
        primaryWeaponLoadedMagazine[] = {"LIB_20Rnd_762x63"};
    };
};

class IFA3_US_Grenadier : IFA3_US_StandardSoldier {
    class GrenadesClass : IFA3_US_GrenadierGrenades {};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryAttachments[] = {"LIB_ACC_GL_M7"};
    };
};

class IFA3_US_Marksman : IFA3_US_StandardSoldier {
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1903A4_Springfield"};
        magazines[] = {{"LIB_5Rnd_762x63", 7}};
        primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_762x63"};
    };
};

class IFA3_US_LightAntiTank : IFA3_US_StandardSoldier {
    backpack[] = {"B_LIB_US_RocketBag_Empty"};
    secondaryWeapon[] = {"LIB_M1A1_Bazooka"};
    magazines[] = {{"LIB_1Rnd_60mm_M6", 1}};
    secondaryWeaponLoadedMagazine[] = {"LIB_1Rnd_60mm_M6"};
};

class IFA3_US_MachineGunner : IFA3_US_StandardSoldier {
    vest[] = {"V_LIB_US_AB_Vest_Bar"};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1919A4"};
        magazines[] = {{"LIB_50Rnd_762x63", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_50Rnd_762x63"};
    };
};


class IFA3_US_Crewman : IFA3_US_StandardSoldier {
    uniform[] = {"U_LIB_US_Tank_Crew"};
    headgear[] = {"H_LIB_US_Helmet_Tank"};
    vest[] = {""};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MP40"};
        magazines[] = {{"LIB_32Rnd_9x19", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19"};
    };
};

class IFA3_US_Pilot : IFA3_US_Crewman {
    uniform[] = {"U_LIB_US_Tank_Crew"};
    headgear[] = {"H_LIB_US_Helmet_Tank"};
    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1_Carbine"};
        magazines[] = {{"LIB_15Rnd_762x33", 3}};
    };
};

class IFA3_US_Sniper : IFA3_US_StandardSoldier {

    class PrimaryWeaponClass : IFA3_US_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M1903A4_Springfield"};
        magazines[] = {{"LIB_10Rnd_792x57", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_10Rnd_792x57"};
    };
};

class IFA3_US_Spotter : IFA3_US_StandardSoldier {
    binocular[] = {"Binocular"};
};
