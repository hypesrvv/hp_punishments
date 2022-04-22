void Forward_OnClientPunished(const int iUserID, const int iAdminID, const char[] szReason, const char[] szLength, int iType)
{
	Call_StartForward(Core.fOnPlayerPunished);

	Call_PushCell(iUserID);
	Call_PushCell(iAdminID);
	Call_PushString(szReason);
	Call_PushString(szLength);
	Call_PushCell(iType);

	Call_Finish();

#if defined DEBUG
	CPrintToServer("%s Forward '{YELLOW}HP_OnClientPunished{WHITE}' called.", TAG_BANS_CONSOLE);
#endif
}

void Native_PunishPlayer(Handle hPlugin, int iParams)
{
	int iUserID = GetNativeCell(1);
	int iAdminID = GetNativeCell(2);

	decl char szReason[128];

	GetNativeString(3, szReason, sizeof(szReason));

	int iLength = GetNativeCell(4);
	int iType = GetNativeCell(5);

	if (iLength != -1)
		HYPPunish(iUserID).Punish(iAdminID, szReason, iLength, iType);
	else
		HYPPunish(iUserID).Punish(iAdminID, szReason, 0, iType);

#if defined DEBUG
	CPrintToServer("%s Native '{YELLOW}Native_PunishPlayer{WHITE}' called. [DATA]: {PURPLE}iUserID \"%i\", iAdminID \"%i\", szReason \"%s\", iLength \"%i\", iType \"%i\"", TAG_BANS_CONSOLE, iUserID, iAdminID, szReason, iLength, iType);
#endif
}