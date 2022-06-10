#include <sourcemod>
#include <DateTime>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <anymap>
#include <ripext>
#include <PTaH>
#include <regex>
#include <hypesrv>
#include <hypesrv/plugin/core>
#include <hypesrv/plugin/punishments>

#if !defined RSVP_COMPILER
	#define decl static
#endif

#define DEBUG
#define MAX_NAME_TRIM 16

#define TAG_BANS_CONSOLE "[{GREEN}PUNISHMENTS{WHITE}]"
#define TAG_BANS " \x0FPunishments〡"

#define TIME_HOUR  1
#define TIME_DAY   24
#define TIME_MONTH 730

#define REGEX_DAY "d|day|days|"
#define REGEX_MONTH "m|mo|month|months|"
#define REGEX_HOUR "h|hr|hour|hours"

#define PUNISHMENT_FOOTER "\n\nWebsite: " ... HP_WEB ... "\nDiscord: " ... HP_URL ... "\nEmail: " ... HP_EMAIL

#define MAX_PUNISHMENTS_LENGTH 128

#define UNIX_TIMEZONE "-0400"

#define MAX_REASON_LEGNTH 128

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
	author  = HP_AUTHOR,
	version = "0.5",
	url     = HP_URL
}

public void OnPluginStart()
{
	OnHypeSRVInit();

	// HookEvent("player_spawn", Event_OnPlayerSpawn);

	RegAdminCmd("sm_admin", Command_Admin, ADMFLAG_BAN);
	RegAdminCmd("sm_ban", Command_Ban, ADMFLAG_BAN);

	PTaH(PTaH_ClientVoiceToPre, Hook, Event_OnPlayerVoice);
}

public APLRes AskPluginLoad2(Handle hMySelf, bool bLate, char[] szError, int iLength)
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

// public void Event_OnPlayerSpawn(Event hEvent, const char[] szName, bool bHush)
// {
// 	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));

// 	if (IsFakeClient(iClient))
// 		return;


// }

public Action Command_Admin(int iClient, int iArgs)
{
	DisplayAdminMenu(iClient);

	return Plugin_Handled;
}

public void HP_OnClientConnected(int iUserID)
{
	int iClient = GetClientOfUserId(iUserID);

	if (HP_IsClientStaff(iClient))
		g_ETarget[iClient].Clear();

	g_EUser[iClient].Init(iClient);

	UpdateClientPunishments(iClient);
}

public void OnClientDisconnect(int iClient)
{
	if (HP_IsClientStaff(iClient))
		g_ETarget[iClient].Clear();

	g_EUser[iClient].Clear();
}

public Action Command_Ban(int iClient, int iArgs)
{
	if (iArgs < 2)
	{
		DisplayPunishMenu(iClient);

		return Plugin_Handled;
	}

	int iTarget;
	int iCaptures;
	int iBanLength;
	decl char szTarget[32];
	decl char szReason[64];
	decl char szBanNumber[5];
	decl char szBanPeriod[4];
	decl char szArguments[128];

	// static const char szDay[][]   = { "d", "day", "days" };
	// static const char szMonth[][] = { "m", "month", "mo", "months" };
	// static const char szHour[][]  = { "h", "hour", "hr", "hours" };

	GetCmdArgString(szArguments, sizeof(szArguments));

	Regex hRegex = new Regex("^([\\w\\d]+)\\s([1-9][0-9]{0,1})(" ... REGEX_DAY ... REGEX_MONTH ... REGEX_HOUR ... ")\\s(.*)$", PCRE_CASELESS);

	iCaptures = hRegex.Match(szArguments);

	hRegex.GetSubString(1, szTarget, sizeof(szTarget), 0);
	hRegex.GetSubString(2, szBanNumber, sizeof(szBanNumber), 0);
	iBanLength = StringToInt(szBanNumber);
	hRegex.GetSubString(3, szBanPeriod, sizeof(szBanPeriod), 0);

	if (iCaptures == 5)
		hRegex.GetSubString(4, szReason, sizeof(szReason), 0);

	DateTime dTime = new DateTime(DateTime_Now);

	switch (szBanPeriod[1])
	{
		case 'd': dTime += TimeSpan.FromDays(iBanLength);
		case 'm': dTime += TimeSpan.FromHours(iBanLength * TIME_MONTH);
		case 'h': dTime += TimeSpan.FromHours(iBanLength);
	}

	// for (int i = 0; i < sizeof(szDay); i++)
	// {
	// 	if (!strcmp(szBanPeriod, szDay[i], false))
	// 	{
	// 		dTime += TimeSpan.FromDays(iBanLength);
	// 		break;
	// 	}
	// }

	// for (int i = 0; i < sizeof(szMonth); i++)
	// {
	// 	if (!strcmp(szBanPeriod, szMonth[i], false))
	// 	{
	// 		dTime += TimeSpan.FromHours(iBanLength * TIME_MONTH);
	// 		break;
	// 	}
	// }

	// for (int i = 0; i < sizeof(szHour); i++)
	// {
	// 	if (!strcmp(szBanPeriod, szHour[i], false))
	// 	{
	// 		dTime += TimeSpan.FromHours(iBanLength);
	// 		break;
	// 	}
	// }

	iTarget = FindTarget(iClient, szTarget, false, false);

	if (!IsClientConnected(iTarget))
	{
		PrintToChat(iClient, "%s\x08Client \"\x04%s\x08\" not found or has been disconected", TAG_HYPESRV_CLR, szTarget);
		return Plugin_Handled;
	}

	Punish(iTarget).Execute(iClient, szReason, dTime.Unix, view_as<int>(k_EPunishmentTypeBan));

	delete hRegex;

	return Plugin_Handled;
}

public Action OnClientSayCommand(int iClient, const char[] szCommand, const char[] szArgs)
{
	if (g_EUser[iClient].bIsGagged || g_EUser[iClient].bIsSilenced)
		return Plugin_Handled;

	return Plugin_Continue;
}

public void OnClientSayCommand_Post(int iClient, const char[] szCommand, const char[] szArgs)
{
	if (g_ETarget[iClient].bOwnReason)
	{
		if (!strncmp(szArgs, "!abort", 6, false))
		{
			PrintToChatAll("aborted!");
			g_ETarget[iClient].bOwnReason = false;
		}

		strcopy(g_ETarget[iClient].szReason, sizeof(ETarget::szReason), szArgs);
	}
}

public Action Event_OnPlayerVoice(int iClient, int iTarget, bool &bListen)
{
	if (g_EUser[iClient].bIsMuted || g_EUser[iClient].bIsSilenced)
		return Plugin_Handled;

	return Plugin_Continue;
}

// subtract 250 from string
