#if defined _HP_MODULE_COMMANDS_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_COMMANDS_INCLUDED_

stock void HP_GetCommandName(char[] szBuffer, int iSize)
{
	GetCmdArg(0, szBuffer, iSize);
}

stock int HP_GetCmdArgInt(int iArgNum)
{
	decl char szBuffer[32];
	GetCmdArg(iArgNum, szBuffer, sizeof(szBuffer));
	return StringToInt(szBuffer);
}

stock float HP_GetCmdArgFloat(int iArgNum)
{
	decl char szBuffer[32];
	GetCmdArg(iArgNum, szBuffer, sizeof(szBuffer));
	return StringToFloat(szBuffer);
}

stock bool HP_GetCmdArgBool(int iArgNum)
{
	decl char szBuffer[32];
	GetCmdArg(iArgNum, szBuffer, sizeof(szBuffer));
	return view_as<bool>(StringToInt(szBuffer));
}

stock int HP_GetCmdArgTarget(int iClient, int iArgNum, bool bNoBots = false, bool bImmunity = true)
{
	decl char szTarget[MAX_TARGET_LENGTH];
	GetCmdArg(iArgNum, szTarget, sizeof(szTarget));
	return FindTarget(iClient, szTarget, bNoBots, bImmunity);
}

stock bool HP_IsCommandExists(const char[] szCommand)
{
	return GetCommandFlags(szCommand) != INVALID_FCVAR_FLAGS;
}
