
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Notice( words, duration, r, g, b )
	
	umsg.Start( "Notice", self )
	umsg.String( words )
	umsg.Short( duration )
	umsg.Short( r )
	umsg.Short( g )
	umsg.Short( b )
	umsg.End() 
	
end  

function meta:SpawnArmor()
	self.ArmorTime = CurTime() + 5
end

function meta:GetArmorTime()
	return self.ArmorTime or -1
end

function meta:GetFuel()
	return self:GetNWInt( "Fuel", 0 )
end

function meta:AddFuel( num )

	local class = self:GetPlayerClass()
	local max = class.MaxFuel or 100

	self:SetFuel( math.Clamp( self:GetFuel() + num, 0, max ) )
	
end

function meta:SetFuel( num )
	self:SetNWInt( "Fuel", num )
end

function meta:SetFocus( num )

	if not num then
		num = 450
	end
	
	self:SetNWInt( "Focus", num )
	
end

function meta:SetPrimary( name )
	self.Primary = name
end

function meta:SetSecondary( name )
	self.Secondary = name
end

function meta:GetPrimary()
	return self.Primary
end

function meta:GetSecondary()
	return self.Secondary
end

function meta:CheckFire()

	if !ValidEntity( self.FireAttacker ) or !self:Alive() or ( self:GetNWBool( "Fire", false ) and self.FireTime != -1 and self.FireTime < CurTime() ) then
	
		self.NextBurn = -1
		self.FireTime = -1
		self.FireAttacker = nil
		self:SetNWBool( "Fire", false )
	
	elseif self.NextBurn != -1 and self.NextBurn < CurTime() then
	
		self.NextBurn = CurTime() + 0.3
		self:TakeDamage( math.random(1,3), self.FireAttacker )
		
	end

end

function meta:DoIgnite( attacker )

	if not self:GetNWBool( "Fire", false ) and self.FireTime == -1 then
	
		self.NextBurn = 0
		self.FireTime = CurTime() + 8
		self.FireAttacker = attacker
		self:SetNWBool( "Fire", true )
		
		local ed = EffectData()
		ed:SetEntity( self )
		util.Effect( "player_immolate", ed, true, true )
	
	end

end

function meta:SetPowerup( id )

	self:CallPowerupFunction( "End" )

	if not id or id == "null" then

		self:SetNWString( "Powerup", "null" )
		return
	
	end
	
	local c, name = powerup.GetByID( id )

	self:SetNWString( "Powerup", name )
	
	if ( !c ) then
	
		MsgN( "Warning: Player used undefined powerup! (", name, ")" )
		
	else
	
		self:CallPowerupFunction( "Start" )
		self:Notice( c.Description or "N/A", 3, c.Color.r, c.Color.g, c.Color.b )
		
	end

end

function meta:GetPowerupName()

	return self:GetNWString( "Powerup", "null" )

end

function meta:GetPowerup()

	local name = self:GetPowerupName()
	local c = powerup.Get( name )
	
	if ( c ) then return c end
	
	return nil

end

function meta:CallPowerupFunction( name, ... )

	local power = self:GetPowerup()
	if ( !power ) then return end
	if ( !power[ name ] ) then return end
	
	return power[ name ]( power, self, ... )
	
end