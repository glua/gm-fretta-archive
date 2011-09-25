local CLASS = {}

CLASS.DisplayName			= "Assault"
CLASS.WalkSpeed 			= 150
CLASS.CrouchedWalkSpeed 	= 0.65
CLASS.RunSpeed				= 305
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/leet.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 100
CLASS.StartArmor			= 50
CLASS.CanBunnyHop			= false

function CLASS:Loadout( pl )

end

player_class.Register( "Spectator", CLASS )
player_class.Register( "Default", CLASS )

local CLASS = {}

CLASS.DisplayName			= "Assault"
CLASS.CrouchedWalkSpeed 	= 0.65
CLASS.WalkSpeed 			= 150
CLASS.RunSpeed				= 305
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/leet.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 100
CLASS.StartArmor			= 50
CLASS.CanBunnyHop			= false
CLASS.Description			= "Lightly armoured class given the AK-47, Glock-20C pistol and 1 frag grenade";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 150,	"SMG1", 		true );
		
	pl:Give( "weapon_glock18" );
	pl:Give( "weapon_ak_47" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 1 );
	
	pl:SelectWeapon( "weapon_ak_47" );

end

function CLASS:Footstep( ply, pos, foot, sound, volume, rf )
	
	if( ply:KeyDown( IN_SPEED ) ) then
		if( SERVER ) then
			if( foot == 1 ) then
				ply:EmitSound( "NPC_CombineS.RunFootstepRight" );
			else
				ply:EmitSound( "NPC_CombineS.RunFootstepLeft" );
			end
		end
		
		return true
	end

end

function CLASS:OnSpawn( pl )
end

function CLASS:Move( pl, mv )

	if( self.CanBunnyHop == true and pl:KeyPressed( IN_JUMP ) and pl:IsOnGround() ) then -- by stgn
		mv:SetVelocity( mv:GetVelocity() * 1.25 );
	end
	
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

player_class.Register( "Assault_ter", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Special Operations"
CLASS.WalkSpeed 			= 175
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/phoenix.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 100
CLASS.Description			= "Heavily armoured class given the P90, Desert Eagle and 2 frag grenades";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 250,	"SMG1", 		true );
		
	pl:Give( "weapon_deserteagle" );
	pl:Give( "weapon_p90" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_p90" );

end

function CLASS:Footstep( ply, pos, foot, sound, volume, rf )
	
	local weap = ply:GetActiveWeapon();
	
	if( ValidEntity( weap ) and weap:GetNetworkedBool( "Ironsights", false ) == true ) then
		return true // silent footsteps in ironsights
	end
	
end

player_class.Register( "SpecOps_ter", CLASS )

CLASS = {}
CLASS.Base 					= "SpecOps_ter"
CLASS.DisplayName			= "Light Assault"
CLASS.WalkSpeed 			= 165
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/phoenix.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Light class given the IMI Galil rifle, 2 grenades and the Glock pistol";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 200,	"SMG", 		true );
		
	pl:Give( "weapon_glock18" );
	pl:Give( "weapon_galil" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_galil" );
	
end
player_class.Register( "LightAssault_ter", CLASS )

CLASS = {}
CLASS.Base 					= "SpecOps_ter"
CLASS.DisplayName			= "Close Quarters"
CLASS.WalkSpeed 			= 175
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/phoenix.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Fast class given the M1014 Auto Shotgun, P228 pistol and 2 frag grenades";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 100,	"Buckshot", 		true );
		
	pl:Give( "weapon_p228" );
	pl:Give( "weapon_m3s90" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_m3s90" );
	
end
player_class.Register( "CloseQuar_ter", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Sniper"
CLASS.WalkSpeed 			= 150
CLASS.RunSpeed				= 305
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/guerilla.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Slow scouting class given Scout and Desert Eagle";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 150,	"SMG1", 		true );
		
	pl:Give( "weapon_deserteagle" );
	pl:Give( "weapon_scout" );
	pl:Give( "weapon_knife" );
	
	pl:SelectWeapon( "weapon_scout" );

end
player_class.Register( "Sniper_ter", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Heavy"
CLASS.WalkSpeed 			= 135
CLASS.RunSpeed				= 295
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/arctic.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 25
CLASS.Description			= "Slow class with a lot of fire power. Give the M249 SAW and Five-Seven pistol";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 100,	"Pistol", 		true );
	pl:GiveAmmo( 300,	"SMG1", 		true );
		
	pl:Give( "weapon_five_seven" );
	pl:Give( "weapon_m249" );
	pl:Give( "weapon_knife" );
	
	pl:SelectWeapon( "weapon_m249" );

end
player_class.Register( "Heavy_ter", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Rusher"
CLASS.WalkSpeed 			= 190
CLASS.RunSpeed				= 330
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/arctic.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.CanBunnyHop			= true
CLASS.Description			= "Extremely quick class with bunny hopping abilities. Given the Mac-10."

function CLASS:Loadout( pl )

	pl:GiveAmmo( 350,	"SMG1", 		true );
		
	pl:Give( "weapon_uzi" );
	pl:Give( "weapon_knife" );
	
	
	pl:SelectWeapon( "weapon_uzi" );

end
player_class.Register( "Rusher_ter", CLASS )