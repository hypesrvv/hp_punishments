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