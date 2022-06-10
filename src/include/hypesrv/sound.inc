#if defined _HP_MODULE_SOUND_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_SOUND_INCLUDED_

stock void HP_PlayToRadius(float fOrigin[3], float fRadius, char[] szSound)
{
	decl char szBuffer[PLATFORM_MAX_PATH];
	FormatEx(szBuffer, sizeof(szBuffer), "play %s", szSound);

	for (int i = 0; i < MaxClients; i++)
	{
		if (IsClientConnected(i))
			if (HP_GetDistanceOrigin(i, fOrigin) <= fRadius)
				ClientCommand(i, szBuffer);
	}
}

stock bool HP_CheckAudio(int iClient)
{
	if (!HP_IsValidPlayer(iClient))
		return false;

	return QueryClientConVar(iClient, "voice_inputfromfile", HP_Query_CheckAudio);
}

stock bool HP_Query_CheckAudio(QueryCookie cCookie, int iClient, ConVarQueryResult rResult, const char[] szName, const char[] szValue)
{
	return rResult == ConVarQuery_Okay && StringToInt(sValue) == 1;
}