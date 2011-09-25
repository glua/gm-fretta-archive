AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )
include( "downloads.lua" )

GM.MaxRounds = CreateConVar( "ob_maxrounds", "3", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )
GM.MaxPoints = CreateConVar( "ob_pointstowin", "120", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE )

GM.GodTime = 3

GM.TimeRed = 0
GM.TimeBlue = 0

function GM:OnPreRoundStart( num )
	self.BaseClass:OnPreRoundStart()

	for k,v in pairs(player.GetAll()) do
		self.TimeRed = 0
		self.TimeBlue = 0
		v:SetFrags(0)
		v:SetDeaths(0)
		v:SetNWBool("HasOddBall",false)
		v:SetNWInt("Time",0)
		v:Spawn()
	end

	--Each round we start fresh.
end

function GM:GetTeamTime(t)
	if t == TEAM_RED then
		return self.TimeRed
	elseif t == TEAM_BLUE then
		return self.TimeBlue
	end
end

function GM:AddTeamTime(t)
	if t == TEAM_RED then
		self.TimeRed = self.TimeRed + 1
	elseif t == TEAM_BLUE then
		self.TimeBlue = self.TimeBlue + 1
	end
end

function GM:DoBallPoints(t) --Called by the swep every second a player is holding the ball.

	self:AddTeamTime(t)

	local maxpoints = GetConVar("ob_pointstowin"):GetInt()

	if self:GetTeamTime(t) >= maxpoints then
		team.AddScore( t, 1 )
		self:RoundTimerEnd() --End the round like we normally would by ending the round timer.
	end
end

function GM:PlayerSetModel(ply)
	local RedModels	= {"alyx","barney","eli","monk","mossman","odessa"}
	local BlueModels = {"police","combine_super_soldier","combine_soldier_prisonguard","combine_soldier"}
	local modelname

	--Combine V. Humans

	if ply:Team() == TEAM_RED then
		modelname = "models/player/" ..table.Random(RedModels).. ".mdl"
		util.PrecacheModel(modelname)
		ply:SetModel(modelname)
	elseif ply:Team() == TEAM_BLUE then
		modelname = "models/player/" ..table.Random(BlueModels).. ".mdl"
		util.PrecacheModel(modelname)
		ply:SetModel(modelname)
	end
end

function GM:DoGod(ply,HP)

	ply:SetHealth(9999)
	ply:SetColor(255, 255, 255, 100)

	timer.Simple(self.GodTime,function()
		if ply:IsValid() then
			ply:SetHealth(HP)
			ply:SetColor(255, 255, 255, 255)
		end
	end)
end

function GM:Announce(id,str)
	for _, p in pairs(player.GetAll()) do
		p:PrintMessage(HUD_PRINTCENTER,team.GetName(id).." "..str)
	end
end

function GM:PlayerDisconnected(ply)
	self:DropBall(ply) --Asshole drop the ball NOW!
end

function GM:DropBall(ply)
	if ply:GetNWBool("HasOddBall",false) == true then --If they have the ball..

		ply:StripWeapon("weapon_oddball")

		local newball = ents.Create("oddball")
		newball:SetPos(ply:GetPos() + ply:GetUp()*32)
		newball:SetAngles(ply:GetAngles())
		newball:Spawn() --Make a new ball, because the SWEP was in its place for the time being

		local phys = newball:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:SetVelocity(ply:GetVelocity()) --Make it fly forward with the player
		end

		ply:SetNWBool("HasOddBall",false) --They don't have it anymore.
		self:BallDropped(ply) --Play them sounds
	end
end

function GM:BallPickUp(ply)
	self:Announce(ply:Team(), "has the OddBall!")

	ply:EmitSound("ambient/alarms/klaxon1.wav", 100, 100)

	for k,v in pairs(player.GetAll()) do
		v:ConCommand("play oddball/captured.wav")
	end
end

function GM:BallDropped(ply)

	self:Announce(ply:Team(), "dropped the OddBall!")

	ply:EmitSound("npc/roller/code2.wav", 100, 100)

	for k,v in pairs(player.GetAll()) do
		v:ConCommand("play oddball/dropped.wav")
	end
end

function GM:RoundEnd( t )
	self.BaseClass:RoundEnd()
	
	for k,v in pairs(player.GetAll()) do
		if v:HasWeapon("weapon_oddball") then
			v:SetNWBool("HasOddBall",false)
			v:StripWeapon("weapon_oddball")
			v:ConCommand("lastinv") --Remove the weapon and switch to the last used weapon. Why? So the teams stop getting points.
		end
	end
	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "oddball" then
			v:Remove() --Remove the oddball from the map after a team has won. Why? So the teams stop getting points.
		end
	end
end

function GM:OnRoundResult( t )
	
	local maxrounds = GetConVar("ob_maxrounds"):GetInt()
	
	if GetGlobalInt( "RoundNumber" ) >= maxrounds then
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end

	if self:GetTeamTime( TEAM_RED ) < self:GetTeamTime( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Blue Team has won the round!")
			v:ConCommand("play oddball/bluewins.wav")
		end
	elseif self:GetTeamTime( TEAM_RED ) > self:GetTeamTime( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Red Team has won the round!")
			v:ConCommand("play oddball/redwins.wav")
		end
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Round draw!")
		end
	end

end

function GM:PlayerDeath(ply, inflictor, attacker)

	self.BaseClass:PlayerDeath(ply, inflictor, attacker)
	
	timer.Simple(2, function()
		if ply and attacker and ply:IsValid() and attacker:IsValid() and ply:IsPlayer() and attacker:IsPlayer() and ply != attacker then
			ply:ConCommand("play misc/freeze_cam.wav")
			ply:SpectateEntity(attacker)
			ply:Spectate(OBS_MODE_FREEZECAM)
		end
	end)

	self:DropBall(ply) --Asshole drop the ball NOW!

	ply:EmitSound("player/death"..math.random(1,6)..".wav", 100, 100) --Normal death sounds, not the annoying BEEP BEEEEP
	
end

function GM:PlayerDeathSound()
	return true --FUCK YOU
end