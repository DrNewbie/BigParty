if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end

if UpdateThisMod then
	UpdateThisMod:Add({
		mod_id = 'Spawn More and Faster',
		data = {
			modworkshop_id = 20649,
            dl_url = 'https://github.com/DrNewbie/BigParty/raw/master/Spawn%20More%20and%20Faster.zip',
            info_url = 'https://raw.githubusercontent.com/DrNewbie/BigParty/master/Spawn%20More%20and%20Faster/mod.txt'
		}
	})
end