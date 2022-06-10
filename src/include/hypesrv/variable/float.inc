#if defined _HP_MODULE_FLOAT_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_FLOAT_INCLUDED_

#define MAX_FLOAT_LENGTH 32

stock float HP_FloatMultiply(float fValue, float fMultiply)
{
	return fValue *= 1.0 + fMultiply;
}

stock float HP_FloatDivide(float fValue, float fMultiply)
{
	return fValue *= 1.0 - fMultiply;
}