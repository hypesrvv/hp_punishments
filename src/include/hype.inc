#if defined _hypesrv_included
    #endinput
#endif
#define _hypesrv_included

#if !defined RSVP_COMPILER
	#define decl static
#endif

#pragma newdecls required

/* ─────────────────────DEFINITIONS──────────────────── */

// META INFORMATION

#define HP_PLUG   "[HS] "

#define HP_AUTHOR "HypeSRV"
#define HP_WEB    "https://hypesrv.com"
#define HP_URL    "https://discord.gg/hypesrv"
#define HP_STEAM  "https://steamcommunity.com/groups/hypesrv"
#define HP_EMAIL  "Support@hypesrv.com"

// CHAT / MENU / CONSOLE

#define TAG_HYPESRV_MENU    "HypeSRV | "
#define TAG_HYPESRV_CLR     " \x0BHypeSRV〡"
#define TAG_HYPESRV_NCLR    "[HypeSRV]"
#define TAG_HYPESRV_CONSOLE "[{LIGHTBLUE}HypeSRV{DEFAULT}]"

// Coding

#define MAX_STRING_LENGTH 1024
#define HYPESRV_IP "104.243.41.150"

stock char g_szTagConsole[78];
stock char g_szPluginName[78];
stock void OnHypeSRVInit()
{
	GetPluginFilename(GetMyHandle(), g_szTagConsole, sizeof(g_szTagConsole));
	g_szTagConsole[FindCharInString(g_szTagConsole, '.')] = '\0';
	strcopy(g_szPluginName, sizeof(g_szPluginName), g_szTagConsole);
	Format(g_szTagConsole, sizeof(g_szTagConsole), TAG_HYPESRV_CONSOLE ... " '{LIME_BOLD}%s{DEFAULT}'", g_szTagConsole);
}

/* ───────────────────────STOCKS─────────────────────── */

/**
 * Gets a real random integer.
 *
 * @param iMin				Minimum number value
 * @param iMin				Maximum number value
 *
 * @return					Returns a true random value from iMin to iMax.
 */
stock int TryRandomInt(int iMin, int iMax)
{
    int iRandom = GetURandomInt();

    if (iRandom == 0) iRandom++;

    return RoundToCeil(float(iRandom) / (float(2147483647) / float(iMax - iMin + 1))) + iMin - 1;
}

/**
 * Gets the ip address of the server.
 *
 * @param bPort				Boolean value to include port
 *
 * @return					Returns char string with ip.
 */
stock char[] GetServerIP(bool bPort = false)
{
    decl char szNetIP[32];

    if (bPort)
        FormatEx(szNetIP, sizeof(szNetIP), HYPESRV_IP ... ":%i", FindConVar("hostport").IntValue);
    else
        strcopy(szNetIP, sizeof(szNetIP), HYPESRV_IP);

    return szNetIP;
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

stock void CPrintToServer(char[] szMessage, any ...)
{
	decl char szOutput[MAX_STRING_LENGTH];
	VFormat(szOutput, sizeof(szOutput), szMessage, 2);

	for (int i = 0; i < sizeof(szConsoleColoursTags); i++)
		ReplaceString(szOutput, sizeof(szOutput), szConsoleColoursTags[i], szConsoleColoursCodes[i]);

	PrintToServer(szOutput);
}

stock void LogDebug(const char[] szMessage, any ...)
{
	decl char szTime[48];
	decl char szPath[PLATFORM_MAX_PATH];
	decl char szBuffer[MAX_STRING_LENGTH];

	VFormat(szBuffer, sizeof(szBuffer), szMessage, 2);

	BuildPath(Path_SM, szPath, sizeof(szPath), "logs/%s.log", g_szPluginName);

	Format(szBuffer, sizeof(szBuffer), "%s {GREY}%s", g_szTagConsole, szBuffer);

	CPrintToServer(szBuffer);

	FormatTime(szTime, sizeof(szTime), "L %Y/%m/%d - %I:%M:%S ");
	Format(szBuffer, sizeof(szBuffer), "%s%s", szTime, szBuffer);

	for (int i = 0; i < sizeof(szConsoleColoursCodes); i++)
		ReplaceString(szBuffer, sizeof(szBuffer), szConsoleColoursTags[i], NULL_STRING);

	File hFile = OpenFile(szPath, "a+");
	hFile.WriteLine(szBuffer);
	hFile.Flush();

	delete hFile;
}

/**
 * Wraps ProcessTargetString()
 *
 * @param iClient        Client who issued command
 * @param szTarget       Client's target argument
 * @param bNoBots        Optional. Set to true if bots should NOT be targetted
 * @param bImmunity      Optional. Set to false to ignore target immunity.
 * @return               Index of target client, or -1 on error.
 */
stock int FindPlayer(const int iClient, const char[] szTarget, bool bNoBots = false, bool bImmunity = true)
{
	decl char szTargetName[MAX_TARGET_LENGTH];
	int iTargetList[1], iTargetCount;
	bool bTnIsMl;

	int iFlags = COMMAND_FILTER_NO_MULTI;
	if (bNoBots)
		iFlags |= COMMAND_FILTER_NO_BOTS;

	if (!bImmunity)
		iFlags |= COMMAND_FILTER_NO_IMMUNITY;

	if ((iTargetCount = ProcessTargetString(
			szTarget,
			iClient,
			iTargetList,
			1,
			iFlags,
			szTargetName,
			sizeof(szTargetName),
			bTnIsMl)) > 0)
	{
		return iTargetList[0];
	}

	return -1;
}

stock bool IsClientDonor(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_RESERVATION));
}

stock bool IsClientAdmin(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_BAN));
}

stock bool IsClientOwner(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_ROOT));
}

stock bool IsClientStaff(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & (ADMFLAG_KICK|ADMFLAG_BAN|ADMFLAG_ROOT)));
}

stock char[] HPMenuTag(int iLen)
{
	decl char szLine[48];

	for (int i = 0; i <= iLen; i++)
		StrCat(szLine, sizeof(szLine), "—");

	return szLine;
}
