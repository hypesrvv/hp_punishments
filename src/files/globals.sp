HTTPRequest hRequest;

enum struct Global
{
    GlobalForward fOnPlayerPunished;
}

Global Core;

enum struct ETarget
{
    int iUserID;
    int iBanType;
    bool bBanCheating;
    char szName[MAX_NAME_TRIM];

    void Clear()
    {
        this.iUserID = -1;
        this.szName = "\0";
        this.iBanType = -1;
        this.bBanCheating = false;
    }
}

ETarget g_iTarget;

// enum EBanType
// {
//     k_EBanTypeGlobal,
//     k_EBanTypeVoice,
//     k_EBanTypeChat
// }

// enum EPunishmentType
// {
//     k_EPunishmentTypeBan,
//     k_EPunishmentTypeKick,
//     k_EPunishmentTypeSilence,
//     k_EPunishmentTypeGag,
//     k_EPunishmentTypeMute
// }

// enum EBanReason
// {
//     k_EBanReasonCheat,
//     k_EBanReasonExploit,
//     k_EBanReasonSpam,
//     k_EBanReasonInappropriate,
//     k_EBanReasonIgnorance,
//     k_EBanReasonCustom,

//     k_EBanReasonTotal
// }

// char g_szBanReasons[][] =
// {
//     "Cheating",
//     "Exploiting",
//     "Spamming",
//     "Inappropiate Behaviour",
//     "Ignoring Admins",
//     "Own Reason"
// };

// enum ECheatingReason
// {
//     k_ECheatingReasonAimbot,
//     k_ECheatingReasonAntiRecoil,
//     k_ECheatingReasonWallhack,
//     k_ECheatingReasonMultiHack,

//     k_ECheatingReasonTotal
// }

// char g_szBanCheatingReasons[][] =
// {
//     "Aimbot",
//     "Anti Recoil",
//     "Wall Hack",
//     "Multi-Hack"
// };

// enum EBanTime
// {
//     k_EBanTimePermanent,       // 0,
//     k_EBanTimeDay,             // 1440
//     k_EBanTimeHour,            // 60,
//     k_EBanTimeWeek,            // 10080,
//     k_EBanTimeMonth,           // 43200,
//     k_EBanTimeYear,            // 525600,

//     k_EBanTimeTotal
// }

// char g_szBanTimes[][] =
// {
//     "Permanent",
//     "One Day",
//     "One Hour",
//     "One Week",
//     "One Month",
//     "One Year"
// };

methodmap HYPPlayer < JSONObject
{
    public HYPPlayer()
    {
        return view_as<HYPPlayer>(new JSONObject());
    }

    property int iAccountID
    {
        public get()
        {
            return this.GetInt("recipient_id");
        }

        public set(int iValue)
        {
            this.SetInt("recipient_id", iValue);
        }
    }

    property int iAdminID
    {
        public get()
        {
            return this.GetInt("issuer_id");
        }

        public set(int iValue)
        {
            this.SetInt("issuer_id", iValue);
        }
    }

    property int iServerID
    {
        public get()
        {
            return this.GetInt("server_id");
        }

        public set(int iValue)
        {
            this.SetInt("server_id", iValue);
        }
    }

    public void GetReason(char[] buffer, int maxlength)
    {
        this.GetString("reason", buffer, maxlength);
    }

    public void SetReason(const char[] value)
    {
        this.SetString("reason", value);
    }

    property int iExpires
    {
        public get()
        {
            return this.GetInt("expires_at");
        }

        public set(int iValue)
        {
            this.SetInt("expires_at", iValue);
        }
    }

    property int iType
    {
        public get()
        {
            return this.GetInt("type");
        }

        public set(int iValue)
        {
            this.SetInt("type", iValue);
        }
    }
}

methodmap HYPPunish
{
    public HYPPunish(const int Index)
    {
        return view_as<HYPPunish>(Index);
    }

    property int iUserID
    {
        public get()
        {
            return view_as<int>(this);
        }
    }

    public void Form(int iAdminID, const char[] szReason, int iLength = -1, int iType = 0)
    {
        int iClient = GetClientOfUserId(this.iUserID);
        int iAdmin = GetClientOfUserId(iAdminID);

        if (IsPlayerAlive(iClient))
            // ForcePlayerSuicide(iClient);

        PrintToChatAll("%s\x09%N \x08was banned from the server for \x0F%s", TAG_BANS, iClient, szReason);

        hRequest = new HTTPRequest(API_ENDPOINT ... "/punishment");
        hRequest.SetHeader("Content-Type", "application/json");
        hRequest.SetHeader("Authorization", ACCESS_TOKEN);

        HYPPlayer jPlayer = new HYPPlayer();

        jPlayer.iAccountID = GetSteamAccountID(iClient);

        if (iAdmin == 0)
            jPlayer.iAdminID = 0;
        else
            jPlayer.iAdminID = GetSteamAccountID(iAdmin);

        jPlayer.iServerID = HP_GetServerID();
        jPlayer.SetReason(szReason);

        DateTime dTime = new DateTime(DateTime_Now);

        switch (view_as<EPunishmentTime>(iLength))
        {
            case view_as<EPunishmentTime>(-1): jPlayer.iExpires = 0;
            case k_EPunishmentTimePermanent: jPlayer.iExpires = 0;

            case k_EPunishmentTimeDay:
            {
                dTime += TimeSpan.FromDays(1);
                jPlayer.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeHour:
            {
                dTime += TimeSpan.FromHours(1);
                jPlayer.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeWeek:
            {
                dTime += TimeSpan.FromDays(7);
                jPlayer.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeMonth:
            {
                dTime += TimeSpan.FromDays(30);
                jPlayer.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeYear:
            {
                dTime += TimeSpan.FromDays(365);
                jPlayer.iExpires = dTime.Unix;
            }

            default: jPlayer.iExpires = iLength;
        }

        jPlayer.iType = iType;

#if defined DEBUG
        char szBuffer[1024];
        jPlayer.ToString(szBuffer, sizeof(szBuffer));
        CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

        hRequest.Post(jPlayer, HTTPRequest_OnPlayerPunished, GetClientUserId(iClient));

        // KickClient(iClient, szReason);

        delete jPlayer;
    }

    public void Kick(int iAdmin, const char[] szReason)
    {
        int iClient = GetClientOfUserId(this.iUserID);

        if (IsPlayerAlive(iClient))
            // ForcePlayerSuicide(iClient);

        PrintToChatAll("%s\x09%N \x08was kicked from the server %s", TAG_BANS, iClient, szReason);

        HYPPlayer jPlayer = new HYPPlayer();

        jPlayer.iAccountID = GetSteamAccountID(iClient);
        jPlayer.iAdminID = GetSteamAccountID(iAdmin);
        jPlayer.SetReason(szReason);

#if defined DEBUG
        char szBuffer[1024];
        jPlayer.ToString(szBuffer, sizeof(szBuffer));
        CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

        // hRequest = new HTTPRequest(API_ENDPOINT... "/bans/create");
        // hRequest.Post(jPlayer, HTTPRequest_OnPlayerBan, GetClientOfUserId(this.index));

        // KickClient(this.index, szReason);

        delete jPlayer;
    }
}

