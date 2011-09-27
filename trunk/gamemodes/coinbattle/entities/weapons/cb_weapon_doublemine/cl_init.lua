
include("shared.lua")

SWEP.PrintName          = "Double Mine"
SWEP.Slot               = 0
SWEP.SlotPos            = 1

SWEP.VElements = {
	["Mine1"] = { type = "Model", model = "models/weapons/w_models/w_stickybomb.mdl", bone = "Crossbow_model.bolt", pos = Vector(0, 0, 11.274), angle = Angle(46.368, 31.575, 0), size = Vector(0.649, 0.649, 0.649), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
	["Mine2"] = { type = "Model", model = "models/weapons/w_models/w_stickybomb.mdl", bone = "Crossbow_model.bolt", pos = Vector(0, 0, -0.35), angle = Angle(-3.925, -175.206, 116.574), size = Vector(0.649, 0.649, 0.649), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""}
}
SWEP.WElements = {
	["Mine2"] = { type = "Model", model = "models/weapons/w_models/w_stickybomb.mdl", pos = Vector(14.375, -1.532, -5.375), angle = Angle(29.375, 16.5, 54.025), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""},
	["Mine1"] = { type = "Model", model = "models/weapons/w_models/w_stickybomb.mdl", pos = Vector(23, -2.75, -5.901), angle = Angle(-71.401, 75, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = ""}
}

function SWEP:CreateModels( tab )

	if (!tab) then return end

	// Create the clientside models here because Garry says we can't do it in the render hook
	for k, v in pairs( tab ) do
		if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and
				string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
			
			local skin = 0
			if self.Owner:Team() == TEAM_CYAN then
				skin = 1
			end

			v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			if (ValidEntity(v.modelEnt)) then
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
				v.modelEnt:SetSkin(skin)
				v.modelEnt:SetNoDraw(true)
				v.createdModel = v.model
			else
				v.modelEnt = nil
			end
			
		elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite)
			and file.Exists ("../materials/"..v.sprite..".vmt")) then
			
			local name = v.sprite.."-"
			local params = { ["$basetexture"] = v.sprite }
			// make sure we create a unique name based on the selected options
			local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
			for i, j in pairs( tocheck ) do
				if (v[j]) then
					params["$"..j] = 1
					name = name.."1"
				else
					name = name.."0"
				end
			end

			v.createdSprite = v.sprite
			v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
			
		end
	end
	
end