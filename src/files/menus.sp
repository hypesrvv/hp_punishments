void DisplayAdminMenu(int iClient)
{
    Menu hMenu = new Menu(Menu_AdminMainHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Admin Menu\n ");

    hMenu.AddItem("0", "Kick Player");
    hMenu.AddItem("1", "Punish Player");
    hMenu.AddItem("2", "Communication");
    hMenu.AddItem("3", "Player Management");

    hMenu.ExitButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_AdminMainHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            switch (iOption)
            {
                case 0: DisplayKickMenu(iClient);
                case 1: DisplayPunishMenu(iClient);
                case 2: DisplayPunishMenu(iClient); // DisplayCommunicationMenu(iClient);
                case 3: DisplayPunishMenu(iClient); // DisplayManagementMenu(iClient);
            }
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}

void DisplayPunishMenu(int iClient)
{
    decl char szUserID[16];
    decl char szName[MAX_NAME_TRIM];

    Menu hMenu = new Menu(Menu_PunishHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Punish Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i))
        {
            GetClientName(i, szName, sizeof(szName));
            IntToString(GetClientUserId(i), szUserID, sizeof(szUserID));

            hMenu.AddItem(szUserID, szName);
        }
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_PunishHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            decl char szUserID[16];
            decl char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));

            g_iTarget.iUserID = StringToInt(szUserID);
            strcopy(g_iTarget.szName, sizeof(ETarget::szName), szName);

            DisplayPunishReasonMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_iTarget.Clear();

                DisplayAdminMenu(iClient);
            }
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}

void DisplayPunishReasonMenu(int iClient)
{
    decl char szID[1];

    Menu hMenu = new Menu(Menu_PunishReasonsHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Punish %s\n ", g_iTarget.szName);

    for (int i = 0; i < view_as<int>(k_EBanReasonTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanReasons[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_PunishReasonsHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            if (iOption == view_as<int>(k_EBanReasonCheat))
            {
                g_iTarget.iPunishType = 0;
                g_iTarget.bPunishCheating = true;
                DisplayPunishCheaterMenu(iClient);
                return 0;
            }

            g_iTarget.iPunishType = iOption;
            g_iTarget.bPunishCheating = false;
            DisplayPunishTimeMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_iTarget.Clear();

                DisplayPunishMenu(iClient);
            }
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}

void DisplayPunishTimeMenu(int iClient)
{
    decl char szID[1];

    Menu hMenu = new Menu(Menu_PunishTimeHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Punish %s\n ", g_iTarget.szName);

    for (int i = 0; i < view_as<int>(k_EPunishmentTimeTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanTimes[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_PunishTimeHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            if (g_iTarget.bPunishCheating)
            {
                HYPPunish(g_iTarget.iUserID).Punish(GetClientUserId(iClient), g_szBanCheatingReasons[g_iTarget.iPunishType], iOption);
                return 0;
            }

            HYPPunish(g_iTarget.iUserID).Punish(GetClientUserId(iClient), g_szBanReasons[g_iTarget.iPunishType], iOption);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
                DisplayPunishReasonMenu(iClient);
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}

void DisplayPunishCheaterMenu(int iClient)
{
    decl char szID[1];

    Menu hMenu = new Menu(Menu_PunishCheaterHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Punish %s\n ", g_iTarget.szName);

    for (int i = 0; i < view_as<int>(k_ECheatingReasonTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanCheatingReasons[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_PunishCheaterHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            g_iTarget.iPunishType = iOption;
            DisplayPunishTimeMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
                DisplayPunishReasonMenu(iClient);
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}

void DisplayKickMenu(int iClient)
{
    decl char szUserID[16];
    decl char szName[MAX_NAME_TRIM];

    Menu hMenu = new Menu(Build_KickMenu);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Kick Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsClientConnected(i))
        {
            GetClientName(i, szName, sizeof(szName));
            IntToString(GetClientUserId(i), szUserID, sizeof(szUserID));

            hMenu.AddItem(szUserID, szName);
        }
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Build_KickMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            decl char szUserID[16];
            decl char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
                DisplayAdminMenu(iClient);
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }

    return 0;
}