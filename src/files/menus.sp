void DisplayAdminMenu(int iClient)
{
    Menu hMenu = new Menu(Menu_AdminMainHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Admin Menu\n ");

    hMenu.AddItem(NULL_STRING, "Kick Player");
    hMenu.AddItem(NULL_STRING, "Ban Player");
    hMenu.AddItem(NULL_STRING, "Communication");
    hMenu.AddItem(NULL_STRING, "Player Management");

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
                case 2: DisplayCommunicationMenu(iClient); // DisplayCommunicationMenu(iClient);
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
    decl char szName[MAX_NAME_TRIM];
    Menu hMenu = new Menu(Menu_PunishHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Ban Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i))
        {
            GetClientName(i, szName, sizeof(szName));

            hMenu.AddItem(IntToStr(GetClientUserId(i)), szName);
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

            g_ETarget[iClient].SetupTarget(StringToInt(szUserID), szName);

            DisplayPunishReasonMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_ETarget[iClient].Clear();

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
    Menu hMenu = new Menu(Menu_PunishReasonsHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Ban %s\n ", g_ETarget[iClient].szName);

    for (int i = 0; i < view_as<int>(k_EBanReasonTotal); i++)
        hMenu.AddItem(NULL_STRING, g_szBanReasons[i]);

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
            g_ETarget[iClient].iPunishType = view_as<int>(k_EPunishmentTypeBan);

            if (iOption == view_as<int>(k_EBanReasonCheat))
            {
                g_ETarget[iClient].bPunishCheating = true;
                DisplayBanCheaterMenu(iClient);
            }
            else
            {
                g_ETarget[iClient].iReason = iOption;
                DisplayBanTimeMenu(iClient);
            }
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_ETarget[iClient].Clear();

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

void DisplayBanTimeMenu(int iClient)
{
    Menu hMenu = new Menu(Menu_BanTimeHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "%s %s\n ", (g_ETarget[iClient].bPunishComms == true ? "Punish" : "Ban"), g_ETarget[iClient].szName);

    for (int i = 0; i < view_as<int>(k_EPunishmentTimeTotal); i++)
        hMenu.AddItem(NULL_STRING, g_szBanTimes[i]);

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BanTimeHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            if (g_ETarget[iClient].bPunishCheating)
                Punish(GetClientOfUserId(g_ETarget[iClient].iUserID)).Execute(iClient, g_szBanCheatingReasons[g_ETarget[iClient].iReason], iOption, g_ETarget[iClient].iPunishType);
            else
            {
                if (g_ETarget[iClient].iReason != -1)
                    Punish(GetClientOfUserId(g_ETarget[iClient].iUserID)).Execute(iClient, g_szBanReasons[g_ETarget[iClient].iReason], iOption, g_ETarget[iClient].iPunishType);
                else
                    Punish(GetClientOfUserId(g_ETarget[iClient].iUserID)).Execute(iClient, _, iOption, g_ETarget[iClient].iPunishType);
            }

            g_ETarget[iClient].Clear();
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                if (g_ETarget[iClient].bPunishComms)
                {
                    g_ETarget[iClient].bPunishComms = false;
                    DisplayCommunicationMenu(iClient);
                }
                else
                    DisplayPunishReasonMenu(iClient);
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
    Menu hMenu = new Menu(Menu_BanCheaterHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Ban %s\n ", g_ETarget[iClient].szName);

    for (int i = 0; i < view_as<int>(k_ECheatingReasonTotal); i++)
        hMenu.AddItem(NULL_STRING, g_szBanCheatingReasons[i]);

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_BanCheaterHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            g_ETarget[iClient].iReason = iOption;
            DisplayBanTimeMenu(iClient);
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

void DisplayCommunicationMenu(int iClient)
{
    decl char szName[MAX_NAME_TRIM];
    Menu hMenu = new Menu(Menu_CommunicationHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Communication\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i))
        {
            GetClientName(i, szName, sizeof(szName));

            hMenu.AddItem(IntToStr(GetClientUserId(i)), szName);
        }
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_CommunicationHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            decl char szUserID[16];
            decl char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));

            g_ETarget[iClient].SetupTarget(StringToInt(szUserID), szName);

            DisplaySelectCommunicationMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_ETarget[iClient].Clear();

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

void DisplaySelectCommunicationMenu(int iClient)
{
    Menu hMenu = new Menu(Menu_PunishCommunicationHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Edit Comms %s\n ", g_ETarget[iClient].szName);

    hMenu.AddItem(NULL_STRING, "Silence");
    hMenu.AddItem(NULL_STRING, "Gag");
    hMenu.AddItem(NULL_STRING, "Mute");

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_PunishCommunicationHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            g_ETarget[iClient].iPunishType = (iOption + 2);
            g_ETarget[iClient].bPunishComms = true;
            DisplayBanTimeMenu(iClient);
        }

        case MenuAction_Cancel:
        {
            if (iOption == MenuCancel_ExitBack)
            {
                g_ETarget[iClient].Clear();

                DisplayCommunicationMenu(iClient);
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
    decl char szName[MAX_NAME_TRIM];
    Menu hMenu = new Menu(Menu_KickHandler);

    hMenu.SetTitle(TAG_HYPESRV_MENU ... "Kick Player\n ");

    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsClientConnected(i))
        {
            GetClientName(i, szName, sizeof(szName));

            hMenu.AddItem(IntToStr(GetClientUserId(i)), szName);
        }
    }

    hMenu.ExitButton = true;
    hMenu.ExitBackButton = true;
    hMenu.Display(iClient, MENU_TIME_FOREVER);
}

public int Menu_KickHandler(Menu hMenu, MenuAction iAction, int iClient, int iOption)
{
    switch (iAction)
    {
        case MenuAction_Select:
        {
            decl char szUserID[16];
            decl char szName[MAX_NAME_TRIM];
            hMenu.GetItem(iOption, szUserID, sizeof(szUserID), _, szName, sizeof(szName));

            Punish(GetClientOfUserId(StringToInt(szUserID))).Execute(iClient, _, -1, view_as<int>(k_EPunishmentTypeKick));
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