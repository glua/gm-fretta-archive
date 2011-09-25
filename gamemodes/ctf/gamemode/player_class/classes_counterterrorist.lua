local CLASS = {}

CLASS.DisplayName			= "Assault"
CLASS.Base 					= "Assault_ter"
CLASS.WalkSpeed 			= 150
CLASS.CrouchedWalkSpeed 	= 0.65
CLASS.RunSpeed				= 305
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/urban.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 100
CLASS.StartArmor			= 50
CLASS.Description			= "Lightly armoured class given the automatic M4A1, USP pistol and 1 frag grenade";


function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 150,	"SMG1", 		true );
		
	pl:Give( "weapon_usp" );
	pl:Give( "weapon_m4a1" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 1 );
	
	pl:SelectWeapon( "weapon_m4a1" );

end

function CLASS:OnSpawn( pl )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

player_class.Register( "Assault_ct", CLASS )

CLASS = {}
CLASS.Base 					= "SpecOps_ter"
CLASS.DisplayName			= "Special Operations"
CLASS.WalkSpeed 			= 175
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/gasmask.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 100
CLASS.Description			= "Heavily armoured class given the MP5, Desert Eagle and 2 frag grenades";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 150,	"SMG1", 		true );
		
	pl:Give( "weapon_deserteagle" );
	pl:Give( "weapon_mp5n" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_mp5n" );

end
player_class.Register( "SpecOps_ct", CLASS )

CLASS = {}
CLASS.Base 					= "SpecOps_ct"
CLASS.DisplayName			= "Light Assault"
CLASS.WalkSpeed 			= 165
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/swat.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Light class given the Famas rifle, 2 grenades and the USP pistol";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 200,	"SMG", 		true );
		
	pl:Give( "weapon_usp" );
	pl:Give( "weapon_famas" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_famas" );
	
end
player_class.Register( "LightAssault_ct", CLASS )

CLASS = {}
CLASS.Base 					= "SpecOps_ter"
CLASS.DisplayName			= "Close Quarters"
CLASS.WalkSpeed 			= 175
CLASS.RunSpeed				= 320
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/gasmask.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Fast class given the M1014 Auto Shotgun, P228 pistol and 2 frag grenades";

function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 100,	"Buckshot", 		true );
		
	pl:Give( "weapon_p228" );
	pl:Give( "weapon_xm1014" );
	pl:Give( "weapon_knife" );
	
	pl:Give( "weapon_hegrenade" );
	pl:SetCustomAmmo( "FragGrenades", 2 );
	
	pl:SelectWeapon( "weapon_xm1014" );

end
player_class.Register( "CloseQuar_ct", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Sniper"
CLASS.WalkSpeed 			= 150
CLASS.RunSpeed				= 305
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/swat.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.Description			= "Slow scouting class given AWP and Desert Eagle";


function CLASS:Loadout( pl )

	pl:GiveAmmo( 200,	"Pistol", 		true );
	pl:GiveAmmo( 150,	"SMG1", 		true );
		
	pl:Give( "weapon_deserteagle" );
	pl:Give( "weapon_awp" );
	pl:Give( "weapon_knife" );
	
	pl:SelectWeapon( "weapon_awp" );

end
player_class.Register( "Sniper_ct", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Heavy"
CLASS.WalkSpeed 			= 135
CLASS.RunSpeed				= 295
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/riot.mdl"
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
player_class.Register( "Heavy_ct", CLASS )

CLASS = {}
CLASS.Base 					= "Default"
CLASS.DisplayName			= "Rusher"
CLASS.WalkSpeed 			= 190
CLASS.RunSpeed				= 330
CLASS.JumpPower				= 220
CLASS.PlayerModel			= "models/player/riot.mdl"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.CanBunnyHop			= true
CLASS.Description			= "Extremely quick class with bunny hopping abilities. Given UMP45."

function CLASS:Loadout( pl )

	pl:GiveAmmo( 350,	"SMG1", 		true );
		
	pl:Give( "weapon_ump45" );
	pl:Give( "weapon_knife" );
	
	
	pl:SelectWeapon( "weapon_ump45" );

end
player_class.Register( "Rusher_ct", CLASS )