
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )


// Serverside only stuff goes here
// Serversided shit is gay D=

-- Round Start Sounds
resource.AddFile("sound/OIC/RoundStart/Rangers_v2.mp3")
resource.AddFile("sound/OIC/RoundStart/Spetsnaz_v2.mp3")

-- Round End Sounds
resource.AddFile("sound/OIC/Victory/Spetsnaz_v2.mp3")
resource.AddFile("sound/OIC/Victory/Rangers_v2.mp3")
resource.AddFile("sound/OIC/Victory/DrawGame.mp3")

--Generic Sounds

-- Tango Down
resource.AddFile("sound/OIC/Generic/Spetsnaz/TangoDown.mp3")
resource.AddFile("sound/OIC/Generic/Rangers/TangoDown.mp3")


-- Playe The Victory/Draw Sound At The End Of The Round
function GM:OnRoundEnd(round)
	local winner = GetGlobalInt("RoundResult")
	if winner == 2 then
		for i, ply in pairs(player.GetAll()) do
			ply:ConCommand("play OIC/Victory/Rangers_v2.mp3")
		end
	elseif winner == 1 then
		for i, ply in pairs(player.GetAll()) do
			ply:ConCommand("play OIC/Victory/Spetsnaz_v2.mp3")
		end
	else
		for i, ply in pairs(player.GetAll()) do
			ply:ConCommand("play OIC/Victory/DrawGame.mp3")
		end
	end
	
	
end



