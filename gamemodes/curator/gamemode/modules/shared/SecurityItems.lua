--[[-----------------------------------------------------
-------------------Security Item Table-------------------
]]-------------------------------------------------------

local SecurityItemsByName = {}

Security = {}

function Security.GetItems()
	return SecurityItemsByName
end 

function Security.AddItem(itemz)
	SecurityItemsByName[itemz:GetName()] = itemz
end 

function Security.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if SecurityItemsByName[str] then
		SecurityItemsByName[str] = nil
	end
end 

function Security.GetItem(name)
	return SecurityItemsByName[name]
end 

function Security.MakeStandardSpawnFunc(class)
	local func = function(item,ply,pos,ang) 
		if item and ply and pos and ang then
			local ent = ents.Create(class)
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent.Item = item:CopyTo(GetNewItemObject())
			ent.IType = "Security"
			ent:SetModel(item:GetModel())
			ent:Spawn()
			--if class ~= "curator_turret" then
				--ent.Fading = true
			--end
			AccessorFunc(ent,"t_pOwner","Player")
			ent:SetPlayer(ply)
			
			return ent
		end
	end
	return func
end

function Security.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

local StdRot = Angle(90,0,0)

Security.AddItem(GetNewItemObject("Survailance Camera",
"Affords Basic Protection against intruders.",
800,
10,
-1,
0,
0,
Security.MakeStandardSpawnFunc("curator_camera"),
nil,
Security.MakeStandardLimitCheckFunc("curator_camera"),
"models/props_combine/combinecamera001.mdl"):SetAngularOffset(Angle(35,0,0)):SetPosOffset(4))

Security.AddItem(GetNewItemObject("Pressure Plates",
"Sensitive to thives walking on it.",
1500,
4,
0,
0,
0,
function(item,ply,pos,ang) 
	if ang:Up().z > 0.95 then --some tolerance.
		local ent = ents.Create("curator_pressureplate")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent.Item = item:CopyTo(GetNewItemObject())
		ent.IType = "Security"
		ent:SetModel(item:GetModel())
		ent:Spawn()
		AccessorFunc(ent,"t_pOwner","Player")
		ent:SetPlayer(ply)
	
		return ent
	else
		ply:SetNWInt("money",ply:GetNWInt("money")+item:GetPrice())
		ply:ChatPrint("You can't spawn a pressure plate on a sloped surface or wall.")
	end
end,
nil,
Security.MakeStandardLimitCheckFunc("curator_pressureplate"),
"models/props_junk/TrashDumpster02b.mdl"):SetAngularOffset(StdRot))

Security.AddItem(GetNewItemObject("Laser Emitter",
"Detects (and hurts) thieves.",
500,
10,
0,
0,
0,
Security.MakeStandardSpawnFunc("curator_laser"),
nil,
Security.MakeStandardLimitCheckFunc("curator_laser"),
"models/props_combine/combine_mine01.mdl"):SetAngularOffset(StdRot):SetPosOffset(0))

Security.AddItem(GetNewItemObject("Laser Grid",
"A large grid of lasers!",
2500,
2,
0,
0,
0,
Security.MakeStandardSpawnFunc("curator_laser_grid"),
nil,
Security.MakeStandardLimitCheckFunc("curator_laser_grid"),
"models/props_combine/combine_fence01a.mdl"):SetPosOffset(0):SetAngularOffset(Angle(0,90,0)))

Security.AddItem(GetNewItemObject("Turret",
"A deadly turret.",
4500,
1,
-5,
-3,
-1,
Security.MakeStandardSpawnFunc("curator_turret"),
nil,
function(item) --h4x
	local lim = math.Clamp(math.floor((#player.GetAll()-1)/3),1,4)
	local num = #ents.FindByClass("curator_turret") 
	if num < lim then
		return 0
	else
		return math.huge
	end
end,
"models/Combine_turrets/Floor_turret.mdl"):SetAngularOffset(StdRot))

local UpVec = Vector(0,0,1)