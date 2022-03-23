#if defined _punishments_included
    #endinput
#endif
#define _punishments_included

/**
 *	Called once a client is punnished
 *
 *	@param iClient			Client index.
 *
 *	@noreturn
*/
forward void HP_OnClientPunished(int iClient);
