/*---------------------------------------------------------
Init
---------------------------------------------------------*/
function EFFECT:Init(data)

	local particule = ParticleEmitter( data:GetOrigin() );
		for i=1, 40 do
			local pos = Vector(math.Rand(-20, 20), math.Rand(-20, 20), math.Rand(-20, 20) + 30);
			local smoke = particule:Add( "particle/particle_smokegrenade", data:GetOrigin() + pos );
			if (smoke) then
	
				smoke:SetVelocity(VectorRand() * math.Rand(2000,2300));
				
				smoke:SetLifeTime(0);
				smoke:SetDieTime(math.random(20,32));
				
				smoke:SetColor(math.random(220, 240), math.random(220, 240), math.random(220, 240));
				smoke:SetStartAlpha(math.Rand(245,255));
				smoke:SetEndAlpha(math.Rand(0,50));
				
				smoke:SetStartSize(math.Rand(350, 450));
				smoke:SetEndSize(math.Rand(550, 650));
				
				smoke:SetRoll(math.Rand(-180, 180));
				smoke:SetRollDelta(math.Rand(-0.2,0.2));
				
				smoke:SetAirResistance(math.Rand(520,620));
				smoke:SetGravity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(20, -20)));

				smoke:SetCollide(true);
				smoke:SetBounce(0.5);

				smoke:SetLighting(0);
			end
		end
	particule:Finish()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
Render
---------------------------------------------------------*/
function EFFECT:Render()
end

