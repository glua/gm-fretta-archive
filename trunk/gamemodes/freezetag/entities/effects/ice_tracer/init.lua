
EFFECT.Mat = Material( "effects/spark" )
EFFECT.Glow = Material( "effects/yellowflare" )

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Dir 		= self.EndPos - self.StartPos
	self.Normal     = ( self.EndPos - self.StartPos ):Normalize()
	self.Length     = math.Rand( 0.15, 0.30 )
	self.Size       = math.Rand( 5, 15 )
	
	local dist = self.StartPos:Distance( self.EndPos )
	
	self.TracerTime = 0.1 * math.Clamp( dist / 3000, 0.1, 1.0 )
	self.DieTime = CurTime() + self.TracerTime
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	local emitter = ParticleEmitter( self.EndPos )
	
	for i=1, math.random(5,10) do
	
		local particle = emitter:Add( "effects/fleck_glass"..math.random(1,3), self.EndPos )
		particle:SetVelocity( self.Normal * math.Rand(50,200) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand(2.0,4.0) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand(1,3) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(0,360) )
		particle:SetRollDelta( math.Rand(-2,2) )
		particle:SetColor( 150, 150, 255 )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector(0,0,-500) )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand(1.0,0.5) )
	
	end
	
	emitter:Finish()
	
end

function EFFECT:Think()
	
	return CurTime() < self.DieTime

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5
	
	local sinWave = math.sin( fDelta * math.pi )
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.EndPos - self.Dir * ( fDelta - sinWave * self.Length ), 		
					 self.EndPos - self.Dir * ( fDelta + sinWave * self.Length ),
					 2 + sinWave * 16, 
					 1,					
					 0,				
					 Color( 100, 100, 255, 255 ) )
	
	render.SetMaterial( self.Glow )
	render.DrawSprite( self.EndPos, self.Size, self.Size, Color( 100, 100, 255, 255 ) ) 
	
end
