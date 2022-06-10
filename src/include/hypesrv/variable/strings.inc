#if defined _HP_MODULE_STRING_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_STRING_INCLUDED_

#define STRING_EMPTY "\0"

stock bool HP_IsStringEmpty(const char[] szBuffer)
{
	return !szBuffer[0] || strlen(szBuffer) == 0;
}

stock bool HP_IsStringNumber(const char[] szBuffer)
{
	int iTarget, iDots, iNumbers;

	if (szBuffer[iTarget] == '+' || szBuffer[iTarget] == '-')
		iTarget++;

	while (szBuffer[iTarget] != EOS)
	{
		if (IsCharNumeric(szBuffer[iTarget]))
		{
			iNumbers++;
		}
		else if (szBuffer[iTarget] == '.')
		{
			iDots++;

			if (iDots > 1)
				return false;
		}
		else
			return false;

		iTarget++;
	}

	return iNumbers > 0;
}

stock bool HP_StringToBool(const char[] szBuffer)
{
	return view_as<bool>(StringToInt(szBuffer));
}

stock void HP_TruncateString(char[] szBuffer)
{
	szBuffer[0] = EOS;
}

stock int HP_FlagStringToInt(char[] szBuffer)
{
	AdminFlag aFlag;
	return FindFlagByChar(szBuffer[0], aFlag) ? FlagToBit(aFlag) : INVALID_ENT_REFERENCE;
}

stock char[] HP_StringBuilder(const char[] szFormat, any...)
{
	int iLength			= strlen(szFormat) + 255;
	char[] cBuiltString = new char[iLength];

	VFormat(cBuiltString, iLength, szFormat, 2);
	return cBuiltString;
}

stock int HP_FlagIntToString(int iFlag)
{
	AdminFlag aFlag;
	int		  iChar;
	return (BitToFlag(iFlag, aFlag) && FindFlagChar(aFlag, iChar)) ? iChar : INVALID_ENT_REFERENCE;
}

stock char HP_IntToString(int iInt)
{
	decl char szBuffer[32];
	FormatEx(szBuffer, sizeof(szBuffer), "%d", iInt);
	return cBuffer;
}

stock bool HP_StrEquals(const char[] string, char[] substring, bool caseSensitive = true)
{
	return strcmp(string, substring, caseSensitive) == 0;
}

stock bool HP_StrContains(const char[] String, const char[] Text, bool caseSensitive = false)
{
	return StrContains(String, Text, caseSensitive) != -1;
}

stock void HP_StringToLower(char[] sText, int iStartLen = 0, int iEndLen = 0)
{
	int iLen = strlen(sText) + 1;

	if (1 > iEndLen || iLen < iEndLen)
		iEndLen = iLen;

	for (int i = iStartLen; i != iEndLen; i++)
		sText[i] |= 0x20;
}

stock void HP_StringToUpper(char[] szText, int iStartLen = 0, int iEndLen = 0)
{
	int iLen = strlen(szText) + 1;

	if (1 > iEndLen || iLen < iEndLen)
		iEndLen = iLen;

	for (int i = iStartLen; i != iEndLen; i++)
		szText[i] &= ~0x20;
}

stock void HP_FirstCharUpper(char[] szText)
{
	if (strlen(szText) > 0)
		szText[0] &= ~0x20;
}

stock void HP_RemoveFrontString(char[] szText, int iSize, int iPosition)
{
	strcopy(szText, iSize, sText[iPosition]);
}

stock bool HP_StartsWith(const char[] szBuffer, const char[] szSubString)
{
	int n;

	while (szSubString[n] != EOS)
	{
		if (szBuffer[n] == EOS || szBuffer[n] != szSubString[n])
			return false;

		n++;
	}

	return true;
}

/*
 * Count the characters in a string
 *
 * @param str           String to check
 * @return              Count of characters in the string
 */
stock int HP_CharCount(const char[] szStr)
{
	int iCount, ilen = strlen(szStr);

	for (int i, b; i < ilen; i++)
	{
		if (b = IsCharMB(szStr[i]))
			i += (b - 1);

		iCount++;
	}

	return iCount;
}

stock int HP_CountChar(int iCharacter, const char[] szString)
{
	int iCount, ilen = strlen(szString);

	for (int i; i < ilen; i++)
		if (szString[i] == iCharacter)
			iCount++;

	return iCount;
}