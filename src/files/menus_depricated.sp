public void DisplayMainAdminMenu(int iClient)
{
	Menu hMenu = new Menu(Menu_BuildMainMenu);

	hMenu.SetTitle("%sAdmin Menu\n ", TAG_MENU);

	hMenu.AddItem("0", "Ban Player");
	hMenu.AddItem("1", "Kick Player");
	hMenu.AddItem("2", "Mute Player");
	hMenu.AddItem("4", "User Managment");

	hMenu.ExitButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildMainMenu(Menu hMenu, MenuAction Actions, int iClient, int Option)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			switch (Option)
			{
				case 0:
				{
					DisplayBanMenu(iClient);
				}

				case 1:
				{
					DisplayKickMenu(iClient);
				}

				case 2:
				{
					DisplayMuteMenu(iClient);
				}
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

public void DisplayBanMenu(int iClient)
{
	char szName[MAX_NAME_TRIM];
	char szUserid[12];

	Menu hMenu = new Menu(Menu_BuildBanMenu);

	hMenu.SetTitle("%sBan Player\n ", TAG_MENU);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i, false))
		{
			IntToString(GetClientUserId(i), szUserid, sizeof(szUserid));
			GetClientName(i, szName, sizeof(szName));

			hMenu.AddItem(szUserid, szName);
		}
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildBanMenu(Menu hMenu, MenuAction Actions, int iClient, int iOption)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			int iTarget = GetClientOfUserId(iOption);

			if (!IsValidClient(iTarget, false))
			{
				PrintToChat(iClient, "%s\x08Error player is no longer in-game", TAG_CLR);
				return 0;
			}

			g_iTarget = iOption;
			DisplayBanMenuReason(iClient);
		}

		case MenuAction_Cancel:
		{
			if (iOption == MenuCancel_ExitBack)
			{
				DisplayMainAdminMenu(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

public void DisplayBanMenuReason(int iClient)
{
	Menu hMenu = new Menu(Menu_BuildBanMenuReason);

	char szName[MAX_NAME_TRIM];
	GetClientName(g_iTarget, szName, sizeof(szName));

	hMenu.SetTitle("%sBan %s\n ", TAG_MENU, szName);

	char mID[2];
	for (Reason i = Cheating; i < ReasonTotal; i++)
	{
		IntToString(view_as<int>(i), mID, sizeof(mID));
		hMenu.AddItem(mID, szPunishmentReason[i]);
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildBanMenuReason(Menu hMenu, MenuAction Actions, int iClient, int Option)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			g_iReason = view_as<Reason>(Option);

			switch (view_as<Reason>(Option))
			{
				case Cheating:
				{
					DisplayBanMenuReasonExt(iClient);
					return 0;
				}

				case OwnReason:
				{
					g_bOwnReason[iClient] = true;
					return 0;
					// DisplayOwnReasonPanel(iClient);
				}
			}

			// DisplayBanMenuTime(iClient);
		}

		case MenuAction_Cancel:
		{
			if (Option == MenuCancel_ExitBack)
			{
				DisplayBanMenu(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

stock void DisplayOwnReasonPanel(int iClient)
{
	Panel hPanel = new Panel();

	char szName[MAX_NAME_TRIM];
	char sBuffer[MAX_STRING_LENGTH];
	GetClientName(g_iTarget, szName, sizeof(szName));

	FormatEx(sBuffer, sizeof(sBuffer), "%s%s: %s", TAG_MENU, szName, szPunishmentReason[g_iReason]);
	hPanel.SetTitle(sBuffer);
	hPanel.DrawText(" ");
	hPanel.DrawText("Write your reason");
	hPanel.DrawText(" ");
	hPanel.DrawText(" ");
	hPanel.DrawText(" ");
	SetPanelCurrentKey(hPanel, 5);
	hPanel.DrawItem("Accept", ITEMDRAW_CONTROL);
	hPanel.DrawText(" ");
	SetPanelCurrentKey(hPanel, 9);
	hPanel.DrawItem("Exit", ITEMDRAW_CONTROL);

	hPanel.Send(iClient, Panel_BuildOwnReason, MENU_TIME_FOREVER);
	delete hPanel;
}

public int Panel_BuildOwnReason(Menu hMenu, MenuAction Choice, int iClient, int iOption)
{
	if (Choice == MenuAction_Select)
	{
		ClientCommand(iClient, "playgamesound \"buttons/button14.wav\"");
		switch (iOption)
		{
			case 5:
			{
				delete hMenu;
			}
			case 9:
			{
				delete hMenu;
			}
		}
	}
	return 0;
}

public void DisplayBanMenuReasonExt(int iClient)
{
	Menu hMenu = new Menu(Menu_BuildBanMenuReasonExt);

	char szName[MAX_NAME_TRIM];
	GetClientName(g_iTarget, szName, sizeof(szName));

	hMenu.SetTitle("%sBan %s\n ", TAG_MENU, szName);

	char mID[2];
	for (ReasonExt i = WallHacking; i < ReasonExtTotal; i++)
	{
		IntToString(view_as<int>(i), mID, sizeof(mID));
		hMenu.AddItem(mID, szReasonExtended[i]);
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildBanMenuReasonExt(Menu hMenu, MenuAction Actions, int iClient, int iOption)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			HYPPunish(g_iTarget).Form(iClient, szReasonExtended[iOption], _, 0);
		}

		case MenuAction_Cancel:
		{
			if (iOption == MenuCancel_ExitBack)
			{
				DisplayBanMenuReason(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

public void DisplayBanMenuTime(int iClient)
{
	Menu hMenu = new Menu(Menu_BuildBanMenuTime);

	char szName[MAX_NAME_TRIM];
	GetClientName(g_iTarget, szName, sizeof(szName));

	hMenu.SetTitle("%s%s: %s\n ", TAG_MENU, szName, szPunishmentReason[g_iReason]);

	char mID[2];
	for (Time i = ThreeDay; i < TimeTotal; i++)
	{
		IntToString(view_as<int>(i), mID, sizeof(mID));
		hMenu.AddItem(mID, szPunishmentTime[i]);
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildBanMenuTime(Menu hMenu, MenuAction Actions, int iClient, int Option)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
		}

		case MenuAction_Cancel:
		{
			if (Option == MenuCancel_ExitBack)
			{
				DisplayBanMenuReason(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

public void DisplayKickMenu(int iClient)
{
	char szName[MAX_NAME_LENGTH];
	char szUserid[12];

	Menu hMenu = new Menu(Menu_BuildKickMenu);

	hMenu.SetTitle("%sKick Player\n ", TAG_MENU);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i, false))
		{
			IntToString(GetClientUserId(i), szUserid, sizeof(szUserid));
			GetClientName(i, szName, sizeof(szName));

			hMenu.AddItem(szUserid, szName);
		}
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildKickMenu(Menu hMenu, MenuAction Actions, int iClient, int Option)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			char szPlayer[32];

			hMenu.GetItem(Option, szPlayer, sizeof(szPlayer));
			int iTarget = GetClientOfUserId(StringToInt(szPlayer));

			if (!IsValidClient(iTarget, false))
			{
				return 0;
			}

			HYPPunish(iTarget).Form(iClient, "Test Mute", _, 1);
		}

		case MenuAction_Cancel:
		{
			if (Option == MenuCancel_ExitBack)
			{
				DisplayMainAdminMenu(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}

public void DisplayMuteMenu(int iClient)
{
	char szUserid[12];
	char szName[MAX_NAME_LENGTH];

	Menu hMenu = new Menu(Menu_BuildMuteMenu);

	hMenu.SetTitle("%sMute Player\n ", TAG_MENU);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i, false))
		{
			IntToString(GetClientUserId(i), szUserid, sizeof(szUserid));
			GetClientName(i, szName, sizeof(szName));

			hMenu.AddItem(szUserid, szName);
		}
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BuildMuteMenu(Menu hMenu, MenuAction Actions, int iClient, int Option)
{
	switch (Actions)
	{
		case MenuAction_Select:
		{
			char szPlayer[32];

			hMenu.GetItem(Option, szPlayer, sizeof(szPlayer));
			int iTarget = GetClientOfUserId(StringToInt(szPlayer));
			PrintToChatAll("%N", iTarget);

			if (!IsValidClient(iTarget, false))
			{
				return 0;
			}

			HYPPunish(iTarget).Form(iClient, "Test Mute", _, 2);
		}

		case MenuAction_Cancel:
		{
			if (Option == MenuCancel_ExitBack)
			{
				DisplayMainAdminMenu(iClient);
			}
		}

		case MenuAction_End:
		{
			delete hMenu;
		}
	}
	return 0;
}