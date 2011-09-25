
local matBlueFlash 	= Material("Effects/blueblackflash")
local matBlueMuzzle	= Material("Effects/bluemuzzle")
matBlueMuzzle:SetMaterialInt("$spriterendermode",9)


function EFFECT:Init(data)
	
	self.Shooter = data:GetEntity()
	self.Attachment = data:GetAttachment()
	//self.WeaponEnt = self.Shooter:GetActiveWeapon()
	self.KillTime = 0
	self.ShouldRender = false
	

	if GetViewEntity() == LocalPlayer() then 
		self.ViewModel = LocalPlayer():GetVehicle():GetNWEntity("turret")
		self.SpriteSize = 20
		self.FlashSize = 40
	else
		self.ViewModel = self.WeaponEnt
		self.SpriteSize = 60
		self.FlashSize = 120
	end
	
	if not self.ViewModel:IsValid() then return end	

	local Muzzle = 	self.ViewModel:GetAttachment(self.Attachment)
	self:SetRenderBoundsWS(Muzzle.Pos + Vector()*self.SpriteSize,Muzzle.Pos - Vector()*self.SpriteSize)

	self.KillTime = CurTime() + 2
	self.ShouldRender = true

end


function EFFECT:Think()

	if CurTime() > self.KillTime then return false end
	if not self.Shooter then return false end
	//if self.WeaponEnt ~= self.Shooter:GetActiveWeapon() then return false end
	if not self.ViewModel:IsValid() then return false end

	return true
	
end


function EFFECT:Render()

	if not self.ShouldRender then return end

	local Muzzle = 	self.ViewModel:GetAttachment(self.Attachment)
	if not Muzzle then return end
	
	local RenderPos = Muzzle.Pos
	self:SetRenderBoundsWS(RenderPos + Vector()*self.SpriteSize,RenderPos - Vector()*self.SpriteSize)	

	local invintrplt = (self.KillTime - CurTime())/2
	local intrplt = 1 - invintrplt

	local size
	
	if invintrplt > 0.8 then
		render.SetMaterial(matBlueMuzzle)
		size = 2*self.FlashSize*(invintrplt - 0.5)
		local alpha = 1275*(invintrplt - 0.8)
		render.DrawSprite(RenderPos,size,size,Color(200,150,255,alpha))
	end

	render.SetMaterial(matBlueFlash)
	size = self.SpriteSize*invintrplt
	render.DrawSprite(RenderPos,size,size,Color(200,150,255,100*invintrplt))
	

end
