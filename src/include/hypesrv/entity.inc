#if defined _HP_MODULE_ENTITY_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_ENTITY_INCLUDED_

#define MAX_ENTITY_LIMIT 4096 + 1

stock bool HP_IsValidEntity(int iEntity)
{
	if (!iEntity || iEntity < MaxClients || iEntity > MAX_ENTITY_LIMIT)
		return false;

	return IsValidEntity(iEntity);
}

stock bool HP_IsEntityWorld(int iEntity)
{
	return iEntity == 0;
}

stock bool HP_IsValidEntityRef(int iReference)
{
	return HP_IsValidEntity(EntRefToEntIndex(iReference));
}

stock bool HP_GetAbsOrigin(int iEntity, float fVec[3], bool bValidate = false)
{
	if (!bValidate || (IsValidEdict(iEntity) && HasEntProp(iEntity, Prop_Send, "m_vecOrigin")))
	{
		GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fVec);
		return true;
	}

	return false;
}

stock int HP_GetClassName(int iEntity, char[] cBuffer, int iSize)
{
	return GetEntPropString(iEntity, Prop_Data, "m_iClassname", cBuffer, iSize);
}

stock bool HP_SetClassName(int iEntity, const char[] cClassName)
{
	return DispatchKeyValue(iEntity, "classname", cClassName);
}

stock bool HP_ClassNameMatches(int iEntity, const char[] cClassName, bool bPartialMatch = false)
{
	decl char cEntityClassName[64];
	HP_GetClassName(iEntity, STRING(cEntityClassName));

	if (bPartialMatch)
		return HP_StrContains(cEntityClassName, cClassName);

	return HP_StrEquals(cEntityClassName, cClassName);
}

stock float HP_GetDistanceOrigin(int entity, const float vec[3])
{
	decl float entityVec[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", entityVec);

	return GetVectorDistance(entityVec, vec);
}

stock int HP_GetClosestToEntity(int iEntity, bool bOnlyClients = false)
{
	decl float fOrigin[3];
	return HP_GetAbsOrigin(iEntity, fOrigin) ? HP_GetClosest(fOrigin, bOnlyClients) : INVALID_ENT_REFERENCE;
}

stock int HP_GetClosest(float fOriginVec[3], bool bOnlyClients = false)
{
	decl float fTempVec[3], fSmallestDistance = 0.0, fTempDistance;
	int iClosest	 = INVALID_ENT_REFERENCE;

	int iMaxEntities = bOnlyClients ? MaxClients : GetMaxEntities();

	for (int iEdict = 1; iEdict <= iMaxEntities; iEdict++)
	{
		if (HP_GetAbsOrigin(iEdict, fTempVec))
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

stock void HP_SetEntitySelfDestruct(int iEntity, float fDuration)
{
	decl char sOutput[64];
	FormatEx(STRING(sOutput), "OnUser1 !self:kill::%.1f:1", fDuration);
	SetVariantString(sOutput);
	AcceptEntityInput(iEntity, "AddOutput");
	AcceptEntityInput(iEntity, "FireUser1");
}