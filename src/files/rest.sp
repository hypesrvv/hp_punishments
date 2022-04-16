void HTTPRequest_OnPlayerPunished(HTTPResponse hResponse, any data)
{
	if (hResponse.Status != HTTPStatus_OK)
	{
#if defined DEBUG
		LogDebug("[HTTPRequest_OnPlayerBan] An error has occured");
		CPrintToServer("[{GREEN}BANS{NORMAL}] An error has occured on 'HTTPRequest_OnPlayerBan'");
#endif
		return;
	}

	decl char szLength[48];
	decl char szReason[128];
	JSONObject jObject = view_as<JSONObject>(hResponse.Data);

	jObject.GetString("reason", szReason, sizeof(szReason));
	jObject.GetString("expires_at", szLength, sizeof(szLength));

	Forward_OnClientPunished(data, data, szReason, szLength, jObject.GetInt("type"));

#if defined DEBUG
	// JSONObject jbObject = view_as<JSONObject>(hResponse.Data);
	decl char szBuffer[1024];
	jObject.ToString(szBuffer, sizeof(szBuffer));
	CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

	delete jObject;
}