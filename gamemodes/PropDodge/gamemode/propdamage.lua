//Modified Simple Prop Damage script by ltp0wer

spd = spd or {}

hook.Add("EntityRemoved", "spdEntityRemoved", function(ent)
    if ent:IsValid() and
    ent:GetClass() == "prop_physics" and
    ent:Health() == 0 then
        spd[ent:EntIndex()] = nil
    end
end)

hook.Add("EntityTakeDamage", "spdEntityTakeDamage", function(ent, inflictor, attacker, amount)
    if ent:IsValid() and
	spd[ent:EntIndex()] then
        spd[ent:EntIndex()] = spd[ent:EntIndex()] - amount / 2
		local mass = ent:GetPhysicsObject():GetMass()
		local colmod = spd[ent:EntIndex()] / mass
        ent:SetColor(255, colmod * 255, colmod * 255, 255)

        if spd[ent:EntIndex()] < mass * 0.5 then
            ent:GetPhysicsObject():EnableMotion(true)
        end

        if spd[ent:EntIndex()] < mass * 0.25 and
        ent:IsConstrained() then
            local effect = EffectData()
            effect:SetStart(ent:GetPos())
            effect:SetOrigin(ent:GetPos()+ Vector(0, 0, 10))
            effect:SetScale(mass)
            util.Effect("cball_explode", effect)
            constraint.RemoveAll(ent)
        end

        if spd[ent:EntIndex()] < 1 then
			local effect = EffectData()
			effect:SetStart(ent:GetPos())
			effect:SetOrigin(ent:GetPos()+ Vector(0, 0, 10))
			effect:SetScale(mass)
			util.Effect("cbal_explode", effect)
			if( ent.propreg != nil ) then propreg.propcount = propreg.propcount - 1 end
			ent:Remove()
        end
    end
end)

hook.Add("OnEntityCreated", "spdOnEntityCreated", function(ent)
    timer.Simple(0.01, function()
        if ent:IsValid() and
        ent:GetClass() == "prop_physics" and
        ent:Health() == 0 then
            spd[ent:EntIndex()] = propreg:GetHealth( ent.pid, ent )
        end
    end, ent)
end)