
local meta = FindMetaTable("Player");


function meta:IsScared()
	return self:GetNWBool("IsScared", false);
end


if (SERVER) then



function meta:Scare(t)
	
	if (self:Team() != GAMEMODE.TEAM_PIGS || !self:Alive() || self:IsGhost()) then
		return;
	end
	
	self.UnScareTime = (self.UnScareTime || 0);
	
	if (self:IsScared()) then
		return;
	end
	
	self:SetNWBool("IsScared", true);
	self:SetSprinting(false);
	
	self:PlaybackRateOV(1);
	
	local num = (6.5 + ((t * (1 - (self:GetRankNum() / 5))) * .5));
	self.UnScareTime = (CurTime() + num);
	
	//self:ChatPrint(tostring(num));
	
	self:EmitSound("vo/halloween_scream" .. tostring(math.random(1, 8)) .. ".wav", 75, math.random(94, 105));
	
end

function meta:UnScare(b)
	
	if (!self:IsScared()) then
		return;
	end
	
	self:SetNWBool("IsScared", false);
	
	if (b) then
		local num = math.Clamp((self:GetSprint() - .5), 0, 1);
		self:SetSprint(num);
		
		local num = (3.5 + (1.5 * (1 - (self:GetRankNum() / 5))));
		self.SprintCooldown = (CurTime() + num);
	end
	
end


function GM:ScareThink()
	for k, v in pairs(player.GetAll()) do
	
		if (v:IsScared()) then
			
			if (v:IsTaunting()) then
				v:StopTaunting();
			end
			
			if (CurTime() >= v.UnScareTime) then
				v:UnScare(true);
			end
			
		end
	
	end
end


else



end
