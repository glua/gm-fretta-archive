ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/

function ENT:Think( )
	if self.eOwner then
		if !self.DeathTime then
			self.DeathTime = CurTime() + 5
			if (CLIENT) then
				self.DeathTime = CurTime() + 6
				self.completed = 0
			end
		end
		if (CLIENT) then
			
			self.dcountdown = math.floor( self.DeathTime - CurTime() )
			if self.dcountdown == 6 then self.dcountdown = 5 end
			
			if self.dcountdown == 0 then
				self:Explode()
			elseif self.completed != self.dcountdown then
				self.BallMaterial = Material( "sprites/ball/sent_ball"..self.dcountdown )
				util.PrecacheSound("buttons/blip1.wav")
				self.Entity:EmitSound("buttons/blip1.wav", 400, 200)
				self.completed = self.dcountdown
			end
			
		elseif CurTime() >= self.DeathTime then --server only
			self:Explode()
		end	
	end
	
end

/*---------------------------------------------------------
   Name: Explode
---------------------------------------------------------*/

function ENT:Explode( )	
	if (SERVER) then
		for k,v in pairs( ents.FindInSphere( self.Entity:GetPos(), 200 ) ) do
			if v:IsPlayer() then
				if v:Team() != self.eOwner:Team() or v == self.eOwner then
					v:Jail( self.eOwner )
				end
			end
		end
		GAMEMODE:Alert( self.eOwner:Name() .. " held on to the ball too long" )
		local ed = EffectData()
		ed:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", ed, true, true )
	end
	
	self.eOwner = nil
	self.DeathTime = nil
end
