local SKIN = derma.SkinList["SimpleSkin"]

SKIN.SchemeScorePanelLabel = function(skin,panel)
	local pl = panel.pPlayer
	
	panel:SetTextColor(panel.cTeamColor)
	if ValidEntity(pl) then
		if pl:IsMutant() then panel:SetTextColor(Color(100,220,50)) end
		if pl:IsBottomFeeder() then panel:SetTextColor(Color(160,40,220)) end
	end

	panel:SetFont("FRETTA_MEDIUM_SHADOW")
end
