stock void CreatePunishmentExpireTimer(EPunishmentType EType, int iClient, float iRemainingTime)
{
    DataPack hPack;

    hPack.WriteCell(view_as<int>(EType));
    hPack.WriteCell(GetClientUserId(iClient));

    if (iRemainingTime)
        g_EUser[iClient].hPunishmentTimer = CreateDataTimer(iRemainingTime, Timer_PunishmentExpire, hPack);
    else
        g_EUser[iClient].hPunishmentTimer = CreateDataTimer((iRemainingTime * 60), Timer_PunishmentExpire, hPack);
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

    delete hPack;
    hTimer = null;
    return Plugin_Stop;
}


stock char[] IntToStr(const int szInteger)
{
    decl char z[10];
    FormatEx(z, 10, "%i", szInteger);
    return z;
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
    decl char szBuffer[64];
    decl char szPublicOutPut[PLATFORM_MAX_PATH];
    decl char szOutput[PLATFORM_MAX_PATH];
    VFormat(szPublicOutPut, sizeof(szPublicOutPut), szMessage, 2);
    VFormat(szOutput, sizeof(szOutput), szMessage, 2);

    FormatEx(szBuffer, sizeof(szBuffer), " \x08by \x0B%s", g_EPunishment.szAdminName);
    StrCat(szOutput, sizeof(szOutput), szBuffer);

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i) && !IsClientInGame(i))
            continue;

        if (IsClientStaff(i))
            PrintToChat(i, szOutput);
        else
            PrintToChat(i, szPublicOutPut);
    }
}