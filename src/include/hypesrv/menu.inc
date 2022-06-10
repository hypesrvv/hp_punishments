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


stock void HP_MenuSetTitle(Menu hMenu, const char[] szTitle, any...)
{
	int ilen = strlen(szTitle) + 255;
	char[] myFormattedString = new char[ilen];
	VFormat(myFormattedString, ilen, szTitle, 3);

	hMenu.SetTitle(myFormattedString);
}

stock char HP_MenuGetSelect(Menu hMenu, int iParam)
{
	char szBuffer[32];
	GetMenuItem(hMenu, iParam, szBuffer, sizeof(szBuffer));
	return szBuffer;
}

stock void HP_PanelSetTitle(Panel hPanel, const char[] szTitle, any...)
{
	int ilen = strlen(szTitle) + 255;
	char[] myFormattedString = new char[ilen];
	VFormat(myFormattedString, ilen, szTitle, 3);

	hPanel.SetTitle(myFormattedString);
}