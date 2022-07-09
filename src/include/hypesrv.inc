
#if defined _HP_BASE_INCLUDED_
	#endinput
#endif
#define _HP_BASE_INCLUDED_

#if !defined RSVP_COMPILER
	#define decl static
#endif

#pragma semicolon 1
#pragma newdecls required

#define HP_PLUG   "[HS] "

#define HP_AUTHOR "HypeSRV"
#define HP_WEB    "https://hypesrv.com"
#define HP_URL    "https://discord.gg/hypesrv"
#define HP_STEAM  "https://steamcommunity.com/groups/hypesrv"
#define HP_EMAIL  "support@hypesrv.com"

#define TAG_HYPESRV_MENU    "HypeSRV | "
#define TAG_HYPESRV_CLR     " \x0BHypeSRV〡"
#define TAG_HYPESRV_NCLR    "[HypeSRV]"
#define TAG_HYPESRV_CONSOLE "[{LIGHTBLUE}HypeSRV{DEFAULT}]"

#define HYPESRV_IP "104.243.41.150"
#define HYPESRV_WEB_IP "cs.hypesrv.com"

#define	HYPESRV_API "https://api.hypesrv.com/"
#define HYPESRV_AUTH_TOKEN "SD7hyuum66Bk7pKS6WsBJsThURgsFugh"

#define CS_COLOR_T { 204, 153, 102 }
#define CS_COLOR_CT { 73, 104, 247 }

#define MAX_CONSOLE_LENGTH 1024
#define MAX_STRING_LENGTH  512
#define MAX_MESSAGE_LENGTH 256
#define MAX_BUFFER_LENGTH  (MAX_MESSAGE_LENGTH * 4)

#define SDK_TIMER_128 0.1
#define SDK_TIMER_64 0.2

#if !defined _cstrike_included
	#define CS_TEAM_NONE        0   /* No team yet */
	#define CS_TEAM_SPECTATOR   1   /* Spectators */
	#define CS_TEAM_T           2   /* Terrorists */
	#define CS_TEAM_CT          3   /* Counter-Terrorists */

	#define CS_SLOT_PRIMARY     0   /* Primary weapon slot */
	#define CS_SLOT_SECONDARY   1   /* Secondary weapon slot */
	#define CS_SLOT_KNIFE       2   /* Knife slot */
	#define CS_SLOT_GRENADE     3   /* Grenade slot (will only return one grenade) */
	#define CS_SLOT_C4          4   /* C4 slot */
	#define CS_SLOT_BOOST       11  /* Slot for healthshot and shield (will only return one weapon/item) */
	#define CS_SLOT_UTILITY     12  /* Slot for tablet */
#endif

#include <hypesrv/variable/int>
#include <hypesrv/variable/random>
#include <hypesrv/variable/strings>

#include <hypesrv/game/game>

#include <hypesrv/command>
#include <hypesrv/entity>
#include <hypesrv/prop>
#include <hypesrv/server>
#include <hypesrv/client>
#include <hypesrv/menu>
#include <hypesrv/sound>

stock const char g_szHypeSRVWelcome[11][69] =
{
	" /$$   /$$                                /$$$$$$  /$$$$$$$  /$$    /$$",
	"| $$  | $$                               /$$__  $$| $$__  $$| $$   | $$",
	"| $$  | $$ /$$   /$$  /$$$$$$   /$$$$$$ | $$  \\__/| $$  \\ $$| $$   | $$",
	"| $$$$$$$$| $$  | $$ /$$__  $$ /$$__  $$|  $$$$$$ | $$$$$$$/|  $$ / $$/",
	"| $$__  $$| $$  | $$| $$  \\ $$| $$$$$$$$ \\____  $$| $$__  $$ \\  $$ $$/",
	"| $$  | $$| $$  | $$| $$  | $$| $$_____/ /$$  \\ $$| $$  \\ $$  \\  $$$/",
	"| $$  | $$|  $$$$$$$| $$$$$$$/|  $$$$$$$|  $$$$$$/| $$  | $$   \\  $/",
	"|__/  |__/ \\____  $$| $$____/  \\_______/ \\______/ |__/  |__/    \\_/",
	"           /$$  | $$| $$",
	"          |  $$$$$$/| $$",
	"           \\______/ |__/"
};