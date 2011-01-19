
GM.Name 	= "Ultimate Chimera Hunt";
GM.Author 	= "Aska and FluxMage";
GM.Email 	= "";
GM.Website 	= "";

DeriveGamemode("fretta")

include("sh_player.lua")
include("sh_chataddtext.lua")
include("globalshits.lua")
include("sh_roundtimer.lua")
include("sh_cache.lua");

//Fretta variables
GM.Help	= "Turn off the Ultimate Chimera, and don't get bit.";
GM.TeamBased = true;
GM.AutomaticTeamBalance = false;
GM.ForceJoinBalancedTeams = false;

GM.AllowSpectating = false;
GM.SelectClass = false;

GM.ValidSpectatorModes = {};
GM.ValidSpectatorEntities = {};

GM.GameLength = 25;
GM.VotingDelay = 8;
 
GM.EnableFreezeCam = false;
 
GM.SelectModel = false;
GM.SelectColor = false;

GM.RoundBased = false;


//Gamemode variables
GM.CountdownStartTime = 4; //time in seconds the countdown lasts before a game starts
GM.CountdownEndTime = 10; //time in seconds the countdown lasts before a game ends/resets

GM.CustomRanksAllowed = false;

GM.NumPlayers = 1;


//Player variables
GM.SprintRecharge = .0062;
GM.SprintDrain = .015;
GM.DJump_Penalty = .042;


GM.TEAM_PIGS = 1;
GM.TEAM_UC = 2;
GM.TEAM_SPECTATE = 3;


//states
GM.STATE_WAITING = 1;
GM.STATE_COUNTDOWN = 2;
GM.STATE_PLAYING = 3;
GM.STATE_ENDCOUNTDOWN = 4;


PrecacheParticleSystem("sprint_dust");
PrecacheParticleSystem("uch_ghost_smoke");


function GM:CreateTeams()
	
	team.SetUp(self.TEAM_PIGS, "Pigmasks", Color(225, 150, 150), true);
	team.SetSpawnPoint(self.TEAM_PIGS, {"info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_teamspawn"});
		
	team.SetUp(self.TEAM_UC, "Ultimate Chimera", Color(230, 30, 110, 255), false);
	team.SetSpawnPoint(self.TEAM_UC, {"info_player_start", "info_player_terrorist", "info_player_counterterrorist"});
	
	team.SetUp(self.TEAM_SPECTATE, "Spectators", Color(225, 225, 225), true);
	team.SetSpawnPoint(self.TEAM_SPECTATE, {"info_player_start", "info_player_terrorist", "info_player_counterterrorist", "info_player_teamspawn"});

end

function GM:SetState(state)
	SetGlobalInt("GamemodeState", state);
end

function GM:GetState()
	return GetGlobalInt("GamemodeState", self.STATE_WAITING);
end

function GM:IsPlaying()
	return (self:GetState() == self.STATE_PLAYING);
end


function GM:CustomRanks()
	SetGlobalBool("CustomRanks", self.CustomRanksAllowed);
	return GetGlobalBool("CustomRanks", false);
end


function GM:Think()
	
	self.BaseClass:Think()
	
	if (SERVER) then
		self:SprintThink();
		self:ScareThink();
		self:UCThink();
		self:JumpThink();
		
		self:RoundTimeThink();
		
		for k, v in pairs(player.GetAll()) do
			if (v:Team() == self.TEAM_PIGS && !v:IsGhost() && !v:HasCustomRank() && !v:IsSalsa()) then
				v:MakePiggyNoises();
			end
		end
		
		self:CheckForBrokenTimers();
		
		if (self.ShouldMapChange) then
			if (CurTime() >= self.WaitForMapChange) then
				self.WaitForMapChange = (CurTime() + 100);
				RunConsoleCommand("changegamemode", (self.NextMap || GetRandomGamemodeMap("ultimatechimerahunt")), "ultimatechimerahunt");
			end
		end
		
		for k, ply in pairs(player.GetAll()) do
			if (ply:WaterLevel() > 0) then
				
				if (ply:IsOnGround() && ply:WaterLevel() <= 2) then
					if (ply:GetNWBool("Swimming", false)) then
						ply:SetNWBool("Swimming", false);
					end
				else
					if (!ply:GetNWBool("Swimming", false)) then
						ply:SetNWBool("Swimming", true);
					end
				end
				
			else
				
				if (ply:GetNWBool("Swimming", false)) then
					ply:SetNWBool("Swimming", false);
				end
				
			end
		end
		
	end
	
end


local function ShouldCollide(ent1, ent2)
	if (ValidEntity(ent1) && ValidEntity(ent2)) then
		
		if (ValidEntity(GetGlobalEntity("UltimateChimera"))) then
			if ((ent1 == GetGlobalEntity("UltimateChimera") && !ent1:Alive()) || (ent2 == GetGlobalEntity("UltimateChimera") && !ent2:Alive())) then
				return false;
			end
		end
		
		if (ent1:IsPlayer() && ent2:IsPlayer()) then
			if (ent1:Team() == ent2:Team()) then
				return false;
			end
			if (ent1:IsPancake() || ent2:IsPancake()) then
				return false;
			end
		end
		if ((ent1:GetNWBool("UCGhost", false) || ent2:GetNWBool("UCGhost", false))) then
			return false;
		end
		if (((ent1:GetClass() == "prop_ragdoll" && ent1.CollideVar) && !ent2:IsWorld()) || ((ent2:GetClass() == "prop_ragdoll" && ent2.CollideVar) && !ent1:IsWorld())) then
			return false;
		end
	
	end
end
hook.Add("ShouldCollide", "UCH_ShouldCollide", ShouldCollide);


function team.AlivePlayers(t)
	local num = 0;
	for k, v in pairs(team.GetPlayers(t)) do
		if (v:Alive() && !v:IsGhost()) then
			num = (num + 1);
		end
	end
	return num;
end

function team.NumPlayersNotBots(t)
	local num = 0;
	for k, v in pairs(team.GetPlayers(t)) do
		if (!v:IsBot()) then
			num = (num + 1);
		end
	end
	return num;
end
