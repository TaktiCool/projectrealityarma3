// ------------------------------------
// IFA3_GER
// ------------------------------------

class IFA3_GER_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"LIB_P08"};
    magazines[] = {{"LIB_8Rnd_9x19_P08",1}};
    handgunLoadedMagazine[] = {"LIB_8Rnd_9x19_P08"};
};

class IFA3_GER_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"LIB_K98"};
    magazines[] = {{"LIB_5Rnd_792x57", 9}};
    primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_792x57"};
};

class IFA3_GER_StandardGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_shg24",1}, {"LIB_nb39", 2}};
};

class IFA3_GER_SignalGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_nb39",2}};
};

class IFA3_GER_GrenadierGrenades : CfgCLibLoadoutsClassBase {
    class StandardGrenades : IFA3_GER_StandardGrenades {};
    items[] = {"LIB_shg24", {"LIB_1Rnd_G_SPRGR_30", 6}};
};


class IFA3_GER_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_LIB_GER_Soldier_camo"};
    vest[] = {"V_LIB_GER_VestKar98"};
    backpack[] = {"B_LIB_GER_A_frame"};
    headgear[] = {"H_LIB_GER_HelmetCamo"};

    class HandgunClass : IFA3_GER_StandardHandgun {};
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {};
    class GrenadesClass : IFA3_GER_StandardGrenades {};
    class BasicItemsClass : IFA3_BasicItems {};
};

class IFA3_GER_Rifleman : IFA3_GER_StandardSoldier {
    items[] = {"LIB_shg24"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class IFA3_GER_SquadLeader : IFA3_GER_StandardSoldier {
    binocular[] = {"LIB_Binocular_GER"};

    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MP40"};
        magazines[] = {{"LIB_32Rnd_9x19", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19"};
    };

    class SignalGrenadesClass : IFA3_GER_SignalGrenades {};
};

class IFA3_GER_Medic : IFA3_GER_StandardSoldier {
    backpack[] = {"B_LIB_GER_MedicBackpack_Empty"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : IFA3_GER_SignalGrenades {};
};

class IFA3_GER_AutomaticRifleman : IFA3_GER_StandardSoldier {
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MG34"};
        magazines[] = {{"LIB_50Rnd_792x57", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_50Rnd_792x57"};
    };
};

class IFA3_GER_Grenadier : IFA3_GER_StandardSoldier {
    class GrenadesClass : IFA3_GER_GrenadierGrenades {};
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryAttachments[] = {"LIB_ACC_GW_SB_Empty"};
    };
};

class IFA3_GER_Marksman : IFA3_GER_StandardSoldier {
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_G43"};
        magazines[] = {{"LIB_10Rnd_792x57", 5}};
        primaryWeaponLoadedMagazine[] = {"LIB_10Rnd_792x57"};
    };
};

class IFA3_GER_LightAntiTank : IFA3_GER_StandardSoldier {
    backpack[] = {"B_LIB_GER_SapperBackpack_empty"};
    secondaryWeapon[] = {"LIB_PzFaust_30m"};
    magazines[] = {{"LIB_1Rnd_PzFaust_30m", 1}};
    secondaryWeaponLoadedMagazine[] = {"LIB_1Rnd_PzFaust_30m"};
};

class IFA3_GER_MachineGunner : IFA3_GER_StandardSoldier {
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MG42"};
        magazines[] = {{"LIB_50Rnd_792x57", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_50Rnd_792x57"};
    };
};

class IFA3_GER_Crewman : IFA3_GER_StandardSoldier {
    uniform[] = {"U_LIB_GER_Tank_crew_private"};
    headgear[] = {"H_LIB_GER_TankPrivateCap2"};
    vest[] = {""};
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MP40"};
        magazines[] = {{"LIB_32Rnd_9x19", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19"};
    };
};

class IFA3_GER_Pilot : IFA3_GER_Crewman {
    uniform[] = {"U_LIB_GER_Tank_crew_private"};
    headgear[] = {"H_LIB_GER_TankPrivateCap2"};
    vest[] = {""};
    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_MP40"};
        magazines[] = {{"LIB_32Rnd_9x19", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_32Rnd_9x19"};
    };
};

class IFA3_GER_Sniper : IFA3_GER_StandardSoldier {

    class PrimaryWeaponClass : IFA3_GER_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_K98ZF39"};
        magazines[] = {{"LIB_5Rnd_792x57", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_792x57"};
    };
};

class IFA3_GER_Spotter : IFA3_GER_StandardSoldier {
    binocular[] = {"LIB_Binocular_GER"};
};
