void HTTPRequest_OnPlayerPunished(HTTPResponse hResponse, DataPack hPack)
{
	int iStatus = view_as<int>(hResponse.Status);

	switch (view_as<HTTPStatus>(iStatus))
	{
		case HTTPStatus_OK:
		{
			hPack.Reset();

			g_EPunishment.Clear();

			int iTargetID = hPack.ReadCell();
			int iAdminID = hPack.ReadCell();

			if (g_EPunishment.Populate(iTargetID, iAdminID, hResponse.Data))
			{
				Forward_OnClientPunished(g_EPunishment.iTargetID, g_EPunishment.iAdminID, g_EPunishment.szReason, g_EPunishment.szLength, g_EPunishment.iBanID);

				int iTarget = GetClientOfUserId(g_EPunishment.iTargetID);

				switch (view_as<EPunishmentType>(g_EPunishment.iType))
				{
					case k_EPunishmentTypeBan:
					{
						if (IsPlayerAlive(iTarget))
							ForcePlayerSuicide(iTarget);

						PunishPrint("%s\x09%s \x08was banned from the server for \x0F%s", TAG_BANS, g_EPunishment.szTargetName, g_EPunishment.szReason);

						KickClient(iTarget, "You′ve been permanetly banned from " ... HP_AUTHOR ... " Community servers\n\nReason: %s%s", g_EPunishment.szReason, PUNISHMENT_FOOTER);
					}

					case k_EPunishmentTypeKick:
					{
						if (IsPlayerAlive(iTarget))
							ForcePlayerSuicide(iTarget);

						PunishPrint("%s\x09%s \x08was kicked from the server for %s", TAG_BANS, g_EPunishment.szTargetName, g_EPunishment.szReason);

						KickClient(iTarget, "You′ve been kicked from the " ... HP_AUTHOR ... " server\n\n %s", PUNISHMENT_FOOTER);
					}

					case k_EPunishmentTypeSilence:
					{

					}

					case k_EPunishmentTypeGag:
					{

					}

					case k_EPunishmentTypeMute:
					{
						MutePlayer(iTarget);
					}
				}
			}

			delete hPack;

			// enum EPunishmentType
			// {
			// 	k_EPunishmentTypeBan,
			// 	k_EPunishmentTypeKick,
			// 	k_EPunishmentTypeSilence,
			// 	k_EPunishmentTypeGag,
			// 	k_EPunishmentTypeMute,

			// 	k_EPunishmentTypeTotal
			// }

			// int iTarget;
			// int iAdmin;
			// int iBanID;
			// decl char szLength[48];
			// decl char szReason[128];
			// JSONObject jPunishment = view_as<JSONObject>(hResponse.Data);

			// if (!jPunishment.GetString("reason", szReason, sizeof(szReason)))
			// 	strcopy(szReason, sizeof(szReason), NULL_STRING);

			// if (!jPunishment.GetString("expires_at", szLength, sizeof(szLength)))
			// 	strcopy(szLength, sizeof(szLength), "Permanent");

			// if (!jPunishment.GetInt("id"))
			// {
			// 	LogDebug("There has been a fatal error proccesing punishment ID for %N")
			// }

			// if (IsPlayerAlive(iTarget))
			// 	ForcePlayerSuicide(iTarget);

			// PrintToChatAll("%s\x09%N \x08was banned from the server for \x0F%s", TAG_BANS, iTarget, szReason);

			// Forward_OnClientPunished(GetClientUserId(iTarget), GetClientUserId(iAdmin), szReason, szLength, jPunishment.GetInt("type"));

			// if (szLength[10] == 't')
			// 	KickClient(iTarget, "You′ve been permanetly banned from HypeSRV Community servers\n\nReason: %s%s", szReason, PUNISHMENT_FOOTER);
			// else
			// 	KickClient(iTarget, "You′ve been banned from HypeSRV Community servers\n\nReason: %s%s", szReason, PUNISHMENT_FOOTER);

// #if defined DEBUG
// 			// JSONObject jbObject = view_as<JSONObject>(hResponse.Data);
// 			decl char szBuffer[1024];
// 			jPunishment.ToString(szBuffer, sizeof(szBuffer));
// 			CPrintToServer("{LIGHTBLUE}%s", szBuffer);
// #endif

// 			delete jPunishment;
// 			delete hPack;
 		}

		default:
		{
			LogDebug("There was an error with {TEAL}HTTPRequest_OnPlayerPunished {GREY}({YELLOW}%i{GREY})", iStatus);
		}
	}
}