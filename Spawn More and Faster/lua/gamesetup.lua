_G.MoreEnemies = _G.MoreEnemies or {}

Hooks:PostHook(GameSetup, "init_game", "SMF_GameSetup_init_game", function(self)
	if MutatorBigParty and managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	if tweak_data.group_ai then
		local SME_S = MoreEnemies and MoreEnemies.Settings or nil
		local group_ai = tweak_data.group_ai
		local besiege = group_ai.besiege
		local assault = group_ai.besiege.assault
		
		group_ai.special_unit_spawn_limits = {
			tank = 8,
			taser = 8,
			spooc = 8,
			shield = 16,
			medic = 16,
			sniper = 16
		}
		
		local general_groups_multiplier = 4
		local general_max_of_groups = 8
		
		if SME_S then
			general_groups_multiplier = SME_S.general_groups_multiplier or general_groups_multiplier
			general_max_of_groups = SME_S.general_max_of_groups or general_max_of_groups
			group_ai.special_unit_spawn_limits.tank = SME_S.special_max_tank or group_ai.special_unit_spawn_limits.tank
			group_ai.special_unit_spawn_limits.taser = SME_S.special_max_taser or group_ai.special_unit_spawn_limits.taser
			group_ai.special_unit_spawn_limits.spooc = SME_S.special_max_spooc or group_ai.special_unit_spawn_limits.spooc
			group_ai.special_unit_spawn_limits.shield = SME_S.special_max_shield or group_ai.special_unit_spawn_limits.shield
			group_ai.special_unit_spawn_limits.medic = SME_S.special_max_medic or group_ai.special_unit_spawn_limits.medic
			group_ai.special_unit_spawn_limits.sniper = SME_S.special_max_sniper or group_ai.special_unit_spawn_limits.sniper
			GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = general_max_of_groups or GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS
		end
		
		local half_spooc = 3
		
		for id, group in pairs(group_ai.enemy_spawn_groups) do
			if id ~= "Phalanx" then
				local is_spooc = id:find("spooc")
				if group.amount then
					for k, v in pairs(group.amount) do
						group.amount[k] = math.round(v * general_groups_multiplier) + 1
						group.amount[k] = math.clamp(group.amount[k], 1, general_max_of_groups)
						if is_spooc then
							group.amount[k] = math.clamp(group.amount[k], 1, half_spooc)
						end
					end
				end
				for _, spawn in pairs(group.spawn or {}) do
					if spawn.amount_max then
						spawn.amount_max = spawn.amount_max * (general_groups_multiplier * ((spawn.unit:find("swat") or spawn.unit:find("heavy")) and 1 or 0.5))
						spawn.amount_max = math.round(spawn.amount_max) + 1
						spawn.amount_max = math.clamp(spawn.amount_max, 1, general_max_of_groups)
						if is_spooc then
							spawn.amount_max = math.clamp(spawn.amount_max, 1, half_spooc)
						end
					end
				end
			end
		end
		
		for i = 1, #assault.force do
			assault.force[i] = 1200 * i
		end
		
		for i = 1, #besiege.reenforce.interval do
			besiege.reenforce.interval[i] = i
		end
		
		for i = 1, #assault.force_pool_balance_mul do
			assault.force_pool_balance_mul[i] = 24 * i
		end
		
		for i = 1, #assault.delay do
			assault.delay[i] = 15
		end
		
		for i = 1, #assault.sustain_duration_min do
			assault.sustain_duration_min[i] = assault.sustain_duration_min[i] * 3
		end
		
		for i = 1, #assault.sustain_duration_max do
			assault.sustain_duration_max[i] = assault.sustain_duration_max[i] * 3
		end
		
		for i = 1, #assault.sustain_duration_balance_mul do
			assault.sustain_duration_balance_mul[i] = assault.sustain_duration_balance_mul[i] * 3
		end
	end
end)