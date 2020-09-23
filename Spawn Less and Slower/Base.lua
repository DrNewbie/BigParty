local _r = 0.49
local _mul = 0.88
local _cd_mul = 6.66
local _clamp = {1, 12}

function set_group_ai_tweak_data()
	if MutatorBigParty and managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	if tweak_data.group_ai then
		local group_ai = tweak_data.group_ai
		local besiege = group_ai.besiege
		local assault = besiege.assault
		
		group_ai.special_unit_spawn_limits.tank = math.round(math.clamp(group_ai.special_unit_spawn_limits.tank*_r, 1, 2))
		group_ai.special_unit_spawn_limits.taser = math.round(math.clamp(group_ai.special_unit_spawn_limits.taser*_r, 1, 3))
		group_ai.special_unit_spawn_limits.spooc = math.round(math.clamp(group_ai.special_unit_spawn_limits.spooc*_r, 1, 2))
		group_ai.special_unit_spawn_limits.shield = math.round(math.clamp(group_ai.special_unit_spawn_limits.shield*_r, 1, 6))
		group_ai.special_unit_spawn_limits.medic = math.round(math.clamp(group_ai.special_unit_spawn_limits.medic*_r, 1, 2))

		for id, group in pairs(group_ai.enemy_spawn_groups) do
			if id ~= "Phalanx" then
				local is_spooc = id:find("spooc")
				if group.amount then
					for k, v in pairs(group.amount) do
						group.amount[k] = math.round(v * _r) + 1
						group.amount[k] = math.clamp(group.amount[k], _clamp[1], _clamp[2])
						if is_spooc then
							group.amount[k] = math.clamp(group.amount[k], _clamp[1], _clamp[2])
						end
					end
				end
				for _, spawn in pairs(group.spawn or {}) do
					if spawn.amount_max then
						spawn.amount_max = spawn.amount_max * (_r * ((spawn.unit:find("swat") or spawn.unit:find("heavy")) and 1 or _r))
						spawn.amount_max = math.round(spawn.amount_max) + 1
						spawn.amount_max = math.clamp(spawn.amount_max, _clamp[1], _clamp[2])
						if is_spooc then
							spawn.amount_max = math.clamp(spawn.amount_max, _clamp[1], _clamp[2])
						end
					end
				end
			end
		end
		
		for i = 1, #assault.force do
			assault.force[i] = 15
		end
		
		for i = 1, #assault.force_pool do
			assault.force[i] = 150
		end
		
		for i = 1, #besiege.reenforce.interval do
			besiege.reenforce.interval[i] = besiege.reenforce.interval[i] * _cd_mul
		end
		
		for i = 1, #assault.force_balance_mul do
			assault.force_balance_mul[i] = 1
		end
		
		for i = 1, #assault.force_pool_balance_mul do
			assault.force_pool_balance_mul[i] = 1
		end
		
		for i = 1, #assault.delay do
			assault.delay[i] = assault.delay[i] * _cd_mul
		end
		
		for i = 1, #assault.sustain_duration_min do
			assault.sustain_duration_min[i] = assault.sustain_duration_min[i] * _mul
		end
		
		for i = 1, #assault.sustain_duration_max do
			assault.sustain_duration_max[i] = assault.sustain_duration_max[i] * _mul
		end
		
		for i = 1, #assault.sustain_duration_balance_mul do
			assault.sustain_duration_balance_mul[i] = assault.sustain_duration_balance_mul[i] * _mul
		end
		
		if assault.build_duration then 
			assault.build_duration = assault.build_duration * _mul
		end
		
		if assault.fade_duration then 
			assault.fade_duration = assault.fade_duration * _mul
		end
		
		tweak_data.group_ai = group_ai
		
		tweak_data.group_ai.besiege = besiege
		
		tweak_data.group_ai.besiege.assault = assault
	end
end

if GameSetup then
	Hooks:PostHook(GameSetup, "init_game", "F_"..Idstring("Spawn Less but Slower::_GameSetup_init_game"):key(), function(self)
		set_group_ai_tweak_data()
	end)
end

if GroupAIStateBase then
	GroupAIStateBase._MAX_SIMULTANEOUS_SPAWNS = 8
	function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
end

if GroupAIStateBesiege then
	GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = 8
	function GroupAIStateBesiege:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
end

if GroupAIStateStreet then
	GroupAIStateStreet._MAX_SIMULTANEOUS_SPAWNS = 8
	function GroupAIStateStreet:_get_balancing_multiplier(balance_multipliers)
		return balance_multipliers[#balance_multipliers]
	end
end