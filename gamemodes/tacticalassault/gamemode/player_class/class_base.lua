
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 		= 0.2
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.MaxHealth 				= 100
CLASS.StartHealth 			= 100
CLASS.StartArmor				= 0
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide		= false
CLASS.AvoidPlayers			= false
CLASS.Selectable				= true
CLASS.FullRotation			= true

local redmdls = {
{"Combine",{
	"models/player/Police.mdl",
	"models/player/Combine_Soldier.mdl",
	"models/player/Combine_Soldier_PrisonGuard.mdl",
	"models/player/Combine_Super_Soldier.mdl"}},
}

local blumdls = {
{"Rebels - Male",{
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/Male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/Group03/Male_09.mdl"}},
{"Rebels - Female",{
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_06.mdl",
	"models/player/Group03/Female_07.mdl"}},
}

function CLASS:OnSpawn( pl )

	// Set their model randomly
	if pl:Team() == 1 then 
		pl:SetModel(table.Random(table.Random(redmdls)[2]))
		
		if table.Count(GAMEMODE.Red.Spawns) > 0 then pl:SetPos(table.Random(table.Random(GAMEMODE.Red.Spawns)):GetPos()) end
		
	else 
		pl:SetModel(table.Random(table.Random(blumdls)[2])) 
		
		if table.Count(GAMEMODE.Blu.Spawns) > 0 then pl:SetPos(table.Random(table.Random(GAMEMODE.Blu.Spawns)):GetPos()) end
	end

end

function CLASS:Loadout( pl )
	pl:GiveAmmo(90,"Pistol")
	pl:GiveAmmo(15,"357")
	pl:GiveAmmo(90,"SMG1")
	pl:GiveAmmo(75,"AR2")
	pl:GiveAmmo(30,"Buckshot")
	pl:GiveAmmo(20,"XBowBolt")
	pl:GiveAmmo(3,"Grenade")
	pl:GiveAmmo(3,"RPG_Round")
	
	pl:Give("weapon_binoculars")
	pl:Give("weapon_mad_fists")
	
	if GetGlobalString("ta_mode") == "bomb" && pl:Team() == 1 then pl:Give("weapon_bomb") end
	//if pl:IsAdmin() then pl:Give("weapon_mad_smoke") end
end

player_class.Register( "BaseClass", CLASS )






