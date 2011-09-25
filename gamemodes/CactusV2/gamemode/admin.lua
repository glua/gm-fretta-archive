
GM.Diffuculty = CreateConVar( "c_difficulty", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )
GM.MaxPowerups = CreateConVar( "c_maxpowerups", "3", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )
GM.MaxCacti = CreateConVar( "c_maxcacti", "50", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )

for k,v in pairs(Cactus.GetTypes()) do
	local first = string.upper(string.Left(v:GetType(),1))
	local right = string.TrimLeft(v:GetType(),first)
	local typ = first..right
	GM["Max"..typ] = CreateConVar( "c_max"..v:GetType(), v:GetMaxType(), FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )
end

// c_difficulty effects the speed of the cacti
// c_maxpowerups is unused for now
// c_maxcacti is the total maximum number of cactus entities allowed in play
// c_max<type> changes the total maximum number of cactus entities of a specific type allowed in play