
include("shared.lua")

SWEP.PrintName          = "Base Weapon"
SWEP.Slot               = 5
SWEP.SlotPos            = 1
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false
SWEP.CrossRadius		= 10

SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon   = false

SWEP.vRenderOrder = nil
function SWEP:ViewModelDrawn()
	
    local vm = self.Owner:GetViewModel()
    if !ValidEntity(vm) then return end
     
    if (!self.VElements) then return end
     
    if vm.BuildBonePositions ~= self.BuildViewModelBones then
        vm.BuildBonePositions = self.BuildViewModelBones
    end

    if (self.ShowViewModel == nil or self.ShowViewModel) then
        vm:SetColor(255,255,255,255)
    else
        // we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
        vm:SetColor(255,255,255,1)
    end
     
    if (!self.vRenderOrder) then
         
        // we build a render order because sprites need to be drawn after models
        self.vRenderOrder = {}

        for k, v in pairs( self.VElements ) do
            if (v.type == "Model") then
                table.insert(self.vRenderOrder, 1, k)
            elseif (v.type == "Sprite" or v.type == "Quad") then
                table.insert(self.vRenderOrder, k)
            end
        end
         
    end

    for k, name in ipairs( self.vRenderOrder ) do
     
        local v = self.VElements[name]
        if (!v) then self.vRenderOrder = nil break end
     
        local model = v.modelEnt
        local sprite = v.spriteMaterial
         
        if (!v.bone) then continue end
        local bone = vm:LookupBone(v.bone)
        if (!bone) then continue end
         
        local pos, ang = Vector(0,0,0), Angle(0,0,0)
        local m = vm:GetBoneMatrix(bone)
        if (m) then
            pos, ang = m:GetTranslation(), m:GetAngle()
        end
         
        if (self.ViewModelFlip) then
            ang.r = -ang.r // Fixes mirrored models
        end
         
        if (v.type == "Model" and ValidEntity(model)) then

            model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)

            model:SetAngles(ang)
            model:SetModelScale(v.size)
             
            if (v.material == "") then
                model:SetMaterial("")
            elseif (model:GetMaterial() != v.material) then
                model:SetMaterial( v.material )
            end
             
            if (v.skin and v.skin != model:GetSkin()) then
                model:SetSkin(v.skin)
            end
             
            if (v.bodygroup) then
                for k, v in pairs( v.bodygroup ) do
                    if (model:GetBodygroup(k) != v) then
                        model:SetBodygroup(k, v)
                    end
                end
            end
             
            if (v.surpresslightning) then
                render.SuppressEngineLighting(true)
            end
             
            render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
            render.SetBlend(v.color.a/255)
            model:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
             
            if (v.surpresslightning) then
                render.SuppressEngineLighting(false)
            end
             
        elseif (v.type == "Sprite" and sprite) then
             
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            render.SetMaterial(sprite)
            render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
             
        elseif (v.type == "Quad" and v.draw_func) then
             
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)
             
            cam.Start3D2D(drawpos, ang, v.size)
                v.draw_func( self )
            cam.End3D2D()

        end
         
    end
     
end

SWEP.wRenderOrder = nil
function SWEP:DrawWorldModel()
     
    if (self.ShowWorldModel == nil or self.ShowWorldModel) then
        self:DrawModel()
    end
     
    if (!self.WElements) then return end
     
    if (!self.wRenderOrder) then

        self.wRenderOrder = {}

        for k, v in pairs( self.WElements ) do
            if (v.type == "Model") then
                table.insert(self.wRenderOrder, 1, k)
            elseif (v.type == "Sprite" or v.type == "Quad") then
                table.insert(self.wRenderOrder, k)
            end
        end

    end
     
    local opos, oang = self:GetPos(), self:GetAngles()
    local bone_ent

    if (ValidEntity(self.Owner)) then
        bone_ent = self.Owner
    else
        // when the weapon is dropped
        bone_ent = self
    end
     
    local bone = bone_ent:LookupBone("ValveBiped.Bip01_R_Hand")
    if (bone) then
        local m = bone_ent:GetBoneMatrix(bone)
        if (m) then
            opos, oang = m:GetTranslation(), m:GetAngle()
        end
    end
     
    for k, name in pairs( self.wRenderOrder ) do
     
        local v = self.WElements[name]
        if (!v) then self.wRenderOrder = nil break end
     
        local model = v.modelEnt
        local sprite = v.spriteMaterial

        local pos, ang = Vector(opos.x, opos.y, opos.z), Angle(oang.p, oang.y, oang.r)

        if (v.type == "Model" and ValidEntity(model)) then

            model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)

            model:SetAngles(ang)
            model:SetModelScale(v.size)
             
            if (v.material == "") then
                model:SetMaterial("")
            elseif (model:GetMaterial() != v.material) then
                model:SetMaterial( v.material )
            end
             
            if (v.skin and v.skin != model:GetSkin()) then
                model:SetSkin(v.skin)
            end
             
            if (v.bodygroup) then
                for k, v in pairs( v.bodygroup ) do
                    if (model:GetBodygroup(k) != v) then
                        model:SetBodygroup(k, v)
                    end
                end
            end
             
            if (v.surpresslightning) then
                render.SuppressEngineLighting(true)
            end
             
            render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
            render.SetBlend(v.color.a/255)
            model:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
             
            if (v.surpresslightning) then
                render.SuppressEngineLighting(false)
            end
             
        elseif (v.type == "Sprite" and sprite) then
             
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            render.SetMaterial(sprite)
            render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
             
        elseif (v.type == "Quad" and v.draw_func) then
             
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)
             
            cam.Start3D2D(drawpos, ang, v.size)
                v.draw_func( self )
            cam.End3D2D()

        end
         
    end
     
end

function SWEP:CreateModels( tab )

	if (!tab) then return end

	// Create the clientside models here because Garry says we can't do it in the render hook
	for k, v in pairs( tab ) do
		if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and
				string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
			
			v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			if (ValidEntity(v.modelEnt)) then
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
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

function SWEP:RemoveModels()
	if (self.VElements) then
		for k, v in pairs( self.VElements ) do
			if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
		end
	end
	if (self.WElements) then
		for k, v in pairs( self.WElements ) do
			if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
		end
	end
	self.VElements = nil
	self.WElements = nil
end

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Ironsights
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:DrawHUD()

	--if GAMEMODE:InRound() then
		local trace = util.QuickTrace(LocalPlayer():GetShootPos(), LocalPlayer():GetCursorAimVector()*4096, LocalPlayer())
		local pos = trace.HitPos:ToScreen()
		surface.DrawCircle(pos.x,pos.y,self.CrossRadius,GAMEMODE:GetTeamColor(self.Owner))
	--end

end