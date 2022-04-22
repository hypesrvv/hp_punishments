void HTTPRequest_OnPlayerPunished(HTTPResponse hResponse, int iData)
{
	if (hResponse.Status != HTTPStatus_OK)
	{
#if defined DEBUG
		LogDebug("[HTTPRequest_OnPlayerBan] An error has occured");
		CPrintToServer("[{GREEN}BANS{NORMAL}] An error has occured on 'HTTPRequest_OnPlayerBan'");
#endif
		return;
	}

	int iAdmin = GetClientOfUserId(iData >> 4);
	int iTarget = GetClientOfUserId(iData & 0xF);

	// CPrintToServer("{LIGHTBLUE}%N(%X):%N(%X)", iAdmin, (iData >> 5), iTarget, (iData & 0xF));

	decl char szLength[48];
	decl char szReason[128];
	JSONObject jPunishment = view_as<JSONObject>(hResponse.Data);

	jPunishment.GetString("reason", szReason, sizeof(szReason));

	if (!jPunishment.GetString("expires_at", szLength, sizeof(szLength)))
		strcopy(szLength, sizeof(szLength), "Permanent");

	Forward_OnClientPunished(iTarget, iAdmin, szReason, szLength, jPunishment.GetInt("type"));

#if defined DEBUG
	// JSONObject jbObject = view_as<JSONObject>(hResponse.Data);
	decl char szBuffer[1024];
	jPunishment.ToString(szBuffer, sizeof(szBuffer));
	CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

	delete jPunishment;
}