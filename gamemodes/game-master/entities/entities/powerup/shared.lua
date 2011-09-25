ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= "Dlaor"

powerups = {}

function AddPW( name, nicename, model, color, func ) //I love mah tables

	local addtab = {}
	addtab.name = name
	addtab.nicename = nicename
	addtab.model = model
	addtab.color = color
	addtab.func = func
	table.insert( powerups, addtab )
	
end

//Note to self: make function return true to disallow any player from picking up the powerup
AddPW( "health", "Health", "models/gmaster/pw_medic.mdl", Color( 187, 44, 44 ), function( ply )
	if ( ply:Health() < 100 ) then
		ply:SetHealth( ply:Health() + 40 )
		SendUserMessage( "Healed", ply )
	elseif ( ply:GetNWInt( "Stamina", 0 ) < 1000 ) then
		ply:SetNWInt( "Stamina", math.Clamp( ply:GetNWInt( "Stamina", 0 ) + 250, 0, 1000 ) )
		SendUserMessage( "Healed", ply )
	else return true end
end )

function ENT:SetPowerup( pw )
	self:SetNWInt( "Powerup", pw )
end

function ENT:GetPowerup()
	return self:GetNWInt( "Powerup", 1 )
end