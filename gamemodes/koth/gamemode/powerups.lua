
module( "powerup", package.seeall )

local PowerupTables = {}

function Register( name, ptable )

	PowerupTables[ name ] = ptable
	
end

function Get( name )
	
	if ( !PowerupTables[ name ] ) then return end

	return PowerupTables[ name ]
	
end

function RandomPowerup()

	local tbl = {}

	for k,v in pairs( PowerupTables ) do
		table.insert( tbl, { Type = k, Color = v.Color, DisplayName = v.DisplayName } )
	end
	
	return table.Random( tbl )

end
