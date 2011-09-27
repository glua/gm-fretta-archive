include("vgui/vgui_ammoclip.lua")

local screenScale = (ScrW() / 1280)

surface.CreateFont("Trebuchet MS", 28 * screenScale, 700, true, false, "BigMessageText")
surface.CreateFont("Trebuchet MS",20,720,true,false,"MutantHUDText")

local cross = surface.GetTextureID("hud/health")
local ball = surface.GetTextureID("hud/ammo")

local ammoPanel = nil

GM.CurrentMessage = ""
GM.CurrentMessageColor = Color(255,255,255)
GM.MessageStartTime = 0
GM.MessageDuration = 0

function GM:CreateAmmoHUD()
	ammoPanel = vgui.Create("AmmoClip")
end

function GM:HUDPaint()
	if self.MessageStartTime ~= nil then
		local bigMessageT = (CurTime() - self.MessageStartTime) / self.MessageDuration
		if bigMessageT < 1 then
			local a = 1 - math.pow(bigMessageT,4)
			local tCol = self.CurrentMessageColor
			draw.SimpleText(self.CurrentMessage,"BigMessageText",ScrW()/2,(ScrH()/4) + 2*screenScale,Color(0,0,0,200*a),TEXT_ALIGN_CENTER)
			draw.SimpleText(self.CurrentMessage,"BigMessageText",ScrW()/2,ScrH()/4,Color(tCol.r,tCol.g,tCol.b,255*a),TEXT_ALIGN_CENTER)
		end
	end

	local pl = LocalPlayer()

	if ValidEntity(pl) and ValidEntity(pl:GetActiveWeapon()) then
		if pl:Alive() then
			surface.SetTexture(cross)
			surface.SetDrawColor(pl:IsMutant() and Color(160,255,60,255) or Color(255,140,40,255))
			surface.DrawTexturedRect(20,ScrH() - 83,64,64)
			
			surface.SetTexture(ball)
			surface.DrawTexturedRect(100,ScrH() - 83,128,64)
			
			surface.SetTexture(nil)
			local hFrac = pl:Health() / (pl:IsMutant() and 300 or 100)
			surface.SetDrawColor(50,50,50,220)
			local mH = (1 - hFrac) * 56
			surface.DrawTexturedRect(44,ScrH() - 80,16,mH)
			if mH > 20 then
				surface.DrawTexturedRect(24,ScrH() - 60,20,math.min(mH - 20,16))
				surface.DrawTexturedRect(60,ScrH() - 60,20,math.min(mH - 20,16))
			end
			
			draw.SimpleText(tostring(pl:Health()),"MutantHUDText",52,ScrH()-60,Color(0,0,0,200),TEXT_ALIGN_CENTER)
			draw.SimpleText(tostring(pl:Health()),"MutantHUDText",52,ScrH()-62,Color(255,255,255,255),TEXT_ALIGN_CENTER)
			
		end
		
		if ammoPanel ~= nil then
			if pl:Alive() then
				ammoPanel:SetVisible(true)
				ammoPanel:InvalidateLayout(true)
			else
				ammoPanel:SetVisible(false)
			end
			
			local amm = (ValidEntity(pl:GetActiveWeapon()) and pl:GetActiveWeapon():GetNetworkedInt("ammo") or 0)
			draw.SimpleText(tostring(amm),"MutantHUDText",162,ScrH()-60,Color(0,0,0,200),TEXT_ALIGN_CENTER)
			draw.SimpleText(tostring(amm),"MutantHUDText",162,ScrH()-62,Color(255,255,255,255),TEXT_ALIGN_CENTER)
		end
	
	end
	self.BaseClass:HUDPaint()
end

function GM:Think()
	
end

function GM:HUDShouldDraw(el)
	if el == "CHudHealth" or el == "CHudAmmo" then return false end
	return self.BaseClass:HUDShouldDraw(el)
end
