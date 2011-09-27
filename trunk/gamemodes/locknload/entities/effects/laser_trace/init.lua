EFFECT.Flare = Material("effects/blueflare1")
EFFECT.EndFlare = Material("effects/yellowflare")
EFFECT.Mat = Material("effects/yellowflare")

function InitLNLLaserTracer (self, data)
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = GetTracerShootPosLNL( self, self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	self.Norm = ( self.StartPos - self.EndPos ):Normalize()
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Alpha = LNL_TracerAlpha or 255
	
	local emitter = ParticleEmitter( self.EndPos )
	
	for i=1, 25 * self.Alpha / 255 do
	
		local particle = emitter:Add( "effects/yellowflare", self.EndPos )
		particle:SetVelocity( self.Norm * math.Rand( 100, 200 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.25, 0.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetStartLength( 0.1 )
		particle:SetEndLength( 0.5 )
		particle:SetRoll( 0 )
		particle:SetColor( 255, 255, 255 )
			
		particle:SetAirResistance( 50 )
		particle:SetVelocityScale( true )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		
	end
	
	emitter:Finish()
end

function EFFECT:Init (data)
	InitLNLLaserTracer (self, data)
end

local lifetime = 0.5

function ThinkLNLLaserTracer (self)
	self.Alpha = self.Alpha - FrameTime() * (255 / lifetime)
	
	if (self.Alpha < 0) then return false end
	
	return true
end

function EFFECT:Think( )
	return ThinkLNLLaserTracer (self)
end

function RenderLNLLaserTracer (self, color)
	if ( self.Alpha < 1 ) then return end
	
	color.a = self.Alpha
	
	local sc = self.Alpha / 255 
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPos, self.EndPos, sc * 2.5 + 1.0, 0.5, 0.5, color )
	
	render.SetMaterial( self.Flare )
	render.DrawSprite( self.StartPos, sc * 10, sc * 10, color )
	
	render.SetMaterial( self.EndFlare )
	render.DrawSprite( self.EndPos, sc * 30, sc * 30, color )
end

function EFFECT:Render( )
	RenderLNLLaserTracer (self, color_white)
end
