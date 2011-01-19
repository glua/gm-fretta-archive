
local ranks = {};

ranks[1] = "Ensign";
ranks[2] = "Captain";
ranks[3] = "Major";
ranks[4] = "Colonel";

//Custom ranks
ranks[5] = {};

ranks[5]["2139209410"] = {name = "Ness", /*mdl = "",*/

	TauntStart = function(ply)
		timer.Simple(.2, function()
			if (ValidEntity(ply) && ply:IsTaunting()) then
				ply:EmitSound("UCH/custom/ness_OK.wav", 68, math.random(95, 102));
			end
		end);
	end,
	
	TauntEnd = function(ply)
	end
	
};

ranks[5]["1231610699"] = {name = "Lucas"
};



local meta = FindMetaTable("Player");



//Get taunt functions
function meta:HasCustomTaunt()
	local uid = self:UniqueID();
	return (self:HasCustomRank() && type(ranks[5][tostring(uid)].TauntStart) == "function");
end

function meta:GetTauntStart()

	if (!self:HasCustomTaunt()) then
		return;
	end
		
	local uid = self:UniqueID();
	local tstart = ranks[5][tostring(uid)].TauntStart;
	
	local func, err = pcall(tstart, self);
	
	if (err) then
		print("ERROR");
	end
	
end

function meta:GetTauntEnd()

	if (!self:HasCustomTaunt()) then
		return;
	end

	local uid = self:UniqueID();
	local tend = ranks[5][tostring(uid)].TauntEnd;

	if (type(tend) == "function") then
		
		local func, err = pcall(tend, self);
		
		if (err) then
			print("ERROR");
		end
		
	end
	
end


//Get rank functions
function meta:GetRank()

	local ranknum = self:GetRankNum();
	local rank = ranks[ranknum];
	
	if (self:HasCustomRank()) then
		local uid = self:UniqueID();
		rank = ranks[5][tostring(uid)].name;
	end
	
	return rank;

end

function meta:GetRankNum()
	
	return self:ConvertCustomRank();
	
end


function meta:GetRankModel()
	
	
	
end


function meta:GetRankColor()

	local rank = self:GetRank();
	
	local clr = {250, 180, 180};

	if (self:HasCustomRank()) then
		clr = {232, 50, 50};
	else
		
		if (rank == "Captain") then
			clr = {150, 200, 250};
		elseif (rank == "Major") then
			clr = {90, 200, 90};
		elseif (rank == "Colonel") then
			clr = {250, 250, 250};
		end
		
	end
	
	if (self:IsUC()) then
		clr = {230, 30, 110};
	end
	
	return unpack(clr);
	
end

function meta:GetRankColorSat()

	local rank = self:GetRank();
	
	local clr = {255, 255, 255};

	if (self:HasCustomRank()) then
		clr = {232, 50, 50};
	else
		
		if (rank == "Captain") then
			clr = {153, 204, 255};
		elseif (rank == "Major") then
			clr = {115, 255, 115};
		elseif (rank == "Colonel") then
			clr = {225, 225, 225};
		end
		
	end
	
	return unpack(clr);
	
end


function meta:ConvertCustomRank()
	
	local rank = self:GetNWInt("UC_Rank", 1);
	
	if (self:HasCustomRank()) then
		rank = 5;
	end
	
	return rank;
	
end

function meta:HasCustomRank()
	local uid = self:UniqueID();
	return (ranks[5][tostring(uid)] != nil && !SinglePlayer() && GAMEMODE:CustomRanks());
end


if (SERVER) then



//Ranks
function meta:SetRank(num)
	
	local uid = self:UniqueID();
	if (self:HasCustomRank()) then
		num = 5;
	else
		num = math.Clamp(num, 1, 4);
	end
	
	self:SetNWInt("UC_Rank", num);
	
	if (!self:IsGhost()) then
		self:SetRankBodygroups();
		self:SetRankSkin();
	end
	
end

function meta:RankUp()
	if (!self:HasCustomRank()) then
		self.NextRank = math.Clamp((self:GetRankNum() + 1), 1, 4);
	end
end

function meta:RankDown()
	if (!self:HasCustomRank()) then
		self.NextRank = math.Clamp((self:GetRankNum() - 1), 1, 4);
	end
end

function meta:ResetRank()
	if (!self:HasCustomRank()) then
		self.NextRank = 1;
	end
end




else









end

