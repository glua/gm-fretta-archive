function GM:TertiaryAttackPressed (ply, key)
	if not (key == IN_USE) then return end
	local wpn = ply:GetActiveWeapon()
	if ValidEntity(wpn) and wpn.Tertiary and wpn.Tertiary.Attack then
		wpn.Tertiary.Attack (wpn)
	end
end

GM:AddHook ("KeyPress", "TertiaryAttackPressed")

function GM:TertiaryAttackThink ()
	for _,ply in pairs (player.GetAll()) do
		local wpn = ply:GetActiveWeapon()
		if ValidEntity(wpn) and wpn.Tertiary and wpn.Tertiary.Think then
			wpn.Tertiary.Think (wpn)
		end
	end
end

GM:AddHook ("Think", "TertiaryAttackThink")

function GM:TertiaryAttackDrawHUD ()
	for _,ply in pairs (player.GetAll()) do
		local wpn = ply:GetActiveWeapon()
		if ValidEntity(wpn) and wpn.Tertiary and wpn.Tertiary.DrawHUD then
			wpn.Tertiary.DrawHUD (wpn)
		end
	end
end

GM:AddHook ("HUDPaint", "TertiaryAttackDrawHUD")