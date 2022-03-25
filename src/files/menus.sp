void DisplayAdminMenu(int iClient)
{
    Menu hMenu = new Menu(Build_AdminMainMenu);

    hMenu.SetTitle(TAG_HYPE_MENU ... "Admin Menu\n ");

    hMenu.AddItem("0", "Ban Player");
    hMenu.AddItem("1", "Kick Player");
    hMenu.AddItem("2", "Communication");
    hMenu.AddItem("3", "Player Management");

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

    hMenu.SetTitle(TAG_HYPE_MENU ... "Ban Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) || IsClientConnected(i))
        {
            GetClientName(i, szName, sizeof(szName));
            IntToString(GetClientUserId(i), szUserID, sizeof(szUserID));

            hMenu.AddItem(szUserID, szName);
        }
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);

    // switch (iPosition)
    // {
    //     case 0: hMenu.Display(iClient, MENU_TIME_FOREVER);
    //     default: hMenu.DisplayAt(iClient, MENU_TIME_FOREVER, iPosition);
    // }
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

            g_iTarget.iUserID = StringToInt(szUserID);
            strcopy(g_iTarget.szName, sizeof(Target::szName), szName);

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

    hMenu.SetTitle(TAG_HYPE_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(k_EBanReasonTotal); i++)
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
            if (iOption == view_as<int>(k_EBanReasonCheat))
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

    hMenu.SetTitle(TAG_HYPE_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(k_EBanTimeTotal); i++)
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
                HYPPunish(g_iTarget.iUserID).Form(iClient, g_szBanCheatingReasons[g_iTarget.iBanType], iOption);
                return 0;
            }

            HYPPunish(g_iTarget.iUserID).Form(iClient, g_szBanReasons[g_iTarget.iBanType], iOption);
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

    hMenu.SetTitle(TAG_HYPE_MENU ... "Ban %s\n ", g_iTarget.szName);

    char szID[1];
    for (int i = 0; i < view_as<int>(k_EBanReasonTotal); i++)
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

    hMenu.SetTitle(TAG_HYPE_MENU ... "Kick Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) || IsClientConnected(i))
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