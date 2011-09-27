--[[-----------------------------------------------------
-------------------Fancy Item Table-------------------
]]-------------------------------------------------------

local FancyItemsByName = {}

Fancy = {}

function Fancy.GetItems()
	return FancyItemsByName
end 

function Fancy.AddItem(itemz)
	FancyItemsByName[itemz:GetName()] = itemz
end 

function Fancy.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if FancyItemsByName[str] then
		FancyItemsByName[str] = nil
	end
end 

function Fancy.GetItem(name)
	return FancyItemsByName[name]
end 

local zeroAng = Angle(0,0,0)

function Fancy.MakeStandardSpawnFunc(class)
	local func = function(item,ply,pos,ang) 
		if item and ply and pos and ang then
			local ent = ents.Create(class)
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent.Item = item:CopyTo(GetNewItemObject())
			ent.IType = "Fancy"
			ent:SetModel(item:GetModel())
			ent:Spawn()
			AccessorFunc(ent,"t_pOwner","Player")
			ent:SetPlayer(ply)
			
			return ent
		end
	end
	return func
end

function Fancy.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Fancy.MakeStandardArtCheckFunc(name)
    local func = function(item)
        local i = 0
        for k,v in ipairs(ents.FindByClass("curator_art")) do
            if v.Item:GetName() == name then
                i = i + 1
            end
        end
        return i
    end
    return func
end

local StdRot = Angle(90,0,0)

Fancy.AddItem(GetNewItemObject("Mona Lisa",
"It's incredible. Collectors love this.", 
1500, 
1, 
-6,
3, 
12, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("Mona Lisa"), 
"models/props_c17/Frame002a.mdl"))

Fancy.AddItem(GetNewItemObject("Horse Statue",
"A true artistic beauty.", 
1500, 
3, 
1,
3, 
8, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("Horse Statue"), 
"models/props_c17/statue_horse.mdl"):SetAngularOffset(StdRot))

Fancy.AddItem(GetNewItemObject("The Unknown One",
"A very mysterious statue.", 
3000, 
2, 
2,
8, 
18, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("The Unknown One"), 
"models/props_c17/gravestone_statue001a.mdl"):SetAngularOffset(StdRot))

Fancy.AddItem(GetNewItemObject("The Holy Cross",
"A very religious statue.", 
2250, 
3, 
4,
6, 
14, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("The Holy Cross"), 
"models/props_c17/gravestone_cross001a.mdl"):SetAngularOffset(StdRot))

Fancy.AddItem(GetNewItemObject("<insert name of famous art here>",
"It's fucking incredible.", 
750, 
8, 
-3,
1, 
4, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("<insert name of famous art here>"), 
"models/props_c17/Frame002a.mdl"))

Fancy.AddItem(GetNewItemObject("Stone Chalice",
"The gods must have drank from it", 
2000, 
2, 
-4,
-2, 
16, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("Stone Chalice"), 
"models/props_c17/pottery_large01a.mdl"):SetAngularOffset(StdRot))

Fancy.AddItem(GetNewItemObject("Le Tall Picture",
"This must have filled the Stone Challice.", 
1750, 
2, 
-2,
-1, 
11, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("Le Tall Picture"), 
"models/props_c17/pottery08a.mdl"):SetAngularOffset(StdRot))

Fancy.AddItem(GetNewItemObject("The Angry Man",
"He frowned so hard his face got frozen in place.", 
1500, 
2, 
-4,
-2, 
9, 
Fancy.MakeStandardSpawnFunc("curator_art"),
nil, 
Fancy.MakeStandardArtCheckFunc("The Angry Man"), 
"models/props_combine/breenbust.mdl"):SetAngularOffset(StdRot))