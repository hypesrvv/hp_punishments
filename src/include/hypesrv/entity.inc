#if defined _HP_MODULE_ENTITY_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_ENTITY_INCLUDED_

#define MAX_ENTITY_LIMIT 4096 + 1

stock bool IsValidEntityEx(int iEntity)
{
	if (!iEntity || iEntity < MaxClients || iEntity > MAX_ENTITY_LIMIT)
		return false;

	return IsValidEntity(iEntity);
}

stock bool IsEntityWorld(int iEntity)
{
	return (iEntity == 0);
}

stock bool IsValidEntityRef(int iReference)
{
	return IsValidEntityEx(EntRefToEntIndex(iReference));
}

stock bool GetAbsOrigin(int iEntity, float fVec[3], bool bValidate = false)
{
	if (!bValidate || (IsValidEdict(iEntity) && HasEntProp(iEntity, Prop_Send, "m_vecOrigin")))
	{
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fVec);
		return true;
	}

	return false;
}

stock float GetDistanceOrigin(int entity, const float vec[3])
{
	decl float entityVec[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", entityVec);

	return GetVectorDistance(entityVec, vec);
}

stock int GetClosestToEntity(int iEntity, bool bOnlyClients = false)
{
	decl float fOrigin[3];
	return GetAbsOrigin(iEntity, fOrigin) ? GetClosest(fOrigin, bOnlyClients) : INVALID_ENT_REFERENCE;
}

stock int GetClosest(float fOriginVec[3], bool bOnlyClients = false)
{
	decl float fTempVec[3], fSmallestDistance = 0.0, fTempDistance;
	int iClosest	 = INVALID_ENT_REFERENCE;

	int iMaxEntities = bOnlyClients ? MaxClients : GetMaxEntities();

	for (int iEdict = 1; iEdict <= iMaxEntities; iEdict++)
	{
		if (GetAbsOrigin(iEdict, fTempVec))
		{
			fTempDistance = GetVectorDistance(fOriginVec, fTempVec, true);

			if (fTempDistance < fSmallestDistance || fSmallestDistance == 0.0)
			{
				fSmallestDistance = fTempDistance;
				iClosest		  = iEdict;
			}
		}
	}

	return iClosest;
}

stock void SetEntitySelfDestruct(int iEntity, float fDuration)
{
	decl char sOutput[64];
	FormatEx(sOutput, sizeof(sOutput), "OnUser1 !self:kill::%.1f:1", fDuration);
	SetVariantString(sOutput);
	AcceptEntityInput(iEntity, "AddOutput");
	AcceptEntityInput(iEntity, "FireUser1");
}