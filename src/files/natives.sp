void Forward_OnClientPunished(const int iTargetID, const int iAdminID, const char[] szReason, const char[] szLength, const int iBanType)
{
	Call_StartForward(Core.fOnPlayerPunished);

	Call_PushCell(iTargetID);
	Call_PushCell(iAdminID);
	Call_PushString(szReason);
	Call_PushString(szLength);
	Call_PushCell(iBanType);

	Call_Finish();

#if defined DEBUG
	LogDebug("Forward {YELLOW}HP_OnClientPunished{GREY} called");
#endif
}

void Native_PunishPlayer(Handle hPlugin, int iParams)
{
	int iTarget = GetNativeCell(1);
	int iAdmin = GetNativeCell(2);

	decl char szReason[128];

	GetNativeString(3, szReason, sizeof(szReason));

	int iLength = GetNativeCell(4);
	int iType = GetNativeCell(5);

	if (iLength != -1)
		HYPPunish(iTarget).Punish(iAdmin, szReason, iLength, iType);
	else
		HYPPunish(iTarget).Punish(iAdmin, szReason, 0, iType);

#if defined DEBUG
	LogDebug("Native {YELLOW}HP_PunishPlayer{GREY} accessed [DATA]: {PURPLE}iUserID \"%i\", iAdminID \"%i\", szReason \"%s\", iLength \"%i\", iType \"%i\"", iTarget, iAdmin, szReason, iLength, iType);
#endif
}