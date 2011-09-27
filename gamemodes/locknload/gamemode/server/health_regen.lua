GM.MaxPlayerHealth = 120
GM.HealthSquareValue = 40
GM.RegenHurtDelay = 4
GM.RegenRate = 0.1

function GM:HealthRegenThink ()
	if (self.NextHealthRegenThink or 0) > CurTime() then return end
	for _,ply in pairs (player.GetAll()) do
		if
			(not ((ply:Health() / self.HealthSquareValue) == math.floor(ply:Health() / self.HealthSquareValue)))
			and ((ply.LastHurt or 0) + self.RegenHurtDelay < CurTime())
		then
			ply:SetHealth (ply:Health() + 1)
		end
	end
	self.NextHealthRegenThink = CurTime() + 0.1
end

GM:AddHook ("Think", "HealthRegenThink")

function GM:HealthRegenPlayerHurt (ply)
	ply.LastHurt = CurTime()
end

GM:AddHook ("PlayerHurt", "HealthRegenPlayerHurt")