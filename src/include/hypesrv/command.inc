#if defined _HP_MODULE_COMMANDS_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_COMMANDS_INCLUDED_

stock float GetCmdArgFloat(int iArgNum)
{
	decl char s[32];
	GetCmdArg(iArgNum, s, sizeof(s));
	return StringToFloat(s);
}

stock bool GetCmdArgBool(int iArgNum)
{
	decl char s[32];
	GetCmdArg(iArgNum, s, sizeof(s));
	return view_as<bool>(StringToInt(s));
}

stock int GetCmdArgTarget(int iClient, int iArgNum, bool bNoBots = false, bool bImmunity = true)
{
	decl char szTarget[MAX_TARGET_LENGTH];
	GetCmdArg(iArgNum, szTarget, sizeof(szTarget));
	return FindTarget(iClient, szTarget, bNoBots, bImmunity);
}

stock bool IsValidCommand(const char[] szCommand)
{
	return GetCommandFlags(szCommand) != INVALID_FCVAR_FLAGS;
}
