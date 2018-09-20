// ------------------------------------
// CTRG
// ------------------------------------
class CTRG_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"hgun_Pistol_heavy_01_F"};
    magazines[] = {{"11Rnd_45ACP_Mag", 1}};
    handgunLoadedMagazine[] = {"11Rnd_45ACP_Mag"};
};

class CTRG_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"arifle_SPAR_01_blk_F"};
    primaryWeaponOptic[] = {"optic_Holosight"};
    primaryWeaponMuzzle[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_556x45_Stanag", 5}};
    primaryWeaponLoadedMagazine[] = {"30Rnd_556x45_Stanag"};
};


class CTRG_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_B_CTRG_Soldier_3_F"};
    vest[] = {"V_PlateCarrier1_tna_F"};
    headgear[] = {"H_HelmetB_Light_tna_F"};


    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {};
    class HandgunClass : CTRG_StandardHandgun {};
};

class CTRG_Rifleman : CTRG_StandardSoldier {
    items[] = {"HandGrenade"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class CTRG_SquadLeader : CTRG_StandardSoldier {
    headgear[] = {"H_HelmetB_TI_tna_F"};
    binocular[] = {"Binocular"};

    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_ERCO_blk_F"};
    };

    class SignalGrenadesClass : A3_SignalGrenades {};
};

class CTRG_Medic : CTRG_StandardSoldier {
    backpack[] = {"B_AssaultPack_tna_F"};
    uniform[] = {"U_B_CombatUniform_mcam_tshirt"};
    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : A3_SignalGrenades {};
};

class CTRG_AutomaticRifleman : CTRG_StandardSoldier {
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_SPAR_02_blk_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"150Rnd_556x45_Drum_Mag_Tracer_F", 2}};
        primaryWeaponLoadedMagazine[] = {"150Rnd_556x45_Drum_Mag_Tracer_F"};
    };
};

class CTRG_Grenadier : CTRG_StandardSoldier {
    class GrenadesClass : A3_GrenadierGrenades {};
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_SPAR_01_GL_blk_F"};
    };
};

class CTRG_Marksman : CTRG_StandardSoldier {
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeaponOptic[] = {"arifle_SPAR_03_blk_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"20Rnd_762x51_Mag", 5}};
        primaryWeaponLoadedMagazine[] = {"20Rnd_762x51_Mag"};
    };
};

class CTRG_AntiAir : CTRG_StandardSoldier {
    backpack[] = {"B_Kitbag_rgr"};
    secondaryWeapon[] = {"launch_B_Titan_F"};
    magazines[] = {{"Titan_AA", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AA"};
};

class CTRG_LightAntiTank : CTRG_StandardSoldier {
    backpack[] = {"B_AssaultPack_ocamo"};
    secondaryWeapon[] = {"launch_NLAW_F"};
    magazines[] = {{"NLAW_F", 1}};
    secondaryWeaponLoadedMagazine[] = {"NLAW_F"};
};

class CTRG_AntiTank : CTRG_StandardSoldier {
    backpack[] = {"B_FieldPack_ocamo"};
    secondaryWeapon[] = {"launch_B_Titan_short_F"};
    magazines[] = {{"Titan_AT", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AT"};
};

class CTRG_Crewman : CTRG_StandardSoldier {
    headgear[] = {"H_HelmetCrew_O_ghex_F"};
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_SPAR_01_blk_F"};
        magazines[] = {{"30Rnd_556x45_Stanag", 3}};
    };
};

class CTRG_Pilot : CTRG_Crewman {
    uniform[] = {"U_B_HeliPilotCoveralls"};
    headgear[] = {"H_PilotHelmetHeli_B"};
};

class CTRG_Sniper : CTRG_StandardSoldier {
    uniform[] = {"U_B_FullGhillie_lsh"};
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeapon[] = {"srifle_LRR_F"};
        primaryWeaponOptic[] = {"optic_LRPS"};
        magazines[] = {{"7Rnd_408_Mag", 6}};
        primaryWeaponLoadedMagazine[] = {"7Rnd_408_Mag"};
    };
};

class CTRG_Spotter : CTRG_StandardSoldier {
    uniform[] = {"U_B_FullGhillie_lsh"};
    binocular[] = {"Rangefinder"};
    class PrimaryWeaponClass : CTRG_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_ERCO_blk_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};
