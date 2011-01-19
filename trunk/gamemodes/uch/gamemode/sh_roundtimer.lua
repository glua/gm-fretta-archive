
local mins = 2.1; //number of minutes a round lasts


function GM:RoundTimeUp()
	local t = GetGlobalInt("RoundTimer", 0);
	if (CurTime() >= t) then
		return true;
	end
	return false;
end


if (SERVER) then



	function GM:StartTimer()
		
		self.RoundTimeCheck = (CurTime() + 1);
		SetGlobalInt("RoundTimer", (CurTime() + (mins * 60)));
		
	end
	
	function GM:AddTime(num)
		
		local t = GetGlobalInt("RoundTimer", 0);
		t = (t + num);
		
		t = math.Clamp((t - CurTime()), 0, ((2.5 * 60) + 1));
		t = (CurTime() + t);
		
		SetGlobalInt("RoundTimer", t);
		
		umsg.Start("UpdateRoundTimer")
			umsg.Long(num);
		umsg.End()
		
	end
	
	function GM:RoundTimeThink()
		
		self.RoundTimeCheck = (self.RoundTimeCheck || CurTime());
		
		if (CurTime() >= self.RoundTimeCheck) then
			self.RoundTimeCheck = (CurTime() + 1);
		end
		
		if (self:RoundTimeUp() && self:IsPlaying()) then
			self:EndCountdown(self.ResetGame, "tie");
		end
		
	end


else
	
	
	local sw, sh = ScrW(), ScrH();
	local timerticks = {};
	
	
	local function UpdateRoundTimer(um)
		local num = um:ReadLong();
		table.insert(timerticks, {CurTime(), num});
		
		GAMEMODE.LastTimerAdd = (GAMEMODE.LastTimerAdd || 0);
		if (CurTime() >= GAMEMODE.LastTimerAdd) then
			GAMEMODE.LastTimerAdd = (CurTime() + .4);
			surface.PlaySound("UCH/music/cues/round_timer_add.mp3");
		end
	
	end
	usermessage.Hook("UpdateRoundTimer", UpdateRoundTimer);
	
	
	function GM:DrawTimerTicks()
		for k, v in ipairs(timerticks) do
		
			local t, num = (v[1] + 1), v[2];
			local fade = (t - CurTime());
		
			local alpha = math.Clamp(fade, 0, 255);
			self:DrawNiceText("+" .. tostring(num), "UCText", ((sw * .48) - (fade * (sw * .1))), 0, Color(255, 255, 255, (alpha * 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, (alpha * 150));
			
			if (CurTime() >= t) then
				table.remove(timerticks, k);
			end
			
		end
	end
	
	
	local pemat = surface.GetTextureID("UCH/hud/pigtimee");
	local pmat = surface.GetTextureID("UCH/hud/pigtime");
	local pCmat = surface.GetTextureID("UCH/hud/pigtimec");
	local ucmat = surface.GetTextureID("UCH/hud/chimeratime");
	
	function GM:DrawRoundTime()
		
		if (self:IsPlaying() || self:GetState() == self.STATE_ENDCOUNTDOWN) then
			
			local t = GetGlobalInt("RoundTimer", 0);
			local tm = (t - CurTime());
			tm = string.FormattedTime(tm, "%2i:%02i");
			
			if (self:RoundTimeUp() || !self:IsPlaying()) then
				tm = "Time up!";
			end
			
			tm = string.Trim(tm);
			
			surface.SetFont("UCH_TargetID");
			local txtw, txth = surface.GetTextSize("Time up!");
			
			local x, y = (sw * .5), -(sh * .05);
			local h = (txth + -y);
			local w = (h * 2);
			
			
			local mat = pmat;
			
			local r, g, b = LocalPlayer():GetRankColorSat();

			if (LocalPlayer():GetRank() == "Colonel" && !LocalPlayer():IsGhost()) then
				mat = pCmat;
			end
			if (LocalPlayer():GetRank() == "Ensign") then
				mat = pemat;
				r, g, b = 255, 255, 255;
			end
			if (LocalPlayer():IsUC()) then
				mat = ucmat;
				r, g, b = 255, 255, 255;
			end
			if (LocalPlayer():IsGhost()) then
				mat = pmat;
				r, g, b = 255, 255, 255;
			end
			
			surface.SetTexture(mat);
			surface.SetDrawColor(Color(r, g, b, 255));
			surface.DrawTexturedRect((x - (w * .5)), 0, w, h);
			
			self:DrawNiceText(tm, "UCH_TargetID", (sw * .5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, 250);
			
			if (#timerticks > 0) then
				self:DrawTimerTicks();
			end
		
		end
		
	end
	
	
	
end
