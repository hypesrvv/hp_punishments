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
				Forward_OnClientPunished(g_EPunishment.iTargetID, g_EPunishment.iAdminID, g_EPunishment.szReason, g_EPunishment.szLength, g_EPunishment.iID);

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

						PunishPrint("%s\x09%s \x08was kicked from the server", TAG_BANS, g_EPunishment.szTargetName);

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
 		}

		default:
		{
			LogDebug("There was an error with {TEAL}HTTPRequest_OnPlayerPunished {GREY}({YELLOW}%i{GREY})", iStatus);
		}
	}
}

void HTTPRequest_OnPunishmentsFetched(HTTPResponse hResponse, int iUserID)
{
	int iStatus = view_as<int>(hResponse.Status);

	switch (view_as<HTTPStatus>(iStatus))
	{
		case HTTPStatus_OK:
		{
			int iClient = GetClientOfUserId(iUserID);

			if (g_EUser[iClient].LoadPunishments(hResponse.Data))
			{
				EPunishment PunishmentData;

				for (int i = g_EUser[iClient].iPunishmentCount - 1; i >= 0; i--)
				{
					g_EUser[iClient].ALPunishments.GetArray(i, PunishmentData, sizeof(PunishmentData));

					LogDebug("Function {YELLOW}HTTPRequest_OnPunishmentsFetched {GREY}TargetID: {GREEN}%i{GREY}, AdminID: {GREEN}%i{GREY}, Reason: \"{GREEN}%s{GREY}\", Length: {GREEN}%s{GREY}, Type: {GREEN}%i{GREY}, PunishmentID: {GREEN}%i{GREY}",
					PunishmentData.iTargetID,
					PunishmentData.iAdminID,
					PunishmentData.szReason,
					PunishmentData.szLength,
					PunishmentData.iType,
					PunishmentData.iID);

					switch (view_as<EPunishmentType>(PunishmentData.iType))
					{
						case k_EPunishmentTypeSilence:
						{

						}

						case k_EPunishmentTypeGag:
						{

						}

						case k_EPunishmentTypeMute:
						{
							CreatePunishmentExpireTimer(k_EPunishmentTypeMute, iClient, 0.0);
						}
					}
				}
			}
		}

		default:
		{
			LogDebug("There was an error with {TEAL}HTTPRequest_OnPunishmentsFetched {GREY}({YELLOW}%i{GREY})", iStatus);
		}
	}
}