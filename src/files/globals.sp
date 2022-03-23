HTTPRequest hRequest;

enum struct Global
{
    GlobalForward fOnPlayerPunished;
}

Global Core;

enum struct Target
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

Target g_iTarget;

enum EBanType
{
    k_EBanTypeGlobal,
    k_EBanTypeVoice,
    k_EBanTypeChat
}

enum EInfractionType
{
    k_EInfractionTypeKick,
    k_EInfractionTypeSilence,
    k_EInfractionTypeGag,
    k_EInfractionTypeMute
}

enum EBanReason
{
    k_EBanReasonCheat,
    k_EBanReasonExploit,
    k_EBanReasonSpam,
    k_EBanReasonInappropriate,
    k_EBanReasonIgnorance,
    k_EBanReasonCustom,

    k_EBanReasonTotal
}

char g_szBanReasons[][] =
{
    "Cheating",
    "Exploiting",
    "Spamming",
    "Inappropiate Behaviour",
    "Ignoring Admins",
    "Own Reason"
};

enum ECheatingReason
{
    k_ECheatingReasonAimbot,
    k_ECheatingReasonAntiRecoil,
    k_ECheatingReasonWallhack,
    k_ECheatingReasonMultiHack,

    k_ECheatingReasonTotal
}

char g_szBanCheatingReasons[][] =
{
    "Aimbot",
    "Anti Recoil",
    "Wall Hack",
    "Multi-Hack"
};

enum EBanTime
{
    k_EBanTimePermanent,       // 0,
    k_EBanTimeDay,             // 1440
    k_EBanTimeHour,            // 60,
    k_EBanTimeWeek,            // 10080,
    k_EBanTimeMonth,           // 43200,
    k_EBanTimeYear,            // 525600,

    k_EBanTimeTotal
}

char g_szBanTimes[][] =
{
    "Permanent",
    "One Day",
    "One Hour",
    "One Week",
    "One Month",
    "One Year"
};

methodmap HYPPlayer < JSONObject
{
    public HYPPlayer()
    {
        return view_as<HYPPlayer>(new JSONObject());
    }

    property int AccountID
    {
        public get()
        {
            return this.GetInt("accountid");
        }

        public set(int iValue)
        {
            this.SetInt("accountid", iValue);
        }
    }

    property int AdminID
    {
        public get()
        {
            return this.GetInt("adminid");
        }

        public set(int iValue)
        {
            this.SetInt("adminid", iValue);
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

    property int Expires
    {
        public get()
        {
            return this.GetInt("expires");
        }

        public set(int iValue)
        {
            this.SetInt("expires", iValue);
        }
    }

    property int Type
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

    property int index
    {
        public get()
        {
            return view_as<int>(this);
        }
    }

    public void Form(int iAdmin, const char[] szReason, int iLength = -1, int iType = 0)
    {
        if (IsPlayerAlive(this.index))
        {
            ForcePlayerSuicide(this.index);
        }

        PrintToChatAll("%s\x09%N \x08was banned from the server for \x0F%s", TAG_BANS, this.index, szReason);

        HYPPlayer jPlayer = new HYPPlayer();

        jPlayer.AccountID = GetSteamAccountID(this.index);
        jPlayer.AdminID = GetSteamAccountID(iAdmin);
        jPlayer.SetReason(szReason);

        DateTime dTime = new DateTime(DateTime_Now);

        switch (view_as<EBanTime>(iLength))
        {
            case view_as<EBanTime>(-1):
            {
                jPlayer.Expires = 0;
            }

            case k_EBanTimePermanent:
            {
                jPlayer.Expires = 0;
            }

            case k_EBanTimeDay:
            {
                dTime += TimeSpan.FromDays(1);
                jPlayer.Expires = dTime.Unix;
            }

            case k_EBanTimeHour:
            {
                dTime += TimeSpan.FromHours(1);
                jPlayer.Expires = dTime.Unix;
            }

            case k_EBanTimeWeek:
            {
                dTime += TimeSpan.FromDays(7);
                jPlayer.Expires = dTime.Unix;
            }

            case k_EBanTimeMonth:
            {
                dTime += TimeSpan.FromDays(30);
                jPlayer.Expires = dTime.Unix;
            }

            case k_EBanTimeYear:
            {
                dTime += TimeSpan.FromDays(365);
                jPlayer.Expires = dTime.Unix;
            }

            default:
            {
                jPlayer.Expires = iLength;
            }
        }

        jPlayer.Type = iType;

#if defined DEBUG
        char szBuffer[1024];
        jPlayer.ToString(szBuffer, sizeof(szBuffer));
        CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

        // hRequest = new HTTPRequest(API_ENDPOINT ... "/bans/create");
        // hRequest.Post(jPlayer, HTTPRequest_OnPlayerBan, GetClientOfUserId(this.index));

        // KickClient(this.index, szReason);

        delete jPlayer;
    }

    public void Kick(int iAdmin, const char[] szReason)
    {
        if (IsPlayerAlive(this.index))
        {
            ForcePlayerSuicide(this.index);
        }

        PrintToChatAll("%s\x09%N \x08was kicked from the server %s", TAG_BANS, this.index, szReason);

        HYPPlayer jPlayer = new HYPPlayer();

        jPlayer.AccountID = GetSteamAccountID(this.index);
        jPlayer.AdminID = GetSteamAccountID(iAdmin);
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

