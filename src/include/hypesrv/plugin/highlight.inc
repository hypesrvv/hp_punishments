#if defined _HP_HIGHLIGHT_API_INCLUDED_
	#endinput
#endif
#define _HP_HIGHLIGHT_API_INCLUDED_

/**
 *	Sets entity highlight color.
 *
 *	@param iEntity			Entity index.
 *	@param iColors			Red|Green|Blue values.
 *
 *	@return					true if successful, false otherwise.
 *	@error					Invalid entity.
 */
native bool HP_SetEntityColor(int iEntity, int iColors[3]);

/**
 *	Sets player highlight distance.
 *
 *	@param iClient			Client index.
 *	@param iValue			Distance.
 *
 *	@return					true if successful, false otherwise.
 *	@error					Invalid client.
 */
native bool HP_SetPlayerHighlightDistance(int iClient, int iValue);

/**
 *	Sets player highlight duration. Also used for stoping player's highlights.
 *
 *	@param iClient			Client index.
 *	@param iValue			Duration.
 *
 *	@return					true if successful, false otherwise.
 *	@error					Invalid client.
 */
native bool HP_SetPlayerHighlightDuration(int iClient, int iValue);

/**
 *	Highlights an entity to a player.
 *
 *	@param iClient					Client index.
 *	@param iEntity				 	Entity index.
 *
 *	@return					true if successful, false otherwise.
 *	@error					Invalid client.
 */
native bool HP_HighlightEntityToPlayer(int iEntity, int iClient);

/**
 *	Disables highlighting of an entity for a player.
 *
 *	@param iClient					Client index.
 *	@param iEntity				 	Entity index.
 *
 *	@return					true if successful, false otherwise.
 *	@error					Invalid client.
 */
native bool HP_DisableHighlightEntityToPlayer(int iClient, int iEntity);

/**
 *	Checks if an entity is highlited for a player.
 *
 *	@param iClient					Client index.
 *	@param iEntity				 	Entity index.
 *
 *	@return					true if highlighted, false otherwise.
 *	@error					Invalid client.
 */
native bool HP_IsEntityHighlighted(int iClient, int iEntity);

/**
 *	Clears all highlights.
 *
 */
native void HP_ClearPluginHighlights();

/**
 *	Clears highlights for a client.
 *
 */
native bool HP_ClearClientHighlights(int iClient);

public SharedPlugin __pl_hp_hapi =
{
	name = "Highlight",
	file = "hp_hapi.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_hp_hapi_SetNTVOptional()
{
	MarkNativeAsOptional("HP_SetEntityColor");
	MarkNativeAsOptional("HP_IsEntityHighlighted");
	MarkNativeAsOptional("HP_ClearPluginHighlights");
	MarkNativeAsOptional("HP_ClearClientHighlights");
	MarkNativeAsOptional("HP_HighlightEntityToPlayer");
	MarkNativeAsOptional("HP_SetPlayerHighlightDistance");
	MarkNativeAsOptional("HP_SetPlayerHighlightDuration");
	MarkNativeAsOptional("HP_DisableHighlightEntityToPlayer");
}
#endif