
function EFFECT:Init( data )

	self.Entity:SetRenderBounds( Vector() * -1024, Vector() * 1024 )
	
	local pos = data:GetOrigin()
	local teamnum = math.floor( data:GetScale() )
	local col = table.Copy( team.GetColor( teamnum ) )
	local emitter = ParticleEmitter( pos )
	
	for i=0, 90 do
	
		local ang = Angle( i * 4, 90, 0 )
		local particle = emitter:Add( "effects/spark", pos )
		particle:SetVelocity( ang:Forward() * ( 50 + math.sin( i / 2 ) * 10 ) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 15 )
		particle:SetEndSize( 0 )
		particle:SetRoll( 360 )
		particle:SetRollDelta( 0.2 )
		particle:SetColor( col.r, col.g, col.b )
	
	end
	
	emitter:Finish()
	
end

function EFFECT:Think( )
	
	return false
	
end

function EFFECT:Render()

end

