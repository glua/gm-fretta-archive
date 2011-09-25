
function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local col = data:GetStart()
	local emitter = ParticleEmitter( pos )

	for i=1,6 do
	
		local ed = EffectData()
		ed:SetOrigin( pos )
		util.Effect( "crate_gib", ed, true, true )
	
	end
	
	for i=1, 25 do
	
		local vec = VectorRand()
		vec.x = math.Rand( -1.0, 0.1 )
		vec.z = math.Rand( 0.1, 1.0 )
	
		local particle = emitter:Add( "effects/yellowflare", pos + VectorRand() * 50 )
		particle:SetVelocity( vec * 150 )
		particle:SetDieTime( 2.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 10, 30 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -15.5, 15.5 ) )
		particle:SetColor( col.x, col.y, col.z )
		particle:SetCollide( true )
	
	end
	
	emitter:Finish()
	
	WorldSound( Sound( "Wood.Break" ), self.Entity:GetPos(), 100, math.random(90,110) )
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end

