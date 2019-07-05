core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

_G.MoreEnemies = _G.MoreEnemies or {}

local MoreEnemies = _G.MoreEnemies or {}

MoreEnemies.SFM_Sniper_Element = MoreEnemies.SFM_Sniper_Element or {}

MoreEnemies.Settings = MoreEnemies.Settings or {}

local _spawn_enemy = function (unit_name, pos, rot)
	local unit_done = safe_spawn_unit(unit_name, pos, rot)
	local team_id = tweak_data.levels:get_default_team_ID(unit_done:base():char_tweak().access == "gangster" and "gangster" or "combatant")
	unit_done:movement():set_team(gro:team_data( team_id ))
	gro:assign_enemy_to_group_ai(unit_done, team_id)
	return unit_done
end

local _pos_offset = function ()
	local ang = math.random() * 360 * math.pi
	local rad = math.random(20, 30)
	return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
end

Hooks:PostHook(ElementSpawnEnemyDummy, "produce", "SMF_ElementSpawnEnemyDummy_produce", function(self)
	local unit = self._units[#self._units]
	if not unit or not alive(unit) then
		return
	end
	if not managers.groupai or not managers.groupai:state() then
		return
	end
	if unit:name():key() == Idstring('units/pd2_dlc_wwh/characters/ene_locke/ene_locke'):key() then
		return
	end
	local gro = managers.groupai:state()
	if not gro:is_AI_enabled() or not gro:enemy_weapons_hot() or gro:whisper_mode() then
		return
	end
	if unit:character_damage()._invulnerable or unit:character_damage()._immortal or unit:character_damage()._dead then
		return
	end
	if gro:is_enemy_converted_to_criminal(unit) then
		return
	end
	local _unit_objective = unit:brain() and unit:brain():objective() or nil
	if type(MoreEnemies) == "table" then
		local _time_now = math.round(TimerManager:game():time())
		local _enemy_name = unit:name()
		local pos, rot = self:get_orientation()
		local xtimes = 1
		local catname = tostring(unit:base()._tweak_table)
		if MoreEnemies.Settings.more_sniper then
			local sniper_clone = MoreEnemies.Settings.more_sniper_amount or 3
			local sniper_delay = MoreEnemies.Settings.more_sniper_delay or 10
			if catname == "sniper" then
				for i = 1, sniper_clone do
					local unit_done_sniper = _spawn_enemy(_enemy_name, pos + _pos_offset(), rot)
					if _unit_objective then
						unit_done_sniper:brain():set_objective(_unit_objective)
					end
					table.insert(self._units, unit_done_sniper)
				end
				local _ids_id = Idstring(self._id):key()
				if not MoreEnemies.SFM_Sniper_Element[_ids_id] then
					MoreEnemies.SFM_Sniper_Element[_ids_id] = {
						id = self._id,
						t = _time_now + 15
					}
				end
				return unit
			else
				if type(MoreEnemies.SFM_Sniper_Element) == "table" then
					local ask_sniper_clone = math.min(math.round(sniper_clone * 0.5), 1)
					for i = 1, ask_sniper_clone do
						local _ele_key = table.random_key(MoreEnemies.SFM_Sniper_Element)
						local _ele_data = MoreEnemies.SFM_Sniper_Element[_ele_key]
						if type(_ele_data) == "table" and _time_now > _ele_data.t then
							MoreEnemies.SFM_Sniper_Element[_ele_key].t = _time_now + sniper_delay + math.random()*10
							local _sniper_element = self:get_mission_element(_ele_data.id)
							if _sniper_element then
								_sniper_element:on_executed()
							end
						end
					end
				end
			end
		end
		if type(MoreEnemies.Settings.more_spawn) == "number" and MoreEnemies.Settings.more_spawn > 0 then
			if not gro:is_enemy_special(unit) then
				xtimes = MoreEnemies.Settings.more_spawn
			end
			if xtimes > 0 then
				for i = 1, xtimes do
					call_on_next_update(function ()
						local unit_done = _spawn_enemy(_enemy_name, pos + _pos_offset(), rot)
						if _unit_objective then
							unit_done:brain():set_objective(_unit_objective)
						end
						table.insert(self._units, unit_done)
					end)
				end
			end
		end
	end
end)