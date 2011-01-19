
local meta = FindMetaTable("Player");

function meta:IsGhost()
	return self:GetNWBool("UCGhost", false);
end

function meta:SetGhost(bool)
	
	self:SetNWBool("UCGhost", bool);
	
	GAMEMODE:UpdateHull(self);
	self:UpdateSpeeds();
	
	local rnd = math.random(1, 6);
	if (rnd == 1) then
		self.Fancy = true;
	else
		self.Fancy = false;
	end
	
	timer.Create(tostring(self) .. "SetGhostModels", 1, 1, function()
		if (ValidEntity(self)) then
			hook.Call("PlayerSetModel", GAMEMODE, self)
		end
	end);
	
end


function meta:GhostMove(move)
	
	if (!self:IsOnGround()) then
		
		local vel = self:GetVelocity();
	
		if (self:KeyDown(IN_JUMP)) then
			
			local num = math.Clamp((vel.z * -.18), 0, 75);
			num = (num * .1);
			
			vel.z = (vel.z + (32 + (5 * num)));
			
			vel.z = math.Clamp(vel.z, -250, 125);
			
		end
		
		/*local fwd, right = self:GetForward(), self:GetRight();
		
		fwd.z = 0;
		right.z = 0;
		fwd:Normalize();
		right:Normalize();
		
		local back, left = (fwd * -1), (right * -1);
		
		local ang = self:EyeAngles();
		
		if (self:KeyDown(IN_FORWARD) && ang:Forward():DotProduct(vel) < 250) then
			vel = (vel + (fwd * 250));
		end
		if (self:KeyDown(IN_BACK) && (ang:Forward() * -1):DotProduct(vel) < 250) then
			vel = (vel + (back * 250));
		end
		if (self:KeyDown(IN_MOVERIGHT) && ang:Right():DotProduct(vel) < 250) then
			vel = (vel + (right * 250));
		end
		if (self:KeyDown(IN_MOVELEFT) && (ang:Right() * -1):DotProduct(vel) < 250) then
			vel = (vel + (left * 250));
		end
		
		if ((self:KeyDown(IN_FORWARD) || self:KeyDown(IN_BACK)) && (self:KeyDown(IN_MOVERIGHT) || self:KeyDown(IN_MOVELEFT))) then
			local z = vel.z;
			vel = (vel * .5);
			vel.z = z;
		end*/
		
		
		if (self:KeyDown(IN_DUCK) && !self:KeyDown(IN_JUMP)) then
			
			vel.z = 5;
			
		end
		
		move:SetVelocity(vel);
		
	end
	
	return move;
	
end


if (SERVER) then





else


function DoGhostEffects()

	local ply = LocalPlayer();
	DrawColorModify{
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = (10 / 255) * 4,
		["$pp_colour_addb"] = (30 / 255) * 4,
		["$pp_colour_brightness"] = -.25,
		["$pp_colour_contrast"] = 1.5,
		["$pp_colour_colour"] = .32,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	};
	DrawBloom(.75,  1,  .65,  .65,  3,  0,  0, (72 / 255), 1);
	
end



end
