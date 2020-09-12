function set_group_ai_tweak_data()
	if MutatorBigParty and managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	if tweak_data.group_ai then
		local group_ai = tweak_data.group_ai
		local besiege = group_ai.besiege
		local assault = besiege.assault
		
		group_ai.special_unit_spawn_limits.tank = math.round(math.clamp(group_ai.special_unit_spawn_limits.tank*0.5, 1, 2))
		group_ai.special_unit_spawn_limits.taser = math.round(math.clamp(group_ai.special_unit_spawn_limits.taser*0.5, 1, 3))
		group_ai.special_unit_spawn_limits.spooc = math.round(math.clamp(group_ai.special_unit_spawn_limits.spooc*0.5, 1, 2))
		group_ai.special_unit_spawn_limits.shield = math.round(math.clamp(group_ai.special_unit_spawn_limits.shield*0.5, 1, 6))
		group_ai.special_unit_spawn_limits.medic = math.round(math.clamp(group_ai.special_unit_spawn_limits.medic*0.5, 1, 2))

		for id, group in pairs(group_ai.enemy_spawn_groups) do
			if id ~= "Phalanx" then
				local is_spooc = id:find("spooc")
				if group.amount then
					for k, v in pairs(group.amount) do
						group.amount[k] = math.round(v * 0.5) + 1
						group.amount[k] = math.clamp(group.amount[k], 1, 3)
						if is_spooc then
							group.amount[k] = math.clamp(group.amount[k], 1, 2)
						end
					end
				end
				for _, spawn in pairs(group.spawn or {}) do
					if spawn.amount_max then
						spawn.amount_max = spawn.amount_max * (0.5 * ((spawn.unit:find("swat") or spawn.unit:find("heavy")) and 1 or 0.5))
						spawn.amount_max = math.round(spawn.amount_max) + 1
						spawn.amount_max = math.clamp(spawn.amount_max, 1, 3)
						if is_spooc then
							spawn.amount_max = math.clamp(spawn.amount_max, 1, 2)
						end
					end
				end
			end
		end
		
		for i = 1, #assault.force do
			assault.force[i] = assault.force[i] * 0.5
		end
		
		for i = 1, #besiege.reenforce.interval do
			besiege.reenforce.interval[i] = besiege.reenforce.interval[i] * 1.5
		end
		
		for i = 1, #assault.force_balance_mul do
			assault.force_balance_mul[i] = 0.5
		end
		
		for i = 1, #assault.force_pool_balance_mul do
			assault.force_pool_balance_mul[i] = 0.5
		end
		
		for i = 1, #assault.delay do
			assault.delay[i] = assault.delay[i] * 1.5
		end
		
		for i = 1, #assault.sustain_duration_min do
			assault.sustain_duration_min[i] = assault.sustain_duration_min[i] * 0.5
		end
		
		for i = 1, #assault.sustain_duration_max do
			assault.sustain_duration_max[i] = assault.sustain_duration_max[i] * 0.5
		end
		
		for i = 1, #assault.sustain_duration_balance_mul do
			assault.sustain_duration_balance_mul[i] = assault.sustain_duration_balance_mul[i] * 0.5
		end
		
		tweak_data.group_ai = group_ai
		
		tweak_data.group_ai.besiege = besiege
		
		tweak_data.group_ai.besiege.assault = assault
	end
end

Hooks:PostHook(GameSetup, "init_game", "SLS_GameSetup_init_game", function(self)
	set_group_ai_tweak_data()
end)