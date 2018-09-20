// ------------------------------------
// NATO
// ------------------------------------

class NATO_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"hgun_Pistol_heavy_01_F"};
    magazines[] = {{"11Rnd_45ACP_Mag", 1}};
    handgunLoadedMagazine[] = {"11Rnd_45ACP_Mag"};
};

class NATO_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"arifle_MX_F"};
    primaryWeaponOptic[] = {"optic_Holosight"};
    primaryWeaponMuzzle[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_65x39_caseless_mag", 5}};
    primaryWeaponLoadedMagazine[] = {"30Rnd_65x39_caseless_mag"};
};


class NATO_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_B_CombatUniform_mcam"};
    vest[] = {"V_PlateCarrier1_rgr"};
    headgear[] = {"H_HelmetB"};

    class PrimaryWeaponClass : NATO_StandardAssaultRifle {};
    class HandgunClass : NATO_StandardHandgun {};
};

class NATO_Rifleman : NATO_StandardSoldier {
    items[] = {"HandGrenade"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class NATO_SquadLeader : NATO_StandardSoldier {
    headgear[] = {"H_HelmetSpecB"};
    binocular[] = {"Binocular"};

    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_Arco"};
    };

    class SignalGrenadesClass : A3_SignalGrenades{};
};

class NATO_Medic : Nato_StandardSoldier {
    uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
    backpack[] = {"B_AssaultPack_rgr"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : A3_SignalGrenades {};
};

class NATO_AutomaticRifleman : NATO_StandardSoldier {
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MX_SW_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"100Rnd_65x39_caseless_mag_Tracer", 3}};
        primaryWeaponLoadedMagazine[] = {"100Rnd_65x39_caseless_mag_Tracer"};
    };
};

class NATO_Grenadier : NATO_StandardSoldier {
    class GrenadesClass : A3_GrenadierGrenades {};
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MX_GL_F"};
    };
};

class NATO_Marksman : NATO_StandardSoldier {
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXM_F"};
        primaryWeaponOptic[] = {"optic_Arco"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};

class NATO_AntiAir : NATO_StandardSoldier {
    backpack[] = {"B_Kitbag_rgr"};
    secondaryWeapon[] = {"launch_B_Titan_F"};
    magazines[] = {{"Titan_AA", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AA"};
};

class NATO_LightAntiTank : NATO_StandardSoldier {
    backpack[] = {"B_AssaultPack_rgr"};
    secondaryWeapon[] = {"launch_NLAW_F"};
    magazines[] = {{"NLAW_F", 1}};
    secondaryWeaponLoadedMagazine[] = {"NLAW_F"};
};

class NATO_AntiTank : NATO_StandardSoldier {
    backpack[] = {"B_Kitbag_rgr"};
    secondaryWeapon[] = {"launch_B_Titan_short_F"};
    magazines[] = {{"Titan_AT", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AT"};
};

class NATO_Crewman : NATO_StandardSoldier {
    headgear[] = {"H_HelmetCrew_B"};
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXC_F"};
        magazines[] = {{"30Rnd_65x39_caseless_mag", 3}};
    };
};

class NATO_Pilot : NATO_Crewman {
    uniform[] = {"U_B_HeliPilotCoveralls"};
    headgear[] = {"H_PilotHelmetHeli_B"};
};

class NATO_Sniper : NATO_StandardSoldier {
    uniform[] = {"U_B_FullGhillie_lsh"};
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"srifle_LRR_F"};
        primaryWeaponOptic[] = {"optic_LRPS"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"7Rnd_408_Mag", 6}};
        primaryWeaponLoadedMagazine[] = {"7Rnd_408_Mag"};
    };
};

class NATO_Spotter : NATO_StandardSoldier {
    uniform[] = {"U_B_FullGhillie_lsh"};
    binocular[] = {"Rangefinder"};
    class PrimaryWeaponClass : NATO_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXM_F"};
        primaryWeaponOptic[] = {"optic_Arco"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};
