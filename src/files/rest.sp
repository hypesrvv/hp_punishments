void HTTPRequest_OnPlayerBan(HTTPResponse hResponse, any data)
{
	if (hResponse.Status != HTTPStatus_Created)
	{
#if defined DEBUG
		LogDebug("[HTTPRequest_OnPlayerBan] An error has occured");
		CPrintToServer("[{GREEN}BANS{NORMAL}] An error has occured on 'HTTPRequest_OnPlayerBan'");
#endif
		return;
	}

	Forward_OnClientPunished(GetClientOfUserId(data));

#if defined DEBUG
	JSONObject jObject = view_as<JSONObject>(hResponse.Data);
	char szBuffer[1024];
	jObject.ToString(szBuffer, sizeof(szBuffer));
	CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif
}