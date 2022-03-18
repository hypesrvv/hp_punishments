HTTPRequest hRequest;

enum struct Global
{
    GlobalForward fOnPlayerPunished;
}

Global Core;

enum struct User
{
    int iClient;
    char szName[MAX_NAME_TRIM];

    int iBanType;
    bool bBanCheating;

    void Clear()
    {
        this.iClient = -1;
        this.szName = "\0";
        this.iBanType = -1;
        this.bBanCheating = false;
    }
}

User g_iTarget;

enum BanType
{
    GLOBAL,
    SILENCE,
    VOICE,
    CHAT
}

enum InfractionType
{
    KICKED,
    SILENCED,
    GAGGED,
    MUTED
}

enum BanReasons
{
    Cheating,
    Exploiting,
    Spamming,
    Inappropriate,
    Ignoring,
    OwnReason,

    BanReasonsTotal
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

enum BanCheatingReasons
{
    Aimbot,
    AntiRecoil,
    Wallhack,
    MultiHack,

    BanCheatingReasonsTotal
}

char g_szBanCheatingReasons[][] =
{
    "Aimbot",
    "Anti Recoil",
    "Wall Hack",
    "Multi-Hack"
};

enum BanTimes
{
    Permanent,          // 0,
    OneDay,
    OneHour,            // 60,
    OneWeek,            // 10080,
    OneMonth,           // 43200,
    OneYear,            // 525600,

    BanTimesTotal
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

        switch (view_as<BanTimes>(iLength))
        {
            case view_as<BanTimes>(-1):
            {
                jPlayer.Expires = 0;
            }

            case Permanent:
            {
                jPlayer.Expires = 0;
            }

            case OneDay:
            {
                dTime += TimeSpan.FromDays(1);
                jPlayer.Expires = dTime.Unix;
            }

            case OneHour:
            {
                dTime += TimeSpan.FromHours(1);
                jPlayer.Expires = dTime.Unix;
            }

            case OneWeek:
            {
                dTime += TimeSpan.FromDays(7);
                jPlayer.Expires = dTime.Unix;
            }

            case OneMonth:
            {
                dTime += TimeSpan.FromDays(30);
                jPlayer.Expires = dTime.Unix;
            }

            case OneYear:
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
