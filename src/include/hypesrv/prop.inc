#if defined _HP_MODULE_PROP_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_PROP_INCLUDED_

stock bool GetPropBool(const char[] szPropName)
{
	return view_as<bool>(GameRules_GetProp(szPropName));
}

stock bool GetEntPropBool(int iEntity, PropType iType, const char[] szProp)
{
	return view_as<bool>(GetEntProp(iEntity, iType, szProp));
}
