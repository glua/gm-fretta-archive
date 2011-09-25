//PropReg: Prop Register. This registers different models.

//Flags use the functions in flags.lua.

propreg = {}

propreg.mdl = {}
propreg.mhealth = {}
propreg.mskin  = {}
propreg.plist = {}
propreg.damage = {}
propreg.hdamage = {}

propreg.entlist = {}
propreg.MAX_PROPS = 20
propreg.propcount = 0

//Set health to 0 to make it use the mass
function propreg:RegisterModel( model, skin, health, id, damage, hdamage )

	propreg.mskin[id] = skin
	propreg.mdl[id] = model
	propreg.mhealth[id] = health
	propreg.plist[model] = id
	propreg.damage[id] = damage
	propreg.hdamage[id] = hdamage
	
end

function propreg:DeleteAllEnts()

	for k,v in pairs(propreg.entlist) do
	
		local ent = ents.GetByIndex( v )
		if( ent != nil && ent:IsValid() && !ent:IsPlayer() ) then
			
			ent:Remove()
			
		end
		
	end
	propreg.propcount = 0
	
end

function propreg:CreateProp( id, posvec, angles )

	local ent = ents.Create( "prop_physics" )
	ent.propreg = true
	
	propreg.entlist[#(propreg.entlist) + 1] = ent:EntIndex()
	
	ent:SetModel( propreg.mdl[id] )
	
	ent:SetAngles( angles )
	ent:SetPos( posvec )
	
	ent.pid = id
	
	ent:Spawn()
	ent:Activate()
	propreg.propcount = propreg.propcount + 1

	return ent

end

function propreg:GetRandomProp()

	return table.Random( propreg.plist )
	
end

function propreg:GetHealth( id, fallbackent )

	print( "GetHealth()" )

	if(propreg.mhealth[id] == nil || propreg.mhealth[id] == 0) then
		return fallbackent:GetPhysicsObject():GetMass()
	else
		return propreg.mhealth[ids]
	end
	
end

function propreg:GetDmg( id )

	print( "GetDmg()" )

	return propreg.damage[id]
	
end

function propreg:GetHDmg( id )

	print( "GetHDmg()" )

	return propreg.hdamage[id]
	
end

function propreg:GetPropTable()

	return propreg.plist
	
end

function PRScaleDamage( ply, hitgroup, dmginfo )

	local ent = dmginfo:GetInflictor()
	if( propreg:GetDmg( ent.pid ) == nil ) then return end
	
	if( hitgroup == HITGROUP_HEAD ) then
	
		dmginfo:ScaleDamage( propreg:GetHDmg( ent.pid ) )
		
	else
	
		dmginfo:ScaleDamage( propreg:GetDmg( ent.pid ) )
		
	end

end
hook.Add( "ScalePlayerDamage", "PRScale", PRScaleDamage )