#include <sourcemod>
#include <hype/punishments>
#include <hype>

#pragma dynamic 0
#pragma semicolon 1
#pragma newdecls required

public void OnPluginStart()
{
    RegConsoleCmd("sm_ban_test", Command_BanTest);
}

public Action Command_BanTest(int iClient, int iArgs)
{
    HP_PunishPlayer(iClient, 0, "laggin ass jhhit", view_as<int>(k_EPunishmentTimeWeek), view_as<int>(k_EPunishmentTypeBan));
    return Plugin_Handled;
}