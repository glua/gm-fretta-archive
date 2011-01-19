
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_hud.lua");
AddCSLuaFile("cl_help.lua");
AddCSLuaFile("cl_scoreboard.lua");
AddCSLuaFile("cl_selectscreen.lua");
AddCSLuaFile("cl_splashscreen.lua");
AddCSLuaFile("sh_chataddtext.lua");
AddCSLuaFile("cl_voice.lua");
AddCSLuaFile("sh_ghost.lua");
AddCSLuaFile("sh_cache.lua");
AddCSLuaFile("globalshits.lua");
AddCSLuaFile("cl_killnotices.lua");
AddCSLuaFile("cl_targetid.lua");

for k, v in pairs(file.FindInLua(GM.Folder:Replace("gamemodes/", "") .. "/gamemode/scoreboard/*.lua")) do
	AddCSLuaFile("scoreboard/" .. v);
end

AddCSLuaFile("sh_ply_extensions.lua");
AddCSLuaFile("sh_player.lua");
AddCSLuaFile("sh_roundtimer.lua");

include("shared.lua")
include("sv_download.lua")
include("sv_mapcontrol.lua")


function GM:Initialize()
	
	self.BaseClass:Initialize();
	
	self:SetState(self.STATE_WAITING);
	
	timer.Simple(.1, self.RemoveDoors, self);
	
	self.Ending = false;
	
	self.NextRoundSalsa = nil;
	
	self.Changing = false;
	
	self.CanStartDead = 0;
	
	timer.Simple(.1, self.CacheStuff, self);
	
end



function GM:PlayerDisconnected(ply)
	
	local t = nil;
	
	if (self:IsPlaying()) then
		
		if (ply:IsUC()) then
			t = "pigs";
		end
		
		if (team.AlivePlayers(self.TEAM_PIGS) < 1) then
			t = "uc";
		end
		
	end
	
	if (t != nil) then
		self:EndCountdown(self.ResetGame, t);
	end
	
end


function GM:PlayerSetModel(ply)
	
	if (ply:IsUC()) then
		ply:SetModel("models/UCH/uchimeraGM.mdl");
		ply:SetSkin(0);
		ply:SetBodygroup(1, 1);
	else
		if (ply:IsGhost()) then
			ply:SetModel("models/UCH/mghost.mdl");
			
			local b = (ply.Fancy || false);
			if (b) then
				ply:SetBodygroup(1, 1);
			else
				ply:SetBodygroup(1, 0);
			end
		else
			ply:SetModel("models/UCH/pigmask.mdl");
			ply:SetRankBodygroups();
			ply:SetRankSkin();
		end
	end
	
end

function GM:PlayerLoadout(ply)
	
	ply:StripWeapons();
	
end


function GM:IsSpawnpointSuitable(ply, spawn, bool)
	return true;
end


function GM:PlayerSpawn(ply)
	
	ply:UnSpectate();
	
	
	if (ply:IsBot() && !ply.TakenCareOf) then
		ply.TakenCareOf = true;
		ply:SetTeam(self.TEAM_PIGS);
		ply:Spawn();
	end
	
	ply:Freeze(ply.Frozen);
	
	ply:SetupSpeeds();
	
	ply:SetView(48);
	ply:SetJumpPower(242);
	
	ply:SetSprinting(false);
	
	ply:SetSprint(1);
	
	ply:SetPancake(false);
	
	ply.LastUC = false;
	ply:SetNWBool("UC_Voted", false);
	
	ply:UnScare(false);
	ply:ResetUCVars();
	
	ply:SetDead(false);
	
	ply:StopTaunting();
	
	ply:SetDuckSpeed(.25); //blah hacky
	
	if (ply:Team() == self.TEAM_SPECTATE) then
		
		if (!ply:IsGhost()) then
			ply:SetGhost(true);
		end
		
	else
		
		if (self:IsPlaying()) then
		
			//do stuff to a player when the game starts
			if (ply:IsUC()) then
				
				if (ply:IsGhost()) then
					ply:SetGhost(false);
				end
				

				ply.LastUC = true;
				
				ply:SetTeam(self.TEAM_UC);
				ply:SetJumpPower(260);
				ply:SetSwipeMeter(1);
				ply:SendLua("LocalPlayer().SwipeMeterSmooth = 1;");
				ply:SetSprint(1);
				ply:SendLua("LocalPlayer().SprintMeterSmooth = 1;");
				
			else
				
				if (ply:Team() == self.TEAM_UC) then
					ply:SetTeam(self.TEAM_PIGS);
				end
				
				ply.UCChance = (ply.UCChance || 0);
				ply.UCChance = math.Clamp((ply.UCChance + 1), 1, 10);
				
				if (CurTime() >= self.CanStartDead && team.AlivePlayers(self.TEAM_PIGS) < team.NumPlayers(self.TEAM_PIGS) && !ply:IsGhost()) then
					ply:SetGhost(true);
				end
				
			end
			
			if (!ply:IsGhost()) then
				if (!ply:HasCustomRank()) then
					ply:SetRank(ply.NextRank);
				end
			end
			
			ply:PlaySpawnSound();
			
		else
			self.NextRoundSalsa = nil;
			if (!ply:IsGhost()) then
				ply:SetGhost(true);
			end
		end
		
		if (self:GetState() == self.STATE_WAITING) then
			if (self:EnoughPlayers()) then
				self:StartCountdown(self.StartGame);
			end
		end
		
		
	end
	
	if (ValidEntity(ply.Ragdoll)) then
		ply.Ragdoll:Remove();
	end
	
	hook.Call("PlayerSetModel", self, ply);
	
	self:UpdateHull(ply);
	
end


function GM:PlayerInitialSpawn(ply)

	self.BaseClass:PlayerInitialSpawn(ply);
	ply:SetupVariables();
	
	ply:SpectateEntity(NULL);
	ply:UnSpectate();
	
	ply:SetGhost(true);
	ply:SetCanZoom(false);
	
	timer.Simple(.1, ply.SendLua, ply, "surface.PlaySound(\"UCH/music/start.mp3\")");
	timer.Simple(.5, ply.SendLua, ply, "LocalPlayer().VoteMusic = \"music3.mp3\"");
	
	ply:SendLua("GAMEMODE:CacheStuff()");
	
end


function GM:PlayerJoinTeam(ply, id)
	
	local pos = ply:GetPos();
	local ang = ply:EyeAngles();
	local vel = ply:GetVelocity();

	self.BaseClass:PlayerJoinTeam(ply ,id);
	ply:Spawn();
	ply:SetPos(pos);
	ply:SnapEyeAngles(ang);
	ply:SetLocalVelocity(vel);
	
end


function GM:PlayerSelectSpawn(ply)
	
	if (ply:IsUC()) then
		
		local spawntype = 1;
		local map = game.GetMap();
		if (file.Exists("UC_spawns/" .. map .. ".txt")) then //read from file
			spawntype = 2;
		elseif (#ents.FindByClass("chimera_spawn") >= 1) then //spawn at random chimera spawn
			spawntype = 3;
		else //map not supported
			ply:ChatPrint(map .. " isn't supported by this gamemode!");
			spawntype = 1;
		end
		
		if (spawntype != 1) then
					
			if (spawntype == 2) then
				
				self.UCSpawns = (self.UCSpawns || {});
				
				local map = game.GetMap();
				local file = file.Read("UC_spawns/" .. map .. ".txt");
				file = string.Explode("\n", file);
				local pos, ang = string.Explode(" ", file[1]), string.Explode(" ", file[2]);
				local x, y, z = tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3]);
				local p, yy, r = tonumber(ang[1]), tonumber(ang[2]), tonumber(ang[3]);
				
				local identify = tostring(x) .. tostring(y) .. tostring(z);
				
				if (!self.UCSpawns[identify]) then
					local targ = ents.Create("info_target");
					targ:SetPos(Vector(x, y, z));
					targ:SetAngles(Angle(p, yy, r));
					targ:Spawn();
					self.UCSpawns[identify] = targ;
					return targ;
				else
					return self.UCSpawns[identify];
				end
				
			else
				
				local spawns = ents.FindByClass("chimera_spawn");
				return spawns[math.random(1, #spawns)];
				
			end
			
		end
		
	end
	
	
	if ((ply:Team() == self.TEAM_PIGS || ply.LastUC || ply:IsGhost()) && !ply:IsUC()) then
		return self.BaseClass:PlayerSelectSpawn(ply);
	end
	
	//TF2 maps, load from file
	//Chimera Spawn, find entity
	//Neither, map not supported
	
end


function GM:PlayerDeathThink(ply)
	
	if (self:IsPlaying() || self:GetState() == self.STATE_ENDCOUNTDOWN) then
		return;
	else
		self.BaseClass:PlayerDeathThink(ply);
	end
	
end


function GM:PlayerDeath(ply, wep, kill)

	//self.BaseClass:PlayerDeath(ply, wep, kill);
	
	ply:Freeze(false);
	ply.Frozen = false;
	
	ply:UnScare(false);
	ply:StopTaunting();
	
	ply:SetSprinting(false);
	
	ply:AddDeaths(1);
	
	local t = nil;
	
	if (ply:Team() == self.TEAM_PIGS) then
	
		ply:SetGhost(true);
		
		if (!ply:IsSalsa() && team.AlivePlayers(self.TEAM_PIGS) <= 0 && self:IsPlaying()) then
			t = "uc";
		end
		
		ply:SendLua("surface.PlaySound(\"UCH/music/cues/pig_die.mp3\")");
		
	end
	
	if (ply:IsUC() && self:IsPlaying()) then
		
		t = "pigs";
		
	end
	
	if (t != nil && self:IsPlaying()) then
		self:EndCountdown(self.ResetGame, t);
	end
	
end


function GM:DoPlayerDeath(ply, wep, kill)
	
	//self.BaseClass:DoPlayerDeath(ply, wep, kill);
	
end



function GM:CheckForBrokenTimers()
	
	if (self.TimerCheck != false && self.TimerCheck != true) then
		self.TimerCheck = true;
	end
	
	if (CurTime() >= (self.LastTimerCheck || 0)) then
		self.LastTimerCheck = (CurTime() + 2);
		if (self.TimerCheck) then
		
			self.TimerCheck = false;
			timer.Simple(1, function()
				self.TimerCheck = true; //We're working  :D
			end);
			
		else	//fuck, timers broke  :|
		
			self.LastTimerCheck = (CurTime() + 100000);
			
			local map = GetRandomGamemodeMap("ultimatechimerahunt");
			chat.AddText(Color(250, 250, 250, 255), "Timer's are broken, this will be fixed at some point.  Changing level to " .. map);
			self.WaitForMapChange = (CurTime() + 5);
			self.ShouldMapChange = true;
			self.NextMap = map;
		
		end
	end
end



function GM:SendKillNotice(str, ent1, ent2)
	
	umsg.Start("KillNotice")
		umsg.String(str);
		umsg.Entity(ent1);
		if (ent2 && ValidEntity(ent2)) then
			umsg.Entity(ent2);
		end
	umsg.End()
	
end

function GM:DoKillNotice(ply)
	if (ply:IsUC()) then
		if (ply.Pressed && ValidEntity(ply.Presser)) then
			GAMEMODE:SendKillNotice("press", ply, ply.Presser);
			ply.Pressed = false;
			ply.Presser = nil;
		else
			GAMEMODE:SendKillNotice("skull", ply);
		end
	else
		//if (!ply:IsGhost()) then
			if (ply.Squished) then
				ply.Squished = false;
				GAMEMODE:SendKillNotice("pop", ply, GAMEMODE:GetUC());
				return;
			end
			if (ply.Bit) then
				ply.Bit = false;
				GAMEMODE:SendKillNotice("bite", ply, GAMEMODE:GetUC());
				return;
			end
			if (ply.Suicide) then
				ply.Suicide = false;
				GAMEMODE:SendKillNotice("suicide", ply);
				return;
			end
			GAMEMODE:SendKillNotice("skull", ply);
		//end
	end
end



function GM:EntityKeyValue(ent, key, value)
	
	//set keyvalues?  Is this needed?
	
end


function GM:BackToWaiting()
	
	self:SetState(self.STATE_WAITING);
	self:RemoveUC();
	self:FreezePlayers(false);
	self:ResetPlayers();
	
end


function GM:StartGame()
	//start game, choose round, etc.
	
	self:FreezePlayers(false);
	
	if (!self:EnoughPlayers()) then
		print("GAME TRIED TO START, NOT ENOUGH PLAYERS!");
		return;
	end
	
	self.CanStartDead = (CurTime() + 5);
	
	game.CleanUpMap();
	self:RemoveDoors();
	
	self:SalsaCheck();
	
	self:StartTimer();
	
	self:NewUC();
	
	self.Votes = 0;
	
	self:SetState(self.STATE_PLAYING);
	self:ResetPlayers();
	
	//self:StopCountdown();
end


function GM:ResetGame()
	
	if (self:GetState() == self.STATE_ENDCOUNTDOWN && (self.GetTimeLimit() - CurTime()) <= (2 * 60)) then
		self:EndOfGame(true);
		
		self.WinningTeam = (self.WinningTeam || nil);
		local t = self.WinningTeam;
		if (t != nil) then
			local music = (t == "uc" && "music1") || "music2";
			for k, v in pairs(player.GetAll()) do
				v:SendLua("LocalPlayer().VoteMusic = \"" .. music .. ".mp3\";");
			end
		end
		
		return;
	end
	
	if (self.IsEndOfGame) then
		return;
	end
	
	local rag = self.UCRagdoll;
	if (ValidEntity(rag)) then
		rag:Remove();
	end
	local bird = self.BirdProp;
	if (ValidEntity(bird)) then
		bird:Remove();
	end
	
	timer.Destroy("CountdownToStart");
	timer.Destroy("CountdownToEnd");
	
	if (self:EnoughPlayers()) then
		
		self:StartGame();
	
	else
		
		self:BackToWaiting();
		
	end
	
end


function GM:StartCountdown(func)
	
	self:FreezePlayers(true);
	self:SetState(self.STATE_COUNTDOWN);
	timer.Create("CountdownToStart", self.CountdownStartTime, 1, func, self);
	
end


function GM:EndCountdown(func, t)
	
	self:NewSalsa();
	
	self:SetState(self.STATE_ENDCOUNTDOWN);
	timer.Create("CountdownToEnd", self.CountdownEndTime, 1, func, self);
	
	self.WinningTeam = t;
	
	local uc = self:GetUC();
	
	if (t == "uc") then
		for k, v in pairs(player.GetAll()) do
			if (ValidEntity(v)) then
			
				local music = "";
				if (v:IsUC() || v:Team() == self.TEAM_SPECTATE) then
					music = "chimera_win";
				else
					music = "pigs_lose";
				end
				
				v:SendLua("surface.PlaySound(\"UCH/music/cues/" .. music .. ".mp3\")");
				
			end
		end
		uc:AddFrags(2);
	elseif (t == "pigs") then
		for k, v in pairs(player.GetAll()) do
			if (ValidEntity(v)) then
			
				local music = "";
				if (v:Team() == self.TEAM_PIGS || v:IsGhost()) then
					music = "pigs_win";
				else
					music = "chimera_lose";
				end
				
				v:SendLua("surface.PlaySound(\"UCH/music/cues/" .. music .. ".mp3\")");
				
			end
		end
	end
	
	if (t == "tie") then
		for k, v in pairs(player.GetAll()) do
			if (ValidEntity(v)) then
				
				v:Kill();
				v.NextRank = math.Clamp((v:GetRankNum() - 1), 1, 4);
				v:SendLua("surface.PlaySound(\"UCH/music/cues/round_timer.mp3\")");
				
			end
		end
	end
	
end

function GM:StopCountdown()
	
	self:FreezePlayers(false);
	if (timer.IsTimer("CountdownToStart")) then
		timer.Destroy("CountdownToStart");
	end
	self:CheckForPlayers();
	
end


function GM:EnoughPlayers()
	
	//check for the amount of players, return true if there are enough
	
	return (team.NumPlayers(self.TEAM_PIGS) + team.NumPlayers(self.TEAM_UC)) > self.NumPlayers;
end


function GM:CheckForPlayers()
	
	if (team.NumPlayers(self.TEAM_PIGS) <= self.NumPlayers) then
		
		self:StartCountdown(self.BackToWaiting);
		
	end
	
end


function GM:CountVotes()
	
	local plys = team.NumPlayersNotBots(self.TEAM_PIGS);
	local votes = self.Votes;
	
	if (votes >= math.ceil((plys * .5))) then
		chat.AddText(Color(255, 255, 255, 255), "Round restart initiated!");
		for k, v in pairs(player.GetAll()) do
			v:SendLua("surface.PlaySound(\"UCH/music/cues/new_uc_voted.mp3\")");
		end
		self:FreezePlayers(true);
		self:EndCountdown(self.ResetGame, "");
	end
	
end


function GM:VoteRoundChange(ply)
	
	if (ply:GetNWBool("UC_Voted", true) || ply:IsUC() || !self:IsPlaying() || ply:Team() != self.TEAM_PIGS) then
		return;
	end
	
	ply:SetNWBool("UC_Voted", true);
	self.Votes = (self.Votes + 1);
	
	local str =  (tostring(self.Votes) .. "/" .. tostring(math.ceil((team.NumPlayersNotBots(self.TEAM_PIGS) * .5))));
	chat.AddText(Color(250, 200, 200, 255), ply:GetName(), Color(250, 250, 250, 255), " voted for a new UC.  ", Color(62, 255, 62, 255), "(" .. str .. ")");
	
	self:CountVotes();
	
end


local function VoteChange(ply, cmd, args)
	
	GAMEMODE:VoteRoundChange(ply);
	
end
concommand.Add("uch_vote", VoteChange);


function GM:CountVotesForChange()

	if ( CurTime() >= GetConVarNumber( "fretta_votegraceperiod" ) ) then // can't vote too early on
	
		if ( GAMEMODE:InGamemodeVote() || GAMEMODE.Changing ) then return end

		fraction = GAMEMODE:GetFractionOfPlayersThatWantChange()
		
		if ( fraction > fretta_votesneeded:GetFloat() ) then
			GAMEMODE.Changing = true;
			GAMEMODE:EndOfGame(true);
			timer.Simple(8, GAMEMODE.StartGamemodeVote, GAMEMODE);
			return false
		end
		
	end

	return true
end


function GM:OnEndOfGame()
	
	self.BaseClass:OnEndOfGame();
	for k, v in pairs(player.GetAll()) do
		v:SendLua("surface.PlaySound(\"UCH/music/cues/gameend.mp3\") timer.Simple(4, surface.PlaySound, \"UCH/music/cues/gameend.mp3\")");
	end
	
end

