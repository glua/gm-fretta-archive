---- Autodownload resources

function IncludeResFolder( dir )

	local files = file.FindInLua( "sterrortown/content/" .. dir .. "*" )
	local FindFileTypes = 
	{
		".vmt",
		".vtf",
		".mdl",
		".mp3",
		".wav",
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
IncludeResFolder( "materials/cube/" )
IncludeResFolder( "models/" )
IncludeResFolder( "models/cube/" )
IncludeResFolder( "models/weapons/" )
IncludeResFolder( "sounds/cube/" )
