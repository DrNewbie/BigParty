core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

_G.MoreEnemies = _G.MoreEnemies or {}

local MoreEnemies = _G.MoreEnemies or {}

MoreEnemies.SFM_Sniper_Element = MoreEnemies.SFM_Sniper_Element or {}

MoreEnemies.Settings = MoreEnemies.Settings or {}

local SFM_ElementSpawnEnemyDummy_ori_produce = ElementSpawnEnemyDummy.produce

function ElementSpawnEnemyDummy:produce(...)
	local unit = SFM_ElementSpawnEnemyDummy_ori_produce(self, ...)
	if not unit or not alive(unit) then
		return
	end
	if not managers.groupai or not managers.groupai:state() then
		return unit
	end
	if unit:name():key() == Idstring('units/pd2_dlc_wwh/characters/ene_locke/ene_locke'):key() then
		return unit
	end
	local gro = managers.groupai:state()
	if not gro:is_AI_enabled() or not gro:enemy_weapons_hot() or gro:whisper_mode() then
		return unit
	end
	if unit:character_damage()._invulnerable or unit:character_damage()._immortal or unit:character_damage()._dead then
		return unit
	end
	if gro:is_enemy_converted_to_criminal(unit) then
		return unit
	end
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
	local _time_now = math.round(TimerManager:game():time())
	local _enemy_name = unit:name()
	local pos, rot = self:get_orientation()
	local xtimes = 1
	local catname = tostring(unit:base()._tweak_table)
	if MoreEnemies.Settings.more_sniper then
		if catname == "sniper" then
			local _objective_sniper = unit:brain() and unit:brain():objective() or {}
			if type(_objective_sniper) == "table" then
				for i = 1, 2 do
					local unit_done_sniper = _spawn_enemy(_enemy_name, pos + _pos_offset(), rot)
					unit_done_sniper:brain():set_objective(_objective_sniper)
					table.insert(self._units, unit_done_sniper)
				end
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
			if type(MoreEnemies) == "table" and type(MoreEnemies.SFM_Sniper_Element) == "table" then
				for i = 1, 3 do
					local _ele_key = table.random_key(MoreEnemies.SFM_Sniper_Element)
					local _ele_data = MoreEnemies.SFM_Sniper_Element[_ele_key]
					if type(_ele_data) == "table" and _time_now > _ele_data.t then
						MoreEnemies.SFM_Sniper_Element[_ele_key].t = _time_now + 10 + math.random()*10
						local _sniper_element = self:get_mission_element(_ele_data.id)
						if _sniper_element then
							_sniper_element:on_executed()
						end
					end
				end
			end
		end
	end
	if MoreEnemies.Settings.more_spawn then
		if not gro:is_enemy_special(unit) then
			xtimes = 2
		end
		if xtimes > 0 then
			for i = 1, xtimes do
				local unit_done = _spawn_enemy(_enemy_name, pos + _pos_offset(), rot)
				table.insert(self._units, unit_done)
			end
		end
	end
	return unit
end