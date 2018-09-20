// ------------------------------------
// NATO_Tropic
// ------------------------------------

class NATO_Tropic_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"hgun_P07_khk_F"};
    magazines[] = {{"11Rnd_45ACP_Mag", 1}};
    handgunLoadedMagazine[] = {"11Rnd_45ACP_Mag"};
};

class NATO_Tropic_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"arifle_MX_khk_F"};
    primaryWeaponOptic[] = {"optic_Holosight"};
    primaryWeaponMuzzle[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_65x39_caseless_mag", 5}};
    primaryWeaponLoadedMagazine[] = {"30Rnd_65x39_caseless_mag"};
};


class NATO_Tropic_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_B_T_Soldier_F"};
    vest[] = {"V_PlateCarrier1_tna_F"};
    headgear[] = {"H_HelmetB_Light_tna_F"};

    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {};
    class HandgunClass : NATO_Tropic_StandardHandgun {};
};

class NATO_Tropic_Rifleman : NATO_Tropic_StandardSoldier {
    items[] = {"HandGrenade"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class NATO_Tropic_SquadLeader : NATO_Tropic_StandardSoldier {
    headgear[] = {"H_HelmetB_Enh_tna_F"};
    binocular[] = {"Binocular"};

    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_Arco"};
    };

    class SignalGrenadesClass : A3_SignalGrenades {};
};

class NATO_Tropic_Medic : NATO_Tropic_StandardSoldier {
    uniform[] = {"U_B_T_Soldier_AR_F"};
    backpack[] = {"B_AssaultPack_rgr"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : A3_SignalGrenades {};
};

class NATO_Tropic_AutomaticRifleman : NATO_Tropic_StandardSoldier {
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MX_SW_khk_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"100Rnd_65x39_caseless_mag_Tracer", 3}};
        primaryWeaponLoadedMagazine[] = {"100Rnd_65x39_caseless_mag_Tracer"};
    };
};

class NATO_Tropic_Grenadier : NATO_Tropic_StandardSoldier {
    class GrenadesClass : A3_GrenadierGrenades {};
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MX_GL_khk_F"};
    };
};

class NATO_Tropic_Marksman : NATO_Tropic_StandardSoldier {
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXM_khk_F"};
        primaryWeaponOptic[] = {"optic_Arco"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};

class NATO_Tropic_AntiAir : NATO_Tropic_StandardSoldier {
    backpack[] = {"B_Kitbag_rgr"};
    secondaryWeapon[] = {"launch_B_Titan_tna_F"};
    magazines[] = {{"Titan_AA", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AA"};
};

class NATO_Tropic_LightAntiTank : NATO_Tropic_StandardSoldier {
    backpack[] = {"B_AssaultPack_rgr"};
    secondaryWeapon[] = {"launch_NLAW_F"};
    magazines[] = {{"NLAW_F", 1}};
    secondaryWeaponLoadedMagazine[] = {"NLAW_F"};
};

class NATO_Tropic_AntiTank : NATO_Tropic_StandardSoldier {
    backpack[] = {"B_Kitbag_rgr"};
    secondaryWeapon[] = {"launch_B_Titan_short_tna_F"};
    magazines[] = {{"Titan_AT", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AT"};
};

class NATO_Tropic_Crewman : NATO_Tropic_StandardSoldier {
    headgear[] = {"H_HelmetCrew_B"};
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXC_khk_F"};
        magazines[] = {{"30Rnd_65x39_caseless_mag", 3}};
    };
};

class NATO_Tropic_Pilot : NATO_Tropic_Crewman {
    uniform[] = {"U_B_HeliPilotCoveralls"};
    headgear[] = {"H_PilotHelmetHeli_B"};
};

class NATO_Tropic_Sniper : NATO_Tropic_StandardSoldier {
    uniform[] = {"U_B_T_Sniper_F"};
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"srifle_LRR_F"};
        primaryWeaponOptic[] = {"optic_LRPS"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"7Rnd_408_Mag", 6}};
        primaryWeaponLoadedMagazine[] = {"7Rnd_408_Mag"};
    };
};

class NATO_Tropic_Spotter : NATO_Tropic_StandardSoldier {
    uniform[] = {"U_B_T_Sniper_F"};
    binocular[] = {"Rangefinder"};
    class PrimaryWeaponClass : NATO_Tropic_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_MXM_khk_F"};
        primaryWeaponOptic[] = {"optic_Arco"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};
