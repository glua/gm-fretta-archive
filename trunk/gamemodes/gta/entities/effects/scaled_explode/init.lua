
local matRefraction	= Material( "refract_ring" )

function EFFECT:Init( data )
	
	self.Pos = data:GetStart()
	self.Num = math.Clamp( data:GetScale(), 100, 300 )
	self.Ang = Angle(0,0,0)
	
	self.Refract = 0
	self.Size = 30
	self.Timer = CurTime() + 2
	
	self.Entity:SetPos( self.Pos )
	self.Entity:SetRenderBounds( Vector() * -2000, Vector() * 2000 )
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, self.Num do
	
		self.Ang:RotateAroundAxis( self.Ang:Up(), ( 360/self.Num ) )
	
		local forward = self.Ang:Forward() * self.Num / math.Rand(1.5,5.5)
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos + forward  )
		particle:SetDieTime( math.Rand(0.5,1.5) )
		particle:SetStartSize( math.Rand(20,40) )
		particle:SetEndSize( math.Rand(50,150) )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetVelocity( Vector(0,0,1) * 100 + forward * math.Rand(2.5,3.5) )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -2.0, 2.0 ) )
		particle:SetColor( math.Rand( 150, 250 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide(false)
		
	end
	
	for i=1, 5 do
	
		self.Ang:RotateAroundAxis(self.Ang:Up(), (360/self.Num))
	
		local forward = self.Ang:Forward() * self.Num / math.Rand(2.5,6.5)
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos + forward  )
		particle:SetDieTime( math.Rand(1.0,1.5) )
		particle:SetStartSize( math.Rand(50,100) )
		particle:SetEndSize( math.Rand(150,250) )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetVelocity( Vector(0,0,1) * 200 + forward * math.Rand(0.8,1.2) )
		particle:SetRoll( math.Rand( 0, 180 ) )
		particle:SetRollDelta( math.Rand( -2.0, 2.0 ) )
		particle:SetColor( math.Rand( 150, 250 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide(false)
		
	end

	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	if dlight then
		dlight.Pos = self.Pos
		dlight.r = 250
		dlight.g = 200
		dlight.b = 50
		dlight.Brightness = math.Rand(4, 8)
		dlight.Decay = 1024
		dlight.size = 1024
		dlight.DieTime = CurTime() + 2
	end
	
end

function EFFECT:Think( )

	self.Refract = self.Refract + 2.0 * FrameTime()
	self.Size = self.Refract * 1000
	
	if self.Refract >= 1 or self.Timer < CurTime() then return false end
	
	return true
	
end

function EFFECT:Render()

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawQuadEasy( self.Pos + Vector(0,0,1),
					 Vector(0,0,1),
					 self.Size, self.Size,
					 Color( 255, 255, 255, 255 ) )

end
