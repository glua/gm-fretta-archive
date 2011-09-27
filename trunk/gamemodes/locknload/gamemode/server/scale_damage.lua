function GM:ScalePlayerDamage (ply, hitgroup, dmginfo)
	dmginfo:ScaleDamage(0)
	if dmginfo:GetAttacker() == ply then
		dmginfo:ScaleDamage(-0.6)
	end
end