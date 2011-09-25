MsgN( "CLASSES!" );

// It was a pain in the ass in CTF to have the classes of different teams in seperate files so all in one now
// This is our base class, nothing special
CLASS = {};

CLASS.DisplayName			= "Base Class";
CLASS.WalkSpeed 			= 125;
CLASS.CrouchedWalkSpeed 	= 0.33;
CLASS.RunSpeed				= 250;
CLASS.DuckSpeed				= 0.2;
CLASS.JumpPower				= 150;
CLASS.PlayerModel			= Model( "models/player/combine.mdl" );
CLASS.MaxHealth				= 100;
CLASS.StartHealth			= 100;
CLASS.StartArmor			= 0;
CLASS.DropWeaponOnDie		= true;
CLASS.TeammateNoCollide 	= true;
CLASS.AvoidPlayers			= true;

function CLASS:Loadout( pl )

	local weapons = GAMEMODE.PrimaryWeapons;
	local primary = pl:GetInfo( "as_cl_primaryweapon" );
	
	if( !weapons or !primary or primary == "random" or !weapons[ "weapon_as_" .. primary ] ) then
		local rk = math.random( 1, table.Count( weapons ) )
		local i = 1
		
		for k, v in pairs( weapons ) do
			if ( i == rk ) then return pl:Give( k ) end
			i = i + 1
		end
	else
		pl:Give( "weapon_as_" .. primary );
	end
	
end

function CLASS:OnSpawn( pl )

end

function CLASS:OnDeath( pl )
end

function CLASS:Think( pl )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:Footstep( ply, pos, foot, sound, volume, rf )

	if( ply:KeyDown( IN_DUCK ) ) then
		return true
	end
	
end


player_class.Register( "As_Base", CLASS )

// Dr. Breen
CLASS = {}
CLASS.Base					= "As_Base";
CLASS.DisplayName			= "Dr. Wallace Breen";
CLASS.JumpPower				= 220;
CLASS.WalkSpeed 			= 100;
CLASS.RunSpeed				= 280;
CLASS.PlayerModel			= Model( "models/player/breen.mdl" );
CLASS.MaxHealth				= 300;
CLASS.StartHealth			= 300;
CLASS.StartArmor			= 150;
CLASS.DropWeaponOnDie		= false;
CLASS.TeammateNoCollide 	= true;
CLASS.AvoidPlayers			= true;
CLASS.Selectable			= false;

function CLASS:Loadout( pl )
	// we need to give breen a shitty pistol... or not.
	pl:Give( "weapon_as_revolver" );
end

function CLASS:OnSpawn( pl )

	// resets everything and sets our target
	SetGlobalEntity( "Breen", pl );
	SetGlobalBool( "BreenEliminated", false );
	SetGlobalEntity( "BreenKiller", NULL );
	
end

// This handles the assassination stuff, I'm sorta keeping it simple for now
function CLASS:OnDeath( pl, attacker, dmginfo )

	SetGlobalBool( "BreenEliminated", true );
	
	if( ValidEntity( attacker ) ) then
		SetGlobalEntity( "BreenKiller", attacker );
	end
	
	BroadcastLua( "GAMEMODE:PrintCenter( [[The VIP was eliminated]] )" );
	
	GAMEMODE:RoundEndWithResult( TEAM_REBELS, "Dr. Breen was killed. Rebels win" ); // rebels ofc win
	
end

player_class.Register( "As_DrBreen", CLASS )

/*
	=================================
	COMBINE TEAM
	=================================
*/
CLASS = {};

CLASS.Base					= "As_Base";
CLASS.DisplayName			= "Soldier";
CLASS.PlayerModel			= { Model( "models/player/combine_soldier.mdl" ), Model( "models/player/combine_super_soldier.mdl" ), Model( "models/player/combine_soldier_prisonguard.mdl" ) };
CLASS.MaxHealth				= 100;
CLASS.StartHealth			= 100;
CLASS.StartArmor			= 100;
CLASS.DropWeaponOnDie		= true;
CLASS.TeammateNoCollide 	= true;
CLASS.AvoidPlayers			= true;

function CLASS:Loadout( pl )
	self.BaseClass:Loadout( pl );
	pl:Give( "weapon_as_uspmatch" );
end

player_class.Register( "Combine_Soldier", CLASS )

/*
	=================================
	REBELS
	=================================
*/
CLASS = {};

CLASS.Base					= "As_Base";
CLASS.DisplayName			= "Rebel";
CLASS.PlayerModel			= { Model( "models/player/Group01/Female_01.mdl" ),
									Model( "models/player/Group01/Female_02.mdl" ),
									Model( "models/player/Group01/Female_03.mdl" ),
									Model( "models/player/Group01/Female_04.mdl" ),
									Model( "models/player/Group01/Female_06.mdl" ),
									Model( "models/player/Group01/Female_07.mdl"),
									Model( "models/player/Group01/Male_01.mdl" ),
									Model( "models/player/Group01/male_02.mdl" ),
									Model( "models/player/Group01/male_03.mdl" ),
									Model( "models/player/Group01/male_04.mdl" ),
									Model( "models/player/Group01/male_05.mdl" ),
									Model( "models/player/Group01/male_06.mdl" ),
									Model( "models/player/Group01/male_07.mdl" ),
									Model( "models/player/Group01/male_08.mdl" ),
									Model( "models/player/Group01/male_09.mdl" ),
									Model( "models/player/Group03/Male_01.mdl" ),
									Model( "models/player/Group03/Male_02.mdl" ),
									Model( "models/player/Group03/Male_03.mdl" ),
									Model( "models/player/Group03/Male_04.mdl" ),
									Model( "models/player/Group03/Male_05.mdl" ),
									Model( "models/player/Group03/Male_06.mdl" ),
									Model( "models/player/Group03/Male_07.mdl" ),
									Model( "models/player/Group03/Male_08.mdl" ),
									Model( "models/player/Group03/Male_09.mdl" ),
									Model( "models/player/Group03/Female_01.mdl" ),
									Model( "models/player/Group03/Female_02.mdl" ),
									Model( "models/player/Group03/Female_03.mdl" ),
									Model( "models/player/Group03/Female_04.mdl" ),
									Model( "models/player/Group03/Female_06.mdl" ),
									Model( "models/player/Group03/Female_07.mdl" ) };
CLASS.MaxHealth				= 100;
CLASS.StartHealth			= 100;
CLASS.StartArmor			= 100;
CLASS.DropWeaponOnDie		= true;
CLASS.TeammateNoCollide 	= true;
CLASS.AvoidPlayers			= true;

function CLASS:Loadout( pl )
	self.BaseClass:Loadout( pl );
	pl:Give( "weapon_as_uspmatch" );
end

player_class.Register( "Rebel_Assault", CLASS )