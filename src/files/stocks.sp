stock void LogDebug(const char[] szFormat, any ...) {

	char sBuffer[PLATFORM_MAX_PATH * 2],
		sLogPath[PLATFORM_MAX_PATH];

	VFormat(sBuffer, sizeof(sBuffer), szFormat, 2);

	BuildPath(Path_SM, sLogPath, sizeof(sLogPath), "logs/hp_bans.txt");

	LogToFile(sLogPath, sBuffer);
}

stock int FindPlayer(const char[] szPattern)
{
	char szName[MAX_NAME_LENGTH];
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}

		GetClientName(i, szName, sizeof(szName));

		if (StrEqual(szPattern, szName, false))
		{
			return i;
		}
	}
	return -1;
}