#if defined _csfirebans_included
    #endinput
#endif
#define _csfirebans_included

/**
 *	Called once a client is punnished
 *
 *	@param iClient			Client index.
 *
 *	@noreturn
*/
forward void FB_OnClientPunished(int iClient);
