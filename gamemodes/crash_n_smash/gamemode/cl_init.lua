
COLOR_BLACK = Color(0,0,0,255)
COLOR_WHITE = Color(255,255,255,255)

include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'cl_tips.lua' )
include( 'cl_targetid.lua' )
include( 'cl_scores.lua' )

GM.HUDEntity = nil

surface.CreateFont("Arial", 14, 500, true, false, "InfoSmaller")
surface.CreateFont("Arial", 16, 500, true, false, "InfoSmall")
surface.CreateFont("Arial", 26, 500, true, false, "InfoMedium")

surface.CreateFont( "Trebuchet MS", 16, 700, true, false, "ScoreSmall" )
surface.CreateFont( "Trebuchet MS", 20, 700, true, false, "ScoreMedium" )
surface.CreateFont( "Trebuchet MS", 28, 700, true, false, "ScoreBig" )
surface.CreateFont( "Trebuchet MS", 60, 700, true, false, "ScoreHuge" )
surface.CreateFont( "Trebuchet MS", 28, 700, true, false, "Tips" )

surface.CreateFont( "HalfLife2", 108, 400, true, false, "HalfLife2" )
surface.CreateFont( "HalfLife2", 140, 400, true, false, "HalfLife2Big" )

function GM:Initialize()

	util.PrecacheSound("npc/turret_floor/ping.wav")

end

GM.BeeperCreated = false
GM.LastBeeps = 0
GM.YourPropsBrokenChain = {}
function GM:OnRoundStartClient()

	self.BeeperCreated = false
	self.LastBeeps = 0
	self.YourPropsBrokenChain = {}
	
end

function GM:Think()

	local viewmodel = LocalPlayer():GetViewModel()
	if ValidEntity(viewmodel) then
		local mymat = LocalPlayer():GetMaterial()
		// Transfer player model material to view model
		viewmodel:SetMaterial(mymat)	
	end
	
	local timeleft = GetGlobalFloat( "RoundEndTime", 0 ) - CurTime()
	if GetGlobalBool( "InRound", false ) and !self.BeeperCreated and timeleft <= 11 and timeleft > 10 and self.LastBeeps < 9 then
		self.BeeperCreated = true
		timer.Create("last10secsbeep", 1, 9, function()
			if ValidEntity(LocalPlayer()) then
				LocalPlayer():EmitSound("npc/turret_floor/ping.wav", 150, 100 + 2 * self.LastBeeps)
				self.LastBeeps = self.LastBeeps + 1
			end
		end)
	end
	

end

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:PlayerBindPress( pl, bind, pressed ) 

	// This way players can't control their trajectory in the air
	if (string.find(bind, "+back") and not pl:IsOnGround() and !pl:CanBreakTrajectory()) then return true end


end

function GM:CalcView( pl, origin, angles, fov ) 

	if pl:IsAbsorbed() and ValidEntity(pl:GetAbsorber()) then
	
		local view = {}
		local shooter = pl:GetAbsorber()
			
		view.angles = shooter:EyeAngles()//LerpAngle( 50, angles, shooter:EyeAngles() )
		view.origin = shooter:GetShootPos()+(shooter:GetAimVector()*-30)+(shooter:GetAimVector():Angle():Right()*10)//LerpVector( 50, origin, shooter:GetShootPos()+(shooter:GetAimVector()*-30) )
		
		return view
		
	else
		return self.BaseClass:CalcView( pl, origin, angles, fov )
	end


end

function GM:PaintSplashScreen( w, h )
	
	local left_x = w/2-300
	local top_y = h/2-100
	draw.DrawText( self.RealHelp, "ScoreMedium", left_x, top_y, Color(255,255,255,255), TEXT_ALIGN_LEFT )

end

/* ---------------
	Usermessages
*/ ---------------

function UMSG_UpdatePropCount( um )
	
	teaminfo[TEAM_RED].PropCount = um:ReadShort()
	teaminfo[TEAM_RED].TotalPropValue = um:ReadShort()
	teaminfo[TEAM_BLUE].PropCount = um:ReadShort()
	teaminfo[TEAM_BLUE].TotalPropValue = um:ReadShort()
end
usermessage.Hook("update_propcount",UMSG_UpdatePropCount)

function UMSG_ForceUse( um )
	
	RunConsoleCommand( "use", um:ReadString() )
	
end
usermessage.Hook("force_use",UMSG_ForceUse)

function UMSG_ScoreChainUpdate( um )
	
	local pl = um:ReadEntity()
	local size = um:ReadShort()
	local endtime = um:ReadFloat()
	
	pl:UpdateChain(size, endtime)
	
end
usermessage.Hook("chainupdate",UMSG_ScoreChainUpdate)

function UMSG_ScoreChainRemove( um )
	
	local pl = um:ReadEntity()
	pl:RemoveChain()
	
end
usermessage.Hook("chainbroken",UMSG_ScoreChainRemove)

GM.ScoresReceived = -10000
function UMSG_TopRoundScores( um )

	GAMEMODE.ScoresReceived = CurTime()

	scoreinfo.MostPropsBroken.player = um:ReadString()
	scoreinfo.MostPropsBroken.score = um:ReadShort()
	scoreinfo.MostPropsBroken.team = um:ReadShort()
	scoreinfo.MostPlayersLaunched.player = um:ReadString()
	scoreinfo.MostPlayersLaunched.score = um:ReadShort()
	scoreinfo.MostPlayersLaunched.team = um:ReadShort()
	scoreinfo.MostPoints.player = um:ReadString()
	scoreinfo.MostPoints.score = um:ReadShort()
	scoreinfo.MostPoints.team = um:ReadShort()
	scoreinfo.MostAssistPoints.player = um:ReadString()
	scoreinfo.MostAssistPoints.score = um:ReadShort()
	scoreinfo.MostAssistPoints.team = um:ReadShort()
	scoreinfo.MostKills.player = um:ReadString()
	scoreinfo.MostKills.score = um:ReadShort()
	scoreinfo.MostKills.team = um:ReadShort()

end
usermessage.Hook("toproundscores",UMSG_TopRoundScores)

function UMSG_TopRoundScores2( um )

	scoreinfo.MostFallDamage.player = um:ReadString()
	scoreinfo.MostFallDamage.score = um:ReadShort()
	scoreinfo.MostFallDamage.team = um:ReadShort()
	scoreinfo.PropsBrokenChainRecord.player = um:ReadString()
	scoreinfo.PropsBrokenChainRecord.score = um:ReadShort()
	scoreinfo.PropsBrokenChainRecord.team = um:ReadShort()
	
	scoreinfo.LongestChain.numplayers = um:ReadShort()
	scoreinfo.LongestChain.team = um:ReadShort()
	for i = 1, scoreinfo.LongestChain.numplayers do
		table.insert(scoreinfo.LongestChain.players, um:ReadString())
	end

end
usermessage.Hook("toproundscores2",UMSG_TopRoundScores2)

function UMSG_NotifyScoreChange( um )

	local value = um:ReadShort()
	local team = um:ReadShort()

	table.insert(GAMEMODE.ScoreNotes, { val = value, forteam = team, time = CurTime() })
end
usermessage.Hook("notifyscorechange",UMSG_NotifyScoreChange)

function UMSG_ReceiveHintText( um )

	local value = um:ReadShort()
	local team = um:ReadShort()

	table.insert(GAMEMODE.ScoreNotes, { val = value, forteam = team, time = CurTime() })
end
usermessage.Hook("notifyscorechange",UMSG_ReceiveHintText)

function UMSG_ReceiveTip( um )
	local str = um:ReadString()
	local type = um:ReadShort()
	local length = um:ReadShort()

	GAMEMODE:AddNotify( str, type, length )
end
usermessage.Hook("gamenotify",UMSG_ReceiveTip)

function UMSG_PlayMusic( um )
	local music = um:ReadString()
	surface.PlaySound(music)
end
usermessage.Hook("playmusic",UMSG_PlayMusic)

function UMSG_SetPropsBrokenChain( um )
	local model = um:ReadString()
	table.insert(GAMEMODE.YourPropsBrokenChain, model)
end
usermessage.Hook("setpropsbroken",UMSG_SetPropsBrokenChain)

function UMSG_ResetPropsBrokenChain( um )
	GAMEMODE.YourPropsBrokenChain = {}
end
usermessage.Hook("resetpropsbroken",UMSG_ResetPropsBrokenChain)
