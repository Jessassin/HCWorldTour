#bind player chat event
bind(player_chat,null,null,@event,
	#assign player & time variables
	assign(@player,@event['player'])
	#check whether to cancel the chat
	cancel(_chat_intercept(@player))
)