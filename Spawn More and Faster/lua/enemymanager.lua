_G.MoreEnemies = _G.MoreEnemies or {}

Hooks:PostHook(EnemyManager, "init", "SMF_EnemyManager_init", function(self)
	self._sfm_delay = 0
end)

local LogicNotAllow = {
	inactive = true,
	intimidated = true,
	arrest = true,
	sniper = true,
	trade = true,
	phalanx = true
}

local LowSizeTimes = 0

Hooks:PostHook(EnemyManager, "update", "SMF_EnemyManager_update", function(self, t, dt)
	if not managers.groupai or not managers.groupai:state() then
		return
	end
	local gro = managers.groupai:state()
	if not gro:is_AI_enabled() or not gro:enemy_weapons_hot() or gro:whisper_mode() then
		return
	end
	if MoreEnemies.Settings.force_cap then
		if self._sfm_delay then
			self._sfm_delay = self._sfm_delay - dt
			if self._sfm_delay <= 0 then
				self._sfm_delay = nil
			end
		else
			self._sfm_delay = 10
			if self._enemy_data and self._enemy_data.unit_data then
				local size = self._enemy_data.nr_units
				if size > MoreEnemies.Settings.force_cap_attach then
					LowSizeTimes = 0
					size = 0
					local unit_list = {}
					local cat_count = {}
					local sp_limit = tweak_data.group_ai.special_unit_spawn_limits
					for u_key, u_data in pairs(self._enemy_data.unit_data) do
						if not u_data or not u_data.unit or not alive(u_data.unit) or not u_data.unit:character_damage() or not u_data.unit:character_damage():can_kill() or u_data.unit:character_damage()._immortal or u_data.unit:character_damage():dead() or managers.groupai:state():is_enemy_converted_to_criminal(u_data.unit) or not u_data.unit:base()._tweak_table then
						
						else
							if type(u_data.unit:brain()._current_logic_name) ~= "string" or LogicNotAllow[u_data.unit:brain()._current_logic_name] then
							
							else
								local cat_name = u_data.unit:base()._tweak_table
								size = size + 1
								unit_list[u_key] = u_data.unit
								if type(sp_limit[cat_name]) == "number" and sp_limit[cat_name] > 0 then
								
								else
									cat_name = "Normal"
								end
								cat_count[cat_name] = cat_count[cat_name] or 0
								cat_count[cat_name] = cat_count[cat_name] + 1
							end
						end		
					end
					if size > MoreEnemies.Settings.force_cap_attach then
						for u_key, unit in pairs(unit_list) do
							local cat_name = unit:base()._tweak_table
							if type(sp_limit[cat_name]) == "number" and sp_limit[cat_name] > 0 then
								if cat_count[cat_name] > sp_limit[cat_name] then
									cat_count[cat_name] = cat_count[cat_name] - 1
									unit:character_damage():damage_mission({damage = 9999999, forced = true})
								end
							else
								if cat_count["Normal"] > MoreEnemies.Settings.force_cap_normal then
									cat_count["Normal"] = cat_count["Normal"] - 1
									unit:character_damage():damage_mission({damage = 9999999, forced = true})
								end
							end
						end
					end
				elseif size < 20 then
					LowSizeTimes = LowSizeTimes + 1
					if LowSizeTimes >= 5 then
						LowSizeTimes = 0
						local kill_times = 3
						for u_key, u_data in pairs(self._enemy_data.unit_data) do
							if kill_times <= 0 then
								break
							end
							if not u_data or not u_data.unit or not alive(u_data.unit) or not u_data.unit:character_damage() or not u_data.unit:character_damage():can_kill() or u_data.unit:character_damage()._immortal or u_data.unit:character_damage():dead() or managers.groupai:state():is_enemy_converted_to_criminal(u_data.unit) or not u_data.unit:base()._tweak_table then
							
							else
								kill_times = kill_times - 1
								u_data.unit:character_damage():damage_mission({damage = 9999999, forced = true})
								break
							end						
						end
						self._sfm_delay = t + 5
					end
				else
					LowSizeTimes = 0
				end
			end
		end
	end
end)