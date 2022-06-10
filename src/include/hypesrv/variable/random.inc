#if defined _HP_MODULE_RANDOM_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_RANDOM_INCLUDED_

stock bool HP_ShouldHappen(float fChance)
{
	return GetRandomInt(1, 100) <= chance;
}

stock bool HP_RandomBool()
{
	return view_as<bool>(HP_RandomInt(0, 1));
}

stock int HP_RandomInt(int iMin, int iMax)
{
	int iRandom = GetURandomInt();

	if (iRandom == 0)
		iRandom++;

	return RoundToCeil(float(iRandom) / (float(MAX_INTEGER_VALUE) / float(iMax - iMin + 1))) + iMin - 1;
}

stock float HP_RandomFloat(float min, float max)
{
	return (GetURandomFloat() * (max - min)) + min;
}