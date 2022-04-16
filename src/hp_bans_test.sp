#include <sourcemod>
#include <hype/bans>
#include <hype>

public void OnPluginStart()
{
    RegConsoleCmd("sm_ban_test", Command_BanTest);
}

public Action Command_BanTest(int iClient, int iArgs)
{
    HP_PunishPlayer(GetClientUserId(iClient), GetClientUserId(iClient), "Mega Loser", _, view_as<int>(k_EPunishmentTypeBan));
    return Plugin_Handled;
}