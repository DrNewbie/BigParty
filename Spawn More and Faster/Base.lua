if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end

if _G.MoreEnemies then
	return
end

_G.MoreEnemies = {}

MoreEnemies.ModPath = ModPath

MoreEnemies.SavePath = SavePath.."MoreEnemies.txt"

Hooks:Add("LocalizationManagerPostInit", "MoreEnemies_loc", function(loc)
	loc:load_localization_file(MoreEnemies.ModPath.."Loc.json")
end)

function MoreEnemies:Default()
	return {
		general_groups_multiplier = 4,
		general_max_of_groups = 12,
		special_max_tank = 4,
		special_max_taser = 4,
		special_max_spooc = 4,
		special_max_shield = 8,
		special_max_medic = 8,
		special_max_sniper = 8,
		force_cap = true,
		more_spawn = 2,
		force_cap_attach = 90,
		force_cap_normal = 70,
		more_sniper = true,
		more_sniper_amount = 3,
		assault_force = 28
	}
end

function MoreEnemies:save()
	local _file = io.open(self.SavePath, "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
end

function MoreEnemies:reset()
	self.Settings = self:Default()
	self:save()
end

function MoreEnemies:load()
	self.Settings = self:Default()
	local _file = io.open(self.SavePath, "r")
	if _file then
		for k, v in pairs(json.decode(_file:read("*all")) or {}) do
			if k and self:Default()[k] and type(self:Default()[k]) == type(v) then
				self.Settings[k] = v
			end
		end
		_file:close()
	else
		self:reset()
	end
end

function MoreEnemies:set_group_ai_tweak_data()
	if MutatorBigParty and managers.mutators:is_mutator_active(MutatorBigParty) then
		return
	end
	if tweak_data.group_ai then
		local SME_S = self and self.Settings or nil
		local group_ai = tweak_data.group_ai
		local besiege = group_ai.besiege
		local assault = besiege.assault
		
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
		
		general_groups_multiplier = SME_S.general_groups_multiplier or general_groups_multiplier
		general_max_of_groups = SME_S.general_max_of_groups or general_max_of_groups
		group_ai.special_unit_spawn_limits.tank = SME_S.special_max_tank or group_ai.special_unit_spawn_limits.tank
		group_ai.special_unit_spawn_limits.taser = SME_S.special_max_taser or group_ai.special_unit_spawn_limits.taser
		group_ai.special_unit_spawn_limits.spooc = SME_S.special_max_spooc or group_ai.special_unit_spawn_limits.spooc
		group_ai.special_unit_spawn_limits.shield = SME_S.special_max_shield or group_ai.special_unit_spawn_limits.shield
		group_ai.special_unit_spawn_limits.medic = SME_S.special_max_medic or group_ai.special_unit_spawn_limits.medic
		group_ai.special_unit_spawn_limits.sniper = SME_S.special_max_sniper or group_ai.special_unit_spawn_limits.sniper
		if GroupAIStateBesiege then
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
			assault.force[i] = SME_S.assault_force or 14
		end
		
		for i = 1, #besiege.reenforce.interval do
			besiege.reenforce.interval[i] = i
		end
		
		for i = 1, #assault.force_balance_mul do
			assault.force_balance_mul[i] = 1.25
		end
		
		for i = 1, #assault.force_pool_balance_mul do
			assault.force_pool_balance_mul[i] = 1.25
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
		
		tweak_data.group_ai = group_ai
		
		tweak_data.group_ai.besiege = besiege
		
		tweak_data.group_ai.besiege.assault = assault
		
		tweak_data.group_ai.street = tweak_data.group_ai.besiege
		
		tweak_data.group_ai.safehouse = tweak_data.group_ai.besiege
	end
end

Hooks:Add("MenuManagerInitialize", "MenManInitMoreEnemies", function()
	function MenuCallbackHandler:MoreEnemies_toggle_save()
		MoreEnemies:save()
		MoreEnemies:set_group_ai_tweak_data()
	end
	function MenuCallbackHandler:MoreEnemies_more_reset_config()
		MoreEnemies:reset()
	end	
	function MenuCallbackHandler:MoreEnemies_force_cap(item)
		MoreEnemies.Settings.force_cap = tostring(item:value()) == 'on' and true or false
	end
	function MenuCallbackHandler:MoreEnemies_force_cap_attach(item)
		MoreEnemies.Settings.force_cap_attach = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_force_cap_normal(item)
		MoreEnemies.Settings.force_cap_normal = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_more_sniper(item)
		MoreEnemies.Settings.more_sniper = tostring(item:value()) == 'on' and true or false
	end
	function MenuCallbackHandler:MoreEnemies_more_spawn(item)
		MoreEnemies.Settings.more_spawn = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_general_groups_multiplier(item)
		MoreEnemies.Settings.general_groups_multiplier = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_general_max_of_groups(item)
		MoreEnemies.Settings.general_max_of_groups = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_tank(item)
		MoreEnemies.Settings.special_max_tank = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_taser(item)
		MoreEnemies.Settings.special_max_taser = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_spooc(item)
		MoreEnemies.Settings.special_max_spooc = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_shield(item)
		MoreEnemies.Settings.special_max_shield = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_medic(item)
		MoreEnemies.Settings.special_max_medic = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_special_max_sniper(item)
		MoreEnemies.Settings.special_max_sniper = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_more_sniper_amount(item)
		MoreEnemies.Settings.more_sniper_amount = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_more_sniper_delay(item)
		MoreEnemies.Settings.more_sniper_delay = math.round(item:value())
	end
	function MenuCallbackHandler:MoreEnemies_assault_force(item)
		MoreEnemies.Settings.assault_force = math.round(item:value())
	end
	MoreEnemies:load()
	MenuHelper:LoadFromJsonFile(MoreEnemies.ModPath.."Menu.json", MoreEnemies, MoreEnemies.Settings)
end)