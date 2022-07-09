#if defined _HP_MODULE_MENU_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_MENU_INCLUDED_

stock char[] HP_MenuTag(int iLen)
{
	decl char szLine[48];

	for (int i = 0; i <= iLen; i++)
		StrCat(szLine, sizeof(szLine), "—");

	return szLine;
}