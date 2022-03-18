#if defined _hype_included
    #endinput
#endif
#define _hype_included

/* ─────────────────────DEFINITIONS──────────────────── */

// META

#define HP_PLUG "[HYPE] "
#define HP_WEB "https://hypesrv.com"
#define HP_URL "https://discord.gg/hypesrv"
#define HP_STEAM "https://steamcommunity.com/groups/hypesrv"

// CHAT & MENUS

#define TAG_MENU "HYPE | "

#define TAG_CLR " \x0BHype〡"
#define TAG_NCLR "[HYPE]"
#define TAG_CONSOLE "[{LIGHTBLUE}HYPE{DEFAULT}"

// Coding

#define MAX_STRING_LENGTH 250
/* ───────────────────────STOCKS─────────────────────── */

/**
* Checks if the specified client index is valid or not.
*
* @param iClient			An entity index
* @param bAllowBots			Set Bots to be accepted or not. Default: False
* @return					Returns true if the specified entity index is a player connected, false otherwise.
*/
stock bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

/**
* Gets a real random integer.
*
* @param iMin				Minimum number value
* @param iMin				Maximum number value
* @return					Returns a true random value from iMin to iMax.
*/
stock int TryRandomInt(int iMin, int iMax) {

    int iRandom = GetURandomInt();

    if (iRandom == 0) iRandom++;

    return RoundToCeil(float(iRandom) / (float(2147483647) / float(iMax - iMin + 1))) + iMin - 1;
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
	char szOutput[PLATFORM_MAX_PATH];
	VFormat(szOutput, sizeof(szOutput), szMessage, 2);

	for (int i = 0; i < sizeof(szConsoleColoursTags); i++)
	{
		ReplaceString(szOutput, 250, szConsoleColoursTags[i], szConsoleColoursCodes[i]);
	}

	PrintToServer(szOutput);
}
