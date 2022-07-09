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
	return GetCommandLineParamInt("-sid", -1);
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

stock int GetClientCounts(bool bAllowBots = false, bool bAllowDead = true)
{
	int iCount;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientConnected(i))
			continue;

		if (!bAllowBots && IsFakeClient(i))
			continue;

		if (!bAllowDead && !IsClientAlive(i))
			continue;

		iCount++;
	}

	return iCount;
}

stock int GetTeamClientCounts(int iTeam, bool bAllowBots = false, bool bAllowDead = true)
{
	int iCount;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || GetClientTeam(i) != iTeam)
			continue;

		if (!bAllowBots && IsFakeClient(i))
			continue;

		if (!bAllowDead && !IsClientAlive(i))
			continue;

		iCount++;
	}

	return iCount;
}

stock void RestartServer()
{
	ServerCommand("_restart");
}

stock void ReloadTranslations()
{
	ServerCommand("sm_reload_translations");
}

stock char szConsoleColoursTags[][] =
{
	// Styles

	"{BRIGHT}",
	"{DIM}",
	"{UNDERSCORE}",
	"{BLINK}",
	"{REVERSE}",
	"{HIDDEN}",

	// Colors

	"{NORMAL}",
	"{DEFAULT}",
	"{BLACK}",
	"{RED}",
	"{GREEN}",
	"{YELLOW}",
	"{BLUE}",
	"{PURPLE}",
	"{CYAN}",
	"{GREY}",
	"{DARKGREY}",
	"{PINK}",
	"{LIME}",
	"{ORANGE}",
	"{LIGHTBLUE}",
	"{PURPLE}",
	"{TEAL}",
	"{WHITE}",

	"{BLACK_BOLD}",
	"{RED_BOLD}",
	"{GREEN_BOLD}",
	"{YELLOW_BOLD}",
	"{BLUE_BOLD}",
	"{PURPLE_BOLD}",
	"{CYAN_BOLD}",
	"{GREY_BOLD}",
	"{DARKGREY_BOLD}",
	"{PEACH_BOLD}",
	"{LIME_BOLD}",
	"{ORANGE_BOLD}",
	"{LIGHTBLUE_BOLD}",
	"{MAGENTA_BOLD}",
	"{TEAL_BOLD}",
	"{WHITE_BOLD}",
};

stock char szConsoleColoursCodes[][] =
{
	// Styles

	"\x1b[1m",
	"\x1b[2m",
	"\x1b[4m",
	"\x1b[5m",
	"\x1b[7m",
	"\x1b[8m",

	// Colors

	"\x1b[0m",
	"\x1b[0m",
	"\x1b[30m",
	"\x1b[31m",
	"\x1b[32m",
	"\x1b[33m",
	"\x1b[34m",
	"\x1b[35m",
	"\x1b[36m",
	"\x1b[37m",
	"\x1b[90m",
	"\x1b[91m",
	"\x1b[92m",
	"\x1b[93m",
	"\x1b[94m",
	"\x1b[95m",
	"\x1b[96m",
	"\x1b[97m",

	"\x1b[1;30m",
	"\x1b[1;31m",
	"\x1b[1;32m",
	"\x1b[1;33m",
	"\x1b[1;34m",
	"\x1b[1;35m",
	"\x1b[1;36m",
	"\x1b[1;37m",
	"\x1b[1;90m",
	"\x1b[1;91m",
	"\x1b[1;92m",
	"\x1b[1;93m",
	"\x1b[1;94m",
	"\x1b[1;95m",
	"\x1b[1;96m",
	"\x1b[1;97m",
};

stock void LogDebug(const char[] szMessage, any ...)
{
	decl char szTime[48];
	decl char szPath[PLATFORM_MAX_PATH];
	decl char szBuffer[MAX_CONSOLE_LENGTH];

	VFormat(szBuffer, sizeof(szBuffer), szMessage, 2);

	BuildPath(Path_SM, szPath, sizeof(szPath), "logs/%s.log", g_szPluginName);

	Format(szBuffer, sizeof(szBuffer), "%s {GREY}%s", g_szTagConsole, szBuffer);

	CPrintToServer(szBuffer);

	FormatTime(szTime, sizeof(szTime), "L %Y/%m/%d - %I:%M:%S ");
	Format(szBuffer, sizeof(szBuffer), "%s%s", szTime, szBuffer);

	for (int i = 0; i < sizeof(szConsoleColoursCodes); i++)
		ReplaceString(szBuffer, MAX_CONSOLE_LENGTH, szConsoleColoursTags[i], NULL_STRING);

	File hFile = OpenFile(szPath, "a+");
	hFile.WriteLine(szBuffer);
	hFile.Flush();

	delete hFile;
}

stock void CPrintToServer(char[] szMessage, any ...)
{
	char szOutput[MAX_CONSOLE_LENGTH];
	VFormat(szOutput, sizeof(szOutput), szMessage, 2);

	for (int i = 0; i < sizeof(szConsoleColoursTags); i++)
		ReplaceString(szOutput, MAX_CONSOLE_LENGTH, szConsoleColoursTags[i], szConsoleColoursCodes[i]);

	PrintToServer(szOutput);
}