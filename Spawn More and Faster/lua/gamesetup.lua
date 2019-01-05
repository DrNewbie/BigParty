_G.MoreEnemies = _G.MoreEnemies or {}

Hooks:PostHook(GameSetup, "init_game", "SMF_GameSetup_init_game", function(self)
	MoreEnemies:set_group_ai_tweak_data()
end)