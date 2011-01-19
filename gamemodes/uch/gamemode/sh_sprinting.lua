
local meta = FindMetaTable("Player");


function meta:SetSprint(num)
	self:SetDTFloat(2, num);
end

function meta:SetSprinting(bool)
	self:SetDTBool(3, bool);
end

function meta:GetSprint()
	return self:GetDTFloat(2);
end

function meta:GetSprinting()
	return self:GetDTBool(3);
end

function meta:SetSprintingNW(bool)
	self:SetSprinting(bool);
	if (SERVER) then
		self:SetDTBool(1, bool);
	end
end

function meta:GetSprintingNW()
	return self:GetDTBool(1, false);
end

local sprint_minimum = .2;


function meta:CanRechargeSprint()
	
	self.SprintCooldown = (self.SprintCooldown || 0);
	local cooldown = self.SprintCooldown;
	return ((!self:IsUC() && CurTime() >= cooldown) || (self:IsUC() && self:IsOnGround()) && !self:KeyDown(IN_SPEED));
	
end

function meta:CanSprint()
	
	if (self:GetSprint() > 0) then
		if (self:IsUC()) then
			return true;
		end
		if (self:IsTaunting() || self:IsRoaring() || self:IsBiting() || self:IsSalsa()) then
			return false;
		end
		if (self:IsScared() || (!self:IsUC() && (!self:IsOnGround() || self:GetSprinting()))) then
			return false;
		end
		if (self:Team() == GAMEMODE.TEAM_PIGS && !self:GetSprintingNW()) then
			return true;
		end
		if (self:IsOnGround()) then
			return true;
		end
		return false;
	end
	
	return false;
	
end


function GM:SprintKeyPress(ply, key) //pigs sprint
	
	if (key != IN_SPEED || ply:GetSprint() < sprint_minimum) then
		return;
	end
	
	if (ply:CanSprint()) then
		ply:SetSprinting(true);
	end
	
end



if (SERVER) then



	
	function GM:SyncSprints()
			
		umsg.Start("SyncSprints");
			for k, v in pairs(player.GetAll()) do
				
				umsg.Entity(v);
				umsg.Float(v.UCHSprint);
				umsg.Bool(v.UCHSprinting);
			
			end
		umsg.End();
		
	end


	
	
	GM.nextthink = 0;
	local sync = 0;

	function GM:SprintThink()
		
		if (CurTime() >= self.nextthink) then
			self.nextthink = (CurTime() + .05);
			for k, v in pairs(player.GetAll()) do
								
				if (!v:Alive()) then
					v:SetSprinting(false);
				else
				
					v:SetSprint((v:GetSprint() || 1));
					v:SetSprinting((v:GetSprinting() || false));
					v.SprintCooldown = (v.SprintCooldown || 0);
					
					if (v:IsUC()) then
					
						local bool = (v:KeyDown(IN_SPEED) && v:MovementKeyDown() && v:CanSprint());
						v:SetSprinting(bool);
						if (v:GetSprintingNW() != bool) then
							v:SetSprintingNW(bool);
						end
						
					end
					
					if (v:IsScared()) then
						v:UpdateSpeeds();
					else
					
						if (v:GetSprinting()) then //I'm running, I'M RUNNING
							
							if (!v:GetSprintingNW()) then
								v:SetSprintingNW(true);
							end
							
							local drain = self.SprintDrain;
								
							if (v:IsUC()) then
								drain = (drain - .004);
							else
								local rank = v:GetRankNum();
								drain = (drain - (.005 * (rank / 4)));
							end
							
							v:SetSprint((v:GetSprint() - drain));
							
							if (SERVER) then
								v:UpdateSpeeds();
							end
							
							if (v:GetSprint() <= 0) then //you're all out man!
								v:SetSprinting(false);
								
								if (CurTime() > v.SprintCooldown) then
									v.SprintCooldown = (CurTime() + 6);
								end
								
								if (SERVER) then
									v:ResetSpeeds();
								end
								
							end
							
						else
							
							if (v:GetSprintingNW()) then
								v:SetSprintingNW(false);
							end
							
							if (v:GetSprint() < 1 && v:CanRechargeSprint()) then
								
								local recharge = self.SprintRecharge;
								
								if (v:IsUC()) then
									recharge = (recharge + .001);
								else
									local rank = v:GetRankNum();
									local num = .00075;
									
									if (v:Crouching()) then
										num = .02;
									end
									
									recharge = (recharge + (num * (rank / 4)));
								end
								
								v:SetSprint(math.Clamp((v:GetSprint() + recharge), 0, 1));
							end
							
							if (SERVER) then
								v:UpdateSpeeds();
							end
							
						end
						
					end
					
				end
				
			end
		end
		
		if (SERVER) then
			if (CurTime() >= sync) then
				
				self:SyncSprints();
				
				sync = (CurTime() + 7.5);
			end
		end
		
	end
	



else


local function SyncSprints(um)
	
	local ply = um:ReadEntity();
	local sprint, sprinting = um:ReadFloat(), um:ReadBool();
	
	ply:SetSprint(sprint);
	ply:SetSprinting(sprinting);
	
end
usermessage.Hook("SyncSprints", SyncSprints);


local sprintbar = surface.GetTextureID("UCH/hud_sprint_bar");
local ucsprintbar = surface.GetTextureID("UCH/hud_sprint_bar_UC");

local sw, sh = ScrW(), ScrH();

function GM:DrawSprintBar(x, y, w, h)
	
	local ply = LocalPlayer();
	
	if ((!ply:GetSprint() && !ply:IsScared()) || (ply:Team() == self.TEAM_PIGS && !ply:Alive()) || ply:IsSalsa()) then
		return;
	end
	
	local mat = sprintbar;
	local r, g, b = ply:GetRankColor();
	
	if (ply:IsUC()) then
		mat = ucsprintbar;
		r, g, b = 255, 255, 255;
	end
			
	
	local a = ply.SprintBarAlpha;
	
	ply.SprintMeterSmooth = (ply.SprintMeterSmooth || ply:GetSprint());
	
	local diff = math.abs((ply.SprintMeterSmooth - ply:GetSprint()));
	
	ply.SprintMeterSmooth = math.Approach(ply.SprintMeterSmooth, ply:GetSprint(), (FrameTime() * (diff * 5)));
	
	draw.RoundedBox(0, x, y, w, h, Color(130, 130, 130, a));
	
	if (!ply:IsUC()) then
		
		draw.RoundedBox(0, x, y, (w * sprint_minimum), h, Color(100, 100, 100, a));
		
	end
	
	surface.SetTexture(mat);
	surface.SetDrawColor(Color(r, g, b, a));
	surface.DrawTexturedRect(x, (y + 1), (w * ply.SprintMeterSmooth), h);
	
	if (ply.SprintMeterSmooth <= .02 || ply:IsScared()) then
		local alpha = (100 + (math.sin((CurTime() * 5)) * 45));
		draw.RoundedBox(0, x, y, w, h, Color(250, 0, 0, alpha));
	end
	
end




end
