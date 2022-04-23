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
        this.szName = NULL_STRING;
        this.iPunishType = -1;
        this.bPunishCheating = false;
    }
}

ETarget g_iTarget;

enum struct EPunishment
{
    int iTargetID;
    int iAdminID;
    char szTargetName[MAX_NAME_TRIM];
    char szAdminName[MAX_NAME_TRIM];
    char szReason[128];
    char szLength[128];
    int iType;
    int iBanID;

    void Clear()
    {
        this.iTargetID = -1;
        this.iAdminID = -1;
        this.szTargetName = NULL_STRING;
        this.szAdminName = NULL_STRING;
        this.szReason = NULL_STRING;
        this.szLength = NULL_STRING;
        this.iType = 0;
        this.iBanID = -1;
    }

    bool Populate(int iTargetID, int iAdminID, JSON jData)
    {
        JSONObject jPunishment = view_as<JSONObject>(jData);

        this.iTargetID = iTargetID;
        this.iAdminID = iAdminID;

        GetClientName(iTargetID, this.szTargetName, sizeof(this.szTargetName));
        GetClientName(iAdminID, this.szAdminName, sizeof(this.szAdminName));

        if (!jPunishment.GetString("reason", this.szReason, sizeof(this.szReason)))
            strcopy(this.szReason, sizeof(this.szReason), NULL_STRING);

        if (!jPunishment.GetString("expires_at", this.szLength, sizeof(this.szLength)))
            strcopy(this.szLength, sizeof(this.szLength), "Permanent");

        this.iType = jPunishment.GetInt("type");
        this.iBanID = jPunishment.GetInt("id");

        return true;
    }
}

EPunishment g_EPunishment;

methodmap Punishment < JSONObject
{
    public Punishment()
    {
        return view_as<Punishment>(new JSONObject());
    }

    property int iTargetID
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

    public void Punish(const int iAdmin, const char[] szReason, int iLength = -1, int iType = 0)
    {
        hRequest = new HTTPRequest(API_ENDPOINT ... "/punishment");
        hRequest.SetHeader("Content-Type", "application/json");
        hRequest.SetHeader("Authorization", ACCESS_TOKEN);

        Punishment jPunishment = new Punishment();

        jPunishment.iTargetID = GetSteamAccountID(this.iUserID);

        if (iAdmin == 0)
            jPunishment.iAdminID = 0;
        else
            jPunishment.iAdminID = GetSteamAccountID(iAdmin);

        jPunishment.iServerID = HP_GetServerID();
        jPunishment.SetReason(szReason);

        DateTime dTime = new DateTime(DateTime_Now);

        switch (view_as<EPunishmentTime>(iLength))
        {
            case view_as<EPunishmentTime>(-1): {}
            case k_EPunishmentTimePermanent: {}

            case k_EPunishmentTimeDay:
            {
                dTime += TimeSpan.FromDays(1);
                jPunishment.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeHour:
            {
                dTime += TimeSpan.FromHours(1);
                jPunishment.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeWeek:
            {
                dTime += TimeSpan.FromDays(7);
                jPunishment.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeMonth:
            {
                dTime += TimeSpan.FromDays(30);
                jPunishment.iExpires = dTime.Unix;
            }

            case k_EPunishmentTimeYear:
            {
                dTime += TimeSpan.FromDays(365);
                jPunishment.iExpires = dTime.Unix;
            }

            default: jPunishment.iExpires = iLength;
        }

        jPunishment.iType = iType;

#if defined DEBUG
        decl char szJson[1024];
        jPunishment.ToString(szJson, sizeof(szJson));
        LogDebug("{YELLOW}HYPPunish::Punish {GREY}%s", szJson);
#endif

        DataPack hPack = new DataPack();
        hPack.WriteCell(GetClientUserId(this.iUserID));
        hPack.WriteCell(GetClientUserId(iAdmin));

        hRequest.Post(jPunishment, HTTPRequest_OnPlayerPunished, hPack);

        delete jPunishment;
    }

    public void Kick(int iAdmin, const char[] szReason)
    {
        int iClient = GetClientOfUserId(this.iUserID);

        if (IsPlayerAlive(iClient))
            // ForcePlayerSuicide(iClient);

        PrintToChatAll("%s\x09%N \x08was kicked from the server %s", TAG_BANS, iClient, szReason);

        Punishment jPunishment = new Punishment();

        jPunishment.iTargetID = GetSteamAccountID(this.iUserID);
        jPunishment.iAdminID = GetSteamAccountID(iAdmin);
        jPunishment.SetReason(szReason);

#if defined DEBUG
        char szBuffer[1024];
        jPunishment.ToString(szBuffer, sizeof(szBuffer));
        CPrintToServer("{LIGHTBLUE}%s", szBuffer);
#endif

        // hRequest = new HTTPRequest(API_ENDPOINT... "/bans/create");
        // hRequest.Post(jPlayer, HTTPRequest_OnPlayerBan, GetClientOfUserId(this.index));

        // KickClient(this.index, szReason);

        delete jPunishment;
    }
}

