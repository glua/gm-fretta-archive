
EFFECT.Flare = Material("effects/blueflare1")
EFFECT.EndFlare = Material("effects/yellowflare")
EFFECT.Mat = Material("sprites/physbeam")

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	self.Norm = ( self.StartPos - self.EndPos ):Normalize()
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Alpha = 255
	self.Color = Color( 0, 255, 100, self.Alpha )
	
	local emitter = ParticleEmitter( self.EndPos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "effects/yellowflare", self.EndPos )
		particle:SetVelocity( self.Norm * math.Rand( 100, 200 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetStartLength( 0.1 )
		particle:SetEndLength( 0.5 )
		particle:SetRoll( 0 )
		particle:SetColor( 0, 150, 255 )
			
		particle:SetAirResistance( 50 )
		particle:SetVelocityScale( true )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		
	end
	
	emitter:Finish()

end

function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 100
	self.Color = Color( 0, 255, 100, self.Alpha )
	
	if (self.Alpha < 0) then return false end
	
	return true

end

function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	local sc = self.Alpha / 255 
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPos, self.EndPos, sc * 2.5 + 1.0, CurTime(), CurTime(), self.Color )
	
	render.SetMaterial( self.Flare )
	render.DrawSprite( self.StartPos, sc * 10, sc * 10, Color( 0, 150, 255, self.Alpha ) )
	
	render.SetMaterial( self.EndFlare )
	render.DrawSprite( self.EndPos, sc * 30, sc * 30, Color( 0, 150, 255, self.Alpha ) )

end
