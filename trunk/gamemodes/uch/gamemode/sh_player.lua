
AddCSLuaFile("sh_ranks.lua");
AddCSLuaFile("sh_sprinting.lua");
AddCSLuaFile("sh_animation_controller.lua");
AddCSLuaFile("sh_uccontrol.lua");
AddCSLuaFile("sh_scared.lua");
AddCSLuaFile("sh_pancake.lua");
//AddCSLuaFile("sh_salsa.lua");

include("sh_ply_extensions.lua")
include("sh_ranks.lua")
include("sh_sprinting.lua")
include("sh_animation_controller.lua")
include("sh_ghost.lua")
include("sh_uccontrol.lua")
include("sh_scared.lua")
include("sh_pancake.lua")
//include("sh_salsa.lua")



function GM:FreezePlayers(b)
	for k, v in ipairs(player.GetAll()) do
		if (ValidEntity(v) && v:Team() != self.TEAM_SPECTATE) then
			v.Frozen = b;
			v:Freeze(b);
		end
	end
end

function GM:ResetPlayers()
	for k, v in ipairs(player.GetAll()) do
		if (ValidEntity(v) && v:Team() != self.TEAM_SPECTATE) then
		
			if (v:Team() == self.TEAM_PIGS && v:IsGhost()) then
				v:SetGhost(false);
			end
			
			if (timer.IsTimer(tostring(v) .. "SetGhostModels")) then
				timer.Destroy(tostring(v) .. "SetGhostModels");
			end
			
			v:Spawn();
			
		end
	end
end

function GM:NotifyPlayers(txt)
	chat.AddText(Color(255, 255, 255), txt);
end


function GM:KeyPress(ply, key)
	
	if (!ply:IsGhost() && ply:Team() == self.TEAM_PIGS) then
		
		self:SprintKeyPress(ply, key);
		
	end
	
	if (SERVER) then

		if (key == IN_ATTACK2 && ply:CanTaunt()) then
			
			local t, num = "taunt", 1.1;
			
			if (ply:GetRankNum() == 4) then
				t, num = "taunt2", 1;
			end
			
			ply:Taunt(t, num);
	
		end
		
		if (key == IN_USE || key == IN_ATTACK) then
			
			ply.LastPressAttempt = (ply.LastPressAttempt || 0);
			
			if (CurTime() < ply.LastPressAttempt) then
				return;
			end
			
			ply.LastPressAttempt = (CurTime() + .1);
			
			if (ply:Alive() && ply:Team() == self.TEAM_PIGS && !ply:IsGhost()) then
				
				if (ply:CanPressButton()) then
					local uc = self:GetUC();
					
					uc:EmitSound("UCH/chimera/button.mp3", 80, math.random(94, 105));
					
					uc.Pressed = true;
					uc.Presser = ply;
					
					ply:RankUp();
					uc:Kill();
					
					ply:AddFrags(1);
					
				end
				
			end
		end
		
		if (ply:IsUC()) then
			self:UCKeyPress(ply, key);
		end
		
		if (ply:IsSalsa() && !ply:IsGhost()) then
			self:SalsaKeyPress(ply, key);
		end
	
	else
		
		if (!ply:IsGhost() && (key == IN_ATTACK || key == IN_USE)) then
			LocalPlayer().XHairAlpha = 242;
		end
		
	end
	
end


function GM:Move(ply, move)
		
	if (ply:IsGhost()) then
		
		local move = ply:GhostMove(move);
		
		return move;
		
	else

		if (ply:IsTaunting() || ply:IsBiting() || ply:IsRoaring() || (ply:IsUC() && !ply:Alive())) then
			ply:SetLocalVelocity(Vector(0, 0, 0));
			
			if (ply.LockTauntAng == nil) then
				ply.LockTauntAng = ply:EyeAngles();
			end
			
			ply:SetEyeAngles(ply.LockTauntAng);
			
			return true;
		else
			ply.LockTauntAng = nil;
			return self.BaseClass:Move(ply, move);
		end
		
	end
	
end


function GM:GetUC()
	return GetGlobalEntity("UltimateChimera");
end


function GM:PlayerFootstep(ply, pos, foot, sound, volume, players)
	
	if (ply:IsUC() || ply:IsGhost()) then
		return true;
	end
	
end


function RestartAnimation(ply)
	
	//timer.Simple(.1, function()
	
		ply:AnimRestartMainSequence();
		
		umsg.Start("UC_RestartAnimation")
			umsg.Entity(ply);
		umsg.End()
		
	//end);
	
end



if (SERVER) then


function GM:PlayerSwitchFlashlight(ply, SwitchOn)
	if (ply:Team() == self.TEAM_PIGS) then
		umsg.Start("SwitchLight")
			umsg.Entity(ply);
		umsg.End()
	end
    return ((ply:Team() == self.TEAM_PIGS && !ply:IsGhost()) || !SwitchOn);
end


function GM:CanPlayerSuicide(ply)
	
	if (ply:IsGhost() || ply:IsUC() || ply:IsSalsa()) then
		return false;
	end
	ply.RespawnCheck = true;
	
	if (ply:Alive()) then
		if (self:IsPlaying()) then
			ply:ResetRank();
		end
		ply.Suicide = true;
		ply:Kill();
	end
	
	return false;
	
end

function GM:OnPlayerChangedTeam(ply, oldteam, newteam)
	
	ply.RespawnCheck = true;
	self.BaseClass:OnPlayerChangedTeam(ply, oldteam, newteam);
	
end


function GM:UpdateHull(ply)
	
	if (!ValidEntity(ply)) then
		return;
	end
	
	if (ply:IsUC()) then
		ply:SetHull(Vector(-25, -25, 0), Vector(25, 25, 55));
		ply:SetHullDuck(Vector(-25, -25, 0), Vector(25, 25, 55));
		
		ply:SetViewOffset(Vector(0, 0, 68));
		ply:SetViewOffsetDucked(Vector(0, 0, 68));
	else
		ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 55));
		ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 40));
		
		ply:SetViewOffset(Vector(0, 0, 48));
		ply:SetViewOffsetDucked(Vector(0, 0, (48 * .75)));
		
		if (ply:IsSalsa()) then
					
			ply:SetHull(Vector(-12, -12, 0), Vector(12, 12, 28));
			ply:SetHullDuck(Vector(-12, -12, 0), Vector(12, 12, 28));
			
			ply:SetViewOffset(Vector(0, 0, 28));
			ply:SetViewOffsetDucked(Vector(0, 0, 28));
			
		end 
		
		if (ply:IsGhost()) then
			
			ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 55));
			ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 55));
			
			ply:SetViewOffset(Vector(0, 0, 55));
			ply:SetViewOffsetDucked(Vector(0, 0, 55));
			
		end
		
	end
	
	timer.Simple(.1, function()
		umsg.Start("UpdateHulls")
			umsg.Entity(ply);
		umsg.End()
	end);
	
end


function GM:SetUC(ply)
	local uc = self:GetUC();
	if (ply != uc) then
		SetGlobalEntity("UltimateChimera", ply);
		ply.UCChance = -1;
	end
end

function GM:RemoveUC()
	SetGlobalEntity("UltimateChimera", NULL);
end


function GM:NewUC()
	
	local uc = self:GetUC();
	
	self:RemoveUC();
	
	local tbl, plys = {}, player.GetAll();
	for k, v in ipairs(plys) do
		
		v.UCChance = (v.UCChance || 1);
		
		if (v != uc && v.UCChance > 0 && v:Team() == self.TEAM_PIGS && v != self.NextRoundSalsa && !v:IsSalsa()) then
			
			for i = 1, v.UCChance do
				table.insert(tbl, v);
			end
			
		end
		
	end
	
	if (#tbl < 1) then
		return;
	end
	
	local ply = table.Random(tbl);
	
	self:SetUC(ply);
	self:NotifyPlayers(ply:Name() .. " is the new Ultimate Chimera");
	
end



function GM:PlayerUse(ply, ent)
	
	if (ply:IsGhost()) then
		return false;
	end
	
	return true;
	
end



function GM:EntityTakeDamage(ent, inflictor, attacker, amount, dmg)
	
	if (ent:IsPlayer()) then
		if (ent:IsUC() || ent:IsGhost() || ent:IsSalsa() || (ent:Health() - amount) <= 0) then
			
			if (ent:IsUC() && amount > 100) then
				ent:Kill();
			end
			if (ent:Alive() && !ent:IsUC() && (ent:Health() - amount) <= 0) then
				ent:Kill();
			end
			
			dmg:ScaleDamage(0);
		end
	end
	
end



function GM:PlayerDeathSound()
	return true;
end


local function GetFallDamage(ply, vel)
	
	if (ply:IsGhost()) then
		return false;
	end
	if (ply:IsSalsa()) then
		ply:EmitSound("UCH/salsa/squeal.mp3", 75, math.random(94, 105));
		return false;
	end
	if (ply:IsUC()) then
		return 0;
	end
	
end
hook.Add("GetFallDamage", "GAMEMODE_GetFallDamage", GetFallDamage);




else
	
	
	
	
local function TauntAngSafeGuard(ply)
	if (ply.TauntAng == nil) then
		local ang = ply:EyeAngles();
		ang.p = 45;
		ply.TauntAng = ang;
	end
end


function GM:ShouldDrawLocalPlayer()
	
	if ((LocalPlayer():IsUC() && LocalPlayer():Alive()) || LocalPlayer():IsTaunting() || LocalPlayer():IsScared()) then
		return true;
	end
	
	return false;
	
end

	
function GM:InputMouseApply(cmd, x, y, ang)

	local ply = LocalPlayer();

	if (ply:IsTaunting() || ply:IsRoaring()) then
	
		TauntAngSafeGuard(ply);
		
		local ang = ply.TauntAng;
		
		local y = (x * -GetConVar("m_yaw"):GetFloat());
		
		ang.y = (ang.y + y)
		//ang = ang:GetAngle();
		
		ang.p = 16;
		
		ply.TauntAng = ang;
		
		return true
	
	end
	
	if (ply:IsBiting() || (ply:IsUC() && !ply:Alive())) then
		return true;
	end
		
	return self.BaseClass:InputMouseApply(self, cmd, x, y, ang);

end



local function ThirdPersonCamera(ply, pos, ang, fov, dis)
	local view = {};
	
	local dir = ang:Forward();
	
	local tr = util.QuickTrace(pos, (dir * -dis), player.GetAll());
	
	local trpos = tr.HitPos;
	
	if (tr.Hit) then
		trpos = (trpos + (dir * 20));
	end
	
	view.origin = trpos;
	
	view.angles = (ply:GetShootPos() - trpos):Angle();
	
	view.fov = fov;

	return view;
end

function GM:CalcView(ply, pos, ang, fov)
	
	local tang = ply.TauntAng;
	
	if (ply:IsTaunting() || ply:IsRoaring()) then
		
		TauntAngSafeGuard(ply);
		
		local view = {};
		
		local dir = tang:Forward();
		
		local tr = util.QuickTrace(pos, (dir * -115), player.GetAll());
		
		local trpos = tr.HitPos;
		
		if (tr.Hit) then
			trpos = (trpos + (dir * 20));
		end
		
		view.origin = trpos;
		
		view.angles = (ply:GetShootPos() - trpos):Angle();
		
		view.fov = fov;

		return view;
		
	else
		
		if (tang != nil) then
			
			if (!ply:IsUC()) then
				tang.p = 0;
			end
			
			tang.r = 0;
			ply:SetEyeAngles(tang);
			
			ply.TauntAng = nil;
			
		end
		
		if (ply:IsScared()) then
			return ThirdPersonCamera(ply, pos, ang, fov, 100);
		end
		
		if (ply:IsGhost()) then
			
			local num = 3;
			
			local view = {};
			
			local bob = (math.sin((CurTime() * num)) * 4);
			
			view.origin = Vector(pos.x, pos.y, (pos.z + bob));
			view.angles = ang;
			view.fov = fov;
			
			return view;
			
		end
		
	end
	
	if (ply:IsUC()) then
		
		if (ply:Alive()) then
			return ThirdPersonCamera(ply, pos, ang, fov, 125);
		else
			local followang = ang;
		
			local rag = ply:GetRagdollEntity();
			if (ValidEntity(rag)) then
				local pos = (ply:GetPos() - (ply:GetForward() * 800));
				followang = ((rag:GetPos() - Vector(0, 0, 100)) - pos):Angle();
			end
			
			local view = {};
			view.origin = (pos + Vector(0, 0, 25));
			view.angles = followang;
			view.fov = fov;
			
			return view;
		end
		
	end
	
	
	return {ply, pos, ang, fov};
	
	
end


local function RestartAnimation(um)
	
	local ply = um:ReadEntity();
	ply:AnimRestartMainSequence();
	
end
usermessage.Hook("UC_RestartAnimation", RestartAnimation);

	
local function UpdateHulls(um)

	local ply = um:ReadEntity();
	
	if (!ValidEntity(ply)) then
		return;
	end
	
	if (ply:IsUC()) then
		ply:SetHull(Vector(-25, -25, 0), Vector(25, 25, 55));
		ply:SetHullDuck(Vector(-25, -25, 0), Vector(25, 25, 55));
		
		ply:SetViewOffset(Vector(0, 0, 68));
		ply:SetViewOffsetDucked(Vector(0, 0, 68));
	else
		ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 55));
		ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 40));
		
		ply:SetViewOffset(Vector(0, 0, 48));
		ply:SetViewOffsetDucked(Vector(0, 0, (48 * .75)));
		
		if (ply:IsSalsa()) then
					
			ply:SetHull(Vector(-12, -12, 0), Vector(12, 12, 28));
			ply:SetHullDuck(Vector(-12, -12, 0), Vector(12, 12, 28));
			
			ply:SetViewOffset(Vector(0, 0, 28));
			ply:SetViewOffsetDucked(Vector(0, 0, 28));
			
		end 
		
		if (ply:IsGhost()) then
			
			ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 55));
			ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 55));
			
			ply:SetViewOffset(Vector(0, 0, 55));
			ply:SetViewOffsetDucked(Vector(0, 0, 55));
			
		end
		
	end
	
end
usermessage.Hook("UpdateHulls", UpdateHulls);

	
	
end
