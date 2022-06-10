#if defined _HP_MODULE_SERVER_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_SERVER_INCLUDED_

stock char g_szTagConsole[78];
stock char g_szPluginName[78];
stock void OnHypeSRVInit()
{
	GetPluginFilename(GetMyHandle(), g_szTagConsole, sizeof(g_szTagConsole));
	g_szTagConsole[FindCharInString(g_szTagConsole, '.')] = '\0';
	strcopy(g_szPluginName, sizeof(g_szPluginName), g_szTagConsole);
	Format(g_szTagConsole, sizeof(g_szTagConsole), TAG_HYPESRV_CONSOLE ... " '{LIME_BOLD}%s{DEFAULT}'", g_szTagConsole);
}

stock int HP_GetServerID()
{
	return GetCommandLineParamInt("-sid");
}

stock char[] GetServerIP(bool bPort = false)
{
    decl char szNetIP[32];

    if (bPort)
        FormatEx(szNetIP, sizeof(szNetIP), HYPESRV_IP ... ":%i", FindConVar("hostport").IntValue);
    else
        strcopy(szNetIP, sizeof(szNetIP), HYPESRV_IP);

    return szNetIP;
}

stock int HP_GetClientCount(bool bAllowConnecting = false, bool bAllowBots = false, bool bAllowDead = true)
{
	int iCount;
	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (!IsClientConnected(iClient))
			continue;

		if (!bAllowConnecting && !IsClientInGame(iClient))
			continue;

		if (!bAllowBots && IsFakeClient(iClient))
			continue;

		if (!bAllowDead && !IsClientAlive(iClient))
			continue;

		iCount++;
	}

	return iCount;
}

stock int HP_GetTeamClientCount(int iTeam, bool bAllowBots = false, bool bAllowDead = true)
{
	int iCount;

	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (!IsClientInGame(iClient) || GetClientTeam(iClient) != iTeam)
			continue;

		if (!bAllowBots && IsFakeClient(iClient))
			continue;

		if (!bAllowDead && !IsClientAlive(iClient))
			continue;

		iCount++;
	}

	return iCount;
}

stock void HP_ReloadTranslations()
{
	ServerCommand("sm_reload_translations");
}