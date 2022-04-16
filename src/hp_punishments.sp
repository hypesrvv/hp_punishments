#include <sourcemod>
#include <DateTime>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <ripext>
#include <regex>
#include <hype/core>
#include <hype/punishments>
#include <hype>

#if !defined RSVP_COMPILER
	#define decl static
#endif

#define DEBUG
#define MAX_NAME_TRIM 16

#define TAG_BANS_CONSOLE "[{GREEN}BANS{WHITE}]"
#define TAG_BANS " \x0FBans〡"

#define TIME_HOUR  1
#define TIME_DAY   24
#define TIME_MONTH 730

#define REGEX_DAY "d|day|days|"
#define REGEX_MONTH "m|mo|month|months|"
#define REGEX_HOUR "h|hr|hour|hours"

#define API_ENDPOINT "http://73.139.147.98:3000/private"
#define ACCESS_TOKEN "YQ3J9s8pqnfrwQGJAeCjRNd4Bc6mWpPj"

#pragma dynamic 0
#pragma semicolon 1
#pragma newdecls required

#include <files/globals.sp>
#include <files/stocks.sp>
#include <files/natives.sp>
#include <files/menus.sp>
#include <files/rest.sp>

public Plugin myinfo =
{
	name    = HP_PLUG ... "Punishments",
	author  = "DRANIX",
	version = "0.2",
	url     = HP_URL
}

public void OnPluginStart()
{
	RegAdminCmd("sm_admin", Command_Admin, ADMFLAG_BAN);
	RegAdminCmd("sm_ban", Command_Ban, ADMFLAG_BAN);
}

public APLRes AskPluginLoad2(Handle hSelf, bool bLate, char[] szError, int iLength)
{
	if (GetEngineVersion() != Engine_CSGO)
	{
		strcopy(szError, iLength, "This plugin works only on CS:GO");

		return APLRes_Failure;
	}

	Core.fOnPlayerPunished = CreateGlobalForward("HP_OnClientPunished", ET_Ignore, Param_Cell, Param_Cell, Param_String, Param_String, Param_Cell);

	CreateNative("HP_PunishPlayer", Native_PunishPlayer);

	RegPluginLibrary("Punishments");

	return APLRes_Success;
}

public Action Command_Admin(int iClient, int iArgs)
{
	DisplayAdminMenu(iClient);

	return Plugin_Handled;
}

public Action Command_Ban(int iClient, int iArgs)
{
	if (iArgs < 2)
	{
		DisplayBanMenu(iClient);

		return Plugin_Handled;
	}

	decl char szArguments[128];

	static const char szDay[][]   = { "d", "day", "days" };
	static const char szMonth[][] = { "m", "month", "mo", "months" };
	static const char szHour[][]  = { "h", "hour", "hr", "hours" };

	GetCmdArgString(szArguments, sizeof(szArguments));

	Regex hRegex = new Regex("^([\\w\\d]+)\\s([1-9][0-9]{0,1})(" ... REGEX_DAY ... REGEX_MONTH ... REGEX_HOUR ... ")\\s(.*)$", PCRE_CASELESS);

	int iCaptures = hRegex.Match(szArguments);

	if (iCaptures == -1)
	{
		ReplyToCommand(iClient, "[SM] Invalid arguments");
		return Plugin_Handled;
	}

	decl char szTarget[32];
	hRegex.GetSubString(1, szTarget, sizeof(szTarget), 0);

	decl char szBanNumber[5];
	hRegex.GetSubString(2, szBanNumber, sizeof(szBanNumber), 0);
	int iBanNumber = StringToInt(szBanNumber);

	decl char szBanPeriod[4];
	hRegex.GetSubString(3, szBanPeriod, sizeof(szBanPeriod), 0);

	decl char szReason[64];
	if (iCaptures == 5)
	{
		hRegex.GetSubString(4, szReason, sizeof(szReason), 0);
	}

	DateTime dTime = new DateTime(DateTime_Now);

	for (int i = 0; i < sizeof(szDay); i++)
	{
		if (!strcmp(szBanPeriod, szDay[i], false))
		{
			dTime += TimeSpan.FromDays(iBanNumber);
			break;
		}
	}

	for (int i = 0; i < sizeof(szMonth); i++)
	{
		if (!strcmp(szBanPeriod, szMonth[i], false))
		{
			dTime += TimeSpan.FromHours(iBanNumber * TIME_MONTH);
			break;
		}
	}

	for (int i = 0; i < sizeof(szHour); i++)
	{
		if (!strcmp(szBanPeriod, szHour[i], false))
		{
			dTime += TimeSpan.FromHours(iBanNumber);
			break;
		}
	}

	HYPPunish(GetClientUserId(FindTarget(iClient, szTarget, false, false))).Form(GetClientUserId(iClient), szReason, dTime.Unix);

	delete hRegex;

	return Plugin_Handled;
}

// public void OnClientSayCommand_Post(int iClient, const char[] szCommand, const char[] szArgs)
// {
// 	if (g_bOwnReason[iClient])
// 	{
// 		if (!strncmp(szArgs, "!abort", 6, false))
// 		{
// 			PrintToChatAll("aborted!");
// 			g_bOwnReason[iClient] = false;
// 		}

// 		strcopy(g_szOwnReason, sizeof(g_szOwnReason), szArgs);
// 	}
// }

// subtract 250 from string
