
//Shared?

//Stuff for both players and entities
local ent = FindMetaTable( "Entity" )
if (!ent) then return end

//Shared
function ent:GetCactusType() --shd?

	return self.CactusType
	
end
function ent:SetCactusType(cactustype)
	
	self.CactusType = cactustype or table.Random(Cactus.Types)
	--print("cactus type was set to "..self.CactusType)
	
	local cactusObj = Cactus.GetType(self.CactusType)
	--print("cactus object: "..tostring(cactusObj)) --table.ToString(
	
	local color = cactusObj.CColor

	self.Entity:SetColor(color.r, color.g, color.b, color.a)
	
	if self.CactusType == "explosive" then
		timer.Create("bombtick_"..self:EntIndex(), 0.5, 0, function() if ValidEntity(self) then self:EmitSound( "Buttons.snd14", 150, 150 ) end end)
	end
	
	self.Trail = util.SpriteTrail(self.Entity, 0, Color(color.r, color.g, color.b), false, 10, 1, 1/cactusObj.CLength, 1/(15+1)*0.5, "trails/smoke.vmt")
	
	timer.Simple(1, self.Spam, self)
	
end

function ent:IsCactus()
	if self:IsPlayer() and self:Team() == TEAM_CACTUS then
		return true
	elseif self:GetClass() == "sent_cactus" then
		return true
	end
	return false
end

function ent:GetCactusData(strTable)
	if !ValidEntity(self) then return end
	if self:IsPlayer() then
		if self:Team() == TEAM_CACTUS and ValidEntity(self:GetCactus()) then
			local cactus = self:GetCactus()
			local cactusObj = Cactus.GetType(cactus.CactusType)
			if strTable then
				if cactusObj[strTable] then
					return cactusObj[strTable]
				end
			else
				return cactusObj
			end
		end
	elseif self:GetClass() == "sent_cactus" then
		local cactusObj = Cactus.GetType(self.CactusType)
		if strTable then
			if cactusObj[strTable] then
				--PrintTable(cactusObj)
				return cactusObj[strTable]
			end
		else
			return cactusObj
		end
	end
end

function ent:SetPlayerObj(ply)
	self:SetNWEntity("playerobj",ply)
end
function ent:GetPlayerObj()
	return self:GetNWEntity("playerobj")
end

//Server
if !SERVER then return end

function ent:Spam()

	if ValidEntity(self) then
		
		local spamtime,randspam,entdifficulty,sounds,pitch,difficulty
		
		local cactusObj = Cactus.GetType(self.CactusType)
		spamtime = cactusObj.RandSpam
		randspam = math.random(spamtime.lower, spamtime.upper)
		entdifficulty = cactusObj.Difficulty
		sounds = cactusObj.Sounds
		pitch = cactusObj.Pitch
		difficulty = GAMEMODE:GetDifficulty()
		
		if ValidEntity(self:GetPlayerObj()) and self:GetPlayerObj():IsPlayer() then
			
			if self.IsSpamming then
				self.IsSpamming = nil
			end
			
			if !timer.Stop("spamtimer_"..self:EntIndex()) then
				timer.Stop("spamtimer_"..self:EntIndex())
			end
			
			/*local phys = self:GetPhysicsObject()
			if phys and phys:IsValid() then
				--print("applying force to valid physics object in the "..tostring(vec).." direction")
				phys:ApplyForceCenter( self.PlayerObj:GetAimVector()*999*entdifficulty*difficulty )
				self:EmitSound( table.Random(self:GetCactusData("Sounds")), 80, self:GetCactusData("Pitch") )
			else
				print("physics object is invalid")
			end*/
			--self:SetMove(self:GetPlayerObj():GetAimVector()*999*entdifficulty*difficulty)
			
		elseif self.IsSpamming then
			
			if timer.Stop("spamtimer_"..self:EntIndex()) then
				timer.Start("spamtimer_"..self:EntIndex())
			end
			
			timer.Simple(randspam, function() if ValidEntity(self) then self:GetPhysicsObject():ApplyForceCenter( VectorRand()*999*entdifficulty*difficulty ) self:EmitSound( table.Random(sounds), 80, pitch ) end end)
			
		end
	end
	
end
function ent:SetMove(vec)

	if ValidEntity(self) then
		
		--local cactusObj = Cactus.GetType(self.CactusType)
		--local entdifficulty = cactusObj.Difficulty
		--local difficulty = GAMEMODE:GetDifficulty()
		
		vec = vec or Vector(0,0,0)
		
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			--print("applying force to valid physics object in the "..tostring(vec).." direction")
			phys:ApplyForceCenter( (self:GetVelocity() * -1) + vec )--:Normalize()
		else
			print("physics object is invalid")
		end
		
		--print("ent is still valid")
		--self:GetPhysicsObject():ApplyForceCenter( vec*999*entdifficulty*difficulty )
		
	end
	
end

--AccessorFunc( ent, "_cBeingGrabbed",  "BeingGrabbed", FORCE_BOOL )
function ent:SetBeingGrabbed(bool)
	self.BeingGrabbed = bool
end
function ent:GetBeingGrabbed()
	return self.BeingGrabbed
end

--Used to simulate being grabbed in the move hook
function ent:SetGrabData(ply,typ,quit) --sv
	self.GrabData = {}
	self.GrabData.Player = ply
	self.GrabData.Type = typ
	self.GrabData.Quit = quit
	
	self.GrabGhost = ents.Create("sent_cactus_grab")
	self.GrabGhost:SetPos(self:GetPos())
	self.GrabGhost:SetAngles(self:GetAngles())
	self.GrabGhost:Spawn()
	self.GrabGhost.Cactus = self
	self:SetParent(self.GrabGhost)
end
function ent:GetGrabData() --sv
	if !self.GrabData or !self:GetBeingGrabbed() then
		return false
	end
	return self.GrabData
end


