include( 'shared.lua' )
include( 'tables.lua' )
include( 'cl_hud.lua' )
include( 'cl_statscreen.lua' )
include( 'cl_postprocess.lua' )

function GM:Initialize()

	self.BaseClass:Initialize()
	
	WindVector = Vector( math.random(-30,30), math.random(-30,30) ,0 ) //fake random wind velocity
	ViewMode = 1
	FreeCam = false
	
	language.Add( "npc_civilian_male", "Civilian" )
	language.Add( "npc_civilian_female", "Prostitute" )
	language.Add( "sent_fireball", "Debris" )
	language.Add( "sent_debris", "Debris" )
	
	surface.CreateFont( "28 Days Later", 36, 400, true, false, "GtaNotice" )
	
end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end

function GM:FadeRagdolls()

	for k,v in pairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
	
		if v.Time and v.Time < CurTime() then
		
			v:SetColor( 255, 255, 255, v.Alpha )
			v.Alpha = math.Approach( v.Alpha, 0, -2 )
			
			if v.Alpha <= 0 then
				v:Remove()
			end
		
		elseif not v.Time then
		
			v.Time = CurTime() + 10
			v.Alpha = 255
		
		end
		
	end
	
end

function GM:Think()

	GAMEMODE:FadeRagdolls()

end

function GM:GetViewData( car, origin, angles )

	local data = {}
	
	local center = car:LocalToWorld( car:OBBCenter() )
	
	if not FreeCam then
	
		data.angles = car:GetAngles()

		if ViewMode == 1 then
			data.origin = center + car:GetForward() * ( car:BoundingRadius() * -1.5 ) + car:GetUp() * ( car:BoundingRadius() * 1.5 )
			data.angles.p = data.angles.p + 20
		elseif ViewMode == 2 then
			data.origin = center + car:GetForward() * ( car:BoundingRadius() * -3 ) + car:GetUp() * ( car:BoundingRadius() * 2 )
			data.angles.p = data.angles.p + 20
		elseif ViewMode == 3 then
			data.origin = center + car:GetUp() * ( car:BoundingRadius() / 2 )
		end
		
	else
		
		local forward = angles
		forward.p = 0
		
		if ViewMode == 1 then
			data.origin = center + forward:Forward() * ( car:BoundingRadius() * -3 ) + car:GetUp() * ( car:BoundingRadius() * 2 )
		elseif ViewMode == 2 then
			data.origin = center + forward:Forward() * ( car:BoundingRadius() * -4 ) + car:GetUp() * ( car:BoundingRadius() * 2 )
		elseif ViewMode == 3 then
			data.origin = center + forward:Forward() * ( car:BoundingRadius() * -5 ) + car:GetUp() * ( car:BoundingRadius() * 2 )
		end
		
		data.angles = ( center - data.origin ):Normalize():Angle()
	
	end

	return data
	
end

function GM:CalcView( ply, origin, angle, fov )
	
	local car = ply:GetNWEntity( "Car", nil )

	if ValidEntity( car ) then
	
		local data = GAMEMODE:GetViewData( car, origin, angle )
	
		local trace = {}
		trace.start = car:LocalToWorld( car:OBBCenter() )
		trace.endpos = data.origin
		trace.filter = car
		
		local tr = util.TraceLine( trace )
		
		if tr.Hit then
			data.origin = tr.HitPos + tr.HitNormal * 5
		end
	
		return data
		
	end
	
	// motion sickness
	if ViewWobble > 0 then
		angle.roll = angle.roll + math.sin( CurTime() * 2.5 ) * ( ViewWobble * 15 )
		ViewWobble = ViewWobble - 0.1 * FrameTime()
	end

	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

function EditViewMode( ply, cmd, args )

	ViewMode = ViewMode + 1
	
	if ViewMode == 4 then
		ViewMode = 1
	end

end
concommand.Add( "gta_viewmode", EditViewMode )

function EditCamMode( ply, cmd, args )

	FreeCam = !FreeCam

end
concommand.Add( "gta_togglecam", EditCamMode )

function GM:PlayerBindPress( pl, bind, down )

	if ValidEntity( pl:GetNWEntity( "Car", nil ) ) then
	
		if ( bind == "+attack2" ) then	
			RunConsoleCommand( "gta_viewmode" )
		elseif ( bind == "+reload" ) then
			RunConsoleCommand( "gta_togglecam" )
		end
	
	end

	// Redirect binds to the spectate system
	if ( pl:IsObserver() && down ) && ( pl:Team() == TEAM_SPECTATOR or not pl:Alive() ) then
	
		if ( bind == "+jump" ) then 	RunConsoleCommand( "spec_mode" )	end
		if ( bind == "+attack" ) then	RunConsoleCommand( "spec_next" )	end
		if ( bind == "+attack2" ) then	RunConsoleCommand( "spec_prev" )	end
		
	end
	
	return false	
	
end

function GM:HUDWeaponPickedUp()

end

function GM:HUDDrawPickupHistory()

end