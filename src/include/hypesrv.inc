
#if defined _HP_BASE_INCLUDED_
	#endinput
#endif
#define _HP_BASE_INCLUDED_

#if !defined RSVP_COMPILER
	#define decl static
#endif

#pragma semicolon 1
#pragma newdecls required;

#include <sourcemod>
#include <sdktools>

#define HP_PLUG   "[HS] "

#define HP_AUTHOR "HypeSRV"
#define HP_WEB    "https://hypesrv.com"
#define HP_URL    "https://discord.gg/hypesrv"
#define HP_STEAM  "https://steamcommunity.com/groups/hypesrv"
#define HP_EMAIL  "support@hypesrv.com"

#define TAG_HYPESRV_MENU    "HypeSRV | "
#define TAG_HYPESRV_CLR     " \x0BHypeSRV〡"
#define TAG_HYPESRV_NCLR    "[HypeSRV]"
#define TAG_HYPESRV_CONSOLE "[{LIGHTBLUE}HypeSRV{DEFAULT}]"

#define MAX_STRING_LENGTH 1024
#define HYPESRV_IP "104.243.41.150"

#define HYPESRV_API ""
#define HYPESRV_AUTH_TOKEN ""

#if !defined _cstrike_included
	#define CS_TEAM_NONE        0   /* No team yet */
	#define CS_TEAM_SPECTATOR   1   /* Spectators */
	#define CS_TEAM_T           2   /* Terrorists */
	#define CS_TEAM_CT          3   /* Counter-Terrorists */

	#define CS_SLOT_PRIMARY     0   /* Primary weapon slot */
	#define CS_SLOT_SECONDARY   1   /* Secondary weapon slot */
	#define CS_SLOT_KNIFE       2   /* Knife slot */
	#define CS_SLOT_GRENADE     3   /* Grenade slot (will only return one grenade) */
	#define CS_SLOT_C4          4   /* C4 slot */
	#define CS_SLOT_BOOST       11  /* Slot for healthshot and shield (will only return one weapon/item) */
	#define CS_SLOT_UTILITY     12  /* Slot for tablet */
#endif

#include <hypesrv/variable/bit>
#include <hypesrv/variable/float>
#include <hypesrv/variable/int>
#include <hypesrv/variable/random>
#include <hypesrv/variable/strings>

#include <hypesrv/game/game>

#include <hypesrv/command>
#include <hypesrv/entity>
#include <hypesrv/server>
#include <hypesrv/client>
#include <hypesrv/menu>
#include <hypesrv/sound>

 // fix this shit later cause hypesrv work abuse
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
	decl char szOutput[PLATFORM_MAX_PATH];
	VFormat(szOutput, sizeof(szOutput), szMessage, 2);

	for (int i = 0; i < sizeof(szConsoleColoursTags); i++)
		ReplaceString(szOutput, 250, szConsoleColoursTags[i], szConsoleColoursCodes[i]);

	PrintToServer(szOutput);
}

stock void LogDebug(const char[] szMessage, any ...)
{
	decl char szTime[48];
	decl char szPath[PLATFORM_MAX_PATH];
	decl char szBuffer[PLATFORM_MAX_PATH * 2];

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