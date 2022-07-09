#if defined _HP_PROCESSOR_INCLUDED_
    #endinput
#endif
#define _HP_PROCESSOR_INCLUDED_

#define MAX_TEMPLATE_LENGTH	32

/**
 * Called before a chat message is sent, here the message is already processed.
 *
 * @param iSender	    Author that sent the message.
 * @param iReceiver		Receiver of the message.
 * @param szTemplate	Message's template.
 * @param szBuffer		Message's buffer.
 * @param ilength		Max length of the buffer.
 *
 * @return
 *  - Plugin_Continue	Continues the message.
 *  - Plugin_Changed	Continues the message.
 *  - Plugin_Handled	Stops the message.
 *  - Plugin_Stop		Stops the message.
 */
forward Action HP_OnChatMessageSendPre(int iSender, int iReceiver, char[] szTemplate, char[] szBuffer, int ilength);

/**
 * Called while sending a chat message before It's sent.
 * Limits on the name and message strings can be found above.
 *
 * @param iAuthor			Author that created the message.
 * @param ALRecipients	    Array of clients who will receive the message.
 * @param szMsgtype		    Determine the type of message.
 * @param szName			Name of the author to be pushed.
 * @param szMessage		    Message from the author to be pushed.
 * @param bProcesscolors	Toggle to process colors in the buffer strings.
 * @param bPemovecolors	    Toggle to remove colors in the buffer strings. (Requires bProcessColors = true)
 *
 * @return
 *  - Plugin_Continue		Continues the message.
 *  - Plugin_Changed		Fires the post-forward below and prints out a message.
 *  - Plugin_Handled		Fires the post-forward below but doesn't print a message.
 *  - Plugin_Stop		    Stops the message.
 */
forward Action HP_OnChatMessage(int& iAuthor, ArrayList ALRecipients, char[] szMsgtype, char[] szName, char[] szMessage, bool& bProcesscolors, bool& bRemovecolors);

/**
 * Called after the chat message is sent to the designated clients by the author.
 *
 * @param iAuthor			Author that sent the message.
 * @param ALRecipients	    Array of clients who received the message.
 * @param szMsgtype		    Determine the type of message.
 * @param szTemplate		Format used in the message based on the flag string.
 * @param szName			Name of the author.
 * @param szMessage		    Message from the author.
 * @param bProcesscolors	Check if colors were processed in the buffer strings.
 * @param bPemovecolors	    Check if colors were removed from the buffer strings.
 *
 * @noreturn
 */
forward void HP_OnChatMessagePost(int iAuthor, ArrayList ALRecipients, const char[] szMsgtype, const char[] szTemplate, const char[] szName, const char[] szMessage, bool bProcesscolors, bool bRemovecolors);

public SharedPlugin __pl_hp_processor =
{
	name = "Processor",
	file = "hp_processor.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
}