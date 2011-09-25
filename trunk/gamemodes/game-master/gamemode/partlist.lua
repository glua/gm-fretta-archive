partlist = {} //The key of Gamemaster. Without this line of code, Gamemaster would not exist.

function AddPart( name, tex, amount, func ) //I love mah tables

	local addtab = {}
	addtab.name = name
	addtab.tex = tex
	addtab.amount = amount
	addtab.func = func
	table.insert( partlist, addtab )
	
end

AddPart( "Crate", "vgui/gmaster/crate", 6, function( pos )
	local ent = ents.Create( "prop_physics" )
	ent:SetModel( "models/props_junk/wood_crate001a.mdl" )
	ent:SetPos( pos )
	return ent
end )

AddPart( "Barrel", "vgui/gmaster/barrel", 6, function( pos )
	local ent = ents.Create( "prop_physics" )
	ent:SetModel( "models/props_c17/oildrum001_explosive.mdl" )
	ent:SetPos( pos )
	return ent
end )

AddPart( "Rollermine", "VGUI/entities/npc_rollermine", 6, function( pos )
	local ent = ents.Create( "npc_rollermine" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 4 )
	return ent
end )

AddPart( "Manhack", "VGUI/entities/npc_manhack", 6, function( pos )
	local ent = ents.Create( "npc_manhack" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 256 )
	return ent
end )

AddPart( "Metropolice", "VGUI/entities/npc_metropolice", 4, function( pos )
	local ent = ents.Create( "npc_metropolice" )
	ent:SetPos( pos )
	ent:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
	ent:SetKeyValue( "additionalequipment", "weapon_pistol" )
	ent:SetKeyValue( "spawnflags", 256 + 4 )
	return ent
end )

AddPart( "Combine Soldier", "VGUI/entities/npc_combine_s", 3, function( pos )
	local ent = ents.Create( "npc_combine_s" )
	ent:SetPos( pos )
	ent:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
	ent:SetKeyValue( "additionalequipment", "weapon_smg1" )
	ent:SetKeyValue( "NumGrenades", 3 )
	ent:SetKeyValue( "spawnflags", 256 + 4 )
	return ent
end )

AddPart( "Prison Guard", "VGUI/entities/npc_combine_p", 2, function( pos )
	local ent = ents.Create( "npc_combine_s" )
	ent:SetPos( pos )
	ent:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
	ent:SetKeyValue( "additionalequipment", "weapon_shotgun" )
	ent:SetKeyValue( "NumGrenades", 3 )
	ent:SetKeyValue( "spawnflags", 4 )
	ent:SetKeyValue( "model", "models/combine_soldier_prisonguard.mdl" )
	return ent
end )

AddPart( "Combine Elite", "VGUI/entities/npc_combine_e", 2, function( pos )
	local ent = ents.Create( "npc_combine_s" )
	ent:SetPos( pos )
	ent:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
	ent:SetKeyValue( "additionalequipment", "weapon_ar2" )
	ent:SetKeyValue( "spawnflags", 256 + 4 )
	ent:SetKeyValue( "model", "models/combine_super_soldier.mdl" )
	return ent
end )

AddPart( "Antlion", "VGUI/entities/npc_antlion", 5, function( pos )
	local ent = ents.Create( "npc_antlion" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 4 )
	return ent
end )

AddPart( "Zombie", "VGUI/entities/npc_zombie", 5, function( pos )
	local ent = ents.Create( "npc_zombie" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 4 )
	return ent
end )

AddPart( "Fast Zombie", "VGUI/entities/npc_fastzombie", 4, function( pos )
	local ent = ents.Create( "npc_fastzombie" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 4 )
	return ent
end )

AddPart( "Poison Zombie", "VGUI/entities/npc_poisonzombie", 2, function( pos )
	local ent = ents.Create( "npc_poisonzombie" )
	ent:SetPos( pos )
	ent:SetKeyValue( "spawnflags", 4 )
	return ent
end )