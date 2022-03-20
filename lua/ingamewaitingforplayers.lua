Hooks:PostHook(IngameWaitingForPlayersState,"at_exit","mhudu_onheiststart",function(self,next_state)
	MHUDUCore:OnGameStarted()
end)