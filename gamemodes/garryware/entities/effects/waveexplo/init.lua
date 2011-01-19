

local matRefraction	= Material( "refract_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Norm = data:GetNormal()
	
	----
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,20 do
		local particle = emitter:Add( "effects/yellowflare", self.Pos + self.Norm * 12)
		particle:SetColor(255,192,255)
		particle:SetStartSize( math.Rand(5,10) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(0.5,1.5) )
		particle:SetVelocity( self.Norm * 150 + VectorRand() * 100 )
		
		particle:SetBounce(0.8)
		particle:SetGravity( Vector( 0, 0, -300 ) )
		particle:SetCollide(true)
		particle:SetVelocityScale( true )
		particle:SetStartLength( 0.2 )
		particle:SetEndLength( 0 )
	end
	
	local particle = emitter:Add( "effects/yellowflare", self.Pos)
	particle:SetColor(255,192,255)
	particle:SetStartSize( 100 )
	particle:SetEndSize( 0 )
	particle:SetStartAlpha( 128 )
	particle:SetEndAlpha( 0 )
	particle:SetDieTime( 0.4 )
	particle:SetVelocity( Vector(0,0,0) )
	particle:SetBounce(0)
	particle:SetGravity( Vector( 0, 0, 0 ) )
	
	emitter:Finish( )
	----
	
	self.Refract = 0
	
	self.Size = 32
	
	self.Entity:SetRenderBounds( Vector()*-512, Vector()*512 )
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think()
	self.Refract = self.Refract + 2.0 * FrameTime()
	self.Size = 64 * self.Refract^(0.2)
	
	if ( self.Refract >= 1 ) then return false end
	
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + (EyePos()-self.Entity:GetPos()):GetNormal() * Distance * (self.Refract^(0.3)) * 0.8

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )
end



