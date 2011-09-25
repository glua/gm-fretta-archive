
function EFFECT:Init( data )

	self.Ent = data:GetEntity()
	
	if not ValidEntity( self.Ent ) then return end
	
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	
	self.Entity:SetParent( self.Ent )
	
end

function EFFECT:Think( )

	if not ValidEntity( self.Ent ) or not self.Ent:Alive() or not self.Emitter then 
	
		if self.Emitter then
			self.Emitter:Finish()
		end
	
		return false 
		
	end
	
	if self.Ent == LocalPlayer() then
	
		ColorModify[ "$pp_colour_addr" ] = 0.2
		BlurScale = 0.01
	
	end
	
	local particle = self.Emitter:Add( "jumpjet/splash00" .. math.random(1,2) .. table.Random{"a","b"}, self.Ent:GetPos() + Vector(0,0,math.random(30,50)) )
	particle:SetVelocity( VectorRand() * 100 + Vector(0,0,100) )
	particle:SetDieTime( math.Rand( 0.4, 0.8 ) )
	particle:SetStartAlpha( 200 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 10, 20 ) )
	particle:SetEndSize( math.Rand( 40, 80 ) )
	particle:SetRoll( math.Rand( -360, 360 ) )
	particle:SetColor( 100, 0, 0 )
	particle:SetGravity( Vector( 0, 0, -300 ) )

	return true
	
end

function EFFECT:Render()

end
