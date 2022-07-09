#if defined _HP_GAMEMODE_INCLUDED_
    #endinput
#endif
#define _HP_GAMEMODE_INCLUDED_

// switch(szMode[1])
// {
// 	case 'e': // Retakes
// 	case 'o': // Competitive
// 	case 'i': // Wingman
// 	case 'e': // Deathmatch
// 	case 'w': // Awpbhop
// }

/**
 * Called once the gamemode has been set.
 *
 * @param szMode     String containing gamemode
 * @noreturn
 */
forward void HP_OnGameModeStart(const char[] szMode);