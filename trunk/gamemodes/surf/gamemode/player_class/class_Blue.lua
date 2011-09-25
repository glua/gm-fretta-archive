local CLASS = {}

CLASS.DisplayName			= "Blue"
CLASS.WalkSpeed 			= 275
CLASS.RunSpeed				= 275
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true
CLASS.DropWeaponOnDie		= true
CLASS.PlayerModel			= "models/player/urban.mdl"

function CLASS:OnSpawn( pl )

pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)


end

function CLASS:Loadout( pl )


 pl:GiveAmmo(500, "smg1")
 
 pl:GiveAmmo(500, "357")

end

player_class.Register( "Blue", CLASS )