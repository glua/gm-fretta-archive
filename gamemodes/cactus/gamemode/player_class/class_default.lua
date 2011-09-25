
local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 750
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 400
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true

function CLASS:Loadout( ply )
	/*for i=1,6 do
		if ply:Frags() < levels[i]["Score"] then return end
		if ply:Frags() >= levels[i]["Score"] then
			ply:SetLevel(i)
		end
	end*/
end

function CLASS:OnSpawn( ply )
	ply:Give("weapon_physcannon")
	for i=1,6 do
		if ply:Level() <= i or ply:Frags() < levels[i]["Score"] then return end
		if ply:Frags() >= levels[i]["Score"] then
			ply:SetLevel(i)
			ply:ChatPrint("You are in the "..string.upper(levels[i]["Name"]).." class!")
		end
	end
	for k,v in pairs(upgrades) do
		ply:RemoveUpgrade(v["name"])
	end
	ply.Upgrades = {}
end

player_class.Register( "Default", CLASS )