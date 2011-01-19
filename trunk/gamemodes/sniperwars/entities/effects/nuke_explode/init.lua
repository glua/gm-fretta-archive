
function EFFECT:Init( data )
	
	self.Pos = data:GetOrigin()
	self.Num = 200
	self.Ang = Angle(0,0,0)
	
	self.Size = 30
	self.Timer = CurTime() + 2
	
	local dist = LocalPlayer():GetPos():Distance( self.Pos )
	
	if dist < 500 then
	
		local scale = 1 - ( dist / 500 )
		
		ViewWobble = scale * 1.0
		MotionBlur = math.Clamp( scale * 1.0, 0.5, 1.0 )
		Sharpen = scale * 5.5
		ColorModify[ "$pp_colour_brightness" ] = scale * 0.5
	
	end
	
	self.Entity:SetPos(self.Pos)
	self.Entity:SetRenderBounds( Vector() * -2000, Vector() * 2000 )
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, self.Num do
	
		self.Ang:RotateAroundAxis( self.Ang:Up(), ( 360 / self.Num ) )
	
		local forward = self.Ang:Forward() * self.Num / math.Rand(1.5,4.5)
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos + forward  )
		particle:SetDieTime( math.Rand(0.5,2.0) )
		particle:SetStartSize( math.Rand(30,60) )
		particle:SetEndSize( math.Rand(50,150) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetVelocity( Vector(0,0,1) * math.random(0,50) + forward * math.Rand(1.5,3.0) )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -2.0, 2.0 ) )
		particle:SetColor( math.Rand( 150, 250 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide( true )
		
	end
	
	for i=1, 10 do
	
		local forward = VectorRand()
		forward.z = 0
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos + forward  )
		particle:SetDieTime( math.Rand(1.0,2.5) )
		particle:SetStartSize( math.Rand(100,200) )
		particle:SetEndSize( math.Rand(300,400) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetVelocity( forward * math.random(100,300) + Vector(0,0,1) * 150 )
		particle:SetRoll( math.Rand( 0, 180 ) )
		particle:SetRollDelta( math.Rand( -2.0, 2.0 ) )
		particle:SetColor( math.Rand( 150, 250 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide( true )
		
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

	return false
	
end

function EFFECT:Render()

end
