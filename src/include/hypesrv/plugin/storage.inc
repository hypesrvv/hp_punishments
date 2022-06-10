#if defined _HP_STORAGE_INCLUDED_
    #endinput
#endif
#define _HP_STORAGE_INCLUDED_

native bool HP_SetStorageKey(int iClient, const char[] szKey, const any ...);
native Handle HP_GetClientStorage(int iClient);

public SharedPlugin __pl_hp_storage =
{
	name = "Storage",
	file = "hp_storage.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_hp_storage_SetNTVOptional()
{
	MarkNativeAsOptional("HP_SetStorageKey");
	MarkNativeAsOptional("HP_GetClientStorage");
}
#endif