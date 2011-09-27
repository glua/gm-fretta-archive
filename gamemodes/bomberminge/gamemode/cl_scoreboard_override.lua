
function GM:ScoreboardShow(lock, pl, newscore)
	if lock then
		self.LockedScoreboard = true
		self.ScoreboardWinner = pl
		self.ScoreboardNewScore = newscore
	elseif self.LockedScoreboard then
		return
	end
	
	self:GetScoreboard():SetVisible(true)
	self:PositionScoreboard(self:GetScoreboard())
end

function GM:ScoreboardHide(lock)
	if lock then
		self.LockedScoreboard = false
		self.ScoreboardWinner = nil
		self.ScoreboardNewScore = nil
		for _,v in pairs(player.GetAll()) do
			v.VictoryCurrentX = nil
			v.VictoryTargetX = nil
		end
	elseif self.LockedScoreboard then
		return
	end
	
	self:GetScoreboard():SetVisible(false)
end

function GM:AddScoreboardVictories(ScoreBoard)
	--[[local function f(pl)
		return pl:GetNWInt("Victories")
	end]]
	
	local f = function(pl) 	
		local cnt = vgui.Create("VictoryCounter")
		cnt.Player = pl
		return cnt
	end
	
	ScoreBoard:AddColumn("Victories", 100, f, 0.5, nil, 6, 6)
end

function GM:CreateScoreboard(ScoreBoard)
	ScoreBoard:SetAsBullshitTeam(TEAM_SPECTATOR)
	ScoreBoard:SetAsBullshitTeam(TEAM_CONNECTING)
	
	if GAMEMODE.TeamBased then
		ScoreBoard:SetAsBullshitTeam(TEAM_UNASSIGNED)
		ScoreBoard:SetHorizontal(true)
	end
	
	ScoreBoard:SetSkin("SimpleSkin")
	
	self:AddScoreboardAvatar(ScoreBoard)
	self:AddScoreboardWantsChange(ScoreBoard)
	self:AddScoreboardName(ScoreBoard)
	self:AddScoreboardVictories(ScoreBoard)
	self:AddScoreboardKills(ScoreBoard)
	self:AddScoreboardPing(ScoreBoard)
	
	ScoreBoard:SetSortColumns{3, true}
end

function GM:PositionScoreboard(ScoreBoard)
	if GAMEMODE.TeamBased then
		ScoreBoard:SetSize(800, ScrH() - 50)
		ScoreBoard:SetPos((ScrW() - ScoreBoard:GetWide()) * 0.5,  25)
	else
		ScoreBoard:SetSize(600, ScrH() - 64)
		ScoreBoard:SetPos((ScrW() - ScoreBoard:GetWide()) / 2, 32)
	end
end

usermessage.Hook("ShowPostRoundScoreboard", function(msg)
	local pl = msg:ReadEntity()
	local sc = msg:ReadShort()
	GAMEMODE:ScoreboardShow(true, pl, sc)
end)

usermessage.Hook("HidePostRoundScoreboard", function()
	GAMEMODE:ScoreboardHide(true)
end)