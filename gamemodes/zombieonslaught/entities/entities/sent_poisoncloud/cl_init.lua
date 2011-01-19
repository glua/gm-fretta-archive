
include('shared.lua')

function ENT:Initialize()

	for i=1, math.random(10,15) do
	
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() + Vector( math.random(-25,25), math.random(-25,25), math.random(25,50) ) )
		util.Effect( "gib", ed, true, true )
	
	end
	
	self.Entity:SetRenderBounds( Vector() * -800, Vector() * 800 )
	
	local emitter = ParticleEmitter( self:GetPos() )
	
	for i=1, 25 do
	
		local vel = VectorRand() * 500
		vel.z = math.random( 250, 500 )
		
		local pos = VectorRand() * 50
		pos.z = math.random(20,40)
		
		local particle = emitter:Add( "decals/flesh/blood"..math.random(1,3), self:GetPos() + pos )
		particle:SetVelocity( vel )
		particle:SetDieTime( math.Rand( 2.5, 3.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( math.random( 1, 20 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( math.random( 50, 100 ), 0, 0 )
		
		particle:SetCollide( table.Random( { true, false } ) )
		particle:SetBounce( 0.2 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
		local pos = VectorRand() * 150
		pos.z = math.random(20,40)
		
		local particle = emitter:Add( "particle/particle_smokegrenade", self:GetPos() + pos )
		particle:SetVelocity( Vector( 0, 0, 0 ) )
		particle:SetDieTime( math.Rand( 8.0, 10.0 ) )
		particle:SetStartAlpha( math.Rand( 30, 90 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 100, 150 ) )
		particle:SetEndSize( 200 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( math.random( 50, 100 ), 0, 0 )
	
	end
	
	emitter:Finish()
	
end

function ENT:Think()

end

function ENT:Draw()
	
end

