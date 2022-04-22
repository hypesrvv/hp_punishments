#if defined _hp_core_included
    #endinput
#endif
#define _hp_core_included

enum EPower
{
	k_EPowerNone,
	k_EPowerModerator,
	k_EPowerAdmin,
	k_EPowerOwner
}

/**
 *	Called when the core is fully loaded.
 */
forward void HP_OnCoreEngineReady();

/**
 *	Called when the client is ready.
 *
 *	@param iUserID			Client userid.
 */
forward void HP_OnClientConnected(const int iUserID);

/**
 *	Gets the Server ID from Core.
 */
native int HP_GetServerID();

public SharedPlugin __pl_hp_core =
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
public void __pl_hp_core_SetNTVOptional()
{
	MarkNativeAsOptional("HP_GetServerID");
}
#endif