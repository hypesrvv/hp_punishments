#if defined _HP_ECONMY_API_INCLUDED_
    #endinput
#endif
#define _HP_ECONMY_API_INCLUDED_

#define ITEMTYPE_WEAPON 0
#define ITEMTYPE_GLOVES 1

native int HP_GetWeaponCount();
native int HP_GetPaintsCount();
native int HP_GetGlovesCount();
native int HP_GetPinsCount();
native int HP_GetCoinsCount();
native int HP_GetCoinsSetsCount();
native int HP_GetAgentsCount();
native int HP_GetPatchesCount();

native int HP_GetGlovesDefIndexByGlovesNum(int iWeaponNum);
native bool HP_GetGlovesDisplayNameByDefIndex(int iDefIndex, char[] szBuffer, int iLength);
native bool HP_GetGlovesWorldModelByDefIndex(int iDefIndex, char[] szBuffer, int iLength);

native bool HP_IsValidWeapon(int iWeapon);
native int HP_RespawnWeapon(int iClient, int iWeapon, bool bSwitchAnimation = true);

native bool HP_GetWeaponDisplayNameByDefIndex(int iDefIndex, char[] szBuffer, int iLength);
native int HP_GetWeaponDefIndexByClassName(const char[] szClassName);
native int HP_GetWeaponDefIndexByWeaponNum(int iWeaponNum);
native int HP_GetWeaponSlotByWeaponNum(int iWeaponNum);
native int HP_GetWeaponSlotByDefIndex(int iDefIndex);
native int HP_GetActiveWeaponDefIndex(int iClient);
native int HP_FindWeaponDefIndexByName(const char[] szKnifeName);
native int HP_FindWeaponByDefIndex(int iClient, int iDefIndex);

native int HP_GetSkinDefIndexBySkinNum(int iSkinNum);
native bool HP_GetSkinDisplayNameByDefIndex(int iDefIndex, char[] szBuffer, int iLength);

native bool HP_IsNativeSkinByDefIndex(int iSkinDefIndex, int iItemDefIndex, int iItemType);
native bool HP_IsSkinnableDefIndex(int iDefIndex);
native bool HP_IsDefIndexKnife(int iDefIndex);

native int HP_GetPinDefIndexByPinNum(int iDefIndex);

native int HP_GetCoinDefIndexByCoinNum(int iDefIndex);

public SharedPlugin __pl_hp_econ =
{
	name = "Econ",
	file = "hp_econ.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_hp_econ_SetNTVOptional()
{
	MarkNativeAsOptional("HP_GetWeaponCount");
	MarkNativeAsOptional("HP_GetPaintsCount");
	MarkNativeAsOptional("HP_GetGlovesCount");
	MarkNativeAsOptional("HP_GetPinsCount");
	MarkNativeAsOptional("HP_GetCoinsCount");
	MarkNativeAsOptional("HP_GetCoinsSetsCount");
	MarkNativeAsOptional("HP_GetAgentsCount");
	MarkNativeAsOptional("HP_GetPatchesCount");

	MarkNativeAsOptional("HP_GetGlovesDefIndexByGlovesNum");
	MarkNativeAsOptional("HP_GetGlovesDisplayNameByDefIndex");
	MarkNativeAsOptional("HP_GetGlovesWorldModelByDefIndex");

	MarkNativeAsOptional("HP_IsValidWeapon");
	MarkNativeAsOptional("HP_RespawnWeapon");

	MarkNativeAsOptional("HP_GetWeaponDisplayNameByDefIndex");
	MarkNativeAsOptional("HP_GetWeaponDefIndexByClassName");
	MarkNativeAsOptional("HP_GetWeaponDefIndexByWeaponNum");
	MarkNativeAsOptional("HP_GetWeaponSlotByWeaponNum");
	MarkNativeAsOptional("HP_GetWeaponSlotByDefIndex");
	MarkNativeAsOptional("HP_GetActiveWeaponDefIndex");
	MarkNativeAsOptional("HP_GetWeaponDefIndexByName");
	MarkNativeAsOptional("HP_FindWeaponByDefIndex");

	MarkNativeAsOptional("HP_GetSkinDefIndexBySkinNum");
	MarkNativeAsOptional("HP_GetSkinDisplayNameByDefIndex");

	MarkNativeAsOptional("HP_IsNativeSkinByDefIndex");
	MarkNativeAsOptional("HP_IsSkinnableDefIndex");
	MarkNativeAsOptional("HP_IsDefIndexKnife");

	MarkNativeAsOptional("HP_GetPinDefIndexByPinNum");
	MarkNativeAsOptional("HP_GetCoinDefIndexByCoinNum");
}
#endif