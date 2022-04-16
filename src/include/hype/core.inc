#if defined _hp_core_included
    #endinput
#endif
#define _hp_core_included

/**
 *	Called on client data fetched.
 *
 *	@param iUserID			Client userid.
 *
 *	@noreturn
 */
forward void HP_OnClientConnected(const int iUserID);

/**
 * Gets ServerID from Core.
 *
 * @return        ServerID.
 */
native int HP_GetServerID();

public SharedPlugin __pl_core =
{
	name = "Core",
	file = "hp_core.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_core_SetNTVOptional()
{
	MarkNativeAsOptional("HP_GetServerID");
}
#endif