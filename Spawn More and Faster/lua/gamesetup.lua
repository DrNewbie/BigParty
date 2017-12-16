Hooks:PostHook(GameSetup, "init_game", "SMF_GameSetup_init_game", function(self)
	if MutatorBigParty and managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	if tweak_data.group_ai then
		local group_ai = tweak_data.group_ai
		group_ai.special_unit_spawn_limits = {
			tank = 6,
			taser = 8,
			spooc = 8,
			shield = 16,
			medic = 16,
			sniper = 16
		}
		local amount_multiplier = 4
		for id, group in pairs(group_ai.enemy_spawn_groups) do
			if id ~= "Phalanx" and not id:find("spooc") then
				if group.amount then
					for k, v in pairs(group.amount) do
						group.amount[k] = math.round(v * amount_multiplier) + 1
					end
				end
				for _, spawn in pairs(group.spawn or {}) do
					if spawn.amount_max then
						spawn.amount_max = spawn.amount_max * (amount_multiplier * ((spawn.unit:find("swat") or spawn.unit:find("heavy")) and 1 or 0.2))
						spawn.amount_max = math.round(spawn.amount_max) + 1
						if id:find('tank') or id:find('taser') or id:find('shield') or id:find('medic') then
							spawn.amount_max = math.clamp(spawn.amount_max, 1, 8)
						end
					end
				end
			end
		end
		table.insert(group_ai.unit_categories.medic_M4.unit_types.america, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"))
		table.insert(group_ai.unit_categories.medic_M4.unit_types.russia, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"))
		table.insert(group_ai.unit_categories.medic_R870.unit_types.america, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"))
		table.insert(group_ai.unit_categories.medic_R870.unit_types.russia, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"))
		table.insert(group_ai.unit_categories.medic_M4.unit_types.america, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
		table.insert(group_ai.unit_categories.medic_M4.unit_types.russia, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
		table.insert(group_ai.unit_categories.medic_R870.unit_types.america, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
		table.insert(group_ai.unit_categories.medic_R870.unit_types.russia, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
		local besiege = group_ai.besiege
		besiege.assault.force = {
			9,
			9,
			9
		}
		besiege.assault.force_pool = {
			300,
			600,
			1000
		}
		besiege.reenforce.interval = {
			1,
			2,
			3
		}
		besiege.assault.force_balance_mul = {
			20,
			24,
			28,
			32
		}
		besiege.assault.force_pool_balance_mul = {
			12,
			18,
			24,
			32
		}
		besiege.assault.delay = {
			15,
			10,
			5
		}
		besiege.assault.sustain_duration_min = {
			120,
			160,
			240
		}
		besiege.assault.sustain_duration_max = {
			240,
			320,
			480
		}
		besiege.assault.sustain_duration_balance_mul = {
			1.3,
			1.5,
			1.7,
			1.9
		}
	end
end)