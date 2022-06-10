#if defined _HP_MODULE_BIT_INCLUDED_
	#endinput
#endif
#define _HP_MODULE_BIT_INCLUDED_

stock void HP_AddBits(int &iSum, int iBits)
{
	iSum |= iBits;
}

stock void HP_RemoveBits(int &iSum, int iBits)
{
	iSum &= ~iBits;
}

stock bool HP_ContainsBits(int iSum, int iBits)
{
	return (iSum & iBits) == iBits;
}