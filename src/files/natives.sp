void Forward_OnClientPunished(const int iClient)
{
	Call_StartForward(Core.fOnPlayerPunished);
	Call_PushCell(iClient);
	Call_Finish();

#if defined DEBUG
	CPrintToServer("%s Forward '{YELLOW}FR_OnCoreIsReady{WHITE}' called.", TAG_BANS_CONSOLE);
#endif
}