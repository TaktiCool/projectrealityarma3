// ------------------------------------
// IFA3_RUS
// ------------------------------------

class IFA3_RUS_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"LIB_P08"};
    magazines[] = {{"LIB_8Rnd_9x19_P08",1}};
    handgunLoadedMagazine[] = {"LIB_8Rnd_9x19_P08"};
};

class IFA3_RUS_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"LIB_M9130"};
    magazines[] = {{"LIB_5Rnd_762x54", 9}};
    primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_762x54"};
};

class IFA3_RUS_StandardGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_F1",1}, {"LIB_RDG", 2}};
};

class IFA3_RUS_SignalGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"LIB_RDG",2}};
};

class IFA3_RUS_GrenadierGrenades : CfgCLibLoadoutsClassBase {
    class StandardGrenades : IFA3_RUS_StandardGrenades {};
    items[] = {"LIB_F1", {"LIB_1Rnd_G_DYAKONOV", 6}};
};


class IFA3_RUS_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_LIB_NKVD_Strelok"};
    vest[] = {"V_LIB_SOV_RA_MosinBelt"};
    backpack[] = {"B_LIB_SOV_RA_Rucksack"};
    headgear[] = {"H_LIB_SOV_RA_Helmet"};

    class HandgunClass : IFA3_RUS_StandardHandgun {};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {};
    class GrenadesClass : IFA3_RUS_StandardGrenades {};
    class BasicItemsClass : IFA3_BasicItems {};
};

class IFA3_RUS_Rifleman : IFA3_RUS_StandardSoldier {
    items[] = {"LIB_F1"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class IFA3_RUS_SquadLeader : IFA3_RUS_StandardSoldier {
    binocular[] = {"Binocular"};
    vest[] = {"V_LIB_SOV_RA_OfficerVest"};
    headgear[] = {"H_LIB_NKVD_OfficerCap"};

    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_PPSh41_m"};
        magazines[] = {{"LIB_35Rnd_762x25", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_35Rnd_762x25"};
    };

    class SignalGrenadesClass : IFA3_RUS_SignalGrenades {};
};

class IFA3_RUS_Medic : IFA3_RUS_StandardSoldier {
    backpack[] = {"B_LIB_SOV_RA_MedicalBag_Empty"};
    vest[] = {"V_LIB_US_Vest_Medic"};
    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : IFA3_RUS_SignalGrenades {};
};

class IFA3_RUS_AutomaticRifleman : IFA3_RUS_StandardSoldier {
    vest[] = {"V_LIB_US_AB_Vest_Bar"};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_DP28"};
        magazines[] = {{"LIB_47Rnd_762x54", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_47Rnd_762x54"};
    };
};

class IFA3_RUS_Grenadier : IFA3_RUS_StandardSoldier {
    class GrenadesClass : IFA3_RUS_GrenadierGrenades {};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryAttachments[] = {"LIB_ACC_GL_DYAKONOV_Empty"};
    };
};

class IFA3_RUS_Marksman : IFA3_RUS_StandardSoldier {
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M9130PU"};
        magazines[] = {{"LIB_5Rnd_762x54", 5}};
        primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_762x54"};
    };
};

class IFA3_RUS_LightAntiTank : IFA3_RUS_StandardSoldier {
    backpack[] = {"B_LIB_SOV_RA_Rucksack2"};
    secondaryWeapon[] = {"B_AssaultPack_blk"};
    magazines[] = {{"LIB_1Rnd_RPzB", 1}};
    secondaryWeaponLoadedMagazine[] = {"LIB_1Rnd_RPzB"};
};

class IFA3_RUS_MachineGunner : IFA3_RUS_StandardSoldier {
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_DT"};
        magazines[] = {{"LIB_63Rnd_762x54", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_63Rnd_762x54"};
    };
};

class IFA3_RUS_Crewman : IFA3_RUS_StandardSoldier {
    uniform[] = {"U_LIB_SOV_Tank_ryadovoi"};
    headgear[] = {"H_LIB_SOV_TankHelmet"};
    vest[] = {""};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_PPSh41_m"};
        magazines[] = {{"LIB_35Rnd_762x25", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_35Rnd_762x25"};
    };
};

class IFA3_RUS_Pilot : IFA3_RUS_Crewman {
    uniform[] = {"U_LIB_SOV_Tank_ryadovoi"};
    headgear[] = {"H_LIB_SOV_TankHelmet"};
    vest[] = {""};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_PPSh41_m"};
        magazines[] = {{"LIB_35Rnd_762x25", 3}};
        primaryWeaponLoadedMagazine[] = {"LIB_35Rnd_762x25"};
    };
};

class IFA3_RUS_Sniper : IFA3_RUS_StandardSoldier {
    uniform[] = {"U_LIB_SOV_Sniper_spring"};
    class PrimaryWeaponClass : IFA3_RUS_StandardAssaultRifle {
        primaryWeapon[] = {"LIB_M9130PU"};
        magazines[] = {{"LIB_5Rnd_762x54", 6}};
        primaryWeaponLoadedMagazine[] = {"LIB_5Rnd_762x54"};
    };
};

class IFA3_RUS_Spotter : IFA3_RUS_StandardSoldier {
    uniform[] = {"U_LIB_SOV_Sniper_spring"};
    binocular[] = {"Binocular"};
};
