if (SERVER) then
	
	local GlobalInts = {}

	--Overriding garryfunctions to fix the global ints
	local oldGetGlobalInt = GetGlobalInt
	function GetGlobalInt(id)
		if GlobalInts[id] then
			if oldGetGlobalInt(id) ~= GlobalInts[id] then
				SetGlobalInt(id, GlobalInts[id])
			end
			return GlobalInts[id]
		else
			return oldGetGlobalInt(id)
		end
	end

	local OldSetGlobalInt = SetGlobalInt

	function SetGlobalInt(id, int)
		GlobalInts[id] = int
		OldSetGlobalInt(id, int)
		for k, ply in pairs(player.GetAll()) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalInt", ply)
					umsg.Long(int)
					umsg.String(id)
				umsg.End()
			else
				GlobalInts[k] = nil
			end
		end
	end

	function SendGlobalIntsOnSpawn(ply)
		for k,v in pairs(GlobalInts) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalInt", ply)
					umsg.Long(v)
					umsg.String(k)
				umsg.End()
			else
				GlobalInts[k] = nil
			end
		end
	end
	hook.Add("PlayerInitialSpawn", "SendGlobalIntsOnSpawn", SendGlobalIntsOnSpawn)
	
	local GlobalEntitys = {}

	--Overriding garryfunctions to fix the global Entitys
	local oldGetGlobalEntity = GetGlobalEntity
	function GetGlobalEntity(id)
		if GlobalEntitys[id] then
			if oldGetGlobalEntity(id) ~= GlobalEntitys[id] then
				SetGlobalEntity(id, GlobalEntitys[id])
			end
			return GlobalEntitys[id]
		else
			return oldGetGlobalEntity(id)
		end
	end

	local OldSetGlobalEntity = SetGlobalEntity

	function SetGlobalEntity(id, ent)
		GlobalEntitys[id] = ent
		OldSetGlobalEntity(id, ent)
		for k, ply in pairs(player.GetAll()) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalEntity", ply)
					umsg.Entity(ent)
					umsg.String(id)
				umsg.End()
			else
				GlobalEntitys[k] = nil
			end
		end
	end

	function SendGlobalEntitysOnSpawn(ply)
		for k,v in pairs(GlobalEntitys) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalEntity", ply)
					umsg.Entity(v)
					umsg.String(k)
				umsg.End()
			else
				GlobalEntitys[k] = nil
			end
		end
	end
	hook.Add("PlayerInitialSpawn", "SendGlobalEntitysOnSpawn", SendGlobalEntitysOnSpawn)
	
	
	local GlobalBools = {}

	--Overriding garryfunctions to fix the global Bools
	local oldGetGlobalBool = GetGlobalBool
	function GetGlobalBool(id)
		if GlobalBools[id] then
			if oldGetGlobalBool(id) ~= GlobalBools[id] then
				SetGlobalBool(id, GlobalBools[id])
			end
			return GlobalBools[id]
		else
			return oldGetGlobalBool(id)
		end
	end

	local OldSetGlobalBool = SetGlobalBool

	function SetGlobalBool(id, Bool)
		GlobalBools[id] = Bool
		OldSetGlobalBool(id, Bool)
		for k, ply in pairs(player.GetAll()) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalBool", ply)
					umsg.Bool(Bool)
					umsg.String(id)
				umsg.End()
			else
				GlobalBools[k] = nil
			end
		end
	end

	function SendGlobalBoolsOnSpawn(ply)
		for k,v in pairs(GlobalBools) do
			if v ~= 0 then
				umsg.Start("FRecieveGlobalBool", ply)
					umsg.Bool(v)
					umsg.String(k)
				umsg.End()
			else
				GlobalBools[k] = nil
			end
		end
	end
	hook.Add("PlayerInitialSpawn", "SendGlobalBoolsOnSpawn", SendGlobalBoolsOnSpawn)
	
	
else
	
	local GlobalInts = {}
	local OldSetGlobalInt = SetGlobalInt

	function SetGlobalInt(id, int)
		GlobalInts[id] = int
		OldSetGlobalInt(id, int)
	end

	local function RecieveFGlobalInt(msg)
		local int = msg:ReadLong()
		local id = msg:ReadString()
		SetGlobalInt(id, int)
	end
	usermessage.Hook("FRecieveGlobalInt", RecieveFGlobalInt)

	local oldGetGlobalInt = GetGlobalInt
	function GetGlobalInt(id)
		if GlobalInts[id] then
			return GlobalInts[id]
		else
			return oldGetGlobalInt(id)
		end
	end
	
	local GlobalEntitys = {}
	local OldSetGlobalEntity = SetGlobalEntity

	function SetGlobalEntity(id, ent)
		GlobalEntitys[id] = ent
		OldSetGlobalEntity(id, ent)
	end

	local function RecieveFGlobalEntity(msg)
		local ent = msg:ReadEntity()
		local id = msg:ReadString()
		SetGlobalEntity(id, ent)
	end
	usermessage.Hook("FRecieveGlobalEntity", RecieveFGlobalEntity)

	local oldGetGlobalEntity = GetGlobalEntity
	function GetGlobalEntity(id)
		if GlobalEntitys[id] then
			return GlobalEntitys[id]
		else
			return oldGetGlobalEntity(id)
		end
	end
	
	local GlobalBools = {}
	local OldSetGlobalBool = SetGlobalBool

	function SetGlobalBool(id, ent)
		GlobalBools[id] = ent
		OldSetGlobalBool(id, ent)
	end

	local function RecieveFGlobalBool(msg)
		local ent = msg:ReadBool()
		local id = msg:ReadString()
		SetGlobalBool(id, ent)
	end
	usermessage.Hook("FRecieveGlobalBool", RecieveFGlobalBool)

	local oldGetGlobalBool = GetGlobalBool
	function GetGlobalBool(id)
		if GlobalBools[id] then
			return GlobalBools[id]
		else
			return oldGetGlobalBool(id)
		end
	end
	
end