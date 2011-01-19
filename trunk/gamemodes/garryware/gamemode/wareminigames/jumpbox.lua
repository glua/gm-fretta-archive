WARE.Author = "xandar"
WARE.Duration = 7.0

function WARE:Initialize()
	GAMEMODE:SetWareWindupAndLength(0, self.Duration)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Sprint-jump from box to box twice!" )
	
	self.NumberSwaps = 2
	
	self.Entground = GAMEMODE:GetEnts(ENTS_CROSS)
end

function WARE:StartAction()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	
	self.PlayerLastBlock = {}
	self.PlayerSwapCount = {}
	--self.PlayerLastTime = {}
	
	--self.EndTime = CurTime() + self.Duration
	
	self.PlayerList = team.GetPlayers(TEAM_HUMANS)
	
	for _,v in pairs(self.PlayerList) do
		self.PlayerLastBlock[v] = nil
		self.PlayerSwapCount[v] = -1
		--self.PlayerLastTime[v] = CurTime()
	end
end

function WARE:EndAction()

end

function WARE:Think()	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do		
		if v:GetPos().z-self.Entground[1]:GetPos().z <= 5 then
			self.PlayerLastBlock[v] = nil
			self.PlayerSwapCount[v] = -1
			--v:ApplyLose()
		end
	end 
	
	local entposcopy = 	table.Copy(GAMEMODE:GetEnts(ENTS_ONCRATE))
	for _,block in pairs(entposcopy) do
		local box = ents.FindInBox(block:GetPos() + Vector(-30,-30,0), block:GetPos() + Vector(30,30,64))
		for _,target in pairs(box) do
			if target:IsPlayer() and target:IsWarePlayer() then
				if (self.PlayerLastBlock[target] ~= block) then
					self.PlayerLastBlock[target] = block
					self.PlayerSwapCount[target] = self.PlayerSwapCount[target] + 1
					
					if self.PlayerSwapCount[target] >= self.NumberSwaps then
						target:ApplyWin()
					end
					
					--self.PlayerLastTime[target] = CurTime()
					--if ((CurTime() + 1.75) > self.EndTime) then
					--	target:ApplyWin()
					--end
				end
			end
		end
	end
	
	--for k,v in pairs(self.PlayerList) do
	--	if v:IsValid() then
	--		if (CurTime() > (self.PlayerLastTime[v] + 1.75)) then
	--			v:ApplyLose()
	--		end
	--	end
	--end
end