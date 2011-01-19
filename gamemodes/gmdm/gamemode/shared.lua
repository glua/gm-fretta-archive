DeriveGamemode( "fretta" );

-- Configurable cvars
gmdm_unlimitedammo = CreateConVar( "gmdm_unlimitedammo", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )
gmdm_teamplay = CreateConVar( "gmdm_teamplay", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )
gmdm_instagib = CreateConVar( "gmdm_instagib", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )

-- Clientside files we need
if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	AddCSLuaFile( "cl_init.lua" );
	AddCSLuaFile( "pl_extensions.lua" );
	AddCSLuaFile( "gmdm_util.lua" );
	AddCSLuaFile( "cl_postprocessing.lua" );
	AddCSLuaFile( "pickup_manager.lua" );
end

include( "pl_extensions.lua" );
include( "gmdm_util.lua" );
include( "pickup_manager.lua" );

-- Gamerule vars.
GM.Name 	= "Garry's Mod Deathmatch"
GM.Author 	= "SteveUK"
GM.Email 	= "stephen.swires@gmail.com"
GM.Website 	= "http://s-swires.org"
GM.Help		= "All you do is kill each other. Sounds simple enough.\n\nBy SteveUK\n\nPast contributors: HTF, Catdaemon, Rambo_Sechs, Levybreak. Based on the original GMDM by Garry."

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15

GM.MaximumDeathLength = 5			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 1.5			// Player has to be dead for at least this long

GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.RealisticFallDamage = false
GM.NoPlayerSuicide = false
GM.SelectColor = true

-- Classes
IncludePlayerClasses()

-- Gibs

// Global holding all our human gibs!
HumanGibs = {}

	table.insert( HumanGibs, "models/gibs/antlion_gib_medium_2.mdl" )
	table.insert( HumanGibs, "models/gibs/Antlion_gib_Large_1.mdl" )
	//table.insert( HumanGibs, "models/gibs/gunship_gibs_eye.mdl" )
	table.insert( HumanGibs, "models/gibs/Strider_Gib4.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_rib.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_scapula.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_spine.mdl" )


	for k, v in pairs( HumanGibs ) do
		util.PrecacheModel( v )
	end

function GM:Initialize()
	
	if( CLIENT ) then
		GAMEMODE:LoadMapInfo();
	end
	
	self.BaseClass:Initialize()
	
end

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()
	
	local useTeams = GetConVar( "gmdm_teamplay" )
	
	if( useTeams and useTeams:GetBool() ) then
		team.SetUp( TEAM_BLUE, "Blue Team", Color( 80, 150, 255 ) )
		team.SetClass( TEAM_BLUE, { "Default_gmdm" } )
		
		team.SetUp( TEAM_RED, "Red Team", Color( 255, 80, 80 ) )
		team.SetClass( TEAM_RED, { "Default_gmdm" } )
	else
		team.SetUp( TEAM_UNASSIGNED, "Players", Color( 70, 230, 70 ) )
		team.SetClass( TEAM_UNASSIGNED, { "Default_gmdm" } )
		
		self.NoPlayerTeamDamage = false
		self.TeamBased = false
	end
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "point_viewcontrol" } )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end

function GM:Think()
	for k, v in pairs( player.GetAll() ) do 
		v:Think();
	end
end

MAP = {}

function GM:InitPostEntity( )

	if( SERVER ) then
		GAMEMODE:LoadMapInfo();
		
		if( MAP and MAP.CustomTeamSetup ) then
			GAMEMODE:CreateTeams(); -- again
		end
	end
	
	self.BaseClass:InitPostEntity();
	MAP:SpawnEntities();
	
end

function GM:LoadMapInfo()
	local Folder = string.Replace( GAMEMODE.Folder, "gamemodes/", "" );
	
	if( SERVER ) then
		AddCSLuaFile( Folder .. "/gamemode/maps/default_map.lua" );
		AddCSLuaFile( Folder .. "/gamemode/maps/" .. game.GetMap() );	
	end
	
	include( Folder .. "/gamemode/maps/default_map.lua" );
	
	if( file.Exists( "../" .. GAMEMODE.Folder .. "/gamemode/maps/" .. game.GetMap() .. ".lua" ) ) then
		include( Folder .. "/gamemode/maps/" .. game.GetMap() .. ".lua" );
	end
	
	Msg( "Loaded map info for " .. game.GetMap() .. " (" .. MAP.FriendlyName .. ")\n" ); 
	
	if( MAP.RemoveItems and SERVER ) then
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "weapon_*" );
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "item_*" );
		timer.Simple( 1.5, MAP.RemoveEntByClass, MAP, "ammo_*" );
		
		if( MAP.RemoveSpawns ) then
			MAP:RemoveEntByClass( "info_player_*" );
		end
	end
end

function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	
	if( trace.HitGroup == HITGROUP_HEAD ) then
		dmginfo:SetDamageForce( VectorRand() * 500 );
		ply:EmitSound( "Player.DeathHeadShot" );
		
		ply.Headshot = true;
	else
		ply.Headshot = false;
	end
		
	ply:TraceAttack( dmginfo, dir, trace )

	if( SERVER ) then
		dmginfo:ScaleDamage( GAMEMODE:GetHitboxMulti( trace.HitGroup ) ); -- hitbox based damage
		return false
	end
	
	return true
	
end

function GM:GetRagdollEyes( ply )

	local Ragdoll = nil
	
	Ragdoll = ply:GetRagdollEntity()
	if ( !Ragdoll ) then return end
	
	
	local att = Ragdoll:GetAttachment( Ragdoll:LookupAttachment("eyes") )
	if ( att ) then
	
		local RotateAngle = Angle( math.sin( CurTime() * 0.5 ) * 30, math.cos( CurTime() * 0.5 ) * 30, math.sin( CurTime() * 1 ) * 30 )	

		att.Pos = att.Pos + att.Ang:Forward() * 1
		att.Ang = att.Ang
		
		return att.Pos, att.Ang
	
	end
	

end

local LastStrafeRoll = 0
local WalkTimer = 0
local VelSmooth = 0

function GM:CalcView( ply, origin, angle, fov )

	if( ply:IsObserver() and ply:GetObserverTarget() and ply:GetObserverTarget():IsPlayer() ) then ply = ply:GetObserverTarget() end
	
	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	
	local RagdollPos, RagdollAng = self:GetRagdollEyes( ply )
	if ( RagdollPos && RagdollAng && !ply:IsAlive() ) then
		return self.BaseClass:CalcView( ply, RagdollPos, RagdollAng, 90 )
	end

	VelSmooth = math.Clamp( VelSmooth * 0.9 + vel:Length() * 0.1, 0, 700 )
	
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05
	
	// Roll on strafe (smoothed)
	LastStrafeRoll = (LastStrafeRoll * 3) + (ang:Right():DotProduct( vel ) * 0.0001 * VelSmooth * 0.3)
	LastStrafeRoll = LastStrafeRoll * 0.25
	angle.roll = angle.roll + LastStrafeRoll
	

	// Roll on steps
	if ( ply:GetGroundEntity() != NULL ) then	
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.000002 * VelSmooth
		angle.pitch = angle.pitch + math.cos( WalkTimer * 0.5 ) * VelSmooth * 0.000002 * VelSmooth
		angle.yaw = angle.yaw + math.cos( WalkTimer ) * VelSmooth * 0.000002 * VelSmooth
		
	end
	
	angle = angle + ply:HeadshotAngles() + ply:ShootShakeAngles()

	if( !LocalPlayer():Alive() ) then
		fov = 60
	end
	
	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

