core:import("CoreMissionScriptElement")
ElementSpawnEnemyDummy = ElementSpawnEnemyDummy or class(CoreMissionScriptElement.MissionScriptElement)

local SFM_ElementSpawnEnemyDummy_ori_produce = ElementSpawnEnemyDummy.produce

local SFM_4_Sniper = {}

function ElementSpawnEnemyDummy:produce(params)
	local unit = SFM_ElementSpawnEnemyDummy_ori_produce(self, params)
	if not managers.groupai or not managers.groupai:state() then
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
	local xtimes = 0
	local catname = tostring(unit:base()._tweak_table)
	if catname == "sniper" then
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
	elseif catname == "taser" or catname == "tank" then
		xtimes = 1
		table.insert(SFM_4_Sniper, unit:name())
	elseif not gro:is_enemy_special(unit) then
		xtimes = 0
	elseif gro:is_enemy_special(unit) then
		xtimes = 1
		table.insert(SFM_4_Sniper, unit:name())
		table.insert(SFM_4_Sniper, unit:name())
	end
	if xtimes <= 0 then
		return unit
	end
	local _spawn_enemy = function (unit_name, pos, rot)
		local unit_done = safe_spawn_unit(unit_name, pos, rot)
		local team_id = tweak_data.levels:get_default_team_ID(unit_done:base():char_tweak().access == "gangster" and "gangster" or "combatant")
		unit_done:movement():set_team(gro:team_data( team_id ))
		gro:assign_enemy_to_group_ai(unit_done, team_id)
		return unit_done
	end
	for i = 1, xtimes do
		local enemy_name = unit:name()
		local pos, rot = self:get_orientation()
		local ang = math.random() * 360 * math.pi
		local rad = math.random(30, 50)
		local offset = Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
		pos = pos + offset
		local unit_done = _spawn_enemy(enemy_name, pos, rot)
		table.insert(self._units, unit_done)
	end
	if #SFM_4_Sniper > 0 then
		local _r = math.random(#SFM_4_Sniper)
		if tostring(SFM_4_Sniper[_r]):find('Idstring') then
			unit_done = _spawn_enemy(SFM_4_Sniper[_r], pos, rot)
			table.insert(self._units, unit_done)
			table.remove(SFM_4_Sniper, _r)
		end
	end
	return unit
end