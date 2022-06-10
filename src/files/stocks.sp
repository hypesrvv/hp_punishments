stock void CreatePunishmentExpireTimer(EPunishmentType EType, int iUserID, float iRemainingTime)
{
    DataPack hPack = new DataPack();

    hPack.WriteCell(view_as<int>(EType));
    hPack.WriteCell(iUserID);

    if (iRemainingTime)
        g_EUser[GetClientOfUserId(iUserID)].hPunishmentTimer = CreateDataTimer(iRemainingTime, Timer_PunishmentExpire, hPack);
    else
        g_EUser[GetClientOfUserId(iUserID)].hPunishmentTimer = CreateDataTimer((iRemainingTime * 21600.0), Timer_PunishmentExpire, hPack);
}

stock Action Timer_PunishmentExpire(Handle hTimer, DataPack hPack)
{
    hPack.Reset();

    EPunishmentType EType = view_as<EPunishmentType>(hPack.ReadCell());
    int iClient = GetClientOfUserId(hPack.ReadCell());

    switch (EType)
    {
		case k_EPunishmentTypeSilence:
		{

		}

		case k_EPunishmentTypeGag:
		{

		}

		case k_EPunishmentTypeMute: UnmutePlayer(iClient);
    }

    hTimer = null;
    delete hPack;
    return Plugin_Stop;
}


stock char[] IntToStr(const int szInteger)
{
    decl char z[10];
    FormatEx(z, 10, "%i", szInteger);
    return z;
}

stock void PrintToChatTimer(const float fTime, const int iUserID, char[] szMessage, any ...)
{
    decl char szOutput[MAX_STRING_LENGTH];
    VFormat(szOutput, sizeof(szOutput), szMessage, 4);

    DataPack hPack = new DataPack();

    hPack.WriteCell(iUserID);
    hPack.WriteString(szOutput);

    CreateTimer(fTime, Timer_PrintToChat, hPack);
}

public Action Timer_PrintToChat(Handle hTimer, DataPack hPack)
{
    hPack.Reset();
    decl char szMessage[MAX_STRING_LENGTH];

    int iUserID = hPack.ReadCell();
    int iClient = GetClientOfUserId(iUserID);
    hPack.ReadString(szMessage, sizeof(szMessage));

    PrintToChat(iClient, szMessage);

    delete hPack;

    hTimer = null;
    return Plugin_Stop;
}









stock void MutePlayer(int iClient)
{
    SetClientListeningFlags(iClient, VOICE_MUTED);
}

stock void UnmutePlayer(int iClient)
{
    switch (FindConVar("sv_deadtalk").IntValue)
    {
        case 1: if (!IsPlayerAlive(iClient)) SetClientListeningFlags(iClient, VOICE_LISTENALL);
        case 2: if (!IsPlayerAlive(iClient)) SetClientListeningFlags(iClient, VOICE_TEAM);
        default: SetClientListeningFlags(iClient, VOICE_NORMAL);
    }
}

stock void PunishPrint(const char[] szMessage, any ...)
{
    decl char szPublicOutPut[PLATFORM_MAX_PATH];
    decl char szOutput[PLATFORM_MAX_PATH];
    VFormat(szPublicOutPut, sizeof(szPublicOutPut), szMessage, 2);
    VFormat(szOutput, sizeof(szOutput), szMessage, 2);
    Format(szOutput, sizeof(szOutput), "%s \x08by \x0B%s", szOutput, g_EPunishment.szAdminName);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i))
            continue;

        if (HP_IsClientStaff(i))
            PrintToChat(i, szOutput);
        else
            PrintToChat(i, szPublicOutPut);
    }
}

stock void UpdateClientPunishments(int iClient)
{
	decl char szURL[128];
	FormatEx(szURL, sizeof(szURL), HYPESRV_API ... "/user/%i/punishments/active", g_EUser[iClient].iAccountID);

	hRequest = new HTTPRequest(szURL);
	hRequest.SetHeader("Authorization", HYPESRV_AUTH_TOKEN);

	hRequest.Get(HTTPRequest_OnPunishmentsFetched, g_EUser[iClient].iAccountID);
}