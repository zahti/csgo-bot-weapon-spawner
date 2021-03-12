#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

ConVar g_cvEnabled;
ConVar g_cvWeapon;

char WeaponList[][] = //From advadmin
{
    "c4", "knife", "knifegg", "taser", "healthshot", //misc
    "decoy", "flashbang", "hegrenade", "molotov", "incgrenade", "smokegrenade", "tagrenade", //grenades
    "usp_silencer", "glock", "tec9", "p250", "hkp2000", "cz75a", "deagle", "revolver", "fiveseven", "elite", //pistoles
    "nova", "xm1014", "sawedoff", "mag7", "m249", "negev", //heavy
    "mp9", "mp7", "ump45", "p90", "bizon", "mac10", "mp5sd", //smgs
    "ak47", "aug", "famas", "sg556", "galilar", "m4a1", "m4a1_silencer", //rifles
    "awp", "ssg08", "scar20", "g3sg1" //snipers
};

public Plugin myinfo = 
{
    name = "Bot Weapon Spawner",
    author = "Zahti,LuqS,Cruze",
    description = "Forces all bots to get a specific weapon.",
    version = "1.0.1",
    url = "https://github.com/zahti/csgo-bot-weapon-spawner"
};

public void OnPluginStart()
{
    // Not gonna waste time :D //
    if(GetEngineVersion() != Engine_CSGO) 
        SetFailState("This plugin is for CSGO only.");
        
    g_cvEnabled = CreateConVar("bws_enabled", "1", "Disable [0] or Enable [1] the plugin. Default [1]");
    g_cvWeapon = CreateConVar("bws_weapon", "ak47", "Specify which weapon all of the bots are given. Do not include the 'weapon_' string. Default [ak47]");
    
    HookEvent("player_spawn", Event_PlayerSpawn);
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if(g_cvEnabled.BoolValue && IsFakeClient(client) && IsPlayerAlive(client))
    {
        char weapon[32];
        g_cvWeapon.GetString(weapon, sizeof(weapon));
        Format(weapon, sizeof(weapon), "weapon_%s", weapon);
        
        if(!GivePlayerWeapon(client, weapon))
            PrintToServer("Failed to give %N weapon - %s", client, weapon);
    }
}
int GivePlayerWeapon(int client, char[] weapon)
{
    for(int i = 0; i < sizeof(WeaponList); i++)
    {
             if(StrEqual(weapon[7], WeaponList[i], false))
             {
                     GivePlayerItem(client, weapon);
                     return 1;
             }
    }
    return -1;
} 