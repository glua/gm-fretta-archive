////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Statistics (shared)                        //
////////////////////////////////////////////////

GM.GW_STATS = {}
local stats = GM.GW_STATS

stats.Tokens = {}
stats.MagicRef = {}
stats.TokenMagic = 1
local function CreateToken( sRAWNAME, bDesignateLoser, sDescription )
	stats.Tokens[sRAWNAME] = { stats.TokenMagic, sRAWNAME, bDesignateLoser, sDescription }
	stats.MagicRef[stats.TokenMagic] = stats.Tokens[sRAWNAME]
	
	-- This shit is bitwise
	stats.TokenMagic = stats.TokenMagic * 2
end

do
	CreateToken( "IQ"    , false, "Good thinking" )
	CreateToken( "CALC"  , false, "Good at math" )
	CreateToken( "MEMORY", false, "Good at memory" )
	
	CreateToken( "REFLEX" , false, "Quick reflexes" )
	CreateToken( "PATIENT", false, "Patient" )
	CreateToken( "DODGE"  , false, "Nice dodger" )
	
	CreateToken( "VICTIM", true, "Victim" )
	
end

function GM:StatsRawTableToBitwise( tsRaw )
	if not tsRaw or (#tsRaw == 0) then return 0 end
	
	local iBitwise = 0
	for k,sRaw in pairs( tsRaw ) do
		if stats.Tokens[sRaw] then
			-- I said this shit is bitwise earlier thus the |
			iBitwise = iBitwise | stats.Tokens[sRaw][1]
		end
		
	end
	
	return iBitwise
end

function GM:StatsBitwiseToMagicTable( iBitwise )
	if iBitwise == 0 then return {} end
	
	-- It is completely stupid to do math.floor, but
	-- I don't want to run into infinite loops by accident
	-- (but it should never happen, end users (minigame makers)
	-- will never deal directly with bitwise things)
	local iDecrement = math.floor( iBitwise )
	local tMagic = {}
	
	local iTest = 1
	repeat
		if iTest & iBitwise == iTest then
			table.insert( tMagic, iTest )
		end
		iTest = iTest * 2
	until iDecrement <= 0
	
end
