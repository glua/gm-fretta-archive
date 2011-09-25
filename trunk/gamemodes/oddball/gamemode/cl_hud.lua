--Arrows above the players head with the oddball

local function TeamHud3d()
	cam.Start3D(EyePos(), EyeAngles())
	for k, v in pairs(player.GetAll()) do
		if v:Alive() and v:GetNWBool("HasOddBall",false) == true then
			if v:Team() == TEAM_RED then
				render.SetMaterial(Material("oddball/red_arrow")) --Make a red arrow
			elseif v:Team() == TEAM_BLUE then
				render.SetMaterial(Material("oddball/blue_arrow")) --Make a blue arrow
			else
				render.SetMaterial(Material("oddball/grey_arrow")) --Somthing has gone horribly wrong
			end
			if v != LocalPlayer() then --If it's not ourselfs, draw that shit
				render.DrawSprite(v:GetPos()+v:GetUp()*85, 32, 32, Color(255,255,255,255) )
			end
		end
	end
	render.SetMaterial(Material("oddball/team_arrow"))
	for k, v in pairs(team.GetPlayers(LocalPlayer():Team())) do
		if v:Alive() then
			if v != LocalPlayer() and v:GetNWBool("HasOddBall",false) == false then
				render.DrawSprite(v:GetPos()+v:GetUp() * 70, 16, 16, Color(255,255,255,255) )
			end
		end
	end
	cam.End3D()

	if !LocalPlayer():Alive() and (LocalPlayer():Team() != TEAM_BLUE or LocalPlayer():Team() != TEAM_RED) then return end

	local h = ScrH()
	local w = ScrW()

	surface.SetTexture(surface.GetTextureID("oddball/radar"))
	surface.SetDrawColor( 255, 255, 255, 225 )
	surface.DrawTexturedRect(ScrW()/20, ScrH()/20, 200, 200)

	local radar = {}
	radar.w = 200
	radar.h = 200
	radar.x = ScrW()/20
	radar.y = ScrH()/20
	--radar.radius = 590.55118 // 15 meters in inches..
	radar.radius = 700

	for k,pl in pairs(player.GetAll()) do
		local cx = radar.x+radar.w/2
		local cy = radar.y+radar.h/2
		local vdiff = pl:GetPos()-LocalPlayer():GetPos()
		local xvars = vdiff.x
		local yvars = vdiff.y

		local scale = 60

		local distance = LocalPlayer():GetPos():Distance(pl:GetPos())
		local FadeDistance = scale*12
		local alpha = (1 - (distance/(scale*12))) * 200

		if math.sqrt(xvars * xvars + yvars * yvars) < radar.radius then
			local px = (vdiff.x/radar.radius)
			local py = (vdiff.y/radar.radius)
			local z = math.sqrt( px*px + py*py )
			local phi = math.Deg2Rad(math.Rad2Deg(math.atan2( px, py )) - math.Rad2Deg(math.atan2( LocalPlayer():GetAimVector().x, LocalPlayer():GetAimVector().y )) - 90)
			px = math.cos(phi)*z
			py = math.sin(phi)*z
			if cy+py*radar.h/2-4 < radar.y + radar.h then
				--if pl:GetVelocity():Length() > 160 and distance <= FadeDistance then
				if distance <= FadeDistance and pl:Alive() then
					if (pl:Team() == LocalPlayer():Team()) and pl != LocalPlayer() then
						draw.RoundedBox( 6, cx+px*radar.w/2-4, cy+py*radar.h/2-4, 12, 12, Color(255, 255, 0, alpha))
					elseif (pl:Team() != LocalPlayer():Team() and pl:Team() != TEAM_SPECTATOR and pl:Team() != TEAM_UNASSIGNED) then
						draw.RoundedBox( 6, cx+px*radar.w/2-4, cy+py*radar.h/2-4, 12, 12, Color(255, 0, 0, alpha))
					end
				end
			end
		end
	end
end
hook.Add( "HUDPaint", "OddBall", TeamHud3d )

function GM:UpdateHUD_Alive( InRound )
	self.BaseClass:UpdateHUD_Alive()
	GAMEMODE:PaintHealth()
end

function GM:PaintHealth()
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 1 )

	if ( GAMEMODE.SelectClass ) then
	
		local ClassIndicator = vgui.Create( "DHudUpdater" )
			ClassIndicator:SizeToContents()
			ClassIndicator:SetValueFunction( function() 
												return LocalPlayer():GetNWString( "Class", "Default" )
											end )
			ClassIndicator:SetColorFunction( function() 
												return team.GetColor( LocalPlayer():Team() )
											end )
			ClassIndicator:SetFont( "HudSelectionText" )
		
		Bar:AddItem( ClassIndicator )
		
	end
		
	local HealthIndicator = vgui.Create( "DHudUpdater" )
		HealthIndicator:SizeToContents()
		HealthIndicator:SetValueFunction( function() return LocalPlayer():Health() end )
		HealthIndicator:SetColorFunction( function() 
											if LocalPlayer():Health() <= 25 then
												return Color( 255, 100 + math.sin( RealTime() * 3 ) * 100, 100 + math.sin( RealTime() * 3 ) * 100, 255 )	
											end
											return Color( 255, 255, 255, 255 )
										end )
		HealthIndicator:SetLabel( "HEALTH" )
		HealthIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( HealthIndicator )

end

function GM:AddScoreboardTime( ScoreBoard )

	local f = function( ply ) return string.ToMinutesSeconds( ply:GetNWInt("Time",0) ) end
	ScoreBoard:AddColumn( "Time", 50, f, 0.1, nil, 6, 6 )

end

function GM:CreateScoreboard( ScoreBoard )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	
	if ( GAMEMODE.TeamBased ) then
		ScoreBoard:SetAsBullshitTeam( TEAM_UNASSIGNED )
		ScoreBoard:SetHorizontal( true )
	end

	ScoreBoard:SetSkin( "SimpleSkin" )

	self:AddScoreboardAvatar( ScoreBoard )		
	self:AddScoreboardSpacer( ScoreBoard, 8 )	
	self:AddScoreboardName( ScoreBoard )		
	self:AddScoreboardTime( ScoreBoard )		
	self:AddScoreboardKills( ScoreBoard )		
	self:AddScoreboardDeaths( ScoreBoard )		
	self:AddScoreboardPing( ScoreBoard )		
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, false, 3, false } )

end

local function HideHUD(name)
	if name == "CHudHealth" then return false end
	if name == "CHudBattery" then return false end
end
hook.Add("HUDShouldDraw","HideHUD",HideHUD)