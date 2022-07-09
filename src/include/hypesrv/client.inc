#if defined _HP_MODULE_CLIENT_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_CLIENT_INCLUDED_

#define MAX_AUTH_LENGTH		21
#define MAX_IP_LENGTH 		23

enum WaterLevel
{
	WL_NotInWater = 0,
	WL_Feet,
	WL_Waist,
	WL_Full
};

enum TeamType
{
	TeamType_Unknown = 0,
	TeamType_Active,
	TeamType_Spectator,
	TeamType_Unassigned
};

stock bool IsClientCrouching(int iClient)
{
	return (GetEntityFlags(iClient) & FL_DUCKING);
}

stock bool IsClientOnGround(int iClient)
{
	return (GetEntityFlags(iClient) & FL_ONGROUND);
}

stock bool IsClientOnLadder(int iClient)
{
	return (GetEntityMoveType(iClient) == MOVETYPE_LADDER);
}

stock bool IsClientCoaching(int iClient)
{
	return (GetClientTeam(iClient) == CS_TEAM_SPECTATOR && HP_GetEntPropBool(iClient, Prop_Send, "m_iCoachingTeam"));
}

stock bool IsLookingAtWall(int iClient, float fDistance = 40.0)
{
	decl float fEye[3], fEyeAngle[3];
	bool isClientLookingAtWall = false;

	GetClientEyePosition(iClient, fEye);
	GetClientEyeAngles(iClient, fEyeAngle);

	fEyeAngle[0] = 0.0;

	Handle hTrace = TR_TraceRayFilterEx(fEye, fEyeAngle, CONTENTS_SOLID, RayType_Infinite, LookingWall_TraceEntityFilter);

	if (TR_DidHit(hTrace))
	{
		if (TR_GetEntityIndex(hTrace) > 0)
		{
			CloseHandle(hTrace);
			return false;
		}

		decl float fEnd[3];

		TR_GetEndPosition(fEnd, hTrace);

		if (GetVectorDistance(fEye, fEnd, true) <= (fDistance * fDistance))
			isClientLookingAtWall = true;
	}

	CloseHandle(hTrace);

	return isClientLookingAtWall;
}

public bool LookingWall_TraceEntityFilter(int iEntity, int iMask)
{
	return (iEntity == 0);
}

stock TeamType GetClientTeamType(int iClient, int iTeam)
{
	switch (GetClientTeam(iClient))
	{
		case CS_TEAM_NONE:			return TeamType_Unassigned;
		case CS_TEAM_T, CS_TEAM_CT:	return TeamType_Active;
		case CS_TEAM_SPECTATOR:		return TeamType_Spectator;
		default:					return TeamType_Unknown;
	}
}

stock float GetPlayerSpeed(int iClient)
{
	decl float fVelocity[3];
	GetEntPropVector(iClient, Prop_Data, "m_vecAbsVelocity", fVelocity);
	return GetVectorLength(fVelocity);
}

stock int GetClientVehicle(int iClient)
{
	return GetEntPropEnt(iClient, Prop_Send, "m_hVehicle");
}

stock void GetClientLastPlaceName(int iClient, char[] szBuffer, int iSize)
{
	GetEntPropString(iClient, Prop_Send, "m_szLastPlaceName", szBuffer, iSize);
}

stock WaterLevel GetClientWaterLevel(int iClient)
{
	return view_as<WaterLevel>(GetEntProp(iClient, Prop_Send, "m_nWaterLevel"));
}

stock int GetClientFOV(int iClient)
{
	return GetEntProp(iClient, Prop_Send, "m_iFOV");
}

stock void SetClientFOV(int iClient, int iValue)
{
	SetEntProp(iClient, Prop_Send, "m_iFOV", iValue);
}

stock void GetClientViewOffset(int iClient, float fVec[3])
{
	GetEntPropVector(iClient, Prop_Data, "m_vecViewOffset", fVec);
}

stock void SetViewOffset(int iClient, float fVec[3])
{
	SetEntPropVector(iClient, Prop_Data, "m_vecViewOffset", fVec);
}

stock void SetClientCoaching(int iClient, int iTeam)
{
	SetEntProp(iClient, Prop_Send, "m_iCoachingTeam", iTeam);
}

stock void SetClientArmor(int iClient, int value)
{
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", value);
}

stock void SetClientFrags(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Data, "m_iFrags", iValue);
}

stock void SetClientDeaths(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Data, "m_iDeaths", iValue);
}

stock void SetClientMoney(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Send, "m_iAccount", iValue);
}

stock void GiveClientMoney(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Send, "m_iAccount", (GetEntProp(client, Prop_Send, "m_iAccount") + iValue));
}

stock void SetClientKevlar(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Send, "m_ArmorValue", iValue);
}

stock void SetClientHelmet(int iClient, bool bHasHelmet)
{
    SetEntProp(iClient, Prop_Send, "m_bHasHelmet", bHasHelmet);
}

stock void SetClientHud(int iClient, int iValue)
{
    SetEntProp(iClient, Prop_Send, "m_iHideHUD", iValue);
}

stock void ShowOverlayToClient(int iClient, const char[] szOverlayPath)
{
	ClientCommand(iClient, "r_screenoverlay \"%s\"", szOverlayPath);
}

stock void ShowOverlayToAll(const char[] szOverlayPath)
{
	for (int i = 1; i <= MaxClients; i++)
		ShowOverlayToClient(i, szOverlayPath);
}

stock void SetGodMode(int iClient, bool bEnabled)
{
	SetEntProp(iClient, Prop_Data, "m_takedamage", bEnabled ? 0 : 2, 1);
}

stock void SetThirdPerson(int iClient)
{
	SetEntPropEnt(iClient, Prop_Send, "m_hObserverTarget", 0);
	SetEntProp(iClient, Prop_Send, "m_iObserverMode", 1);
	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 0);
	SetEntProp(clieiClientnt, Prop_Send, "m_iFOV", 120);
}

stock void SetFirstPerson(int client)
{
	SetEntPropEnt(iClient, Prop_Send, "m_hObserverTarget", 1);
	SetEntProp(iClient, Prop_Send, "m_iObserverMode", 0);
	SetEntProp(iClient, Prop_Send, "m_bDrawViewmodel", 1);
	SetEntProp(iClient, Prop_Send, "m_iFOV", 90);
}

stock void ResetArmor(int iClient)
{
	SetEntProp(iClient, Prop_Send, "m_bHasHelmet", 0);
	SetEntProp(iClient, Prop_Send, "m_ArmorValue", 0, 0);
	SetEntProp(iClient, Prop_Send, "m_bHasHeavyArmor", 0);
	SetEntProp(iClient, Prop_Send, "m_bWearingSuit", 0);
}

stock void RadarVisibilityToggle(int iClient, bool bStatus)
{
	static int iOffset = FindSendPropInfo("CBaseEntity", "m_bSpotted");

	if (iOffset)
	{
		static Address g_aCanBeSpotted = view_as<Address>((iOffset - 4));

		if (bStatus)
		{
			SetEntProp(iClient, Prop_Send, "m_bSpotted", false);
			SetEntProp(iClient, Prop_Send, "m_bSpottedByMask", 0, 4, 0);
			SetEntProp(iClient, Prop_Send, "m_bSpottedByMask", 0, 4, 1);

			StoreToAddress(GetEntityAddress(iClient) + g_aCanBeSpotted, 0, NumberType_Int32);
		}
		else
			StoreToAddress(GetEntityAddress(iClient) + g_aCanBeSpotted, 9, NumberType_Int32);
	}
}

stock bool GetClientCrosshairOrigin(int iClient, float fOrigin[3], bool bFilterPlayers = true, float fDistance = -35.0)
{
	if (iClient == 0 || iClient > MaxClients || !IsClientInGame(iClient))
		return false;

	decl float vOrigin[3];
	GetClientEyePosition(iClient, vOrigin);

	decl float vAngles[3];
	GetClientEyeAngles(iClient, vAngles);

	Handle hTrace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, bFilterPlayers ? HP_TraceEntityFilterPlayer : HP_TraceEntityFilterNone, iClient);
	bool bReturn = TR_DidHit(hTrace);

	if (bReturn)
	{
		decl float vStart[3];
		TR_GetEndPosition(vStart, hTrace);

		decl float vBuffer[3];
		GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);

		fOrigin[0] = vStart[0] + (vBuffer[0] * fDistance);
		fOrigin[1] = vStart[1] + (vBuffer[1] * fDistance);
		fOrigin[2] = vStart[2] + (vBuffer[2] * fDistance);
	}

	delete hTrace;
	return bReturn;
}

stock bool TraceEntityFilterPlayer(int iEntity, int iMask, any aData)
{
	return iEntity > GetMaxClients() || !iEntity;
}

stock bool TraceEntityFilterNone(int iEntity, int iMask, any aData)
{
	return iEntity != aData;
}

stock bool HP_IsClientDonor(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_RESERVATION));
}

stock bool HP_IsClientStaff(int iClient)
{
	return view_as<bool>(GetUserFlagBits(iClient) & (ADMFLAG_ROOT|ADMFLAG_BAN|ADMFLAG_KICK));
}

stock bool HP_IsClientOwner(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_ROOT));
}

stock bool HP_IsClientAdmininistrator(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_BAN));
}

stock bool HP_IsClientModerator(int iClient)
{
	return view_as<bool>((GetUserFlagBits(iClient) & ADMFLAG_KICK));
}