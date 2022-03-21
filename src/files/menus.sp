void DisplayAdminMenu(int iClient)
{
    Menu hMenu = new Menu(Build_AdminMainMenu);

    hMenu.SetTitle(TAG_MENU ... "Admin Menu\n ");

    hMenu.AddItem("0", "Ban");
    hMenu.AddItem("1", "Kick");
    hMenu.AddItem("2", "Communication");
    hMenu.AddItem("3", "User Management");

    hMenu.ExitButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Build_AdminMainMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            switch (iOption)
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
                    // DisplayCommunicationMenu(iClient);
                }

                case 3:
                {
                    // DisplayManagementMenu(iClient);
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

void DisplayBanMenu(int iClient)
{
    char szUserID[16];
    char szName[MAX_NAME_TRIM];
    Menu hMenu = new Menu(Build_BanMenu);

    hMenu.SetTitle(TAG_MENU ... "Ban User\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i))
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

public int Build_BanMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            char szUserID[16];
            char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));

            g_iTarget.iClient = StringToInt(szUserID);
            strcopy(g_iTarget.szName, sizeof(User::szName), szName);

            DisplayBanReasonMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
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

void DisplayBanReasonMenu(int iClient)
{
    Menu hMenu = new Menu(Build_BanReasonsMenu);

    hMenu.SetTitle(TAG_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(BanReasonsTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanReasons[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Build_BanReasonsMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            if (iOption == view_as<int>(Cheating))
            {
                g_iTarget.iBanType = 0;
                g_iTarget.bBanCheating = true;
                DisplayBanCheaterMenu(iClient);
                return 0;
            }

            g_iTarget.iBanType = iOption;
            g_iTarget.bBanCheating = false;
            DisplayBanTimeMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_iTarget.iBanType = -1;
                g_iTarget.bBanCheating = false;
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

void DisplayBanTimeMenu(int iClient)
{
    Menu hMenu = new Menu(Build_BanTimeMenu);

    hMenu.SetTitle(TAG_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(BanTimesTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanTimes[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Build_BanTimeMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            if (g_iTarget.bBanCheating)
            {
                HYPPunish(GetClientOfUserId(g_iTarget.iClient)).Form(iClient, g_szBanCheatingReasons[g_iTarget.iBanType], iOption);
                return 0;
            }

            HYPPunish(GetClientOfUserId(g_iTarget.iClient)).Form(iClient, g_szBanReasons[g_iTarget.iBanType], iOption);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                DisplayBanReasonMenu(iClient);
            }
        }

        case MenuAction_End:
        {
            delete hMenu;
        }
    }
    return 0;
}

void DisplayBanCheaterMenu(int iClient)
{
    Menu hMenu = new Menu(Build_BanCheaterMenu);

    hMenu.SetTitle(TAG_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(BanCheatingReasonsTotal); i++)
    {
        IntToString(i, szID, sizeof(szID));
        hMenu.AddItem(szID, g_szBanCheatingReasons[i]);
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Build_BanCheaterMenu(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            g_iTarget.iBanType = iOption;
            DisplayBanTimeMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                DisplayBanReasonMenu(iClient);
            }
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
    char szUserID[16];
    char szName[MAX_NAME_TRIM];
    Menu hMenu = new Menu(Build_KickMenu);

    hMenu.SetTitle(TAG_MENU ... "Kick User\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsValidClient(i))
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
            char szUserID[16];
            char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
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