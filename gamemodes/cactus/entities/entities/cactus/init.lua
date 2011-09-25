
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
	
	ENT.CactusData = {}
	ENT.CountDown = 10
	ENT.CountingDown = false
	ENT.Trail = nil
	ENT.IsSpamming = true
	
function ENT:SpawnFunction( hitEnt, tr )
   
 	if ( !tr.Hit ) then return end 
 	
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	
 	local ent = ents.Create( "cactus" )
		ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	
	return ent 
 	
end

function ENT:Initialize()
	
	self.CactusData["slow"] = {color = Color(0, 0, 255, 255), difficulty = 1, randspam = {a = 2, b = 5}, sounds = taunts.slow, pitch = 95, score = 1}
	self.CactusData["fast"] = {color = Color(255, 0, 0, 255), difficulty = 5, randspam = {a = 0, b = 0.5}, sounds = taunts.fast, pitch = 120, score = 3}
	self.CactusData["normal"] = {color = Color(0, 255, 0, 255), difficulty = 3, randspam = {a = 1, b = 3}, sounds = taunts.normal, pitch = 100, score = 2}
	self.CactusData["powerup"] = {color = Color(255, 0, 255, 255), difficulty = 3, randspam = {a = 1, b = 3}, sounds = taunts.normal, pitch = 100, score = 1}
	self.CactusData["explosive"] = {color = Color(0, 0, 0, 255), difficulty = 5, randspam = {a = 0, b = 0.5}, sounds = taunts.normal, pitch = 100, score = 0}
	self.CactusData["golden"] = {color = Color(255, 255, 0, 255), difficulty = 100, randspam = {a = 0, b = 0.1}, sounds = taunts.normal, pitch = 130, score = 5}
	--self.CactusData[""] = {color = Color(255, 255, 0, 255), difficulty = 100, randspam = {a = 0, b = 0.1}, sounds = taunts.normal, pitch = 130, score = 5}
	
 	self:SetModel( "models/props_lab/cactus.mdl" ) 
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

 	local phys = self:GetPhysicsObject()
 	if (phys:IsValid()) then
		phys:Wake() 
 	end
	
	local level = GetGlobalInt("difficulty")/5
	local speed = (1/level)
	local speak = speed*2
	
	timer.Create("spamtimer_"..self:EntIndex(), speed, 0, self.Spam, self)
	--timer.Create("speaktimer_"..self:EntIndex(), speak, 0, self.Speak, self)
	
	--self:StartMotionController()
	--self.ShadowParams = {}
	
end

function ENT:OnTakeDamage( dmginfo )

 	self:TakePhysicsDamage( dmginfo )
	
end

function ENT:Spam()

	if ValidEntity(self) then
		
		local spamtime = self.CactusData[self:GetNWString("cactustype")]["randspam"]
		local randspam = math.random(spamtime.a, spamtime.b)
		local entdifficulty = self.CactusData[self:GetNWString("cactustype")]["difficulty"]
		local sounds = self.CactusData[self:GetNWString("cactustype")]["sounds"]
		local pitch = self.CactusData[self:GetNWString("cactustype")]["pitch"]
		local difficulty = GetGlobalInt("difficulty")
		timer.Simple(randspam, function() if ValidEntity(self) then self:GetPhysicsObject():ApplyForceCenter( VectorRand()*999*entdifficulty*self:Level()*difficulty ) self:EmitSound( table.Random(sounds), 80, pitch ) end end)
		
	end
	
end

/*function ENT:Speak()

	if ValidEntity(self) then
		
		local spamtime = self.CactusData[self:GetNWString("cactustype")]["randspam"]
		PrintTable(spamtime)
		local randspam = math.random(spamtime.a, spamtime.b)
		local sounds = self.CactusData[self:GetNWString("cactustype")]["sounds"]
		local pitch = self.CactusData[self:GetNWString("cactustype")]["pitch"]
		timer.Simple(randspam, function() if ValidEntity(self) then self:EmitSound( table.Random(sounds), 80, pitch ) end end)
		
	end
	
end*/

function ENT:PreExplode()
	
	local function CountDownToDetonate()
		if self.CountingDown == true then
			self.CountDown = self.CountDown-1 or self.CountDown
			timer.Simple(1, function() CountDownToDetonate() end)
		end
	end
	if ValidEntity(self) and self:GetNWString("cactustype") == "explosive" then
		
		self.CountingDown = true
		
		timer.Simple(10, self.Explode, self)
		CountDownToDetonate()
		
	end
	
end

function ENT:Explode()

	if ValidEntity(self) and self:GetNWString("cactustype") == "explosive" then
		
		self:EmitSound("5cacti.mp3", 200, 100)
		
		for i=1,5 do
			local cactus = ents.Create("cactus")
			cactus:SetPos(self:GetPos()+Vector(math.random(-10,10),math.random(-10,10),0))
			cactus:Spawn()
			cactus:SetCactusType(UTIL_GetValidCactus())
			timer.Simple(1, cactus.Spam, cactus)
		end
		
		local position = self:GetPos()
		local damage = 500
		local radius = math.random(800,1000)
		local attacker = self
		local inflictor = self
		
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart( vPoint ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
		effectdata:SetOrigin( vPoint )
		effectdata:SetScale( 3 )
		
		timer.Simple(0.01, function() util.BlastDamage(inflictor, attacker, position, radius, damage) util.Effect( "Explosion", effectdata ) end)
		timer.Simple(0.1, function() if ValidEntity(self) then self:Remove() end end)
		
	end
	
end

function ENT:Remove()
	
	if timer.IsTimer("spamtimer_"..self:EntIndex()) then
		timer.Destroy("spamtimer_"..self:EntIndex())
	end
	if timer.IsTimer("bombtick_"..self:EntIndex()) then
		timer.Destroy("bombtick_"..self:EntIndex())
	end
	if timer.IsTimer("speaktimer_"..self:EntIndex()) then
		timer.Destroy("speaktimer_"..self:EntIndex())
	end

end

function ENT:Think()
	
	if !self:IsInWorld() then
		SafeRemoveEntity(self)
	end
	
end

function ENT:Level()
	return GetGlobalInt("RoundNumber")
end

function ENT:GetCactusType()

	return self:GetNWString("cactustype")
	
end
function ENT:SetCactusType(cactustype)
	
	self:SetNWString("cactustype", cactustype)
	
	local color = self.CactusData[self:GetNWString("cactustype")]["color"]

	self.Entity:SetColor(color.r, color.g, color.b, color.a)
	
	if self:GetNWString("cactustype") == "explosive" then
		color = self.CactusData[table.Random(types)]["color"]
		if color == self.CactusData["explosive"]["color"] then
			color = self.CactusData["normal"]["color"]
		end
		timer.Create("bombtick_"..self:EntIndex(), 0.5, 0, function() if ValidEntity(self) then self:EmitSound( "Buttons.snd14", 100, 100 ) end end)
	end
	
	self.Trail = util.SpriteTrail(self.Entity, 0, Color(color.r, color.g, color.b) or Color(0, 255, 0), false, 30, 1, 3, 1/(15+1)*0.5, "trails/plasma.vmt")
	
	timer.Simple(1, self.Spam, self)
	
end

