

-- Call this BEFORE minigame initialization
-- (NOT AFTER THE END OF MINIGAME !!!)
function GM:ResetWareAwards( )
	self.m_ware_winawards  = {}
	self.m_ware_failawards = {}
	self.m_ware_firstwin  = false
	self.m_ware_firstfail = false
	
end

function GM:SetWinAwards( ... )
	self.m_ware_winawards = {...}
	
end

function GM:SetFailAwards( ... )
	self.m_ware_failawards = {...}
	
end

function GM:IsFirstWinAwardEnabled( )
	return self.m_ware_firstwin or false
	
end

function GM:IsFirstFailAwardEnabled( )
	return self.m_ware_firstfail or false
	
end

function GM:EnableFirstWinAward( )
	self.m_ware_firstwin = true
	
end

function GM:EnableFirstFailAward( )
	self.m_ware_firstfail = true
	
end

function GM:FinalizeEndOfGamemodeAwards()
	local players = team.GetPlayers( TEAM_HUMANS )
	if #players < 2 then return end
	
	table.sort( players, WARE_SortTableStateBlind )
	
	local best_score         = players[1]:Frags()
	local best_scorer__combo = players[1]:GetBestCombo()
	local best_combo_by_t    = { }
	local best_combo         = 0
	
	local tie    = { }
	local almost = { }
	for _,ply in pairs( players ) do
		if ply:Frags() == best_score then
			if ply:GetBestCombo() == best_scorer__combo then
				table.insert( tie , ply )
				
			else
				table.insert( almost , ply )
				
			end
			
		end
		
		if ply:GetBestCombo() > best_combo then
			best_combo_by_t = { ply }
			best_combo = ply:GetBestCombo()

		elseif ply:GetBestCombo() == best_combo then
			table.insert( best_combo_by_t , ply )
		
		end
		
	end
	
	for _,ply in pairs( tie ) do
		ply:GiveAward( "winner" )
	end
	for _,ply in pairs( almost ) do
		ply:GiveAward( "winner_almost" )
	end
	for _,ply in pairs( best_combo_by_t ) do
		ply:GiveAward( "bast_combo" )
	end
	
	
end

function GM:CalculateBestAwards()
	local bestTokensFound  = {}
	
	for k,ply in pairs( team.GetPlayers(TEAM_HUMANS) ) do
		for id,num in pairs(ply.m_tokens) do
			if not bestTokensFound[id] or num > bestTokensFound[id][1] then
				bestTokensFound[id] = { num, ply }
				
			else
				table.insert( bestTokensFound[id] , ply )
			
			end
		end
		
	end
	
	return bestTokensFound
end

function GM:DEBUG_DisplayAwards( tAwards )
	GAMEMODE:PrintInfoMessage( "AWARDS", " (debug mode) ", "::" )
	for id,tab in pairs( tAwards ) do
	-- TODO : Could replace GAMEMODE with self, check if function change
		local text = ""
		for k,ply in pairs( tab ) do
			if k > 1 then
				text = text .. ply:Nick()
			end
			
			if k > 1 and k < #tab then
				text = text .. ", "
				
			elseif k > 1 then
				text = text .. "."
				
			end
			
		end
		GAMEMODE:PrintInfoMessage( id .. " award", " won by " .. tab[1] .. " points : ", text )
	
	end
	
end

function GM:StreamAwards()

end

function GM:DoProcessAllAwards()
	--self:FinalizeEndOfGamemodeAwards()
	local awards = self:CalculateBestAwards()
	
	--self:StreamAwards()
	self:DEBUG_DisplayAwards( awards )
	
end

