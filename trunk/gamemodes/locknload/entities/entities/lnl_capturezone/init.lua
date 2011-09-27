ENT.Type = "brush"

function ENT:Initialize ()
	GAMEMODE.CaptureZone = self.Entity
end

function ENT:CreateDrawHandler ()
	self.DrawHandler = ents.Create ("lnl_capturezone_drawhandler")
	self.DrawHandler:SetPos (self.Entity:OBBCenter())
	self.DrawHandler:Spawn()
end

function ENT:StartTouch (ent)
	if not ent:IsPlayer() then return end
	GAMEMODE:CaptureZoneEntered (ent)
end

function ENT:EndTouch (ent)
	if not ent:IsPlayer() then return end
	GAMEMODE:CaptureZoneExited (ent)
end