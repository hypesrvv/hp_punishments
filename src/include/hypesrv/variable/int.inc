#if defined _HP_MODULE_INT_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_INT_INCLUDED_

#define MAX_INTEGER_VALUE  2147483647
#define MAX_INTEGER_LENGTH 16

stock bool IsValidInt(int iValue)
{
	return -MAX_INTEGER_VALUE < iValue < MAX_INTEGER_VALUE;
}