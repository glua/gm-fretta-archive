include("shared.lua")

include("cl_scoreboard_override.lua")
include("cl_camera.lua")
include("cl_hud.lua")

include("vgui/vgui_victory_counter.lua")

local HiddenHudElements = {
	CHudDamageIndicator = 1,
	CHudHealth = 1,
	CHudBattery = 1,
	CHudAmmo = 1,
	CHudSecondaryAmmo = 1,
	CHudCrosshair = 1,
	CHudSuitPower = 1,
}

function GM:HUDDrawTargetID()
     return false
end

function GM:HUDShouldDraw(n)
	if HiddenHudElements[n] then return false end
	return true
end

function GM:OnEntityCreated(ent)
	if ValidEntity(ent) and ent:GetClass()=="class C_PhysPropClientside" then
		ent:SetColor(255,100,100,255)
	end
end

GibsToCleanUp = {}
GIB_LIFETIME = 3
GIB_FADETIME = 1
hook.Add("Think", "CleanUpGibs", function()
	for k,v in pairs(GibsToCleanUp) do
		if ValidEntity(k) then
			local d = v - CurTime()
			if d<=0 then
				k:Remove()
				GibsToCleanUp[k] = nil
			elseif d<GIB_FADETIME then
				local r,g,b = k:GetColor()
				local a = Lerp(d/GIB_FADETIME, 0, 255)
				k:SetColor(r,g,b,a)
			end
		else
			GibsToCleanUp[k] = nil
		end
	end
end)

hook.Add("OnEntityCreated", "PlayerRagdollCreated", function(ent)
	if not ValidEntity(ent) then return end
	local c = ent:GetClass()
	
	if c=="class C_HL2MPRagdoll" then
		for _,v in pairs(player.GetAll()) do
			if v:GetRagdollEntity()==ent then
				gamemode.Call("SetupPlayerRagdoll", v, ent)
				return
			end
		end
	elseif c=="class C_PhysPropClientside" or c=="class C_ClientRagdoll" then
		GibsToCleanUp[ent] = CurTime() + GIB_LIFETIME
	end
end)

function GM:SetupPlayerRagdoll(pl, rag)
	for i=0,rag:GetPhysicsObjectCount()-1 do
		local phys = rag:GetPhysicsObjectNum(i)
		
		-- makes up for some epic spins and faceplants
		if i==0 then
			phys:SetDamping(0,0)
			phys:SetMass(500)
		else
			phys:SetDamping(3,0)
		end
		phys:EnableMotion(false)
		phys:EnableMotion(true)
		phys:ApplyForceCenter(Vector(0,0,math.Rand(500,700)*phys:GetMass()))
	end
end