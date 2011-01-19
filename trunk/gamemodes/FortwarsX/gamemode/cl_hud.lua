
include( "vgui_scoreboard_team.lua" )

function GM:UpdateHUD_Alive( InRound )

	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
	
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )

		if ( GAMEMODE.TeamBased ) then
		
			local TeamIndicator = vgui.Create( "DHudUpdater" );
				TeamIndicator:SizeToContents()
				TeamIndicator:SetValueFunction( function() 
													return team.GetName( LocalPlayer():Team() )
												end )
				TeamIndicator:SetColorFunction( function() 
													return team.GetColor( LocalPlayer():Team() )
												end )
				TeamIndicator:SetFont( "HudSelectionText" )
			Bar:AddItem( TeamIndicator )
			
		end
		
		if ( GetGlobalInt( "RoundNumber", 0 ) == 2 ) then
			local Class = vgui.Create( "DHudUpdater" );
				Class:SizeToContents()
				Class:SetLabel( "CLASS" )
				Class:SetValueFunction( function() return LocalPlayer():GetPlayerClassName() end )
			Bar:AddItem( Class )
		end
		
		if ( GAMEMODE.RoundBased ) then 
		
			local RoundNumber = vgui.Create( "DHudUpdater" );
				RoundNumber:SizeToContents()
				RoundNumber:SetLabel( "PHASE" )
				local r = GetGlobalInt( "RoundNumber", 0 )
				
				if ( r == 0 ) then
					RoundNumber:SetValueFunction( function() return "Preparing" end )
				elseif ( r == 1 ) then
					RoundNumber:SetValueFunction( function() return "Build" end )
				elseif ( r == 2 ) then
					RoundNumber:SetValueFunction( function() return "Fight" end )
				end
				
			Bar:AddItem( RoundNumber )
			
			local RoundTimer = vgui.Create( "DHudCountdown" );
				RoundTimer:SizeToContents()
				RoundTimer:SetValueFunction( function() 
												if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
												return GetGlobalFloat( "RoundEndTime" ) end )
				RoundTimer:SetLabel( "TIME" )
			Bar:AddItem( RoundTimer )

		end
		
		if ( GetGlobalInt( "RoundNumber" ) != 2 ) then return end
		
		local ScoreBar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( ScoreBar, 8 )
		
		local BlueScore = vgui.Create( "DHudUpdater" )
		BlueScore:SizeToContents()
		BlueScore:SetLabel( "BLUE TIME" )
		BlueScore:SetValueFunction( function()
										return string.ToMinutesSeconds( team.GetScore( TEAM_BLUE ) )
									end )
		ScoreBar:AddItem( BlueScore )
		
		local RedScore = vgui.Create( "DHudUpdater" )
		RedScore:SizeToContents()
		RedScore:SetLabel( "RED TIME" )
		RedScore:SetValueFunction( function()
										return string.ToMinutesSeconds( team.GetScore( TEAM_RED ) )
									end )
		ScoreBar:AddItem( RedScore )
		
	end

end

local shown = false
local play = true
TehEnd = false

function GM:UpdateHUD_RoundResult( RoundResult, Alive )
	
	local txt = GetGlobalString( "RRText" )
	local rnd = GetGlobalInt( "RoundNumber", 0 )
	
	if ( team.GetAllTeams()[ RoundResult ] && txt == "" ) then
		local TeamName = team.GetName( RoundResult )
		if ( TeamName ) then txt = TeamName .. " Wins!" end //TODO: See if this is redundant
	end
	
	if ( txt == "Time Up" ) then //"Time Up" is so standard, lets change it!
		if ( rnd == 1 ) then
			txt = "Get ready to enter the Fight Phase!" //Yeah, that's better!
		elseif ( rnd == 2 ) then
			TehEnd = true
			local yourteam = LocalPlayer():Team()
			local redscore = team.GetScore( TEAM_RED )
			local bluescore = team.GetScore( TEAM_BLUE )
			local winner = 0
			if ( redscore > bluescore ) then //TODO: Looks like this is inefficient
				txt = Format( "The winner is... Team Red, their hold-on time was %s!", string.ToMinutesSeconds( redscore ) )
				winner = TEAM_RED
			elseif ( redscore < bluescore ) then
				txt = Format( "The winner is... Team Blue, their hold-on time was %s!", string.ToMinutesSeconds( bluescore ) )
				winner = TEAM_BLUE
			elseif ( redscore == bluescore ) then
				txt = "A draw... Jesus Christ, how boring is that?"
			end
			if ( play ) then
				PlayMusic( LocalPlayer():Team(), winner )
				play = false
			end
		end
	end

	local EndText = vgui.Create( "DHudElement" );
		EndText:SizeToContents()
		EndText:SetText( txt )
	GAMEMODE:AddHUDItem( EndText, 8 )
	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if ( rnd != 2 or shown ) then return end //Only show end thingy if we're at the end of the fight phase
	shown = true
	
	local List = player.GetAll()
	for k, v in pairs( List ) do
		if ( v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_UNASSIGNED ) then
			table.remove( List, k )
		end
	end
	
	local players = {}
	for i = 1, #List do
		players[i] = {}
		players[i]["Name"] = List[i]:Nick()
		players[i]["Kills"] = List[i]:Frags()
		players[i]["Deaths"] = List[i]:Deaths()
		players[i]["Team"] = List[i]:Team()
	end
	
	table.SortByMember( players, "Kills" )
	
	local InfoPanel = vgui.Create( "DPanel" )
	InfoPanel:SetPos( 0, 0 )
	InfoPanel:SetSize( ScrW(), ScrH() )
	
	local Type = "DLabel"
	local font = "FRETTA_LARGE"
	----------------------------------------------------------------------------------------------------------------------------------
	InfoText1 = vgui.Create( Type, InfoPanel )
		local ply1 = players[1]
		local str1 = FunnyStringMostKills( ply1["Name"], ply1["Kills"] ) //This function is defined at the end of this file
		
		InfoText1:SetFont( font )
		InfoText1:SetText( str1 )
		InfoText1:SizeToContents()
		
		local w = InfoText1:GetWide()
		local h = InfoText1:GetTall()
		InfoText1:SetColor( team.GetColor( ply1["Team"] ) )
	----------------------------------------------------------------------------------------------------------------------------------
	table.SortByMember( players, "Deaths" )
	InfoText2 = vgui.Create( Type, InfoPanel )
		local ply2 = players[1]
		local str2 = FunnyStringMostDeaths( ply2["Name"], ply2["Deaths"] ) //This function is defined at the end of this file
		
		InfoText2:SetFont( font )
		InfoText2:SetText( str2 )
		InfoText2:SizeToContents()
		
		local w2 = InfoText2:GetWide()
		local h2 = InfoText2:GetTall()
		InfoText2:SetColor( team.GetColor( ply2["Team"] ) )
	----------------------------------------------------------------------------------------------------------------------------------
	table.SortByMember( players, "Kills" )
	InfoText3 = vgui.Create( Type, InfoPanel )
		local ply3 = players[#players]
		local str3 = FunnyStringLeastKills( ply3["Name"], ply3["Kills"] ) //This function is defined at the end of this file
		
		InfoText3:SetFont( font )
		InfoText3:SetText( str3 ) 
		InfoText3:SizeToContents()
		
		local w3 = InfoText3:GetWide()
		local h3 = InfoText3:GetTall()
		InfoText3:SetColor( team.GetColor( ply3["Team"] ) )
	----------------------------------------------------------------------------------------------------------------------------------
	
	local width = math.max( w, w2, w3 ) + 14
	local height = h + h2 + h3 + 14
	InfoPanel:SetSize( width, height )
	InfoPanel:Center()
	InfoText2:Center()
	
	InfoText1:CenterHorizontal()
	InfoText1:MoveAbove( InfoText2 )
	
	InfoText3:CenterHorizontal()
	InfoText3:MoveBelow( InfoText2 )
	
	InfoText1.Paint = function( lbl ) LblPaint( lbl, str1 ) return true end
	InfoText2.Paint = function( lbl ) LblPaint( lbl, str2 ) return true end
	InfoText3.Paint = function( lbl ) LblPaint( lbl, str3 ) return true end
	
	InfoPanel.Paint = function( pnl )
		
		local wide = pnl:GetWide()
		draw.RoundedBox( 4, 0, 0, wide, pnl:GetTall(), Color( 0, 0, 0, 100 ) )
		
		local content = {}
		content.text = "RESULTS"
		content.font = "FRETTA_SMALL"
		content.pos = {}
		content.pos[1] = wide / 2
		content.pos[2] = 2
		content.xalign = TEXT_ALIGN_CENTER
		content.yalign = TEXT_ALIGN_TOP
		content.color = Color( 255, 255, 0 )
		
		draw.TextShadow( content, 1, 200 )

	end
	
	timer.Simple( 8, function() InfoPanel:SetVisible( false ) print( "The end... to be continued?") end )
	

end

function LblPaint( label, str )
	
	local content = {}
	content.text = str or "WHAT IS THIS I DON'T EVEN"
	content.font = "FRETTA_LARGE"
	
	content.pos = {}
	content.pos[1] = 0
	content.pos[2] = 0
	content.color = label:GetColor()
	
	draw.TextShadow( content, 2, 200 )
	
end

function PlayMusic( team, winner ) //Happy or sad music

	if ( winner == 0 ) then
		surface.PlaySound( "music/hl2_song19.mp3" )
		return
	end
	
	if ( team == winner ) then
		surface.PlaySound( "music/hl1_song25_remix3.mp3" )
	else
		surface.PlaySound( "music/hl2_song25_teleporter.mp3" )
	end
	
end

function FunnyStringMostKills( str, num ) //HAHAHAHA

	local strings = { "The most destructive player was %s, with %i kills!",
		"%s has slaughtered %i people, HOLY SHIT!",
		"%s is the #1 badass this round, with %i kills!",
		"m-m-m-MONSTER KILL!!! %s has %i kills!",
		"You better praise %s for getting %i kills!",
		"%s has OVER 9000 KILLS!!! Nah, kidding: he's got %i!",
		"%s is Sir Killalot, with %i kills!",
		"You all suck, %s is the way to go! %i kills!" }
	
	return Format( table.Random( strings ), str, num )
	
end

function FunnyStringMostDeaths( str, num ) //HAHAHAHAHAHAHAHA
	
	local strings = { "%s has died the most, with %i deaths!",
		"%s was killed %i times, how sad...",
		"The ultimate victim is %s, getting himself killed %i times!",
		"You suck, %s! Die less than %i times next time, please.",
		"%s fails, he died %i times!",
		"%s with %i deaths? WHAT IS THIS I DONT EVEN",
		"Who's gonna explain to me how %s died %i times? Suicide attempts?" }
	
	return Format( table.Random( strings ), str, num )
	
end

function FunnyStringLeastKills( str, num ) //HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA
	
	local strings = { "Looks like %s did nothing, he only has %i kills!",
		"Jesus Christ %s, how in the world could you only get %i kills?",
		"If you think you sucked, think again. %s does, with %i kills!",
		"Either %s was afk or just laying around, he only has %i kills!",
		"%s == Loser! Kills == %i!",
		"%s with %i kills? DOES NOT COMPUTE."}
	
	return Format( table.Random( strings ), str, num )
	
end
