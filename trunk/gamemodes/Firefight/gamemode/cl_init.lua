include( 'shared.lua' )

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
		
		if ( GAMEMODE.RoundBased ) then 
		
			local RoundNumber = vgui.Create( "DHudUpdater" );
				RoundNumber:SizeToContents()
				RoundNumber:SetValueFunction( function() return GetGlobalInt( "RoundNumber", 0 ) end )
				RoundNumber:SetLabel( "ROUND" )
			Bar:AddItem( RoundNumber )
			
			local RoundTimer = vgui.Create( "DHudCountdown" );
				RoundTimer:SizeToContents()
				RoundTimer:SetValueFunction( function() 
												if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
												return GetGlobalFloat( "RoundEndTime" ) end )
				RoundTimer:SetLabel( "TIME" )
			Bar:AddItem( RoundTimer )

			local points = vgui.Create("DHudUpdater")
			points:SizeToContents()
			points:SetValueFunction( function()
											return LocalPlayer():Frags()
									end)

			points:SetLabel("POINTS")

			Bar:AddItem( points )
			
		end
	end
end

function GM:NotifyPlayer(strText, intTime)

	surface.CreateFont( "akbar", 60, 500, true, true, "Akbar" )

	local text = vgui.Create("DLabel", frame)
	
	text:SetSize(600,60)
	text:Center()
	text:SetTextColor(Color(255,255,255,200))
	text:SetFont("Akbar")
	text:SetText(strText)

	timer.Simple(intTime, function() text:Remove() end)
end

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Points", 50, f, 0.5, nil, 6, 6 )

end