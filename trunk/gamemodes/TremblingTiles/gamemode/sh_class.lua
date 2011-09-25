local CLASS = {}

CLASS.DisplayName			= "Players"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 600
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel			= false
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= false // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc

function CLASS:Loadout( pl )
end

function CLASS:OnSpawn( ply )
	
	local enttab = ents.GetAllAliveTiles();
	
	if( #enttab > 0 ) then
		
		local ent = table.Random( enttab );
		ply:SetPos( ent.Pos + Vector( 0, 0, 32 ) );
		
		if( !DEBUG ) then
			timer.Simple( GAMEMODE.RoundPreStartTime, function()
				
				ent:EmitSound( table.Random( ent.ActivateSounds ), 66, math.random( 70, 130 ) );
				ent:SetColor( 255, 0, 0, 255 );
				ent.Dropped = true;
				
			end );
			
			timer.Simple( GAMEMODE.RoundPreStartTime + 1, function()
				
				ent:EmitSound( table.Random( ent.FallSounds ), 33, math.random( 70, 130 ) );
				ent:Drop();
				
			end );
		end
		
	end
	
	ply:SetGravity( 1 );
	
	ply:SetMaterial( "" );
	ply:SetColor( 255, 255, 255, 255 );
	
	ply.Invincible = false;
	ply.SecondChance = false;
	
end

function CLASS:OnDeath( ply, attacker, dmginfo )
end

function CLASS:Think( pl )
	
	if( SHOTGUNMODE ) then
	
		if( !pl:HasWeapon( "weapon_tt_shotty" ) ) then
			
			pl:Give( "weapon_tt_shotty" );
			
		end
		
	end
	
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:ShouldDrawLocalPlayer( pl )
	return false
end

local WalkTimer = 0;
local VelSmooth = 0;

function CLASS:CalcView( ply, origin, angles, fov )
	
	if( ply:Alive() ) then
		
		VelSmooth = VelSmooth * 0.5 + ply:GetVelocity():Length() * 0.1;
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1;
		
		angles.r = angles.r + ply:EyeAngles():Right():DotProduct( ply:GetVelocity() ) * 0.005;
		
		if( ply:GetGroundEntity() ) then
			
			angles.r = angles.r + math.sin( WalkTimer ) * VelSmooth * 0.001;
			angles.p = angles.p + math.sin( WalkTimer * 0.3 ) * VelSmooth * 0.001;
			
		end
		
		local tSinceFlip = CurTime() - StartFlip;
		
		if( tSinceFlip > 0 and tSinceFlip <= 1 ) then
			
			angles.r = 180 * tSinceFlip;
			
		elseif( tSinceFlip > 1 and tSinceFlip <= 4 ) then
			
			angles.r = 180;
			
		elseif( tSinceFlip > 4 and tSinceFlip <= 5 ) then
			
			tSinceFlip = 1 - ( tSinceFlip - 4 );
			angles.r = 180 * tSinceFlip;
			
		end
		
	else
		
		local targ = LocalPlayer():GetObserverTarget();
		local mode = LocalPlayer():GetObserverMode();
		
		if ( IsValid( targ ) && targ:IsPlayer() && targ != LocalPlayer() && mode != OBS_MODE_ROAMING ) then
		else
			
			origin = Deathcam;
			
		end
		
	end
	
	return { origin = origin, angles = angles, fov = fov };
	
end

player_class.Register( "Default", CLASS );

local CLASS = {}
CLASS.DisplayName			= "Spectator Team"
CLASS.DrawTeamRing			= false
CLASS.PlayerModel			= "models/player.mdl"

player_class.Register( "Spectator", CLASS );