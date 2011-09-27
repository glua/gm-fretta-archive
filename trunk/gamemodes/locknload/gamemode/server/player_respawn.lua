function GM:SetWeaponChoice (ply, cmd, args)
	--PrintTable (args)
	--print ("okay, trying")
	ply.Weapons = ply.Weapons or {}
	local slot = tonumber(args[1])
	if (not slot) or slot < 1 or slot > 2 or math.floor(slot) != slot then return end
	ply.Weapons[slot] = {classname = args[2], mods = {args[3], args[4], args[5]}}
	--print (args[1], args[2])
end

GM:AddConCommand ("lnl_wpn", "SetWeaponChoice")

function GM:LoadoutPlayerFromMenu (ply, cmd, args)
	if ply:SteamID() == "BOT" then
		ply.Weapons = {}
		--ply.Weapons[1] = {classname = "smg", mods = {"rapid", "highcapacity"}}
		--ply.Weapons[2] = {classname = "pistol", mods = {"enraged", "rapidreloading"}}
		--get a weapon
		local wpn1 = self.RegisteredWeapons[math.random(#self.RegisteredWeapons)].classname
		local wpn1mods = {}
		--get its mods
		for i=1, 3 do
			local mods = {}
			for k,v in pairs (self.WeaponModsByCategory[i]) do
				if v:IsApplicable (wpn1) then
					mods[#mods+1] = v
				end
			end
			--PrintTable (mods)
			if #mods > 0 then
				wpn1mods[#wpn1mods+1] = mods[math.random(#mods)].Codename
			end
		end
		
		--get a weapon
		local wpn2 = self.RegisteredWeapons[math.random(#self.RegisteredWeapons)].classname
		while wpn2 == wpn1 do
			wpn2 = self.RegisteredWeapons[math.random(#self.RegisteredWeapons)].classname
		end
		local wpn2mods = {}
		--get its mods
		for i=1, 3 do
			local mods = {}
			for k,v in pairs (self.WeaponModsByCategory[i]) do
				if v:IsApplicable (wpn2) then
					mods[#mods+1] = v
				end
			end
			if #mods > 0 then
				wpn2mods[#wpn2mods+1] = mods[math.random(#mods)].Codename
			end
		end
		
		ply.Weapons[1] = {classname = string.sub (wpn1, 12), mods = wpn1mods}
		ply.Weapons[1] = {classname = string.sub (wpn2, 12), mods = wpn2mods}
	end
	
	ply.BaseWalkSpeed = 200
	ply:SetRunSpeed (ply.BaseWalkSpeed)
	ply.BaseRunSpeed = 300
	ply:SetRunSpeed (ply.BaseRunSpeed)
	ply:SetCrouchedWalkSpeed (0.75)
	ply:SetHealth (self.MaxPlayerHealth or 120)
	
	for k,v in pairs (ply.Weapons) do
		--print ("weapon", k)
		ply:Give ("weapon_lnl_"..v.classname)
		local wpn = ply:GetWeapon ("weapon_lnl_"..v.classname)
		if wpn then
			for k,v in pairs (v.mods) do
				local mod = self.WeaponMods[v]
				if mod and mod.Category == k then
					mod:Apply (wpn)
					wpn:SetNWString ("mod"..k, v)
				end
			end
		end
	end
	
	ply.LoadedOut = true
end

GM:AddConCommand ("lnl_respawn", "LoadoutPlayerFromMenu")

--this stuff is now done in class_default
