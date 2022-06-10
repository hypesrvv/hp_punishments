HTTPRequest hRequest;

enum struct Global
{
    GlobalForward fOnPlayerPunished;
}

Global Core;

#define HP_PUNISHMENTS_ADMIN 1
#define HP_PUNISHMENTS_TARGET 2

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

enum struct ETarget
{
    int iUserID;
    int iReason;
    int iPunishType;
    bool bOwnReason;
    bool bPunishComms;
    bool bPunishCheating;
    char szName[MAX_NAME_TRIM];
    char szReason[MAX_REASON_LEGNTH];

    void Clear()
    {
        this.iUserID = -1;
        this.iReason = -1;
        this.iPunishType = -1;
        this.bPunishComms = false;
        this.bPunishCheating = false;
        this.szName = NULL_STRING;
    }

    void SetupTarget(const int iUserID, const char[] szName)
    {
        this.iUserID = iUserID;
        strcopy(this.szName, sizeof(this.szName), szName);
    }
}

ETarget g_ETarget[MAXPLAYERS + 1];

enum struct EPunishment
{
    int iTargetID;
    int iAdminID;
    char szTargetName[MAX_NAME_TRIM];
    char szAdminName[MAX_NAME_TRIM];
    char szReason[128];
    char szLength[128];
    char szDate[32];
    int iType;
    int iID;

    void Clear()
    {
        this.iTargetID = -1;
        this.iAdminID = -1;
        this.szTargetName = NULL_STRING;
        this.szAdminName = NULL_STRING;
        this.szReason = NULL_STRING;
        this.szLength = NULL_STRING;
        this.szDate = NULL_STRING;
        this.iType = 0;
        this.iID = -1;
    }

    bool Populate(const int iTargetID, const int iAdminID, JSON jData)
    {
        JSONObject jPunishment = view_as<JSONObject>(jData);

        this.iTargetID = iTargetID;
        this.iAdminID = iAdminID;

        GetClientName(GetClientOfUserId(iTargetID), this.szTargetName, sizeof(this.szTargetName));

        if (iAdminID != 0)
            GetClientName(GetClientOfUserId(iAdminID), this.szAdminName, sizeof(this.szAdminName));
        else
            strcopy(this.szAdminName, sizeof(this.szAdminName), "Console");

        if (!jPunishment.GetString("reason", this.szReason, sizeof(this.szReason)))
            strcopy(this.szReason, sizeof(this.szReason), NULL_STRING);

        if (!jPunishment.GetString("expires_at", this.szLength, sizeof(this.szLength)))
            strcopy(this.szLength, sizeof(this.szLength), "Permanent");

        if (!jPunishment.GetString("created_at", this.szDate, sizeof(this.szDate)))
            strcopy(this.szDate, sizeof(this.szDate), NULL_STRING);

        this.iType = jPunishment.GetInt("type");
        this.iID = jPunishment.GetInt("id");

        return true;
    }
}

EPunishment g_EPunishment;

enum struct EUser
{
    int iClient;
    int iAccountID;
    bool bIsSilenced;
    bool bIsGagged;
    bool bIsMuted;
    int iPunishmentCount;
    AnyMap ALPunishments;
    Handle hPunishmentTimer;

    void Clear()
    {
        this.iClient = -1;
        this.bIsSilenced = false;
        this.bIsGagged = false;
        this.bIsMuted = false;
        this.iPunishmentCount = -1;
        delete this.ALPunishments;
        delete this.hPunishmentTimer;
    }

    bool Init(int iClient)
    {
        this.iClient = iClient;
        this.ALPunishments = new AnyMap();
        this.iAccountID = GetSteamAccountID(this.iClient);
    }

    bool LoadPunishments(JSONArray jData)
    {
        JSONObject jPunishment;

        EPunishment PunishmentData;

        this.iPunishmentCount = 0;

        this.ALPunishments.Clear();

        for (int i = (jData.Length - 1); i >= 0; i--)
        {
            jPunishment = view_as<JSONObject>(jData.Get(i));

            PunishmentData.iTargetID = jPunishment.GetInt("recipient_id");
            PunishmentData.iAdminID = jPunishment.GetInt("issuer_id");

            if (!jPunishment.GetString("reason", PunishmentData.szReason, sizeof(PunishmentData.szReason)))
                strcopy(PunishmentData.szReason, sizeof(PunishmentData.szReason), NULL_STRING);

            jPunishment.GetString("created_at", PunishmentData.szDate, sizeof(PunishmentData.szDate));

            if (!jPunishment.GetString("expires_at", PunishmentData.szLength, sizeof(PunishmentData.szLength)))
                strcopy(PunishmentData.szLength, sizeof(PunishmentData.szLength), NULL_STRING);

            PunishmentData.iType = jPunishment.GetInt("type");
            PunishmentData.iID = jPunishment.GetInt("id");

            this.iPunishmentCount++;

            this.ALPunishments.SetArray(i, PunishmentData, sizeof(PunishmentData));
        }

        return true;
    }
}

EUser g_EUser[MAXPLAYERS + 1];

methodmap Punish
{
    public Punish(const int Index)
    {
        return view_as<Punish>(Index);
    }

    property int iTarget
    {
        public get()
        {
            return view_as<int>(this);
        }
    }

    public void Execute(const int iAdmin, const char[] szReason = NULL_STRING, int iLength = -1, int iType = 0)
    {
        hRequest = new HTTPRequest(HYPESRV_API ... "/punishment");
        hRequest.SetHeader("Content-Type", "application/json");
        hRequest.SetHeader("Authorization", HYPESRV_AUTH_TOKEN);

        Punishment jPunishment = new Punishment();

        jPunishment.iTargetID = GetSteamAccountID(this.iTarget);

        if (iAdmin == 0)
            jPunishment.iAdminID = 0;
        else
            jPunishment.iAdminID = GetSteamAccountID(iAdmin);

        jPunishment.iServerID = HP_GetServerID();

        if (szReason[0] != '\0')
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
        LogDebug("Function {YELLOW}HYPPunish::Punish {GREY}%s", szJson);
#endif

        DataPack hPack = new DataPack();

        hPack.WriteCell(GetClientUserId(this.iTarget));

        if (iAdmin != 0)
            hPack.WriteCell(GetClientUserId(iAdmin));
        else
            hPack.WriteCell(0);

        hRequest.Post(jPunishment, HTTPRequest_OnPlayerPunished, hPack);

        delete jPunishment;
    }
}