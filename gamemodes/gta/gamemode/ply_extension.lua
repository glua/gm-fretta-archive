
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:EnterCar( ent )

	if self:GetExitTime() > CurTime() then return end

	local weapon = self:GetActiveWeapon()
	local class = "gta_glock18"
	
	if ValidEntity( weapon ) then
		class = weapon:GetClass()
	end
	
	self:SetCarriedWeapon( class )
	
	self:Flashlight( false )
	self:StripWeapons()
	self:Give( "gta_driver" )
	self:Spectate( OBS_MODE_CHASE )
	self:SetCar( ent )
	self:SetExitTime( CurTime() + 3 )
	self:Notice( "get to the dropoff zone", 3, 255, 255, 255 )
	
	ent:SetOwner( self )
	ent:EmitSound( ent.StartSound )
	
	local phys = ent:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
	end

end

function meta:ExitCar()

	if not ValidEntity( self:GetCar() ) or self:GetExitTime() > CurTime() then return end

	local health = self:Health()
	
	self:GetCar():SetOwner()
	
	self:SetExitTime( CurTime() + 1 )
	self:UnSpectate()
	self:StripWeapons()
	self:Spawn()
	self:ExitTrace( self:GetCar():GetRight(), 0 )
	self:SetHealth( health )
	self:SetCar( NULL )
	self:SetCarriedWeapon()
	
end

function meta:ExitTrace( dir, limit )

	local start = self:GetCar():LocalToWorld( self:GetCar():OBBCenter() )
	local pos = start + self:GetCar():BoundingRadius() * dir + Vector(0,0,25)
	
	local trace = {}
	trace.start = start
	trace.endpos = pos
	trace.filter = { self, self:GetCar() }
	local tr = util.TraceLine( trace )
	
	if tr.Hit then
	
		limit = limit + 1
		
		if limit < 10 then
			local dir = VectorRand():Angle()
			dir.p = self:GetCar():GetAngles().p
			dir.r = self:GetCar():GetAngles().r
			self:ExitTrace( dir:Forward(), limit )
		else
			self:SetPos( tr.HitPos + tr.HitNormal * 30 )
		end
		
	else
		self:SetPos( pos )
	end

end

function meta:Notice( words, duration, r, g, b )
	
	umsg.Start( "Notice", self )
	umsg.String( words )
	umsg.Short( duration )
	umsg.Short( r )
	umsg.Short( g )
	umsg.Short( b )
	umsg.End() 
	
end  

function meta:SetMotionBlur( amt )

	umsg.Start( "AddBlur", self )
	umsg.Float( amt )
	umsg.End() 

end

function meta:Roadkill()

	self:Notice( table.Random( GAMEMODE.RoadkillNotices ), 2, 255, 150, 0 )
	self:SetMotionBlur( 0.5 )

end

function meta:GetCash()
	return self:GetNWInt( "Cash", 0 )
end

function meta:SetCash( num )
	self:SetNWInt( "Cash", num )   
end

function meta:AddCash( num )
	self:SetCash( self:GetCash() + num )
end

function meta:GetBusts()
	return self:GetNWInt( "Busts", 0 )
end

function meta:SetBusts( num )
	self:SetNWInt( "Busts", num )   
end

function meta:AddBusts( num )
	self:SetBusts( self:GetBusts() + num )
end

function meta:SetCar( ent )
	self:SetNWEntity( "Car", ent )
end

function meta:GetCar()
	return self:GetNWEntity( "Car", nil )
end

function meta:SetExitTime( time )
	self.ExitTime = time
end

function meta:GetExitTime()
	return self.ExitTime or 0
end

function meta:SetCarriedWeapon( name )
	self.Carry = name
end

function meta:GetCarriedWeapon( name )
	return self.Carry
end
