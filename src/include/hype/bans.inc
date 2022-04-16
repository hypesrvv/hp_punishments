#if defined _bans_included
    #endinput
#endif
#define _bans_included

enum EPunishmentType
{
    k_EPunishmentTypeBan,
    k_EPunishmentTypeKick,
    k_EPunishmentTypeSilence,
    k_EPunishmentTypeGag,
    k_EPunishmentTypeMute,

    k_EPunishmentTypeTotal
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

stock char g_szBanReasons[][] =
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

stock char g_szBanCheatingReasons[][] =
{
    "Aimbot",
    "Anti Recoil",
    "Wall Hack",
    "Multi-Hack"
};

enum EPunishmentTime
{
    k_EPunishmentTimePermanent,       // 0,
    k_EPunishmentTimeDay,             // 1440
    k_EPunishmentTimeHour,            // 60,
    k_EPunishmentTimeWeek,            // 10080,
    k_EPunishmentTimeMonth,           // 43200,
    k_EPunishmentTimeYear,            // 525600,

    k_EPunishmentTimeTotal
}

stock char g_szBanTimes[][] =
{
    "Permanent",
    "One Day",
    "One Hour",
    "One Week",
    "One Month",
    "One Year"
};

/**
 *	Called once a client is punnished
 *
 *	@param iUserID			Client UserID.
 *	@param iAdminID			Admin Client UserID. ( Use 0 for Console )
 *	@param szReason			Punishment Reason.
 *	@param szLength			Punishment szLegnth.
 *	@param iType			Punishment Type.
 *
 *	@noreturn
*/
forward void HP_OnClientPunished(int iUserID, int iAdminID, const char[] szReason, const char[] szLength, int iType);

/**
 *	Native for punishing players.
 *
 *	@param iUserID			Client UserID.
 *	@param iAdminID			Admin Client UserID. ( Use 0 for Console )
 *	@param szReason			Punishment Reason.
 *	@param iLength			Punishment Legnth.
 *	@param iType			Punishment Type.
 *
 *	@noreturn
*/
native any HP_PunishPlayer(int iUserID, int iAdminID, const char[] szReason, int iLegnth = 0, int iType);

public SharedPlugin __pl_bans =
{
	name = "Bans",
	file = "hp_bans.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
}

#if !defined REQUIRE_PLUGIN
public void __pl_bans_SetNTVOptional()
{
	MarkNativeAsOptional("HP_PunishPlayer");
}
#endif