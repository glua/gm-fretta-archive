
function EFFECT:Init( d )

	self.Pos = d:GetOrigin()
	
	local dist = LocalPlayer():GetPos():Distance( self.Pos )
	
	if dist < 350 then
	
		local scale = 1 - ( dist / 350 )
		
		ViewWobble = math.Clamp( scale, 0.5, 1.0 )
		Sharpen = scale * 5.5
		ColorModify[ "$pp_colour_brightness" ] 	= scale * 1.0
	
	end
	
	self.Refract = 0
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "particles/smokey", self.Pos ) 
 		
 		particle:SetVelocity( VectorRand() * 200 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand(2.0,3.0) ) 
 		particle:SetStartAlpha( math.random(100,150) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(10,20) ) 
 		particle:SetEndSize( math.random(150,200) ) 
		particle:SetRoll( math.Rand(-90,90) )
		particle:SetRollDelta( math.Rand(-2,2) )
		local dark = math.Rand(50,100)
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.5 )
 		
 	end 
	
	for i=1, 35 do
	
		local particle = emitter:Add( "effects/spark", self.Pos )
		particle:SetVelocity( VectorRand() * 500 )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 4, 8 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -100, 100 ) )
		particle:SetColor( 255, 255, 225 )
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector(0,0,1) * math.random( -300,-100 ) )
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
		
	end
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		dlight.Pos = self.Pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 4 
		dlight.Decay = 512
		dlight.size = 1024
		dlight.DieTime = CurTime() + 3
	end
	
end

function EFFECT:Think( )

	self.Refract = self.Refract + 2.0 * FrameTime()
	self.Size = 400 * self.Refract ^ 0.2
	
	if self.Refract >= 1 then 
		return false 
	end
	
	return true
	
end

local matRefraction	= Material( "refract_ring" )

function EFFECT:Render()

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + ( EyePos()-self.Entity:GetPos() ):GetNormal() * Distance * ( self.Refract ^ 0.3 ) * 0.8

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.1 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )

end