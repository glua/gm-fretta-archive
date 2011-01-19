
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.RespawnTime = 3

function ENT:Initialize()

end

function ENT:KeyValue( key, value )

	if key == "frequency" then
		self.RespawnTime = math.Clamp( tonumber( value ), 1, 60 )
	end
	
end

function ENT:Think()
	
	if ( self.Timer or 0 ) < CurTime() then
		self.Timer = CurTime() + self.RespawnTime
		self:SpawnProp()
	end	
	
end

function ENT:SpawnProp()

	if table.Count( ents.FindByClass("prop_phys*") ) > 100 then return end
	
	local prop = self.Entity:CreateProp( self:GetPos(), self:GetAngles(), table.Random( GAMEMODE.PropModels ) )
	
	local phys = prop:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:AddAngleVelocity( ( VectorRand() * 200 ):Angle() )
	end
	
end

function ENT:CreateProp( pos, ang, model )

	local prop = ents.Create( "prop_physics" )
	prop:SetPos( pos )
	prop:SetAngles( ang )
	prop:SetModel( model )
	prop:Spawn()
	
	return prop
	
end

function ENT:GetFrequency()
	return self.RespawnTime 
end