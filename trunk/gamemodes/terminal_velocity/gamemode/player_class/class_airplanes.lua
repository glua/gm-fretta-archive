
local CLASS = {}

CLASS.DisplayName			= "Base Plane Class"
CLASS.DrawTeamRing			= false
CLASS.PlayerModel			= "models/props_junk/wood_crate001a.mdl"
CLASS.DrawViewModel			= false
CLASS.FullRotation			= true

function CLASS:AddPlanePart( pl, pos, ang, mdl )

	local col = table.Copy( team.GetColor( pl:Team() ) )
	
	local attach = pl:GetPos()
	attach = attach + pl:GetForward() * pos.x
	attach = attach + pl:GetRight() * pos.y
	attach = attach + pl:GetUp() * pos.z

	local ent = ents.Create( "sent_planepiece" )
	ent:SetModel( mdl )
	ent:SetPos( attach )
	ent:SetAngles( pl:GetAngles() + ang )
	ent:SetColor( col.r, col.g, col.b, 255 )
	ent:Spawn()
	ent:SetParent( pl )
	ent:SetOwner( pl )
	
	pl.parts = pl.parts or {}
	table.insert( pl.parts, ent )
	
end

function CLASS:ExplodeParts( pl, debris )

	if not pl.parts then return end
	
	local col = table.Copy( team.GetColor( pl:Team() ) )
	
	for k, v in pairs( pl.parts ) do
	
		if ValidEntity( v ) then
			
			local ent = ents.Create( "sent_debris" )
			ent:SetModel( v:GetModel() )
			ent:SetPos( v:GetPos() )
			ent:SetAngles( v:GetAngles() )
			ent:SetOwner( pl )
			ent:SetPhysicsAttacker( pl )
			ent:SetColor( col.r, col.g, col.b, 255 )
			ent:Spawn()
			
			v:Remove()
			
		end
		
	end
	
	pl.parts = {}

end

function CLASS:OnDeath( pl )

	CLASS:ExplodeParts( pl, true )

	if ValidEntity( pl.PlaneTrail ) then
	
		pl.PlaneTrail:SetAttachment( nil )
		
		local trail = pl.PlaneTrail
		timer.Simple( 10, function() if ValidEntity( trail ) then trail:Remove() end end )
		
	end

end

/*function CLASS:CalcView( ply, origin, angles, fov )

	if not ply:Alive() then return end

	local view = {}
	
	view.angles = angles
	view.origin = origin + ply:GetForward() * self.ViewOffset
	
	return view

end*/

function CLASS:Move( pl, mv )

	if not pl:Alive() then return end
	if pl:Team() == TEAM_SPECTATOR then return end
	
	local vel = pl:GetNWFloat( "Speed", 100 )
	local dot = pl:GetAimVector():Dot( Vector( 0, 0, -1 ) ) //scalar - player aim and upwards
	
	if dot > -0.75 and dot < 0 then
		dot = -0.01
	elseif dot < -0.75 then
		dot = dot / 2
	end
	
	vel = math.Clamp( vel + dot * FrameTime() * self.FlySpeed, 0, 5000 )
	
	if vel > 200 then
		vel = vel - ( FrameTime() * 100 )
	end
	
	pl:SetNWFloat( "Speed", vel )

	local velocity = pl:GetAimVector() * vel * 5
	local target = pl:GetPos() + velocity * FrameTime()
	
	local trace = { start = pl:GetPos(), endpos = target, filter = pl }	  
	local tr = util.TraceLine( trace )
	
	if tr.Hit then
	
		pl:SetPos( tr.HitPos + tr.HitNormal * 50 )
		mv:SetVelocity( Vector(0,0,0) )
		
		if SERVER then
		
			pl:Explode()
			
			if tr.HitWorld then
			
				local ed = EffectData()
				ed:SetOrigin( tr.HitPos )
				ed:SetMagnitude( 0.75 )
				util.Effect( "smoke_crater", ed, true, true )
				
				util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
			
			end
		
		end
	
	else
	
		mv:SetVelocity( velocity )
		mv:SetOrigin( target )
	
	end	
	
	return true

end

function CLASS:ShouldDrawLocalPlayer( pl )
	return false
end

function CLASS:InputMouseApply( ply, cmd, x, y, angle )

	if not ply:Alive() then return true end
	
	if angle.roll < 90 and angle.roll > -90 then
		angle.roll = math.Approach( angle.roll, 0, angle.roll / 900 )
	elseif angle.roll < -90 then
		angle.roll = math.Approach( angle.roll, -180, angle.roll / 900 )
	else
		angle.roll = math.Approach( angle.roll, 180, angle.roll / 900 )
	end
	
	local ang = MatrixFromAngle( angle )
	local speed = ply:GetNWFloat( "Speed", 0 )

	local pitchchange = y * self.PitchSpeed
	local rollchange = x * self.RollSpeed
	local stalling = 50 - speed
	
	if ( speed < 50 ) then 
	
		local rate = 1 - ( speed / 50 )
		pitchchange = pitchchange + ( rate ^ 10 ) * 20
	
	end
	
	ang:Rotate( Angle( pitchchange, 0, rollchange ) )
	ang = ang:GetAngle()
	
	cmd:SetViewAngles( ang )
	
	return true

end

function CLASS:InitializePlane( pl )

	local col = table.Copy( team.GetColor( pl:Team() ) )
	
	pl.PlaneTrail = util.SpriteTrail( pl, 0, col, true, 15, 30, 5, 0.01, "trails/smoke.vmt" )
	
	pl:SetColor( col.r, col.g, col.b, 255 )
	pl:SetHull( Vector( -self.HullSize, -self.HullSize, -self.HullSize ), Vector( self.HullSize, self.HullSize, self.HullSize ) )
	pl:SetViewOffset( Vector( 0, 0, 0 ) )
	pl:SetMoveType( MOVETYPE_NOCLIP )
	pl:SetNWFloat( "Speed", 100 )
	pl:SetPos( pl:GetPos() + Vector( 0, 0, 100 ) )
	
	self:ExplodeParts( pl, false )

end

player_class.Register( "Base Plane", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Wasp"
CLASS.Description           = "Small airplane armed with twim machine guns."
CLASS.PlayerModel			= "models/props_junk/cardboard_box001a.mdl"
CLASS.FlySpeed              = 90
CLASS.PitchSpeed            = 0.03
CLASS.RollSpeed             = 0.03 // fast, double gun
CLASS.HullSize              = 20
CLASS.StartHealth			= 50
CLASS.MaxHealth				= 50

function CLASS:Loadout( pl )

	pl:Give( "weapon_twinmachinegun" )
	
end

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( 0, 30, 10 ), Angle( 0, 0, 0 ), "models/props_c17/computer01_keyboard.mdl" )
	self:AddPlanePart( pl, Vector( 0, -30, 10 ), Angle( 0, 0, 0 ), "models/props_c17/computer01_keyboard.mdl" )
	self:AddPlanePart( pl, Vector( -10, -5, -15 ), Angle( 0, 90, 0 ), "models/props/cs_office/radio.mdl" )
	self:AddPlanePart( pl, Vector( -10, 5, -15 ), Angle( 0, 90, 0 ), "models/props/cs_office/radio.mdl" )

end

player_class.Register( "Wasp", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Hornet"
CLASS.PlayerModel			= "models/props_junk/cardboard_box001a.mdl"
CLASS.FlySpeed              = 90
CLASS.PitchSpeed            = 0.03
CLASS.RollSpeed             = 0.03 // fast, single gun
CLASS.HullSize              = 20
CLASS.StartHealth			= 50
CLASS.MaxHealth				= 50

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( 0, 30, 5 ), Angle( 0, 90, 0 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( 0, -30, 5 ), Angle( 0, -90, 0 ), "models/props_c17/playground_swingset_seat01a.mdl" )
	self:AddPlanePart( pl, Vector( -20, 10, -5 ), Angle( 0, 0, 0 ), "models/props_lab/powerbox02d.mdl" )
	self:AddPlanePart( pl, Vector( -20, -10, -5 ), Angle( 0, 0, 0 ), "models/props_lab/powerbox02d.mdl" )

end

player_class.Register( "Hornet", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Hawk"
CLASS.Description           = "Normal sized airplane armed with twim machine guns."
CLASS.FlySpeed              = 50
CLASS.PitchSpeed            = 0.025
CLASS.RollSpeed             = 0.025 // dumbfire rocket dude
CLASS.HullSize              = 30
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( -20, 0, 0 ), Angle( 90, 0, 0 ), "models/props_lab/reciever01b.mdl" )
	self:AddPlanePart( pl, Vector( 0, 0, 10 ), Angle( 0, 0, 180 ), "models/props_wasteland/cafeteria_bench001a.mdl" )

end

player_class.Register( "Hawk", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Falcon"
CLASS.Description           = "Normal sized airplane armed with heatseeker rockets."
CLASS.FlySpeed              = 50
CLASS.PitchSpeed            = 0.025
CLASS.RollSpeed             = 0.025 // heatseek rocket dude
CLASS.HullSize              = 30
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100

function CLASS:Loadout( pl )

	pl:Give( "weapon_heatseeker" )
	
end

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( 0, 55, 10 ), Angle( 0, 90, 0 ), "models/props_c17/computer01_keyboard.mdl" )
	self:AddPlanePart( pl, Vector( 0, -55, 10 ), Angle( 0, -90, 0 ), "models/props_c17/computer01_keyboard.mdl" )
	self:AddPlanePart( pl, Vector( 0, 0, 10 ), Angle( 0, 0, 0 ), "models/props_c17/playground_teetertoter_seat.mdl" ) 
	self:AddPlanePart( pl, Vector( 0, 0, -22 ), Angle( 0, 90, 0 ), "models/props/cs_office/projector.mdl" )

end

player_class.Register( "Falcon", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Vulture"
CLASS.PlayerModel			= "models/props_junk/wood_crate002a.mdl"
CLASS.FlySpeed              = 30
CLASS.PitchSpeed            = 0.020
CLASS.RollSpeed             = 0.015 // heavy rocket dude
CLASS.HullSize              = 40
CLASS.StartHealth			= 200
CLASS.MaxHealth				= 200

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( 0, 0, 8 ), Angle( 0, 0, 0 ), "models/props_wasteland/cafeteria_table001a.mdl" )
	self:AddPlanePart( pl, Vector( -25, 0, 0 ), Angle( 0, 0, 0 ), "models/props_lab/partsbin01.mdl" )
	self:AddPlanePart( pl, Vector( 10, 0, 10 ), Angle( 90, 0, 0 ), "models/props/cs_militia/barstool01.mdl" ) 

end

player_class.Register( "Vulture", CLASS )

local CLASS = {}

CLASS.Base                  = "Base Plane"
CLASS.DisplayName			= "Osprey"
CLASS.PlayerModel			= "models/props_junk/wood_crate002a.mdl"
CLASS.FlySpeed              = 30
CLASS.PitchSpeed            = 0.020
CLASS.RollSpeed             = 0.015 // heavy bomb dude
CLASS.HullSize              = 40
CLASS.StartHealth			= 200
CLASS.MaxHealth				= 200

function CLASS:Loadout( pl )

	pl:Give( "weapon_dropbomb" )
	
end

function CLASS:OnSpawn( pl )
	
	self:InitializePlane( pl )
	
	self:AddPlanePart( pl, Vector( 0, 0, 5 ), Angle( 0, 0, 0 ), "models/props_wasteland/dockplank01b.mdl" )
	self:AddPlanePart( pl, Vector( -25, 0, -5 ), Angle( 0, -90, 0 ), "models/props/cs_office/microwave.mdl" )
	self:AddPlanePart( pl, Vector( 15, 0, 0 ), Angle( 90, 0, 0 ), "models/props_wasteland/barricade001a.mdl" ) 

end

player_class.Register( "Osprey", CLASS )
