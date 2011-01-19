
include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_selectscreen.lua' ) //ya

function GM:Initialize()

	self.BaseClass:Initialize()
	
	WindVector = Vector( math.random(-5,5), math.random(-5,5) ,0 )

end

function GM:AddDeathNotice( victim, inflictor, attacker )

end

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:PlayerBindPress( ply, bind, pressed )

	if not pressed or ply:IsFrozen() then return end
	
	if string.find( bind, "impulse 100" ) then

		if LocalPlayer():Team() == TEAM_STALKER then
		
			RunConsoleCommand( "ts_toggle_esp" )
			
			if not LocalPlayer():GetNWBool( "StalkerEsp", false ) then
			
				LocalPlayer():EmitSound( Sound( "ambient/atmosphere/hole_hit5.wav" ), 100, 200 )
				
			else
			
				LocalPlayer():EmitSound( Sound( "ambient/atmosphere/cave_hit1.wav" ), 100, 150 )
				
			end
			
		end
	
		if LocalPlayer():FlashlightIsOn() and LocalPlayer():Team() == TEAM_HUMAN then 
		
			LocalPlayer():EmitSound( Sound( "items/nvg_on.wav" ), 100, 130 )
			
		end
		
	end
end

function GM:Think()

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 25 and ( HeartBeat or 0 ) < CurTime() then
	
		local scale = LocalPlayer():Health() / 25
		HeartBeat = CurTime() + 0.5 + scale * 1.5
		
		LocalPlayer():EmitSound( Sound( "koth/heartbeat.wav" ), 100, 150 - scale * 50 )
		
	end

	if LocalPlayer():Team() == TEAM_STALKER then
	
		if LocalPlayer():GetNWBool( "StalkerEsp", false ) then
		
			if not HumanEmitter then
				HumanEmitter = ParticleEmitter( LocalPlayer():GetPos() )
			end
			
			local pos = LocalPlayer():GetPos()
			
			for k, ply in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
	
				local trgpos = ply:GetPos() + Vector(0,0,50)
		
				if ply:KeyDown( IN_DUCK ) then
					trgpos = ply:GetPos() + Vector(0,0,20)
				end
		
				if ply:Alive() and trgpos:Distance( pos ) < 4000 then
			
					local scale = math.Clamp( ply:Health() / 100, 0, 1 )
					for i=1, math.random( 1, 3 ) do
						local par = HumanEmitter:Add( "sprites/light_glow02_add_noz.vmt", trgpos )
						par:SetVelocity( VectorRand() * 30 )
						par:SetDieTime( 0.5 )
						par:SetStartAlpha( 255 )
						par:SetEndAlpha( 0 )
						par:SetStartSize( math.random( 2, 10 ) )
						par:SetEndSize( 0 )
						par:SetColor( 255 - scale * 255, 55 + scale * 200, 50 ) 
						par:SetRoll( math.random( 0, 300 ) )
					end
				end
			end
		end
	end
end

function IsOnRadar( ply )

	for k,v in pairs( PosTable ) do
	
		if v.Player == ply then
		
			return v
		
		end
	
	end
	
	return nil

end

FuzzAlpha = 0
ArmAngle = 0
BlipTime = 1.5
FadeDist = 0.3
MaxDist = 1500
PosTable = {}

local matLaser = Material( "sprites/light_glow02_add" )
local matRadar = Material( "stalker/radar" )
local matArm = Material( "stalker/radar_arm" )
local matFuzz = Material( "stalker/radar_fuzz" )
local matBattery = Material( "stalker/battery" )
local matHeart = Material( "stalker/heart" )
local matBrain = Material( "stalker/brain" )

function GM:OnHUDPaint()

	if LocalPlayer():Alive() and LocalPlayer():Team() == TEAM_HUMAN then
	
		if not LocalPlayer():FlashlightIsOn() then
	
			local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )
			local dist = tr.HitPos:Distance( LocalPlayer():GetShootPos() )
			local size = math.Clamp( dist / 500, 0, 1 ) * math.Rand( 8, 10 ) 
			
			if ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() then
			
				size = math.Clamp( dist / 500, 0, 1 ) * math.Rand( 10, 13 ) 
				
			end
			
			cam.Start3D( EyePos(), EyeAngles() )
			
			render.SetMaterial( matLaser )
			render.DrawQuadEasy( tr.HitPos, ( EyePos() - tr.HitPos ):GetNormal(), size, size, Color(255,0,0,255), 0 )
			
			cam.End3D()
			
		end
	
		local radius = 200 
		local centerx = ScrW() - ( radius / 2 ) - 20
		local centery = 20 + ( radius / 2 )
		ArmAngle = ArmAngle + FrameTime() * 70
		
		if ArmAngle > 360 then
			ArmAngle = 0 + ( ArmAngle - 360 )
		end
	
		surface.SetDrawColor( 200, 200, 200, 100 ) 
		surface.SetMaterial( matRadar ) 
		surface.DrawTexturedRect( ScrW() - radius - 20, 20, radius, radius ) 
		
		surface.SetDrawColor( 220, 220, 220, 80 ) 
		surface.SetMaterial( matBattery ) 
		surface.DrawTexturedRect( ScrW() - radius - 20, radius + 20, radius, radius / 6 ) 
		
		local scale = LocalPlayer():GetNWInt( "Battery", 0 ) / 100
		
		draw.RoundedBox( 4, ScrW() - ( radius * 0.7 ) - 20, radius + 32, math.Clamp( radius * ( 0.4 * scale ), 8, radius * 0.4 ), 11, Color( 120, 120, 120, 80 )  )
		
		local pltbl = team.GetPlayers( TEAM_HUMAN )
		local aimvec = LocalPlayer():GetAimVector()
		
		if LocalPlayer():GetNWBool( "IsTracking", false ) then
			table.Add( pltbl, team.GetPlayers( TEAM_STALKER ) )
		end
		
		for k,v in pairs( pltbl ) do
		
			local dir = ( LocalPlayer():GetAngles() + Angle( 0, ArmAngle + 90, 0 ) ):Forward():Normalize()
			local dot = dir:Dot( ( LocalPlayer():GetPos() - v:GetPos() ):Normalize() )

			if DisorientTime < CurTime() and v != LocalPlayer() and !IsOnRadar( v ) and dot > 0.98 then
			
				local pos = v:GetPos()
				local color = Color( 80, 255, 255 )
				
				if not v:Alive() then
				
					color = Color( 255, 255, 80 )
				
					if ValidEntity( v:GetRagdollEntity() ) then
					
						pos = v:GetRagdollEntity():GetPos()
		
					end
					
				elseif v:Team() == TEAM_STALKER then
				
					color = Color( 255, 80, 80 )
				
				end
				
				local dietime = CurTime() + BlipTime
				local diff = ( pos - LocalPlayer():GetPos() )
			
				if math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist * FadeDist then
				
					dietime = -1
				
				end
			
				table.insert( PosTable, { Player = v, Pos = pos, DieTime = dietime, Color = color } )
			
			end
		
		end
	
		for k,v in pairs( PosTable ) do
			
			local diff = ( v.Pos - LocalPlayer():GetPos() )
			local alpha = 50 
			
			if v.DieTime != -1 then
			
				alpha = 50 * ( math.Clamp( v.DieTime - CurTime(), 0, BlipTime ) / BlipTime )
				
			elseif ( !ValidEntity( v.Player ) or !v.Player:Alive() ) and v.Color.r < 255 then
			
				PosTable[k].DieTime = CurTime() + 1.0
			
			end
			
			if math.sqrt( diff.x * diff.x + diff.y * diff.y ) > MaxDist * FadeDist and v.DieTime == -1 then
				
				PosTable[k].DieTime = CurTime() + 1.0
				
			end
				
			if alpha > 0 and math.sqrt( diff.x * diff.x + diff.y * diff.y ) < MaxDist then
			
				local addx = diff.x / MaxDist
				local addy = diff.y / MaxDist
				local addz = math.sqrt( addx * addx + addy * addy )
				local phi = math.atan2( addx, addy ) - math.atan2( aimvec.x, aimvec.y ) - ( math.pi / 2 )
				
				addx = math.cos( phi ) * addz
				addy = math.sin( phi ) * addz
				
				draw.RoundedBox( 4, centerx + addx * ( ( radius - 15 ) / 2 ) - 4, centery + addy * ( ( radius - 15 ) / 2 ) - 4, 5, 5, Color( v.Color.r, v.Color.g, v.Color.b, alpha ) )
			
			end
	
		end
		
		for k,v in pairs( PosTable ) do
		
			if v.DieTime != -1 and v.DieTime < CurTime() then
			
				table.remove( PosTable, k )
			
			end
		
		end
		
		surface.SetDrawColor( 255, 255, 255, 200 ) 
		surface.SetMaterial( matArm )
		surface.DrawTexturedRectRotated( centerx, centery, radius, radius, ArmAngle ) 
		
		if DisorientTime > CurTime() or FuzzAlpha > 0 then
			
			if DisorientTime > CurTime() then
				FuzzAlpha = math.Approach( FuzzAlpha, 20, FrameTime() * 10 ) 
			else
				FuzzAlpha = math.Approach( FuzzAlpha, 0, FrameTime() * 10 )
			end
		
			surface.SetDrawColor( 150, 150, 150, FuzzAlpha ) 
			surface.SetMaterial( matFuzz ) 
			surface.DrawTexturedRectRotated( centerx, centery, radius, radius, math.Rand( 0, 360 ) ) 
		
		end
	
	elseif LocalPlayer():Alive() and LocalPlayer():Team() == TEAM_STALKER then
	
		local size = 55
		local textsize = 75
		local col = Color( 255, 255, 255, 200 )
		
		if LocalPlayer():Health() <= 50 then
			col = Color( 255, 100 + math.sin( RealTime() * 3 ) * 100, 100 + math.sin( RealTime() * 3 ) * 100, 200 )	
		end
	
		surface.SetDrawColor( 200, 200, 200, 255 ) 
		surface.SetMaterial( matHeart ) 
		surface.DrawTexturedRect( ScrW() - textsize - size - 20, ScrH() - size - 20, size, size ) 
		surface.SetMaterial( matBrain )
		surface.DrawTexturedRect( ScrW() - ( textsize * 2 ) - ( size * 2 ) - 20, ScrH() - size - 20, size, size )
		
		draw.SimpleTextOutlined( math.Clamp( LocalPlayer():Health(), 0, 1000 ), "StalkerText", ScrW() - textsize - 10, ScrH() - 70, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 2, Color(10,10,10,255) )	
		draw.SimpleTextOutlined( LocalPlayer():GetNWInt( "Mana", 0 ), "StalkerText", ScrW() - ( textsize * 2 ) - size - 10, ScrH() - 70, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 2, Color(10,10,10,255) )
	
	end
	
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

function GM:HUDDrawTargetID()
	return false
end
