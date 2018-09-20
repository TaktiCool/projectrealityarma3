class CfgCLibLoadoutsClassBase;

class AAW_AmmoBox {
    ammoBox[] = {150,150};
};

class A3_BasicItems : CfgCLibLoadoutsClassBase {
    linkedItems[] = {"ItemWatch", "ItemCompass", "ItemRadio", "ItemMap", "ItemGPS"};
};

class A3_StandardMedicals : CfgCLibLoadoutsClassBase {
    items[] = {{"FirstAidKit",2}};
};

class A3_MedicClassMedicals : CfgCLibLoadoutsClassBase {
    class StandardMedicals : A3_StandardMedicals {};
    items[] = {{"FirstAidKit",2}, "Medikit"};
};

class A3_StandardGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"HandGrenade",1}, {"SmokeShell", 2}};
};

class A3_SignalGrenades : CfgCLibLoadoutsClassBase {
    items[] = {{"SmokeShellRed",1}, {"SmokeShellGreen",1}};
};

class A3_GrenadierGrenades : CfgCLibLoadoutsClassBase {
    class StandardGrenades : A3_StandardGrenades {};
    items[] = {"HandGrenade", {"1Rnd_HE_Grenade_shell", 6}, {"1Rnd_HE_Grenade_shell", 3}};
};

class A3_StandardSoldier : CfgCLibLoadoutsClassBase {
    class MedicalsClass : A3_StandardMedicals {};
    class GrenadesClass : A3_StandardGrenades {};
    class BasicItemsClass : A3_BasicItems {};
};

class IFA3_BasicItems : CfgCLibLoadoutsClassBase {
    linkedItems[] = {"ItemWatch", "ItemCompass", "ItemMap"};
};

class IFA3_StandardSoldier : CfgCLibLoadoutsClassBase {
    class MedicalsClass : A3_StandardMedicals {};
    class GrenadesClass : A3_StandardGrenades {};
    class BasicItemsClass : IFA3_BasicItems {};
};

#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\AAF.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\CSAT.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\CSAT_Tropic.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\NATO.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\NATO_Tropic.hpp"

#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\IFA3_GER.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\IFA3_RUS.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\IFA3_UK.hpp"
#include "\tc\AAW\addons\AAW_Server\Kit\Loadouts\IFA3_US.hpp"
