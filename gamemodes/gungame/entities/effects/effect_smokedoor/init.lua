function EFFECT:Init( data )

	local vOffset = data:GetOrigin()

	local emitter = ParticleEmitter( data:GetOrigin() );
		for i = 40, 50 do

			local smoke = emitter:Add( "particle/particle_smokegrenade", vOffset );

			if (smoke) then

				smoke:SetVelocity(VectorRand() * 600);
				
				smoke:SetLifeTime(0);
				smoke:SetDieTime(math.Rand(5, 10));
				
				smoke:SetColor(120, 120, 120);
				smoke:SetStartAlpha(math.Rand(240, 255));
				smoke:SetEndAlpha(0);
				
				smoke:SetStartSize(math.Rand(30, 45));
				smoke:SetEndSize(math.Rand(175, 225));
				
				smoke:SetRoll(math.Rand(-180, 180));
				smoke:SetRollDelta(math.Rand(-0.1, 0.1));
				
				smoke:SetAirResistance(math.Rand(400, 600));
				smoke:SetGravity( Vector( 0, 0, math.Rand(0, 10) ) );

				smoke:SetCollide( true );

--				smoke:SetLighting(1);
			end
		end
		
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end

