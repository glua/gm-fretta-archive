include('shared.lua')

function ENT:Initialize()
	
end

function ENT:OnRemove()

	self.Entity:DieEffect()

end


function ENT:DieEffect()

	local min = self.Entity:LocalToWorld( self.Entity:OBBMins() )
	local max = self.Entity:LocalToWorld( self.Entity:OBBMaxs() )
	
	local emitter = ParticleEmitter( self.Entity:GetPos() )

	for i=1, math.Clamp( self.Entity:BoundingRadius(), 10, 100 ) do
	
		local pos = Vector( math.Rand( min.x, max.x ), math.Rand( min.y, max.y ), math.Rand( min.z, max.z ) )
		local norm = ( pos - self.Entity:LocalToWorld( self.Entity:OBBCenter() ) ):Normalize()
		
		local particle = emitter:Add( "effects/yellowflare", pos )
		particle:SetVelocity( norm * math.random( 50, 100 ) )
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 3, 6 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( 0 )
		particle:SetColor( 100, 200, 255 )
		
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
		particle:SetAirResistance( 50 )
		particle:SetVelocityScale( true )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		
	end
	
	emitter:Finish()

end

function ENT:Think()
	
	self.Alpha = math.sin( CurTime() * 2 ) * 50 + 50
	
	self.Entity:SetColor( 255, 255, 255, math.Clamp( self.Alpha, 5, 255 ) )
	
end

local matLight = Material( "models/spawn_effect2" )

function ENT:Draw()
	
	local eyenorm = self.Entity:GetPos() - EyePos()
	local dist = eyenorm:Length()
	eyenorm:Normalize()
	
	local pos = EyePos() + eyenorm * dist * 0.01
	
	cam.Start3D( pos, EyeAngles() )
		
		SetMaterialOverride( matLight )
			self.Entity:DrawModel()
		SetMaterialOverride( 0 )
		
	cam.End3D()
	
end

