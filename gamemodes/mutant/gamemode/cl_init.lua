include("shared.lua")
include("skin.lua")
include("hud.lua")

function GM:Tick()
	for _, pl in pairs(player.GetAll()) do
		if pl:IsMutant() then
			pl:SetHull(Vector(-30,-30,0),Vector(30,30,135))
			pl:SetHullDuck(Vector(-30,-30,0),Vector(30,30,67))
			pl:SetViewOffset(Vector(0,0,120))
			pl:SetViewOffsetDucked(Vector(0,0,45))
			pl:SetModelScale(Vector()*1.875)
		else
			pl:SetHull(Vector(-16,-16,0),Vector(16,16,72))
			pl:SetHullDuck(Vector(-16,-16,0),Vector(16,16,36))
			pl:SetViewOffset(Vector(0,0,64))
			pl:SetViewOffsetDucked(Vector(0,0,24))
			pl:SetModelScale(Vector())
		end
	end
end

function GM:Initialize()
	self.BaseClass:Initialize()
	self:CreateAmmoHUD()
end

function GM:BigMessage(text,color,duration)
	self.CurrentMessage = text
	self.CurrentMessageColor = color
	self.MessageStartTime = CurTime()
	self.MessageDuration = duration
end

local function bigMessageHandler(um)
	GAMEMODE:BigMessage(um:ReadString(),Color(um:ReadShort(),um:ReadShort(),um:ReadShort()),um:ReadFloat() or 1.0)
end

usermessage.Hook("Mutant_BigMessage",bigMessageHandler)

function GM:Think()
	self.BaseClass:Think()
	
	LocalPlayer():StopParticles()
	
	for _, pl in pairs(player.GetAll()) do
		if pl:IsMutant() then
			local dl = DynamicLight(pl:EntIndex())
			if dl then
				dl.Pos = pl:LocalToWorld(pl:OBBCenter())
				dl.r = 160
				dl.g = 255
				dl.b = 60
				dl.Brightness = 4
				dl.Size = 200
				dl.Decay = 400
				dl.DieTime = CurTime() + .4
			end
		end
	end
end

local FireMat = Material("effects/mut-screen-fire")
local DistortMat = Material("effects/mut-screen-refract")

local function DrawFireOverlay()
	--if LocalPlayer():Team() != TEAM_MUTANT or !LocalPlayer():Alive() then return end
	if not (LocalPlayer():IsMutant() and LocalPlayer():Alive()) then return end
	local c = {}
	c["$pp_colour_addr"] = 0
	c["$pp_colour_addg"] = 0
	c["$pp_colour_addb"] = 0
	c["$pp_colour_mulr"] = .9
	c["$pp_colour_mulg"] = 2
	c["$pp_colour_mulb"] = .8
	c["$pp_colour_brightness"] = -0.1
	c["$pp_colour_contrast"] = 1.4
	c["$pp_colour_colour"] = 0.7
	DrawColorModify(c)
	
	render.UpdateScreenEffectTexture()
	--render.SetMaterial(DistortMat)
	--render.DrawScreenQuad()
	render.SetMaterial(FireMat)
	render.DrawScreenQuad()
end

hook.Add( "RenderScreenspaceEffects", "MutantFire", DrawFireOverlay)

function GM:GetMotionBlurValues(x, y, fwd, spin)
	if LocalPlayer():IsMutant() and LocalPlayer():Alive() then
		fwd = fwd + (math.sin(CurTime() * 5)*.03 + .03)
		--spin = spin + math.sin(CurTime()*4)*.05
	end

	return x, y, fwd, spin
end

function GM:AddDeathNotice( victim, inflictor, attacker )
	if (!IsValid(g_DeathNotify)) then return end

	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	local aColor = nil
	local vColor = nil
	
	local mColor = Color(100,220,50)
	local bfColor = Color(160,40,220)
	
	if attacker:IsMutant() then aColor = mColor end
	if victim:IsMutant() then vColor = mColor end
	if attacker:IsBottomFeeder() then aColor = bfColor end
	if victim:IsBottomFeeder() then vColor = bfColor end
	
	pnl:AddText(attacker:Name(),aColor)
	pnl:AddIcon(inflictor)
	pnl:AddText(victim:Name(),vColor)
	
	g_DeathNotify:AddItem( pnl )
end
