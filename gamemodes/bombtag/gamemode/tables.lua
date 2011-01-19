
GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end
