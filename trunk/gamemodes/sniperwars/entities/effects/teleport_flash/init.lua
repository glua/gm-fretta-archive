
function EFFECT:Init( data )

	self.Pos = data:GetOrigin( ) 
	
	self.Entity:SetRenderBounds( Vector() * -200, Vector() * 200 )
	
	local dist = LocalPlayer():GetPos():Distance( self.Pos )
	
	if dist < 100 then
	
		local scale = 1 - ( dist / 100 )
		
		ViewWobble = math.Clamp( scale * 1.0, 0.5, 1.0 )
		MotionBlur = math.Clamp( scale * 1.0, 0.5, 1.0 )
		Sharpen = scale * 5.5
		ColorModify[ "$pp_colour_mulb" ] = scale * 2.5
		ColorModify[ "$pp_colour_brightness" ] = scale 
	
	end
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,40 do
	
		local add = VectorRand() * 30
		add.z = math.Rand(20,100)
	
		local particle = emitter:Add( "effects/yellowflare", self.Pos + add )
		particle:SetColor( 255, 255, 255 )
		particle:SetStartSize( math.Rand( 5, 25 ) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand( 2.5, 5.0 ) )
		particle:SetVelocity( Vector(0,0,0) )
		
		particle:SetAirResistance( math.Rand( 50, 250 ) )
		particle:SetGravity( Vector( 0, 0, -50 ) )
		particle:SetCollide( true )
		
	end
	
	local particle = emitter:Add( "effects/yellowflare", self.Pos )
	particle:SetColor( 255, 255, 255 )
	particle:SetStartSize( 100 )
	particle:SetEndSize( 0 )
	particle:SetStartLength( 0.2 )
	particle:SetEndLength( 0 )
	particle:SetStartAlpha( 200 )
	particle:SetEndAlpha( 0 )
	particle:SetDieTime( 2.0 )
	particle:SetVelocity( Vector(0,0,0) )
		
	particle:SetGravity( Vector(0,0,0) )
	
	emitter:Finish()
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
