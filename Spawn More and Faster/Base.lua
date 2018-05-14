if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end

if UpdateThisMod then
	UpdateThisMod:Add({
		mod_id = 'Spawn More and Faster',
		data = {
			modworkshop_id = 20649,
			dl_url = 'https://drnewbie.github.io/BigParty/Spawn%20More%20and%20Faster.zip',
			info_url = 'https://drnewbie.github.io/BigParty/Spawn%20More%20and%20Faster/mod.txt'
		}
	})
end

_G.MoreEnemies = _G.MoreEnemies or {}

MoreEnemies.ModPath = ModPath

MoreEnemies.SavePath = SavePath.."MoreEnemies.txt"

Hooks:Add("LocalizationManagerPostInit", "MoreEnemies_loc", function(loc)
	loc:load_localization_file(MoreEnemies.ModPath.."Loc.json")
end)

MoreEnemies.Settings = {
	general_groups_multiplier = 4,
	general_max_of_groups = 8,
	special_max_tank = 8,
	special_max_taser = 8,
	special_max_spooc = 8,
	special_max_shield = 16,
	special_max_medic = 16,
	special_max_sniper = 16,
	force_cap = false,
	more_spawn = 3,
	force_cap_attach = 120,
	force_cap_normal = 90
}

function MoreEnemies:save()
	local _file = io.open(self.SavePath, "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
end

function MoreEnemies:load()
	local _file = io.open(self.SavePath, "r")
	if _file then
		for k, v in pairs(json.decode(_file:read("*all")) or {}) do
			if k then
				self.Settings[k] = v
			end
		end
		_file:close()
	else
		self.Settings = {
			general_groups_multiplier = 4,
			general_max_of_groups = 8,
			special_max_tank = 8,
			special_max_taser = 8,
			special_max_spooc = 8,
			special_max_shield = 16,
			special_max_medic = 16,
			special_max_sniper = 16,
			force_cap = false,
			more_spawn = 3,
			force_cap_attach = 120,
			force_cap_normal = 90
		}
		self:save()
	end
end

Hooks:Add("MenuManagerInitialize", "MenManInitMoreEnemies", function()
	function MenuCallbackHandler:MoreEnemies_toggle_save()
		MoreEnemies:save()
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
	MoreEnemies:load()
	MenuHelper:LoadFromJsonFile(MoreEnemies.ModPath.."Menu.json", MoreEnemies, MoreEnemies.Settings)
end)