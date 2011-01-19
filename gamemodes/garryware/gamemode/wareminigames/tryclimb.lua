WARE.Author = "Kelth"

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	
	GAMEMODE:SetWareWindupAndLength(0.5,6)
	

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Try to climb on the boxes!" )
end

function WARE:StartAction()
	local angle = nil
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		angle = ply:EyeAngles()
		ply:SetEyeAngles( Angle( angle.p, angle.y, 180 ) )
	end
	
end

function WARE:PerformEyeReset()
	local angle = nil
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		angle = ply:EyeAngles()
		ply:SetEyeAngles( Angle( angle.p, angle.y, 0 ) )
	end
end

function WARE:EndAction()
  self:PerformEyeReset()
  --Double-stream that because there's always some faulties.
  timer.Simple(0.2, self.PerformEyeReset )
  
end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:SetAchievedNoLock( false )
	end
	
	local entposcopy = 	table.Copy(GAMEMODE:GetEnts(ENTS_ONCRATE))
	for _,block in pairs(entposcopy) do
		local box = ents.FindInBox(block:GetPos() + Vector(-30,-30,0), block:GetPos() + Vector(30,30,64))
		
		for _,target in pairs(box) do
			if target:IsPlayer() and target:IsWarePlayer() then
				target:SetAchievedNoLock( true )
			end
		end
	end
end
