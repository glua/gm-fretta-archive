local CLASS = {}

CLASS.DisplayName			= "Default"					// Class name to display in class selection
CLASS.WalkSpeed 			= 360						// Walk speed
CLASS.CrouchedWalkSpeed 	= 0.2						// Walk speed while crouching
CLASS.RunSpeed				= 360						// Run speed
CLASS.DuckSpeed				= 0.2						// Time it takes to duck in seconds
CLASS.JumpPower				= 220						// Jump power
--CLASS.PlayerModel			= "models/player/breen.mdl"	// Player model
CLASS.DrawTeamRing			= true						// When set to true, this class will have a team ring below them
CLASS.DrawViewModel			= true						// When set to false, this class will not see their view models
CLASS.CanUseFlashlight      = true						// When set to false, this will be unable to use thir flashlights
CLASS.MaxHealth				= 100						// Maximum health limit
CLASS.StartHealth			= 100						// Starting health value
CLASS.StartArmor			= 0							// Starting armor value
CLASS.RespawnTime           = 0 						// 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false						// When set to false, this class will not drop weapons when they die
CLASS.TeammateNoCollide 	= true						// When set to true, this class will not collide with teammates
CLASS.AvoidPlayers			= true						// Automatically avoid players that we're no colliding
CLASS.Selectable			= true						// When false, this disables all the team checking
CLASS.FullRotation			= false						// Allow the player's model to rotate upwards, etc etc
 
function CLASS:Loadout( ply )
	
	for i=0, 1 do
		local j = 2-i
		ply:Give(ply:GetLOWeapon(j).entity)
	end
	ply:Give("cb_weapon_crowbar")
	
end

function CLASS:OnSpawn( ply )

	for i=0, 1 do
		local j = 2-i
		ply:SelectWeapon(ply:GetLOWeapon(j).entity)
	end
	if ply:GetLOWeapon(3) then
		ply:SetGrenades(3)
	end

end

function CLASS:OnDeath( ply, attacker, dmginfo )
end

function CLASS:Think( ply )
end

function CLASS:Move( ply, data )
end

function CLASS:OnKeyPress( ply, key )

	if not SERVER then return end

	if (key == IN_SPEED) and GAMEMODE:InRound() then
		ply:FireGrenade()
	end

end

function CLASS:OnKeyRelease( ply, key )
end

function CLASS:ShouldDrawLocalPlayer( ply )
	return false
end

function CLASS:CalcView( ply, pos, ang, fov )
	
end

player_class.Register( "Default", CLASS )