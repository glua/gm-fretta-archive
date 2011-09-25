function IncludeResFolder( dir )

	local files = file.FindInLua( "sterrortown/content/" .. dir .. "*" )
	local FindFileTypes = 
	{
		".vmt",
		".vtf",
		".mdl",
		".mp3",
		".wav",
		".txt",
	}
	
	for k, v in pairs( files ) do
		for k2, v2 in pairs( FindFileTypes ) do
			if ( string.find( v, v2 ) ) then
				resource.AddFile( dir .. v )
			end
		end
	end
end

IncludeResFolder( "materials/" )
IncludeResFolder( "materials/decals/" )
IncludeResFolder( "materials/hud/" )
IncludeResFolder( "materials/hud/gmdm/" )
IncludeResFolder( "materials/hud/gmdm_icons/" )
IncludeResFolder( "materials/sprites/" )
IncludeResFolder( "materials/sprites/gmdm_pickups/" )
IncludeResFolder( "materials/weapons/" )
IncludeResFolder( "materials/weapons/scopes/" )
IncludeResFolder( "scripts/" )
IncludeResFolder( "scripts/decals/" )
IncludeResFolder( "scripts/server_settings/" )

//resource.AddFile( "gmdm_maps.txt" )