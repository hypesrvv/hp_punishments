#if defined _HP_GAME_INCLUDED_
	#endinput
#endif
#define _HP_GAME_INCLUDED_

#include <sdktools_gamerules>
#include <cstrike>
#include <console>

/** Round states detiled
 *	Imported from SourceMod > sdktools_gamerules.inc
 *
 *	RoundState_Init				Initialize the game, create teams
 *	RoundState_Pregame			Before players have joined the game and also reverts to this when there are no active players
 *	RoundState_StartGame		The game is about to start, wait a bit and spawn everyone
 *	RoundState_Preround			All players are (re)spawned, frozen in place
 *	RoundState_RoundRunning		Round is on, playing normally
 *	RoundState_TeamWin			Someone has won the round
 *	RoundState_Restart			Noone has won, manually restart the game, reset scores
 *	RoundState_Stalemate		Noone has won, restart the game
 *	RoundState_GameOver			Game is over, showing the scoreboard etc
 *	RoundState_Bonus			Game is over, doing bonus round stuff
 *	RoundState_BetweenRounds	Between two rounds
 */

enum GamePhase
{
	GamePhase_FirstHalf	 = 2,
	GamePhase_SecondHalf = 3,
	GamePhase_HalfTime	 = 4,
	GamePhase_PostGame	 = 5,
};

stock void HP_EnsurePausedWarmup()
{
	if (!HP_IsWarmupPeriod())
		HP_StartWarmup();

	ServerCommand("mp_warmup_pausetimer 1");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_warmup_pausetimer 1");
}

stock void HP_StartWarmup(bool bIndefiniteWarmup = true, int iWarmupTime = 60)
{
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_warmuptime %d", iWarmupTime);
	ServerCommand("mp_warmup_start");

	if (bIndefiniteWarmup)
	{
		ServerCommand("mp_warmup_pausetimer 1");
		ServerCommand("mp_warmup_pausetimer 1");
	}
}

stock void HP_EndWarmup(int iTime = 0)
{
	if (iTime > 0)
	{
		ServerCommand("mp_warmup_pausetimer 0");
		ServerCommand("mp_warmuptime %d", iTime);
	}
	else
		ServerCommand("mp_warmup_end");
}

stock bool HP_IsMatchPaused()
{
	return HP_GetPropBool("m_bMatchWaitingForResume");
}

stock void HP_PauseMatch(int iTime = 0, int iTeam = CS_TEAM_NONE)
{
	if (iTime > 0 || iTeam >= CS_TEAM_T)
	{
		ServerCommand("mp_pause_match");

		if (iTeam == CS_TEAM_T)
		{
			GameRules_SetProp("m_bTerroristTimeOutActive", true);
			GameRules_SetPropFloat("m_flTerroristTimeOutRemaining", float(iTime));
		}
		else
		{
			GameRules_SetProp("m_bCTTimeOutActive", true);
			GameRules_SetPropFloat("m_flCTTimeOutRemaining", float(iTime));
		}
	}
	else
		ServerCommand("mp_pause_match");
}

stock void HP_UnPauseMatch()
{
	ServerCommand("mp_unpause_match");
}

stock void HP_RestartGame(int iDelay = 1)
{
	ServerCommand("mp_restartgame %d", iDelay);
}

stock RoundState HP_GetRoundState()
{
	return view_as<RoundState>(GameRules_GetProp("m_iRoundState"));
}

stock GamePhase HP_GetGamePhase()
{
	return HP_GetPropBool("m_gamePhase");
}

stock bool HP_IsWarmUpPeriod()
{
	return HP_GetPropBool("m_bWarmupPeriod");
}

stock float HP_WarmupTimeLeft()
{
	return GameRules_GetProp("m_fWarmupPeriodEnd");
}

stock bool HP_IsOvertime()
{
	return HP_GetPropBool("m_nOvertimePlaying");
}

stock bool HP_IsFreezeTime()
{
	return HP_GetPropBool("m_bFreezePeriod");
}

stock bool HP_IsBombPlanted()
{
	return HP_GetPropBool("m_bBombPlanted");
}

stock int HP_GetTotalRoundTime()
{
	return GameRules_GetProp("m_iRoundTime");
}

stock bool HP_ChangeMap(const char[] szMap)
{
    ServerCommand("changelevel %s", szMap);
    return true;
}

stock bool HP_IsTVEnabled()
{
	return (HP_GetConVarIntSafe("tv_enable") != -1);
}

stock int HP_GetTvDelay()
{
	return (HP_IsTVEnabled() ? GetCvarIntSafe("tv_delay") : 0);
}

stock bool HP_StartRecord(const char[] szDemo)
{
	char szDemoName[256];
	strcopy(szDemoName, sizeof(szDemoName), szDemo);
	ReplaceString(szDemoName, sizeof(szDemoName), "\"", "\\\"");
	ServerCommand("tv_record \"%s\"", szDemoName);

	if (HP_IsTVEnabled())
		return true;

	return false;
}

stock void HP_StopRecord()
{
	ServerCommand("tv_stoprecord");
}

stock void HP_ExecCFG(const char[] szFile)
{
	ServerCommand("exec \"%s\"", szFile);
}