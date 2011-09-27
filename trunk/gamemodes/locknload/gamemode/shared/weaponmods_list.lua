GM.WeaponMods = {}
GM.WeaponModsByCategory = {}

function GM:FindWeaponMods ()
	local files = file.Find ("../" .. GM.GamemodeFolder .. "/gamemode/shared/weaponmods/*.lua")
	
	if SERVER then
		for _, fileName in pairs (files) do
			AddCSLuaFile ("weaponmods/" .. fileName)
		end
	end
	
	for id,fileName in pairs (files) do
		if fileName != "base.lua" then
			WMOD = {}
			include ("weaponmods/base.lua")
			include ("weaponmods/"..fileName)
			WMOD.Codename = string.gsub (fileName, ".lua", "")
			--PrintTable (WMOD)
			GM.WeaponMods[WMOD.Codename] = WMOD --GM.WM uses codenames, for finding upgrades by name
			GM.WeaponModsByCategory[WMOD.Category] = GM.WeaponModsByCategory[WMOD.Category] or {}
			table.insert (GM.WeaponModsByCategory[WMOD.Category], WMOD) --GM.WMBC uses ids instead, for ordering purposes
		end
	end
end

GM:FindWeaponMods()