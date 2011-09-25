//player_pup, Player Power Up

module( "player_pup", package.seeall )

local PupTables = {}

function Register( name, puptable )
	PupTables[ name ] = puptable
end

function Get( name )
	if ( !PupTables[ name ] ) then return {} end
	
	return PupTables[ name ]
end

function Obtain( pl, name )
	local puptable = PupTables[ name ]
	
	puptable:Use( pl )
	pl.Powers = pl.Powers or {}
	if puptable.Duration then
		pl.Powers[ name ] = pl.Powers[ name ] or false
		if !pl.Powers[ name ] then
			timer.Create( "PUP" .. name .. pl:UniqueID(), puptable.Duration, 1, EndPup, pl, name )
		else //Reinstate the time
			timer.Adjust("PUP" .. name .. pl:UniqueID(), puptable.Duration, 1, EndPup, pl, name )
		end
	end
	
	pl.Powers[ name ] = true
end

function EndPup(pl, name)
	
	local puptable = Get( name )
	pl.Powers = pl.Powers or {}
	
	if puptable.End then
		puptable:End( pl )
	end
	
	pl.Powers[ name ] = nil
	
end

function EndPlayer( pl )
	
	pl.Powers = pl.Powers or {}
	
	for k,v in pairs( pl.Powers ) do
		EndPup( pl, k )
		timer.Destroy("PUP" .. k .. pl:UniqueID())
	end
	
end
