

for k, v in pairs(file.FindInLua(GM.Folder:Replace("gamemodes/", "") .. "/gamemode/scoreboard/*.lua")) do
	include("scoreboard/" .. v)
end


function SetCenteredPosition(panel, x, y)
	
	local w, h = panel:GetSize();
	panel:SetPos((x - (w * .5)), (y - (h * .5)));
	
end


function GM:ScoreboardShow()

	local ply = LocalPlayer();

	if (!ply.Scoreboard) then
		self:CreateScoreboard();
	end
	
	gui.EnableScreenClicker(true);
	ply.Scoreboard:SetVisible(true);
	
	timer.Simple(0, ply.Scoreboard.UpdateScoreboard, ply.Scoreboard);

	return true;

end

function GM:ScoreboardHide()

	local ply = LocalPlayer();
	
	if (ply.Scoreboard) then
		ply.Scoreboard:SetVisible(false);
	end
	
	gui.EnableScreenClicker(false);

	return true;

end



function GM:CreateScoreboard()
	
	local ply = LocalPlayer();
	
	if (!ply.Scoreboard) then
		
		ply.Scoreboard = vgui.Create("UCScoreboard");
		//ply.Scoreboard:UpdateScoreboard();
		
	end
	
end


