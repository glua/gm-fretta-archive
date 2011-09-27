--[[-----------------------------------------------------
-------------------Family Item Table-------------------
]]-------------------------------------------------------

local FamilyItemsByName = {}

Family = {}

function Family.GetItems()
	return FamilyItemsByName
end 

function Family.AddItem(itemz)
	FamilyItemsByName[itemz:GetName()] = itemz
end 

function Family.RemoveItem(item)
	local str = ""
	if type(item) == "string" then str = item else str = item:GetName() end
	if FamilyItemsByName[str] then
		FamilyItemsByName[str] = nil
	end
end 

function Family.GetItem(name)
	return FamilyItemsByName[name]
end 

local zeroAng = Angle(0,0,0)

function Family.MakeStandardSpawnFunc(class)
	local func = function(item,ply,pos,ang) 
		if item and ply and pos and ang then
			local ent = ents.Create(class)
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent.Item = item:CopyTo(GetNewItemObject())
			ent.IType = "Family"
			ent:SetModel(item:GetModel())
			ent:Spawn()
			AccessorFunc(ent,"t_pOwner","Player")
			ent:SetPlayer(ply)
			if item:GetTexture() ~= nil and item:GetTexture() ~= "" then
				ent:SetMaterial(item:GetTexture())
			end
			
			return ent
		end
	end
	return func
end

function Family.MakeStandardLimitCheckFunc(class)
	local func = function(item) 
		return #ents.FindByClass(class)
	end
	return func
end

function Family.MakeStandardArtCheckFunc(name)
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

Family.AddItem(GetNewItemObject("Virtual Reality Machine", --name
"It's art. No, really.", --desc
350, --cost
3, --limit
10, --Family Hap Val
1, --Enthusist Hap Val
0, --Collector/Fancy Hap Val
Family.MakeStandardSpawnFunc("curator_art"), --spawn function
nil, --OnRemove function (in case it's made of multiple entities or something)
Family.MakeStandardArtCheckFunc("Virtual Reality Machine"), --limit check func
"models/props_vehicles/apc001.mdl"):SetAngularOffset(StdRot)) --model (optionally, texture, too)

Family.AddItem(GetNewItemObject("Interactive Green Screen", --name
"Okay, this might not really be art...", --desc
1000, --cost
1, --limit
14, --Family Hap Val
0, --Enthusist Hap Val
-3, --Collector/Fancy Hap Val
Family.MakeStandardSpawnFunc("curator_art"), --spawn function
nil, --OnRemove function (in case it's made of multiple entities or something)
Family.MakeStandardArtCheckFunc("Interactive Green Screen"), --limit check func
"models/props_wasteland/interior_fence002d.mdl", "models/props_combine/com_shield001a"):SetAngularOffset(StdRot)) --model (optionally, texture, too)

Family.AddItem(GetNewItemObject("Food Court",
"It pleases families.", 
1250, 
1, 
12,
0, 
-1, 
Family.MakeStandardSpawnFunc("curator_art"),
nil, 
Family.MakeStandardArtCheckFunc("Food Court"), 
"models/props_c17/FurnitureTable002a.mdl"):SetAngularOffset(StdRot))

Family.AddItem(GetNewItemObject("Media Arts Exhibit",
"Exhibit on Video Game art and the media.", 
350, 
6, 
4,
2, 
0, 
Family.MakeStandardSpawnFunc("curator_art"),
nil, 
Family.MakeStandardArtCheckFunc("Media Arts Exhibit"), 
"models/props_combine/combine_monitorbay.mdl"):SetAngularOffset(StdRot))

Family.AddItem(GetNewItemObject("Children's Art Exhibit",
"Exhibit on art made by children.", 
750, 
5, 
7,
2, 
0, 
Family.MakeStandardSpawnFunc("curator_art"),
nil, 
Family.MakeStandardArtCheckFunc("Children's Art Exhibit"), 
"models/props_c17/Frame002a.mdl"))

Family.AddItem(GetNewItemObject("Science Theatre",
"Video is a widely popular form of art.", 
1500, 
1, 
20,
8, 
4, 
Family.MakeStandardSpawnFunc("curator_art"),
nil, 
Family.MakeStandardArtCheckFunc("Science Theatre"), 
"models/props_combine/combine_bunker01.mdl"):SetAngularOffset(StdRot))

Family.AddItem(GetNewItemObject("Indoor Playground",
"Well, the children love it...", 
1900, 
1, 
25,
2, 
-2, 
Family.MakeStandardSpawnFunc("curator_art"),
nil, 
Family.MakeStandardArtCheckFunc("Indoor Playground"), 
"models/props_c17/playgroundslide01.mdl"):SetAngularOffset(StdRot))