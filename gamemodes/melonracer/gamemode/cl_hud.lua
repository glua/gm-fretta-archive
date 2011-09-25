
local pnlPlayerName = vgui.RegisterFile( "vgui_playername.lua" )
local pnlPlayerList = vgui.RegisterFile( "vgui_playerlist.lua" )

/*---------------------------------------------------------
   Name: gamemode:HUDThink
---------------------------------------------------------*/
function GM:HUDThink()

	self:UpdatePlayerTooltips()

end


function GM:UpdatePlayerTooltips()

	local Players = player.GetAll()
	
	for k, pl in pairs( Players ) do
		local Melon = pl:GetNWEntity( "Melon" )
		self:UpdatePlayerTooltip( Melon, pl )
	end

end

function GM:UpdatePlayerTooltip( Melon, pl )

	if (!IsValid(Melon) || !IsValid(pl) || IsValid( pl.ToolTip )) then return end
	
	local ScrPos = (Melon:GetPos() + Vector(0,0,32)):ToScreen()
	
	if ( !IsValid( pl.ToolTip ) && IsPlayerTooltipVisible( pl, Melon ) ) then
	
		pl.ToolTip = vgui.CreateFromTable( pnlPlayerName )
		pl.ToolTip:SetPos( ScrPos.x, ScrPos.y )		
		pl.ToolTip:SetMelon( Melon )
		pl.ToolTip:SetPlayer( pl )
	
	end

end