include( "player_extensions_sh.lua" );

DeriveGamemode( "fretta" )
IncludePlayerClasses()

ctf_gametime = CreateConVar( "ctf_gametime", "15", FCVAR_GAMEDLL + FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE );
ctf_scorelimit = CreateConVar( "ctf_scorelimit", "10", FCVAR_GAMEDLL + FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE );

GM.Name 	= "Capture the Flag"
GM.Author 	= "SteveUK"
GM.Email 	= "stephen.swires@gmail.com"
GM.Website 	= "http://s-swires.org"
GM.Help		= "Capture the enemy flag and return it to your base\n\n\n\nHow it works:\nYou take the enemy flag and take it to your base, but your flag must be at your base for the capture to work. If the overlay on your HUD has a red cross over it, it means someone has taken it and you must find it. Once you touch your team's dropped flag it is instantly returned to base.\n\nCreated by SteveUK. Effects by CapsAdmin and ZpankR"

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 5
GM.GameLength = ctf_gametime:GetFloat()
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.MaximumDeathLength = 5			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.SelectClass = true
GM.SpawnProtection = 3;
GM.TeamScoreLimit = 10
GM.NoAutomaticSpawning = false		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = false				// Round based, like CS

TEAM_BLUE 		= 1
TEAM_RED 		= 2

function GetMapName()
	return game.GetMap();
end


/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	if( MAP and MAP.CustomTeamSetup ) then
		Msg( "Map uses custom teams\n");
		MAP:CustomTeamSetup();
	else
		team.SetUp( TEAM_BLUE, "Counter-Terrorists", Color( 80, 150, 255 ) )
		team.SetSpawnPoint( TEAM_BLUE, { "info_player_deathmatch", "info_player_combine", "info_player_counterterrorist", "info_player_allies","ctf_combine_player_spawn" }, true )
		team.SetClass( TEAM_BLUE, { "Assault_ct", "LightAssault_ct", "SpecOps_ct", "CloseQuar_ct", "Sniper_ct", "Heavy_ct", "Rusher_ct" } )
		
		team.SetUp( TEAM_RED, "Terrorists", Color( 255, 80, 80 ) )
		team.SetSpawnPoint( TEAM_RED, { "info_player_deathmatch", "info_player_rebels", "info_player_terrorist", "info_player_axis", "ctf_rebel_player_spawn" }, true )
		team.SetClass( TEAM_RED, { "Assault_ter", "LightAssault_ter", "SpecOps_ter", "CloseQuar_ter", "Sniper_ter", "Heavy_ter", "Rusher_ter" } )
		
		team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
		team.SetSpawnPoint( TEAM_SPECTATOR, "info_player_start", "point_viewcontrol" )
		team.SetClass( TEAM_SPECTATOR, { "Spectator" } )
	end

end

MAP = {}
function GM:Initialize()
	
	self.BaseClass:Initialize()

	if( CLIENT ) then
		GAMEMODE:InitializeClient();
	end
	
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo ) 

	if( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 5 );
	elseif( hitgroup == HITGROUP_CHEST ) then
		dmginfo:ScaleDamage( 1.7 );
	elseif( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM ) then
		dmginfo:ScaleDamage( 0.25 );
	elseif( hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG ) then
		dmginfo:ScaleDamage( 0.33 );
	else
		dmginfo:ScaleDamage( 1 );
	end
	
end

function GM:InitPostEntity( )

	GAMEMODE:LoadMapInfo();
		
	if( MAP and MAP.CustomTeamSetup ) then
		GAMEMODE:CreateTeams(); -- again
	end
	
	MAP:SpawnEntities();
	
	self.BaseClass:InitPostEntity();
	
end

function GM:LoadMapInfo()
	local Folder = string.Replace( GAMEMODE.Folder, "gamemodes/", "" );
	
	if( SERVER ) then
		AddCSLuaFile( Folder .. "/gamemode/maps/default_map.lua" );
		AddCSLuaFile( Folder .. "/gamemode/maps/" .. GetMapName() );	
	end
	
	include( Folder .. "/gamemode/maps/default_map.lua" );
	
	if( file.Exists( "../" .. GAMEMODE.Folder .. "/gamemode/maps/" .. GetMapName() .. ".lua" ) ) then
		include( Folder .. "/gamemode/maps/" .. GetMapName() .. ".lua" );
	end
	
	Msg( "Loaded map info for " .. GetMapName() .. " (" .. MAP.FriendlyName .. ")\n" ); 
	
	if( MAP.RemoveItems and SERVER ) then
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "weapon_*" );
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "item_*" );
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "ammo_*" );
	end
end

function GM:Think()
	
	if( CLIENT ) then
		
		local red_flag = GetGlobalEntity( "flag_2" );
		local blue_flag = GetGlobalEntity( "flag_1" );
		
		if( ValidEntity( red_flag ) and ValidEntity( blue_flag ) ) then
			local r_carrier = red_flag:GetNetworkedEntity( "carrier" );
			local b_carrier = blue_flag:GetNetworkedEntity( "carrier" );
			
			if( red_flag:GetNetworkedBool( "stolen" ) == true and ValidEntity( r_carrier ) ) then
				r_carrier:TeamDynamicLight( TEAM_RED )			
			end

			if( blue_flag:GetNetworkedBool( "stolen" ) == true and ValidEntity( b_carrier ) ) then
				b_carrier:TeamDynamicLight( TEAM_BLUE )
			end			
		end
	end
	
	for k, v in pairs( player.GetAll() ) do
		v:Think();
	end
end

