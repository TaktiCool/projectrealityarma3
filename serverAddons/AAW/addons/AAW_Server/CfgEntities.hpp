#define T_TRUCK_TRANSPORT 5
#define T_TRUCK_SUPPLY 5
#define T_ATV 3
#define T_OFFROAD 3
#define T_OFFROAD_ARMED 10
#define T_MRAP 10
#define T_MRAP_HMG 15
#define T_MRAP_GMG 20
#define T_APC_WHEELED 25
#define T_APC_TRACKED 25
#define T_APC_AA 25
#define T_MBT 30
#define T_ARTILLERY 30
#define T_MLRS 30
#define T_HELI_LIGHT 20
#define T_HELI_LIGHT_ARMED 25
#define T_HELI_TRANSPORT 20
#define T_HELI_TRANSPORT_ARMED 25
#define T_HELI_ATTACK_HELI 40
#define T_PLANE_CAS 75
#define T_PLANE_FIGHTER 75
#define T_VTOL_TRANSPORT 20
#define T_VTOL_ARMED 25

#define S_CAP_TRUCK 10000
#define S_CAP_CONSTRUCTION_TRUCK 50000
#define S_CAP_CAR 2000

class defaultVehicle {
    respawnCondition = "true";
    side = "UNKNOWN";
    respawnTime = -1; // disabled
    ticketValue = 2;
    abandonedVehicleRadius = 100;
    abandonedVehicleTime = 300;
};

class CfgEntities {

    /*
    Logistic Config
    */

    //Crates
    class Box_Nato_Ammo_F {
        isDraggable = 1;
        isLoadable = 1;
        cargoCapacity = 3;
        cargoSize = 5;
    };

    class Box_East_Ammo_F : Box_Nato_Ammo_F {
    };

    class ReammoBox_F : Box_Nato_Ammo_F {
    };

    class Box_IND_Ammo_F : Box_Nato_Ammo_F {
    };

    class Land_CargoBox_V1_F {
        isDraggable = 1;
        isLoadable = 1;
        cargoCapacity = 20;
        cargoSize = 25;
    };

    class B_Slingload_01_Cargo_F {
        isDraggable = 1;
        isLoadable = 0;
        cargoCapacity = 50;
        cargoSize = 60;
        logisticOffset[] = {0,0,5};
    };

    class CargoNet_01_ammo_base_F : B_Slingload_01_Cargo_F {
        isLoadable = 1;
        cargoSize = 20;
        cargoCapacity = 10;
        logisticOffset[] = {0, 0, 0};
    };

    /*
    Vehicle Config VANILLA ARMA
    */
    // TRUCKS
    class Truck_01_base_F {
        side = "WEST";
        respawnTime = 180;
        ticketValue = T_TRUCK_TRANSPORT;
        supplyType[] = {"Medical", "AmmoInfantery"};
        supplyCapacity = S_CAP_TRUCK;
    };

    class B_Truck_01_Ammo_F {
        ticketValue = T_TRUCK_SUPPLY; // Support Truck
    };

    class B_Truck_01_box_F : B_Truck_01_Ammo_F {
        constructionVehicle = 1;
        supplyCapacity = S_CAP_CONSTRUCTION_TRUCK;
        supplyType[] = {"Medical", "Ammo"};
    };

    class B_Truck_01_fuel_F : B_Truck_01_Ammo_F {
    };

    class B_Truck_01_medical_F : B_Truck_01_Ammo_F {
    };

    class B_Truck_01_Repair_F : B_Truck_01_Ammo_F {
    };

    class Truck_02_base_F : Truck_01_base_F {
        side = "GUER";
    };

    class I_Truck_02_Ammo_F : B_Truck_01_Ammo_F {
    };

    class I_Truck_02_box_F : I_Truck_02_Ammo_F {
        constructionVehicle = 1;
        supplyCapacity = S_CAP_CONSTRUCTION_TRUCK;
        supplyType[] = {"Medical", "Ammo"};
    };

    class I_Truck_02_fuel_F : I_Truck_02_Ammo_F {
    };

    class I_Truck_02_medical_F : I_Truck_02_Ammo_F {
    };

    class I_Truck_02_Repair_F : I_Truck_02_Ammo_F {
    };

    class O_Truck_02_Ammo_F : B_Truck_01_Ammo_F {
        side = "EAST";
    };

    class O_Truck_02_box_F : O_Truck_02_Ammo_F {
        constructionVehicle = 1;
        supplyCapacity = S_CAP_CONSTRUCTION_TRUCK;
        supplyType[] = {"Medical", "Ammo"};
    };

    class O_Truck_02_fuel_F : O_Truck_02_Ammo_F {
    };

    class O_Truck_02_medical_F : O_Truck_02_Ammo_F {
    };

    class O_Truck_02_Repair_F : O_Truck_02_Ammo_F {
    };

    class O_Truck_02_transport_F {
        side = "EAST";
    };

    class O_Truck_02_covered_F : O_Truck_02_transport_F {
    };

    class Truck_03_base_F : Truck_01_base_F {
        side = "EAST";
    };

    class O_Truck_03_Ammo_F : B_Truck_01_Ammo_F {
    };

    class O_Truck_03_box_F : O_Truck_02_Ammo_F {
        constructionVehicle = 1;
        supplyCapacity = S_CAP_CONSTRUCTION_TRUCK;
        supplyType[] = {"Medical", "Ammo"};
    };

    class O_Truck_03_fuel_F : O_Truck_02_Ammo_F {
    };

    class O_Truck_03_medical_F : O_Truck_02_Ammo_F {
    };

    class O_Truck_03_Repair_F : O_Truck_02_Ammo_F {
    };

    // MRAPs
    class MRAP_01_base_F : defaultVehicle {
        side = "WEST";
        cargoCapacity = 20;
        respawnTime = 300;
        ticketValue = T_MRAP;
        supplyType[] = {"Medical", "AmmoInfantery"};
        supplyCapacity = S_CAP_CAR;
    };

    class MRAP_01_hmg_base_F {
        ticketValue = T_MRAP_HMG;
    };

    class MRAP_01_gmg_base_F {
        ticketValue = T_MRAP_GMG;
    };


    class MRAP_02_base_F : MRAP_01_base_F {
        side = "EAST";
    };

    class MRAP_02_hmg_base_F : MRAP_01_hmg_base_F {
    };

    class MRAP_02_gmg_base_F : MRAP_01_hmg_base_F  {
    };

    class MRAP_03_base_F : MRAP_01_base_F {
        side = "GUER";
    };

    class MRAP_03_hmg_base_F : MRAP_01_hmg_base_F {
    };

    class MRAP_03_gmg_base_F : MRAP_01_hmg_base_F  {
    };


    // Tanks
    class MBT_01_base_F : defaultVehicle {
        side = "WEST";
        cargoCapacity = 10;
        respawnTime = 600;
        ticketValue = T_MBT;
    };

    class MBT_02_base_F : MBT_01_base_F {
        side = "EAST";
    };

    class MBT_03_base_F : MBT_01_base_F {
        side = "GUER";
    };

    // APCs
    class APC_Wheeled_01_base_F : defaultVehicle {
        side = "WEST";
        cargoCapacity = 25;
        respawnTime = 420;
        ticketValue = T_APC_WHEELED;
        supplyType[] = {"Medical", "AmmoInfantery"};
        supplyCapacity = S_CAP_CAR;
    };

    class APC_Wheeled_02_base_F : APC_Wheeled_01_base_F {
        side = "EAST";
    };

    class APC_Wheeled_03_base_F : APC_Wheeled_01_base_F {
        side = "GUER";
    };

    class APC_Tracked_01_base_F : APC_Wheeled_01_base_F {
        ticketValue = T_APC_TRACKED;
    };

    class APC_Tracked_02_base_F : APC_Wheeled_01_base_F {
        side = "EAST";
    };

    class APC_Tracked_03_base_F : APC_Wheeled_01_base_F {
        side = "GUER";
    };

    // Helicopters
    // WEST
    class Heli_Attack_01_base_F : defaultVehicle { //AH-99 Blackfoot
        side = "WEST";
        respawnTime = 600;
        ticketValue = T_HELI_ATTACK;
    };

    class Heli_Light_01_base_F : Heli_Attack_01_base_F { //MH-9 Hummingbird
        cargoCapacity = 15;
        respawnTime = 300;
        ticketValue = T_HELI_LIGHT;
    };

    class Heli_Light_01_armed_base_F : Heli_Light_01_base_F { //MH-9 Pawnee
        cargoCapacity = 0;
        respawnTime = 420;
        ticketValue = T_HELI_LIGHT_ARMED;
    };

    class Heli_Transport_01_base_F : Heli_Attack_01_base_F { //UH-80 Ghost Hawk
        cargoCapacity = 50;
        respawnTime = 300;
        ticketValue = T_HELI_TRANSPORT_ARMED;
    };

    class Heli_Transport_03_base_F : Heli_Attack_01_base_F { // CH-67 Huron
        cargoCapacity = 100;
        respawnTime = 420;
        ticketValue = T_HELI_TRANSPORT;
    };

    // EAST
    class Heli_Attack_02_base_F : defaultVehicle { //Mi-48 Kajman
        cargoCapacity = 25;
        side = "EAST";
        respawnTime = 600;
        ticketValue = T_HELI_ATTACK;
    };

    class Heli_Light_02_base_F : Heli_Attack_02_base_F { //PO-30 Orca
        cargoCapacity = 50;
        respawnTime = 420;
        ticketValue = T_HELI_LIGHT_ARMED;
    };

    class Heli_Light_02_unarmed_base_F : Heli_Light_02_base_F { //PO-30 Orca (unarmed)
        respawnTime = 300;
        ticketValue = T_HELI_LIGHT;
    };

    class Heli_Transport_04_base_F : Heli_Attack_02_base_F { //Mi-290 Taru
        respawnTime = 420;
        ticketValue = T_HELI_TRANSPORT;
    };

    class O_Heli_Transport_04_covered_F : Heli_Transport_04_base_F { //Mi-290 Taru (Transport)
        cargoCapacity = 50;
    };

    class O_Heli_Transport_04_box_F : Heli_Transport_04_base_F { //Mi-290 Taru (Cargo)
        cargoCapacity = 100;
    };


    //GUER
    class Heli_Transport_02_base_F : defaultVehicle { //CH-49 Mohawk
        side = "GUER";
        cargoCapacity = 70;
        respawnTime = 420;
        ticketValue = T_HELI_TRANSPORT;
    };

    class Heli_light_03_base_F : Heli_Transport_02_base_F { //WY-55 Hellcat
        cargoCapacity = 40;
        respawnTime = 420;
        ticketValue = T_HELI_LIGHT_ARMED;
    };

    class Heli_light_03_unarmed_base_F : Heli_light_03_base_F { //WY-55 Hellcat (unarmed)
        cargoCapacity = 50;
        respawnTime = 300;
        ticketValue = T_HELI_LIGHT;
    };

    // Planes
    // WEST
    class Plane_CAS_01_base_F : defaultVehicle { //A-164 Wipeout
        side = "WEST";
        respawnTime = 600;
        ticketValue = T_PLANE_CAS;
    };

    class Plane_Fighter_01_Base_F : Plane_CAS_01_base_F { //F/A-181 Black Wasp II
        ticketValue = T_PLANE_FIGHTER;
    };

    // EAST
    class Plane_CAS_02_base_F : defaultVehicle { //To-199 Neophron
        side = "EAST";
        respawnTime = 600;
        ticketValue = T_PLANE_CAS;
    };

    class Plane_Fighter_02_Base_F : Plane_CAS_02_base_F { //To-201 Shikra
        ticketValue = T_PLANE_FIGHTER;
    };

    //GUER
    class Plane_Fighter_03_base_F : defaultVehicle { //A-143 Buzzard
        side = "GUER";
        respawnTime = 600;
        ticketValue = T_PLANE_FIGHTER;
    };

    class I_Plane_Fighter_03_CAS_F : Plane_Fighter_03_base_F { //A-143 Buzzard (CAS)
        ticketValue = T_PLANE_CAS;
    };

    class Plane_Fighter_04_Base_F : Plane_Fighter_03_base_F { //A-149 Gryphon
    };

	//VTOL
	//WEST
    class VTOL_01_unarmed_base_F : defaultVehicle { //V-44 X Blackfish
        side = "WEST";
		cargoCapacity = 100;
        respawnTime = 420;
        ticketValue = T_VTOL_TRANSPORT;
    };

    class VTOL_01_armed_base_F : VTOL_01_unarmed_base_F { //V-44 X Blackfish (Armed)
		respawnTime = 600;
        ticketValue = T_VTOL_ARMED;
    };

    // EAST
    class VTOL_02_vehicle_base_F : defaultVehicle { //Y-32 Xi'an
        side = "EAST";
		cargoCapacity = 100;
        respawnTime = 600;
        ticketValue = T_VTOL_ARMED;
    };

    /*
    Vehicle Config IFA3
    */
    /*
    Vehicle Config
    */
    // TRUCKS
    class LIB_Truck_base {
        side = "WEST";
        cargoCapacity = 50;
        respawnTime = 180;
        ticketValue = T_TRUCK_TRANSPORT;
    };

    class LIB_Scout_M3_base : LIB_Truck_base {
        side = "GUER";
    };

    class LIB_US_GMC_Base : LIB_Truck_base {
        side = "GUER";
    };


    // MRAPs
    class LIB_Car_base : defaultVehicle {
        side = "WEST";
        cargoCapacity = 20;
        respawnTime = 300;
        ticketValue = T_MRAP;
    };

    class LIB_Willys_MB_base : LIB_Car_base {
        side = "GUER";
    };
};
