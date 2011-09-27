include ("shared.lua")

function ENT:Initialize ()
	--print ("evenin' guv.")
	self.Entity:SetRenderBounds (Vector() * -10000, Vector() * 10000)
	GAMEMODE.CaptureZoneDrawHandler = self.Entity
end

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

function ENT:Think ()
	--[[print ("-")
	self.Entity:SetPos (LocalPlayer():GetPos())]]
end

function ENT:Draw ()
	--print ("+")
	GAMEMODE:CaptureZoneDraw ()
end