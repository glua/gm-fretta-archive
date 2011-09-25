
local CLASS = {}

CLASS.MaxFuel               = 60
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.DuckSpeed				= 0.3
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true
CLASS.Primaries             = { "jj_shotgun" }
CLASS.Secondaries           = { "jj_usp" }

function CLASS:CheckWeapons( pl )

	if not table.HasValue( self.Primaries, pl:GetPrimary() ) then
	
		pl:SetPrimary( table.Random( self.Primaries ) )
	
	end
	
	if not table.HasValue( self.Secondaries, pl:GetSecondary() ) then
	
		pl:SetSecondary( table.Random( self.Secondaries ) )
	
	end

end

function CLASS:Loadout( pl )

	self:CheckWeapons( pl )
	
	pl:Give( pl:GetPrimary() )
	pl:Give( pl:GetSecondary() )

end

function CLASS:OnSpawn( pl )

	pl:SetFuel( self.MaxFuel )
	pl:SetPowerup()
	pl:SpawnArmor()

	if pl:Team() == TEAM_RED then
	
		pl:SetModel( "models/player/leet.mdl" )
	
	else
	
		pl:SetModel( "models/player/barney.mdl" )
	
	end

	local ed = EffectData()
	ed:SetEntity( pl )
	util.Effect( "rocket_trail", ed, true, true )
	
	local ed = EffectData()
	ed:SetEntity( pl )
	ed:SetScale( pl:Team() )
	util.Effect( "player_spawn", ed, true, true )
	
	pl.ProperX = pl:GetPos().x

end

function CLASS:OnDeath( pl, attacker, dmginfo )

	if dmginfo:IsExplosionDamage() then
	
		pl:EmitSound( table.Random( GAMEMODE.PlayerGore ), 150, math.random(90,110) )
		
		for i=1,5 do
		
			timer.Simple( i * 0.4, function( pos ) WorldSound( table.Random( GAMEMODE.GoreSplat ), pos, 100, math.random(90,110) ) end, pl:GetPos() )
		
		end
		
		return
	
	end
	
	pl:EmitSound( table.Random( GAMEMODE.PlayerDie ), 150 )

end

function CLASS:Think( pl )

	pl:CheckFire()

	if not pl:Alive() then return end

	if ( pl.JetTime or 0 ) < CurTime() then

		if pl:KeyDown( IN_SPEED ) then 
		
			pl.JetTime = CurTime() + 0.05
			pl:AddFuel( -1 )
		
		elseif pl:GetFuel() == 0 then
		
			pl.JetTime = CurTime() + 1.5
			pl:AddFuel( 1 )
		
		else
		
			pl.JetTime = CurTime() + 0.10
			pl:AddFuel( 1 )
		
		end
		
	end
	
	if pl:GetPos().x != pl.ProperX then
	
		local oldpos = Vector( pl.ProperX, pl:GetPos().y, pl:GetPos().z )
		pl:SetPos( oldpos )
	
	end
	
	pl:CallPowerupFunction( "Think" )
	pl:CallPowerupFunction( "EndThink" )
	
end

function CLASS:OnKeyPress( pl, key )

	if key != IN_USE then return end
	
	for k,v in pairs( ents.FindByClass( "func_button" ) ) do
	
		if v:GetPos():Distance( pl:GetPos() ) < 200 then
		
			v:Fire( "Press", 0 )
			return
		
		end
	
	end

end

function CLASS:Move( pl, mv )

	if not pl:Alive() then return end
	
	if pl:KeyDown( IN_SPEED ) and pl:GetNWInt( "Fuel", 0 ) > 1 and not pl:OnGround() then 
	
		pl.JetSpeed = math.Clamp( ( pl.JetSpeed or 2 ) * 1.1, 2, 20 )
	
		local vel = pl:GetAimVector() * pl.JetSpeed
		vel.x = 0
		vel.y = vel.y / 4
		vel.z = pl.JetSpeed
		
		local prev = mv:GetVelocity()
		prev.y = math.Clamp( prev.y, -700, 700 )
		prev.z = math.Clamp( prev.z, -300, 300 )

		mv:SetVelocity( prev + vel )

	else
	
		pl.JetSpeed = math.Clamp( ( pl.JetSpeed or 2 ) / 1.5, 2, 20 )
	
	end
	
end

function CLASS:CalcView( ply, origin, angle, fov )

	if not ply:Alive() then
		origin = ply:GetPos()
	end

	local campos = origin + Vector( 700, 0, 0 )
	local plypos = ply:GetShootPos():ToScreen()
	local aimpos = gui.ScreenToVector( ScreenPos.x, ScreenPos.y )
	local centerpos = gui.ScreenToVector( plypos.x, plypos.y )
	local dist = centerpos:Distance( aimpos )
	local aim = ( aimpos - centerpos ):Normalize()
	local camadd = aim * ( dist * -100 ) 
	local view = {}
	
	campos.x = campos.x + dist * 150
	
	view.origin = campos + ( aim * ( dist * ply:GetNWInt( "Focus", 450 ) ) )
	view.angles = ( origin - ( campos + camadd ) ):Normalize():Angle()
	
	return view
	
end

function CLASS:ShouldDrawLocalPlayer( pl )

	return true
	
end

player_class.Register( "Base Class", CLASS )