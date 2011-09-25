

EFFECT.Mat = Material("trails/plasma")
local matLight 	= Material( "effects/yellowflare" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	local Weapon = data:GetEntity()
	
	self.Color = Color( 100, 255, 100 )
	self.Alpha = 255
	
	local emitter = ParticleEmitter( self.EndPos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "effects/yellowflare", self.EndPos )
		particle:SetVelocity( ( self.StartPos - self.EndPos ):Normalize() * math.Rand( 150, 250 ) + VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 20 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -10, 10 ) )
		particle:SetColor( 100, 255, 100 )
			
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
			
	end
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		dlight.Pos = self.EndPos 
		dlight.r = 100
		dlight.g = 255
		dlight.b = 100
		dlight.Brightness = math.Rand( 2, 4 )
		dlight.Decay = 1024
		dlight.size = 2048 * math.Rand( 0.75, 1.0 )
		dlight.DieTime = CurTime() + 3
	end

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 200
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	if ( self.Alpha < 0 ) then return false end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	self.Length = ( self.StartPos - self.EndPos ):Length()
	
	local texcoord = CurTime() * -0.2
	
	for i = 1, 8 do
	
		render.SetMaterial( self.Mat )
		
		texcoord = texcoord + i * 0.05 * texcoord
	
		render.DrawBeam( self.StartPos, 										
						self.EndPos,											
						i * self.Alpha * 0.025,													
						texcoord,														
						texcoord + ( self.Length / ( 128 + self.Alpha ) ),									
						self.Color )
						
		render.SetMaterial( matLight )

		render.DrawSprite( self.StartPos, i * 15, i * 15, Color( self.Color.r, self.Color.g, self.Color.b, math.Clamp( self.Alpha * 1.5, 0, 255 ) ) )
		render.DrawSprite( self.EndPos, i * 15, i * 15, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
	
	end
	


end
