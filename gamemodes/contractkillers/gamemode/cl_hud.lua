function GetTargetName() 
	if CLContract and CLContract.Nick ~= nil then 
		have_target = true
		return CLContract:Nick() 
	else 
		have_target = false
		return "Loading Target"		
	end
end


function render_target()
	if have_target and CLContract and CLContract:Alive() then
		local position = CLContract:GetPos()
		local screenposition = Vector(position.x,position.y,position.z + 80):ToScreen()
		if screenposition.visible then
			/*surface.SetDrawColor(255,0,0,100)
			surface.DrawRect(screenposition.x -10,screenposition.y -10,20,20)*/
			surface.SetTextColor( 255, 0, 0, 200 )
			surface.SetTextPos( screenposition.x - 20, screenposition.y -20 ) 
			surface.DrawText( "Kill Me!" )
			
		end
	end
end
hook.Add("HUDPaint", "render_target", render_target)

function GM:UpdateHUD_Alive( InRound )

local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )

		if false and ( GAMEMODE.TeamBased ) then
		
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
			local Target = vgui.Create( "DHudUpdater" );
				Target:SizeToContents()
				Target:SetValueFunction(GetTargetName)
				Target:SetLabel( "KILL:" )
			Bar:AddItem( Target )
						
			local RoundTimer = vgui.Create( "DHudCountdown" );
				RoundTimer:SizeToContents()
				RoundTimer:SetValueFunction( function() 
												if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
												return GetGlobalFloat( "RoundEndTime" ) end )
				RoundTimer:SetLabel( "TIME" )
			Bar:AddItem( RoundTimer )

		end
end
		
		

function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )

	if ( !InRound && GAMEMODE.RoundBased ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			RespawnText:SetText( "Waiting for players" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		return
		
	end
	if ( bWaitingToSpawn ) then

		local RespawnTimer = vgui.Create( "DHudCountdown" );
			RespawnTimer:SizeToContents()
			RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
			RespawnTimer:SetLabel( "SPAWN IN" )
		GAMEMODE:AddHUDItem( RespawnTimer, 8 )
		return

	end
	
	if ( InRound ) then
	
		local RoundTimer = vgui.Create( "DHudCountdown" );
			RoundTimer:SizeToContents()
			RoundTimer:SetValueFunction( function() 
											if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
											return GetGlobalFloat( "RoundEndTime" ) end )
			RoundTimer:SetLabel( "TIME" )
		GAMEMODE:AddHUDItem( RoundTimer, 8 )
		return
	
	end
	
end