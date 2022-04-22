HTTPRequest hRequest;

enum struct Global
{
    GlobalForward fOnPlayerPunished;
}

Global Core;

#define HP_PUNISHMENTS_ADMIN 1
#define HP_PUNISHMENTS_TARGET 2

enum struct ETarget
{
    int iUserID;
    int iPunishType;
    bool bPunishCheating;
    char szName[MAX_NAME_TRIM];

    void Clear()
    {
        this.iUserID = -1;
        this.szName = "\0";
        this.iPunishType = -1;
        this.bPunishCheating = false;
    }
}

ETarget g_iTarget;

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

    public void Punish(int iAdminID, const char[] szReason, int iLength = -1, int iType = 0)
    {
        int iClient = GetClientOfUserId(this.iUserID);
        int iAdmin = GetClientOfUserId(iAdminID);

        if (IsPlayerAlive(iClient))
            ForcePlayerSuicide(iClient);

        PrintToChatAll("%s\x09%N \x08was banned from the server for \x0F%s", TAG_BANS, iClient, szReason);

        hRequest = new HTTPRequest(API_ENDPOINT ... "/punishment");
        hRequest.SetHeader("Content-Type", "application/json");
        hRequest.SetHeader("Authorization", ACCESS_TOKEN);

        HYPPlayer jPlayer = new HYPPlayer();

        jPlayer.iAccountID = GetSteamAccountID(iAdmin);

        if (iAdmin == 0)
            jPlayer.iAdminID = 0;
        else
            jPlayer.iAdminID = GetSteamAccountID(iAdmin);

        jPlayer.iServerID = HP_GetServerID();
        jPlayer.SetReason(szReason);

        DateTime dTime = new DateTime(DateTime_Now);

        switch (view_as<EPunishmentTime>(iLength))
        {
            case view_as<EPunishmentTime>(-1): {}
            case k_EPunishmentTimePermanent: {}

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
        decl char szJson[1024];
        jPlayer.ToString(szJson, sizeof(szJson));
        CPrintToServer("{LIGHTBLUE}%s", szJson);
#endif

        hRequest.Post(jPlayer, HTTPRequest_OnPlayerPunished, ((iAdminID << 4) | this.iUserID));

        KickClient(iClient, szReason);

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

