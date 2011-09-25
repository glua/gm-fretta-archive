
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.DrawTeamRing			= false
CLASS.PlayerModel			= "models/props_c17/doll01.mdl"
CLASS.DrawViewModel			= false
CLASS.FullRotation			= true

function CLASS:Loadout( pl )

	pl:Give( "weapon_planegun" )
	
end

function CLASS:OnSpawn( pl )
	
	pl.m_entTrail = util.SpriteTrail( pl, 0, Color( 180, 180, 190, 255 ), true, 0, 16, 10, 0.01, "trails/smoke.vmt" )
	pl.m_entTrail:SetParent( pl )
	
	pl:SetHull( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	pl:SetViewOffset( Vector( 0, 0, 0 ) )
	pl:SetMoveType( MOVETYPE_NOCLIP )
	pl:SetNWFloat( "Speed", 100 )
	
	pl:SetPos( pl:GetPos() + Vector( 0, 0, 100 ) )
	
	self:AddPlanePart( pl, Vector( 0, 0, -7 ), Angle( 0, 92, 0 ), "models/props_junk/plasticcrate01a.mdl" )
	self:AddPlanePart( pl, Vector( 0, 19, -9 ), Angle( -1.682, 120.148, 10.0717 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( 0, -19, -9 ), Angle( -1.682, 70.648, 10.0717 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( 21, 0, -9 ), Angle( -90, 270 + 180, -90 ), "models/props_junk/trafficcone001a.mdl" )
	self:AddPlanePart( pl, Vector( -18, -1, -7 ), Angle( -90, 90 + 180, -90 ), "models/props_lab/powerbox02d.mdl" )

end

function CLASS:AddPlanePart( pl, pos, ang, mdl )
	
	pos = pos + Vector( 0, 0, -3 )
	
	local ent = ents.Create( "prop_dynamic" )

		ent:SetModel( mdl )
		ent:Spawn()
		
		ent:SetParent( pl )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		
	pl.parts = pl.parts or {}
	table.insert( pl.parts, ent )
	
end

function CLASS:ExplodePlaneParts( pl )

	if ( !pl.parts ) then return end
	
	for k, v in pairs( pl.parts ) do
		if ( IsValid( v ) ) then
		
			v:SetParent( NULL )
			
			local ent = ents.Create( "prop_physics" )

				ent:SetModel( v:GetModel() )
				ent:SetPos( v:GetPos() )
				ent:SetAngles( v:GetAngles() )
			ent:Spawn()
			ent:Ignite( 60 )
			
			timer.Simple( math.random( 5, 10 ), function() 
													if ( IsValid( ent ) ) then 
														//local effectdata = EffectData()
														//	effectdata:SetOrigin( ent:GetPos() )
														//util.Effect( "Explosion", effectdata, true, true )
														ent:Remove() 
													end 
												end )
		
			v:Remove()
		end
	end
	
	pl.parts = {}

end

function CLASS:OnDeath( pl )

	if ( IsValid( pl.m_entTrail ) ) then
		pl.m_entTrail:SetAttachment( nil )
		local trail = pl.m_entTrail
		timer.Simple( 30, function() if ( IsValid( trail ) ) then trail:Remove() end end )
	end
	
	self:ExplodePlaneParts( pl )

end

function DoExplosion( pl )

	if ( !IsValid( pl ) ) then return end
	
	util.BlastDamage( pl, pl, pl:GetPos(), 300, 200 )
		
	local effectdata = EffectData()
		effectdata:SetOrigin( pl:GetPos() )
 	util.Effect( "Explosion", effectdata, true, true )

end


function CLASS:Move( pl, mv )

	if ( !pl:Alive() ) then return end
	if ( pl:Team() == TEAM_SPECTATOR ) then return end
	//if ( !pl:GetNWFloat( "Speed", false ) ) then return end
	
	local vel = pl:GetNWFloat( "Speed", 100 )
	local accel = 30.0
	
	local Dot = pl:GetAimVector():Dot( Vector( 0, 0, -1 ) )
	
	// Boost, todo, make temporary
	if ( pl:KeyDown( IN_JUMP ) ) then
		Dot = Dot + 5.0
	end
	
	vel = math.Clamp( vel + Dot * FrameTime() * accel, 0, 1000 )
	
	if ( vel > 200 && !pl:KeyDown( IN_JUMP ) ) then
		vel = vel - ( FrameTime() * 120 )
	end
	
	pl:SetNWFloat( "Speed", vel )

	local Velocity = pl:GetAimVector() * vel * 5
	
	local Target = pl:GetPos() + Velocity * FrameTime()

	
	//debugoverlay.Line( pl:GetPos(), Target, 10 )
	
	local trace = { start = pl:GetPos(), endpos = Target, filter = pl }	  
	local tr = util.TraceLine( trace )
	
	if ( tr.Hit ) then
		
		pl:SetPos( tr.HitPos + tr.HitNormal * 50 )
		mv:SetVelocity( Vector(0,0,0) )
		
		if ( SERVER ) then
			timer.Simple( 0, function() DoExplosion( pl ) end )
			pl:Kill()
		end
	
	else
	
		mv:SetVelocity( Velocity )
		mv:SetOrigin( Target )
	
	end	
	
	return true

end

function CLASS:CalcView( ply, origin, angles, fov )
	
	if ( !ply:Alive() ) then return end
	
	local DistanceAngle = angles:Forward() * - 0.8 + angles:Up() * 0.2
	
	local ret = {}
	ret.origin = origin + DistanceAngle * 75
	
	if ( ply:KeyDown( IN_JUMP ) ) then
		local factor = 1
		ret.angles = angles + Angle( math.random( factor * -1, factor ), math.random( factor * -1, factor ), math.random( factor * -1, factor ) ) 
	end
	//ret.angles 		= angles
	//ret.fov 		= fov
	return ret

end

function CLASS:ShouldDrawLocalPlayer( pl )
	return true
end

function CLASS:InputMouseApply( ply, cmd, x, y, angle )
	
	angle.roll = math.Approach( angle.roll, 0, angle.roll / 400 )
	angle.yaw = angle.yaw + angle.roll * -0.0025
	
	local Ang = MatrixFromAngle( angle )
	
	local speed = ply:GetNWFloat( "Speed", 0 )

	local pitchchange = y * 0.02
	local yawchange = x * -0.005
	local rollchange = x * 0.022
	
	local stalling = 50 - speed
	if ( speed < 50 ) then 
		local rate = 1 - (speed / 50)
		pitchchange = pitchchange + (rate ^ 10.0) * 20
	end
	
	Ang:Rotate( Angle( pitchchange, yawchange, rollchange ) )
	
	local Ang = Ang:GetAngle()
	Ang.roll = math.Clamp( Ang.roll, -90, 90 )
	
	cmd:SetViewAngles( Ang )
	return true

end

player_class.Register( "Default", CLASS )