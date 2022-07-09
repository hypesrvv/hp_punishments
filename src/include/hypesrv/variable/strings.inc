#if defined _HP_MODULE_STRING_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_STRING_INCLUDED_

#define STRING_EMPTY "\0"

stock bool IsStringEmpty(const char[] szBuffer)
{
	return !szBuffer[0] || strlen(szBuffer) == 0;
}

stock bool IsStringNumber(const char[] szBuffer)
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

stock bool StringToBool(const char[] szBuffer)
{
	return view_as<bool>(StringToInt(szBuffer));
}

stock void TruncateString(char[] szBuffer)
{
	szBuffer[0] = EOS;
}

stock int FlagStringToInt(char[] szBuffer)
{
	AdminFlag aFlag;
	return FindFlagByChar(szBuffer[0], aFlag) ? FlagToBit(aFlag) : INVALID_ENT_REFERENCE;
}

stock char[] StringBuilder(const char[] szFormat, any...)
{
	int iLength			= strlen(szFormat) + 255;
	char[] szString = new char[iLength];

	VFormat(szString, iLength, szFormat, 2);
	return szString;
}

stock int FlagIntToString(int iFlag)
{
	AdminFlag aFlag;
	int		  iChar;
	return (BitToFlag(iFlag, aFlag) && FindFlagChar(aFlag, iChar)) ? iChar : INVALID_ENT_REFERENCE;
}

stock char IntToStr(int iInt)
{
	decl char s[32];
	FormatEx(s, sizeof(s), "%i", iInt);
	return s;
}

stock void StringToLower(char[] sText, int iStartLen = 0, int iEndLen = 0)
{
	int iLen = strlen(sText) + 1;

	if (1 > iEndLen || iLen < iEndLen)
		iEndLen = iLen;

	for (int i = iStartLen; i != iEndLen; i++)
		sText[i] |= 0x20;
}

stock void StringToUpper(char[] szText, int iStartLen = 0, int iEndLen = 0)
{
	int iLen = strlen(szText) + 1;

	if (1 > iEndLen || iLen < iEndLen)
		iEndLen = iLen;

	for (int i = iStartLen; i != iEndLen; i++)
		szText[i] &= ~0x20;
}

stock void FirstCharUpper(char[] szText)
{
	if (strlen(szText))
		szText[0] &= ~0x20;
}

stock bool StartsWith(const char[] szBuffer, const char[] szSubString)
{
	int iPos;

	while (szSubString[iPos] != EOS)
	{
		if (szBuffer[iPos] == EOS || szBuffer[iPos] != szSubString[iPos])
			return false;

		iPos++;
	}

	return true;
}