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

stock void EnsurePausedWarmup()
{
	if (!IsWarmupPeriod())
		StartWarmup();

	ServerCommand("mp_warmup_pausetimer 1");
	ServerCommand("mp_do_warmup_period 1");
	ServerCommand("mp_warmup_pausetimer 1");
}

stock void StartWarmup(bool bIndefiniteWarmup = true, int iWarmupTime = 60)
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

stock void EndWarmup(int iTime = 0)
{
	if (iTime)
	{
		ServerCommand("mp_warmup_pausetimer 0");
		ServerCommand("mp_warmuptime %d", iTime);
	}
	else
		ServerCommand("mp_warmup_end");
}

stock bool IsMatchPaused()
{
	return HP_GetPropBool("m_bMatchWaitingForResume");
}

stock void PauseMatch(int iTime = 0, int iTeam = CS_TEAM_NONE)
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

stock void UnPauseMatch()
{
	ServerCommand("mp_unpause_match");
}

stock void RestartGame(int iDelay = 1)
{
	ServerCommand("mp_restartgame %d", iDelay);
}

stock RoundState GetRoundState()
{
	return view_as<RoundState>(GameRules_GetProp("m_iRoundState"));
}

stock GamePhase GetGamePhase()
{
	return GetPropBool("m_gamePhase");
}

stock bool IsWarmUpPeriod()
{
	return GetPropBool("m_bWarmupPeriod");
}

stock float WarmupTimeLeft()
{
	return GameRules_GetProp("m_fWarmupPeriodEnd");
}

stock bool IsOvertime()
{
	return GetPropBool("m_nOvertimePlaying");
}

stock bool IsFreezeTime()
{
	return GetPropBool("m_bFreezePeriod");
}

stock bool IsBombPlanted()
{
	return GetPropBool("m_bBombPlanted");
}

stock int GetTotalRoundTime()
{
	return GameRules_GetProp("m_iRoundTime");
}

stock bool ChangeMap(const char[] szMap)
{
    ServerCommand("changelevel %s", szMap);
    return true;
}

stock bool IsTVEnabled()
{
	return FindConVar("tv_enable").BoolValue;
}

stock int GetTvDelay()
{
	return (IsTVEnabled() ? FindConVar("tv_delay").IntValue : -1);
}

stock bool StartRecordDemo(const char[] szDemo)
{
	char szDemoName[256];
	strcopy(szDemoName, sizeof(szDemoName), szDemo);
	ReplaceString(szDemoName, sizeof(szDemoName), "\"", "\\\"");
	ServerCommand("tv_record \"%s\"", szDemoName);

	if (IsTVEnabled())
		return true;

	return false;
}

stock void StopRecord()
{
	ServerCommand("tv_stoprecord");
}

stock void ExecCFG(const char[] szFile)
{
	ServerCommand("exec \"%s\"", szFile);
}