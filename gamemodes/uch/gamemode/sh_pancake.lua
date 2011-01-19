
local meta = FindMetaTable("Player");


function meta:IsPancake()
	return self:GetNWBool("Pancaked", false);
end




if (SERVER) then
	
	
	
	
	function meta:SetPancake(b)
		self:SetNWBool("Pancaked", b);
	end

	function meta:Pancake()
		
		if (!self:Alive() || self:IsUC()) then
			return;
		end
		
		if (!self:IsPancake()) then
			self:SetPancake(true);
		
			self:EmitSound("UCH/pigs/squeal" .. tostring(math.random(1, 3)) .. ".mp3", 92, math.random(90, 105));
			
			timer.Simple(.32, function()
				self.Squished = true;
				timer.Simple(.5, function()
					self.Squished = false;
				end);
				self:Kill();
				self:ResetRank();
			end);
		end
		
	end
	
	
	
	
else

	
	
	
	local function SetUpTime(ply)
		ply.CanSetUpTime = (ply.CanSetUpTime || true);
		if (ply.CanSetUpTime) then
			ply.CanSetUpTime = false;
			ply.UpTime = (CurTime() + .32);
		end
	end
	
	
	function meta:DoPancakeEffect()

		self.PancakeNum = (self.PancakeNum || 1);
		
		local num = 1;
		local spd = 8;
		
		self.PancakeNum = math.Approach(self.PancakeNum, .2, (FrameTime() * (self.PancakeNum * spd)));
		
		self:SetModelScale(Vector(1, 1, self.PancakeNum));
		
	end
	
	
	
	
	
end
