#if defined _HP_CORE_INCLUDED_
    #endinput
#endif
#define _HP_CORE_INCLUDED_

enum EPower
{
	k_EPowerNone,
	k_EPowerModerator,
	k_EPowerAdmin,
	k_EPowerOwner
}

forward void HP_OnCoreEngineReady();
forward void HP_OnClientConnected(int iUserID);
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