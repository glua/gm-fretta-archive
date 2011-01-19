INC.Maps = {}
DefaultProps = {}

DefaultProps = {
	"models/clannv/incoming/box/box1.mdl",
	"models/clannv/incoming/box/box2.mdl",
	"models/clannv/incoming/box/box3.mdl",
	
	"models/clannv/incoming/cone/cone1.mdl",
	"models/clannv/incoming/cone/cone2.mdl",
	"models/clannv/incoming/cone/cone3.mdl",
	
	"models/clannv/incoming/cylinder/cylinder1.mdl",
	"models/clannv/incoming/cylinder/cylinder2.mdl",
	"models/clannv/incoming/cylinder/cylinder3.mdl",
	
	"models/clannv/incoming/hexagon/hexagon1.mdl",
	"models/clannv/incoming/hexagon/hexagon2.mdl",
	"models/clannv/incoming/hexagon/hexagon3.mdl",
	
	"models/clannv/incoming/pentagon/pentagon1.mdl",
	"models/clannv/incoming/pentagon/pentagon2.mdl",
	"models/clannv/incoming/pentagon/pentagon3.mdl",
	
	"models/clannv/incoming/sphere/sphere1.mdl",
	"models/clannv/incoming/sphere/sphere2.mdl",
	"models/clannv/incoming/sphere/sphere3.mdl",
	
	"models/clannv/incoming/triangle/triangle1.mdl",
	"models/clannv/incoming/triangle/triangle2.mdl",
	"models/clannv/incoming/triangle/triangle3.mdl"
}

INC.Maps[ "inc_duo" ] = {
	[ "PropSpawnDelay" ] = 1.5,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( -1650, 5950, 6656 ),
	[ "Distance" ] = 9000
}

INC.Maps[ "inc_rectangular" ] = {
	[ "PropSpawnDelay" ] = 1.5,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( 158, 1027, 3815 ),
	[ "Distance" ] = 8420
}

INC.Maps[ "inc_linear" ] = {
	[ "PropSpawnDelay" ] = 2,
	[ "FallingProps" ] = {},
	[ "Spot" ] = Vector( 0, 4991, 3456 ),
	[ "Distance" ] = 12500
}

for k, v in pairs( INC.Maps ) do
	table.Add( INC.Maps[ k ][ "FallingProps" ], DefaultProps )
	--Msg("Merged 'DefaultProps' into INC.Maps['"..k.."']['FallingProps']\n")
end