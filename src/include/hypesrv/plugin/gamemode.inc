#if defined _HP_GAMEMODE_INCLUDED_
    #endinput
#endif
#define _HP_GAMEMODE_INCLUDED_

/**
 *	Called once the gamemode has been set.
 *
 *	@param szMode			Gamemode name
 *
 *	@noreturn
*/
forward void HP_OnGameModeStart(const char[] szMode);