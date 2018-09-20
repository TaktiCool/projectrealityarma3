// ------------------------------------
// CSAT
// ------------------------------------
class CSAT_StandardHandgun : CfgCLibLoadoutsClassBase {
    handgun[] = {"hgun_Pistol_heavy_01_F"};
    magazines[] = {{"11Rnd_45ACP_Mag", 1}};
    handgunLoadedMagazine[] = {"11Rnd_45ACP_Mag"};
};

class CSAT_StandardAssaultRifle : CfgCLibLoadoutsClassBase {
    primaryWeapon[] = {"arifle_Katiba_F"};
    primaryWeaponOptic[] = {"optic_Aco"};
    primaryWeaponMuzzle[] = {"acc_pointer_IR"};
    magazines[] = {{"30Rnd_65x39_caseless_green", 5}};
    primaryWeaponLoadedMagazine[] = {"30Rnd_65x39_caseless_green"};
};


class CSAT_StandardSoldier : A3_StandardSoldier {
    uniform[] = {"U_O_CombatUniform_ocamo"};
    vest[] = {"V_HarnessO_brn"};
    headgear[] = {"H_HelmetO_ocamo"};


    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {};
    class HandgunClass : CSAT_StandardHandgun {};
};

class CSAT_Rifleman : CSAT_StandardSoldier {
    items[] = {"HandGrenade"};
    class PortableAmmoBox : AAW_AmmoBox{};
};

class CSAT_SquadLeader : CSAT_StandardSoldier {
    headgear[] = {"H_HelmetLeaderO_ocamo"};
    binocular[] = {"Binocular"};

    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_Hamr"};
    };

    class SignalGrenadesClass : A3_SignalGrenades {};
};

class CSAT_Medic : CSAT_StandardSoldier {
    backpack[] = {"B_AssaultPack_ocamo"};

    class MedicalsClass : A3_MedicClassMedicals {};
    class SignalGrenadesClass : A3_SignalGrenades {};
};

class CSAT_AutomaticRifleman : CSAT_StandardSoldier {
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeapon[] = {"LMG_Zafir_F"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
        magazines[] = {{"150Rnd_762x54_Box", 1}};
        primaryWeaponLoadedMagazine[] = {"150Rnd_762x54_Box"};
    };
};

class CSAT_Grenadier : CSAT_StandardSoldier {
    class GrenadesClass : A3_GrenadierGrenades {};
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_Katiba_GL_F"};
    };
};

class CSAT_Marksman : CSAT_StandardSoldier {
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_Arco"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};

class CSAT_AntiAir : CSAT_StandardSoldier {
    backpack[] = {"B_FieldPack_ocamo"};
    secondaryWeapon[] = {"launch_O_Titan_F"};
    magazines[] = {{"Titan_AA", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AA"};
};

class CSAT_LightAntiTank : CSAT_StandardSoldier {
    backpack[] = {"B_AssaultPack_ocamo"};
    secondaryWeapon[] = {"launch_RPG32_F"};
    magazines[] = {{"RPG32_F", 1}};
    secondaryWeaponLoadedMagazine[] = {"RPG32_F"};
};

class CSAT_AntiTank : CSAT_StandardSoldier {
    backpack[] = {"B_FieldPack_ocamo"};
    secondaryWeapon[] = {"launch_O_Titan_short_F"};
    magazines[] = {{"Titan_AT", 1}};
    secondaryWeaponLoadedMagazine[] = {"Titan_AT"};
};

class CSAT_Crewman : CSAT_StandardSoldier {
    headgear[] = {"H_HelmetCrew_O"};
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeapon[] = {"arifle_Katiba_C_F"};
        magazines[] = {{"30Rnd_65x39_caseless_green", 3}};
    };
};

class CSAT_Pilot : CSAT_Crewman {
    uniform[] = {"U_O_HeliPilotCoveralls"};
    headgear[] = {"H_PilotHelmetHeli_O"};
};


class CSAT_Sniper : CSAT_StandardSoldier {
    uniform[] = {"U_O_FullGhillie_lsh"};
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeapon[] = {"srifle_GM6_F"};
        primaryWeaponOptic[] = {"optic_LRPS"};
        magazines[] = {{"5Rnd_127x108_Mag", 6}};
        primaryWeaponLoadedMagazine[] = {"5Rnd_127x108_Mag"};
    };
};

class CSAT_Spotter : CSAT_StandardSoldier {
    uniform[] = {"U_O_FullGhillie_lsh"};
    binocular[] = {"Rangefinder"};
    class PrimaryWeaponClass : CSAT_StandardAssaultRifle {
        primaryWeaponOptic[] = {"optic_Hamr"};
        primaryWeaponResting[] = {"bipod_01_F_blk"};
    };
};
