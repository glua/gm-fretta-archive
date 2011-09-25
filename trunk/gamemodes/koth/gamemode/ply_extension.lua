
local meta = FindMetaTable( "Player" )
if ( !meta ) then return end 

function meta:Notice( words, duration, r, g, b )
	
	umsg.Start( "Notice", self )
	umsg.String( words )
	umsg.Short( duration )
	umsg.Short( r )
	umsg.Short( g )
	umsg.Short( b )
	umsg.End() 
	
end  

function meta:AddTime()

	self:SetNWInt( "Time", self:GetNWInt( "Time", 0 ) + 1 )
	
	GAMEMODE:AddTeamTime( self:Team(), 1 )
	GAMEMODE:CheckScore( self:Team() )
	
	if self.TimeBonus then
		self.TimeBonus = self.TimeBonus + 1
		if self.TimeBonus == 5 then
		
			local health = math.Clamp( self:Health() + 5, 1, self:GetMaxHealth() )
		
			self:SetHealth( health )
			self.TimeBonus = 0
			
		end
	else
		self.TimeBonus = 0
	end
	
end

function meta:Drop()

	if math.random( 1, 5 ) == 1 then
	
		local power = ents.Create( "sent_powerup" )
		power:SetPos( self:GetPos() + Vector(0,0,40) )
		power:Spawn()
	
	end

	local class = "health"
	
	if self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() then
		class = self:GetActiveWeapon():GetClass()
	end

	local gun = ents.Create( "sent_droppedgun" )
	gun:SetPos( self:GetPos() + Vector(0,0,50) )
	gun:SetAngles( self:GetForward():Angle() )
	gun:SetWeapon( class )
	gun:Spawn()
	
end

function meta:SetPowerup( name )

	self:CallPowerupFunction( "End" )

	if not name then

		self:SetNWString( "Powerup", "null" )
		return
	
	end

	self:SetNWString( "Powerup", name )

	local c = powerup.Get( name )
	
	if ( !c ) then
		MsgN( "Warning: Player used undefined powerup! (", name, ")" )
	else
		self:CallPowerupFunction( "Start" )
		self:Notice( c.DisplayName.." mode activated", 3, 255, 255, 255 )
	end

end

function meta:GetPowerup()

	local name = self:GetNWString( "Powerup", "null" )
	local c = powerup.Get( name )
	
	if ( c ) then return c end

end

function meta:CallPowerupFunction( name, ... )

	local power = self:GetPowerup()
	if ( !power ) then return end
	if ( !power[ name ] ) then return end
	
	return power[ name ]( power, self, ... )
	
end