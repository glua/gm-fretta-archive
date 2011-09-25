//POWERUP SYSTEM

powerup = {}
powerup.tex = {}
powerup.onspawn = {}
powerup.ontouch = {}
powerup.onreverse = {}

function powerup:Register( id, texture, onspawn, ontouch, onreverse )

	powerup.tex[id] = texture
	powerup.onspawn[id] = onspawn
	powerup.ontouch[id] = ontouch
	powerup.onreverse[id] = onreverse

end

function powerup:GetRandom()

	return math.random( 1, #powerup.tex )

end

function powerup:Create( id, vec, ang )

	print( "powerup:Create()" )
	local ent = ents.Create( "pdo_powerup" )
	ent:SetMaterial( powerup.tex[id] )
	ent:SetPos( vec )
	ent:SetAngles( ang )
	ent.ontouch = powerup.ontouch[id]
	ent.onreverse = powerup.onreverse[id]
	if( powerup.onspawn[id] != nil ) then
		powerup.onspawn[id]( ent )
	end
	
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function powerup:DeleteAll()

	for k,v in pairs( ents.FindByClass( "pdo_powerup" ) ) do
	
		v:Remove()
	
	end

end

function reverse_Control( ply, ent )

	print( "reverse_Control()" )
	
	if( !ply:KeyDown( IN_ATTACK ) || ent:GetClass() != "pdo_powerup" ) then return end
	
	ent.reverse = true
	ent.revply = ply

end
hook.Add( "GravGunOnDropped", "reverse_pwuControl", reverse_Control )

function stop_puDamage( ent, inflictor, attacker, amt, dmginfo )

	if( ent:IsPlayer() && inflictor:GetClass() == "pdo_powerup" ) then
	
		dmginfo:SetDamage( 0 )
	
	end

end
hook.Add( "EntityTakeDamage", "stop_puDamage", stop_puDamage )