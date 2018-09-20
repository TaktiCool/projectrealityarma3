// ------------------------------------
// AAF
// ------------------------------------
class AAF_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"hgun_Rook40_F"};
    magazines[] = {{"16Rnd_9x21_Mag", 1}};
    handgunLoadedMagazine[] = {"16Rnd_9x21_Mag"};
};

class AAF_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"arifle_Mk20_F"};
    primaryWeaponOptic[] = {"optic_Aco"};
    primaryWeaponMuzzle[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_556x45_Stanag", 5}};
    primaryWeaponLoadedMagazine[] = {"30Rnd_556x45_Stanag"};
};


class AAF_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_I_CombatUniform"};
    vest[] = {"V_PlateCarrierIA1_dgtl"};
    headgear[] = {"H_HelmetIA"};


    class PrimaryWeaponClass : AAF_StandardAssaultRifle {};
    class HandgunClass : AAF_StandardHandgun {};
};

class AAF_Rifleman : AAF_StandardSoldier {
    items[] = {"HandGrenade"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class AAF_SquadLeader : AAF_StandardSoldier {
    binocular[] = {"Binocular"};

    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_MRCO"};
    };

    class SignalGrenadesClass : A3_SignalGrenades {};
};

class AAF_Medic : AAF_StandardSoldier {
    backpack[] = {"B_AssaultPack_dgtl"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : A3_SignalGrenades {};
};

class AAF_AutomaticRifleman : AAF_StandardSoldier {
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeapon[] = {"LMG_Mk200_F"};
        primaryWeaponResting[] = {"bipod_03_F_blk"};
        magazines[] = {{"200Rnd_65x39_cased_Box", 1}};
        primaryWeaponLoadedMagazine[] = {"200Rnd_65x39_cased_Box"};
    };
};

class AAF_Grenadier : AAF_StandardSoldier {
    class GrenadesClass : A3_GrenadierGrenades {};
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_Mk20_GL_F"};
    };
};

class AAF_Marksman : AAF_StandardSoldier {
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_MRCO"};
        primaryWeaponResting[] = {"bipod_03_F_blk"};
    };
};

class AAF_AntiAir : AAF_StandardSoldier {
    backpack[] = {"B_FieldPack_oli"};
    secondaryWeapon[] = {"launch_I_Titan_F"};
    magazines[] = {"Titan_AA"};
    secondaryWeaponLoadedMagazine[] = {"Titan_AA"};
};

class AAF_LightAntiTank : AAF_StandardSoldier {
    backpack[] = {"B_AssaultPack_dgtl"};
    secondaryWeapon[] = {"launch_NLAW_F"};
    magazines[] = {"NLAW_F"};
    secondaryWeaponLoadedMagazine[] = {"NLAW_F"};
};

class AAF_AntiTank : AAF_StandardSoldier {
    backpack[] = {"B_FieldPack_oli"};
    secondaryWeapon[] = {"launch_I_Titan_short_F"};
    magazines[] = {"Titan_AT"};
    secondaryWeaponLoadedMagazine[] = {"Titan_AT"};
};

class AAF_Crewman : AAF_StandardSoldier {
    headgear[] = {"H_HelmetCrew_I"};
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_Mk20C_F"};
        magazines[] = {{"30Rnd_556x45_Stanag", 3}};
        primaryWeaponLoadedMagazine[] = {"30Rnd_556x45_Stanag"};
    };
};

class AAF_Pilot : AAF_Crewman {
    uniform[] = {"U_I_HeliPilotCoveralls"};
    headgear[] = {"H_PilotHelmetHeli_I"};
};

class AAF_Sniper : AAF_StandardSoldier {
    uniform[] = {"U_I_FullGhillie_lsh"};
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeapon[] = {"srifle_GM6_F"};
        primaryWeaponOptic[] = {"optic_LRPS"};
        magazines[] = {{"5Rnd_127x108_Mag", 6}};
        primaryWeaponLoadedMagazine[] = {"5Rnd_127x108_Mag"};
    };
};

class AAF_Spotter : AAF_StandardSoldier {
    uniform[] = {"U_I_FullGhillie_lsh"};
    binocular[] = {"Rangefinder"};
    class PrimaryWeaponClass : AAF_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_MRCO"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};
