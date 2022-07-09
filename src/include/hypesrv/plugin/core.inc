#if defined _HP_CORE_INCLUDED_
    #endinput
#endif
#define _HP_CORE_INCLUDED_

enum EPower
{
	k_EPowerNone,
	k_EPowerModerator,
	k_EPowerAdministrator,
	k_EPowerOwner,

	k_EPowers
}

forward void HP_OnCoreEngineReady();
forward void HP_OnClientConnected(int iUserID);

stock EPower HP_GetClientPower(int iClient)
{
    switch (GetUserFlagBits(iClient))
    {
        case ADMFLAG_GENERIC: return k_EPowerNone;
        case ADMFLAG_KICK: return k_EPowerModerator;
        case ADMFLAG_BAN: return k_EPowerAdministrator;
        case ADMFLAG_ROOT: return k_EPowerOwner;
        default: return view_as<EPower>(-1);
    }
}

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