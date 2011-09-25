
module( "powerup", package.seeall )

local PowerupTables = {}

function Register( name, ptable )

	PowerupTables[ name ] = ptable
	
end

function Get( name )
	
	if ( !PowerupTables[ name ] ) then return end

	return PowerupTables[ name ]
	
end

function GetByID( id )

	for k,v in pairs( PowerupTables ) do
	
		if v.ID == id then
		
			return v, k
		
		end
		
	end
	
	return nil, "n/a"

end

function RandomPowerup()

	return table.Random( PowerupTables )

end
