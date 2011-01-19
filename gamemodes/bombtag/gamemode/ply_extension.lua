
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:SetCarrier( bool )

	self:SetNWBool( "Carrier", bool )
	
	if bool then
		self:SetWalkSpeed( 400 )
		self:SetRunSpeed( 400 )
		self:SetJumpPower( 400 )
	else
		self:SetWalkSpeed( 300 )
		self:SetRunSpeed( 300 )
		self:SetJumpPower( 300 )
	end
	
end

function meta:IsCarrier()
	return self:GetNWBool( "Carrier", false )
end

function meta:Explode()

	local ed = EffectData()
	ed:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", ed, true, true )
	
	util.BlastDamage( self, self, self:GetPos(), 300, 200 )
	
end

function meta:SetTime( time )
	self:SetNWInt( "Time", time )
end

function meta:GetTime()
	return self:GetNWInt( "Time", 0 )
end

function meta:AddTime( num )

	self:SetNWInt( "Time", self:GetTime() + num )
	
	if self:GetTime() <= 0 then
	
		self:SetTeam( TEAM_DEAD )
		self:Explode()
		
	end
	
end

function meta:SetBomb( bomb )
	self.Bomb = bomb
end

function meta:GetBomb()
	return self.Bomb
end