#if defined _HP_MODULE_SOUND_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_SOUND_INCLUDED_

stock void PlayToRadius(float fOrigin[3], float fRadius, const char[] szSound)
{
	// decl char szBuffer[PLATFORM_MAX_PATH];
	// FormatEx(szBuffer, sizeof(szBuffer), "play %s", szSound);

	for (int i = 0; i < MaxClients; i++)
	{
		if (IsClientConnected(i))
			if (GetDistanceOrigin(i, fOrigin) <= fRadius)
				ClientCommand(i, "play " ... szSound);
	}
}

stock bool CheckAudio(int iClient)
{
	return QueryClientConVar(iClient, "voice_inputfromfile", HP_Query_CheckAudio);
}

stock bool Query_CheckAudio(QueryCookie cCookie, int iClient, ConVarQueryResult rResult, const char[] szName, const char[] szValue)
{
	return (rResult == ConVarQuery_Okay && StringToInt(sValue) == 1);
}