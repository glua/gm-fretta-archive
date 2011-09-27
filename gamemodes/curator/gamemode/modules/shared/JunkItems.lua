--[[-----------------------------------------------------
-------------------Junk Item Table-------------------
]]-------------------------------------------------------

local JunkItemsByName = {}

Junk = {}

function Junk.GetItems()
	return JunkItemsByName
end 

function Junk.AddItem(itemz)
	JunkItemsByName[itemz:GetName()] = itemz
end 

function Junk.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if JunkItemsByName[str] then
		JunkItemsByName[str] = nil
	end
end 

function Junk.GetItem(name)
	return JunkItemsByName[name]
end 

local zeroAng = Angle(0,0,0)

function Junk.MakeStandardSpawnFunc(class)
	local func = function(item,ply,pos,ang) 
		if item and ply and pos and ang then
			local ent = ents.Create(class)
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent.Item = item:CopyTo(GetNewItemObject())
			ent.IType = "Junk"
			ent:SetModel(item:GetModel())
			ent:Spawn()
			AccessorFunc(ent,"t_pOwner","Player")
			ent:SetPlayer(ply)
		end
	end
	return func
end

function Junk.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Junk.MakeStandardJunkCheckFunc(name)
    local func = function(item)
        local i = 0
        for k,v in ipairs(ents.FindByClass("curator_junk")) do
            if v.Item:GetName() == name then
                i = i + 1
            end
        end
        return i
    end
    return func
end

Junk.AddItem(GetNewItemObject("Watermelon",
"Mmmm... Delicious.", 
75, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Watermelon"), 
"models/props_junk/watermelon01.mdl"))

Junk.AddItem(GetNewItemObject("Computer Monitor",
"Looks like it works.", 
125, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Computer Monitor"), 
"models/props_lab/monitor02.mdl"))

Junk.AddItem(GetNewItemObject("Tire",
"Only moderatly damaged.", 
105, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Tire"), 
"models/props_vehicles/carparts_wheel01a.mdl"))

Junk.AddItem(GetNewItemObject("Metal Bin",
"Could be sold for scrap.", 
125, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Metal Bin"), 
"models/props_junk/MetalBucket02a.mdl"))

Junk.AddItem(GetNewItemObject("Soda Machine Faceplate",
"Where's the rest of it?", 
175, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Soda Machine Faceplate"), 
"models/props_interiors/VendingMachineSoda01a_door.mdl"))

Junk.AddItem(GetNewItemObject("Small Couch",
"Only a bit beat up...", 
125, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Small Couch"), 
"models/props_interiors/Furniture_Couch02a.mdl"))

Junk.AddItem(GetNewItemObject("Street Sign",
"Off to the scrap yard with this.", 
100, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Street Sign"), 
"models/props_c17/streetsign004e.mdl"))

Junk.AddItem(GetNewItemObject("Baby Doll",
"Could be a collectable.", 
50, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Baby Doll"), 
"models/props_c17/doll01.mdl"))

Junk.AddItem(GetNewItemObject("Cash Register",
"I think there's still change in it!", 
225, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Cash Register"), 
"models/props_c17/cashregister01a.mdl"))

Junk.AddItem(GetNewItemObject("Metal Wheel",
"A metal wheel.", 
65, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Metal Wheel"), 
"models/props_borealis/door_wheel001a.mdl"))

Junk.AddItem(GetNewItemObject("Globe",
"Depicts the world as we know it.", 
85, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Globe"), 
"models/props_combine/breenglobe.mdl"))

Junk.AddItem(GetNewItemObject("Gas Can",
"There's still some gasoline in it!", 
100, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Gas Can"), 
"models/props_junk/gascan001a.mdl"))

Junk.AddItem(GetNewItemObject("Propane Tank",
"Heavy.", 
75, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Propane Tank"), 
"models/props_junk/PropaneCanister001a.mdl"))

Junk.AddItem(GetNewItemObject("Paint Can",
"Eh...Was this even worth picking up?", 
45, 
-1, 
0,
0, 
0, 
Junk.MakeStandardSpawnFunc("curator_junk"),
nil, 
Junk.MakeStandardJunkCheckFunc("Paint Can"), 
"models/props_junk/plasticbucket001a.mdl"))
