
module("multimodel", package.seeall)

MODELS = {}
NUM_MODELS = 0
TR_STRING_TO_ID = {}
TR_ID_TO_STRING = {}

function Register(name, tbl)
	if CLIENT then
		MODELS[name] = tbl
	end
	NUM_MODELS = NUM_MODELS + 1
	TR_STRING_TO_ID[name] = NUM_MODELS
	TR_ID_TO_STRING[NUM_MODELS] = name
end

function GetModelID(name)
	return TR_STRING_TO_ID[name]
end

function GetModelFromID(id)
	return TR_ID_TO_STRING[id]
end

if CLIENT then

local function DeepCopy(tbl)
	local t = {}
	for k,v in pairs(tbl) do
		if type(v)=="table" then
			t[k] = DeepCopy(v)
		elseif type(v)=="Vector" then
			t[k] = Vector(v.x,v.y,v.z)
		elseif type(v)=="Angle" then
			t[k] = Angle(v.p, v.y, v.r)
		elseif type(v)=="Color" then
			t[k] = Color(v.r, v.g, v.b, v.a)
		else
			t[k] =  v
		end
	end
	return t
end

function GetMultiModel(name)
	return MODELS[name]
end

function CreateInstance(name)
	if MODELS[name] then
		return DeepCopy(MODELS[name])
	end
end

----------------------------------------------------------------------------------

local function DoFrameAdvanceChild(tbl, time, ent)
	if tbl.Think then tbl:Think(time, ent) end
	for _,v in pairs(tbl.children or {}) do
		DoFrameAdvanceChild(v, time, ent)
	end
end

function DoFrameAdvance(tbl, time, ent)
	for _,v in pairs(tbl) do
		DoFrameAdvanceChild(v, time, ent)
	end
end

----------------------------------------------------------------------------------

RENDERER = ClientsideModel("models/props_junk/watermelon01.mdl")
RENDERER:SetNoDraw(true)

local function DrawChild(tbl, ent, param)
	param = param or {}
	local m, scale
	
	if tbl.transform then
		m = Matrix()
		m:Translate(tbl.transform[1])
		m:Rotate(tbl.transform[2])
		m:Scale(tbl.transform[3])
	
		m = ent.CurrentMatrix * m
		scale = Vector(
			ent.CurrentScale.x * tbl.transform[3].x,
			ent.CurrentScale.y * tbl.transform[3].y,
			ent.CurrentScale.z * tbl.transform[3].z
		)
	else
		m = ent.CurrentMatrix
		scale = ent.CurrentScale
	end
	
	if tbl.visible == false then
		-- lol I don't want to indent all this shit below after adding this "visible" feature, so fuck this
	elseif tbl.model and tbl.model~="" then
		RENDERER:SetModel(tbl.model)
		RENDERER:SetPos(m:GetTranslation())
		RENDERER:SetAngles(m:GetAngle())
		RENDERER:SetModelScale(scale)
		
		local min, max = RENDERER:GetRenderBounds()
		
		if not ent.RenderBounds[1] then
			ent.RenderBounds[1] = min
		else
			OrderVectors(ent.RenderBounds[1], min)
		end
		
		if not ent.RenderBounds[2] then
			ent.RenderBounds[2] = max
		else
			OrderVectors(max, ent.RenderBounds[2])
		end
		
		RENDERER:SetSkin(tbl.skin or 0)
		
		local s = ent:GetSkin()
		local r0, g0, b0, a0 = ent.ParentEntity:GetColor()
		local col
		if tbl.skins and tbl.skins[s] and tbl.skins[s].color then
			col = tbl.skins[s].color
		else
			col = tbl.color
		end
		
		if not param.norenderoverride then
			if col then
				render.SetColorModulation(r0 * col.r/65025, g0 * col.g/65025, b0 * col.b/65025)
				render.SetBlend(a0 * col.a/65025)
			end
			if tbl.material then
				if type(tbl.material)=="string" then tbl.material = Material(tbl.material) end
				SetMaterialOverride(tbl.material)
			end
		end
		
		RENDERER:DrawModel()
		
		if not param.norenderoverride then
			SetMaterialOverride(0)
			render.SetBlend(1)
			render.SetColorModulation(1,1,1,1)
		end
	elseif tbl.sprite and not param.nosprites and not param.modelonly then
		if type(tbl.sprite)=="string" then tbl.sprite = Material(tbl.sprite) end
		render.SetMaterial(tbl.sprite)
		render.DrawSprite(m:GetTranslation(), scale.x, scale.y, tbl.color or Color(255,255,255,255))
	elseif tbl.effect and not param.noeffects and not param.modelonly  then
		if not tbl.NextEffect or (tbl.delay>=0 and CurTime()>tbl.NextEffect) then
			local data = EffectData()
				data:SetOrigin(m:GetTranslation())
				data:SetAngle(m:GetAngle())
				data:SetNormal(m:GetAngle():Up())
				data:SetMagnitude(1)
			util.Effect(tbl.effect, data, true, true)
			tbl.NextEffect = CurTime() + tbl.delay
		end
	elseif tbl.custom and not param.nocustom and not param.modelonly  then
		tbl.custom(tbl, m:GetTranslation(), m:GetAngle(), scale, ent)
	end
	
	if tbl.children and #tbl.children>0 then
		table.insert(ent.MatrixStack, 1, {ent.CurrentMatrix, ent.CurrentScale})
		ent.CurrentMatrix = m
		ent.CurrentScale = scale
		
		for _,v in pairs(tbl.children) do
			DrawChild(v, ent, param)
		end
		
		local t = table.remove(ent.MatrixStack, 1)
		ent.CurrentMatrix = t[1]
		ent.CurrentScale = t[2]
	end
end

function Draw(tbl, ent, param)
	if tbl then
		ent.MatrixStack = {}
		
		ent.CurrentMatrix = nil
		ent.RenderBounds = {}
		ent.ParentEntity = ent
		
		local parent = ent.dt.ParentEntity
		if ValidEntity(parent) then
			-- Stuff attached to players will get transmitted to the ragdoll when they die
			if parent:IsPlayer() and not parent:Alive() then
				if ValidEntity(parent:GetRagdollEntity()) then
					parent = parent:GetRagdollEntity()
				else
					return
				end
			end
			
			local b = ent.dt.ParentBone
			if b and b>=0 then
				ent.CurrentMatrix = parent:GetBoneMatrix(b)
				ent.CurrentScale = Vector(1,1,1)
			end
			ent.ParentEntity = parent
		end
		
		if not ent.CurrentMatrix then
			ent.CurrentMatrix = Matrix()
			ent.CurrentMatrix:Translate(ent:GetPos())
			if not ent.NoRotation then
				ent.CurrentMatrix:Rotate(ent:GetAngles())
			end
			ent.CurrentScale = Vector(1,1,1)
		end
		
		for _,v in pairs(tbl) do
			DrawChild(v, ent, param)
		end
		
		if ent.RenderBounds[1] and ent.RenderBounds[2] then
			ent:SetRenderBounds(ent.RenderBounds[1], ent.RenderBounds[2])
		end
	else
		ent:DrawModel()
	end
end

end