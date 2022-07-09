#if defined _HP_MODULE_RANDOM_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_RANDOM_INCLUDED_

stock bool ShouldHappen(float fChance)
{
	return GetRandomInt(1, 100) <= fChance;
}

stock bool RandomBool()
{
	return view_as<bool>(HP_RandomInt(0, 1));
}

stock int RandomInt(int iMin, int iMax)
{
	return RountToZero(GetURandomFloat() * (iMax - iMin + 1) + iMin);
}

stock float RandomFloat(float iMin, float iMax)
{
	return (GetURandomFloat() * (iMax - iMin)) + iMin;
}