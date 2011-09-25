ANGTEST = Angle(0,0,0)

EFFECT.Author = "Ghor"

local ENTITY = FindMetaTable("Entity") --The base table for all entities

EFFECT.Created		= 0 --when the entity was first spawned
EFFECT.UPCreated	= 0
EFFECT.LastTrace	= 0 --the last time the entity calculated a movement trace
EFFECT.LifeTime		= 0 --if nonzero, the entity will remove itself after this many seconds
EFFECT.Direction	= Vector(0,0,0) --unit vector representing the direction of the projectile
EFFECT.Speed		= 0 --scalar value representing how fast the entity should be moving
EFFECT.Mins			= Vector(-8,-8,-8) --default hull mins for movement trace
EFFECT.Maxs			= Vector(8,8,8) --default hull maxes for movement trace
EFFECT.Die			= ENTITY.Remove --make this function point to the normal remove function, done this way to be overriden in derived classes
EFFECT.DieByAge		= ENTITY.Remove --make this function point to the normal remove function, done this way to be overriden in derived classes
local mat = Material("gtv/bullet1")

local function GetDelta(ptime) --return the time in seconds since ptime (ptime is in seconds and is based on how long ago the server started)
	return math.max(CurTime()-ptime,0)
end

function EFFECT:Init(data)
	self:SetOwner(data:GetEntity())
	self.TraceTable = { --setup the table that this entity will use for movement traces
		["mask"]	= MASK_SHOT,
		["filter"]	= {self,self:GetOwner()}, --to avoid collisions with itself and the entity firing it
		["mins"]	= self.Mins, --set the table mins to point to our mins
		["maxs"]	= self.Maxs --set the table maxes to point to our maxes
		}
	self.Created	= CurTime()
	self.UPCreated	= UnPredictedCurTime()
	self.LifeTime	= data:GetScale()
	self.LastTrace	= self.Created
	self:InitVelocity(data:GetStart())
	self:SetMoveType(MOVETYPE_NONE) --use movetype none since we will be calculating our own movement and collision
	self.col = Color(255,255,255,255)
	self.col2 = Color(0,0,0,255)
end

function EFFECT:Render()
	if self.LifeTime != 0 then
		self.col.a = math.Clamp(((self.LifeTime+self.Created)-CurTime())*(1/self.LifeTime)*255,0,255)
		self.col2.a = math.Clamp(((self.LifeTime+self.Created)-CurTime())*255,0,255)
	end
	if self.UPCreated+0.02 < UnPredictedCurTime() then
		render.SetMaterial(mat)
		//render.DrawSprite(self:GetPos(),16,16,self.col2)
		//render.DrawSprite(self:GetPos(),16,16,self.col)
		--render.DrawBeam(self:GetPos(),self:GetPos()-self.Direction*60,16,0,1,self.col)
	end
	return true
end

function EFFECT:InitVelocity(vel)
	self.Direction	= vel:GetNormalized()
	self.Speed		= vel:Length()
	self:SetAngles(vel:Angle())
end

function EFFECT:CollisionCallback(tr) --called if the movement trace encounters an obstacle
	ParticleEffect("gtv_impact_bullet2",tr.HitPos,tr.Normal:Angle(),Entity(0))
	//if tr.MatType != MAT_FLESH then --annoying as fuck but keeping the code in case I can find another sound that's good
	//	self:EmitSound("weapons/fx/rics/ric"..math.random(1,5)..".wav",20)
	//end
	//local edata = EffectData()
	//edata:SetOrigin(tr.HitPos)
	//edata:SetNormal(tr.HitNormal)
	//util.Effect("ef_gtv_bulletimpact",edata)
	self:Die()
	return false
end

function EFFECT:ProcessMovement() --run collision trace and move self accordingly, calling CollisionCallback if the trace hit something
	self.TraceTable.start	= self:GetPos()
	self.TraceTable.endpos	= self:GetPos()+self.Direction*self.Speed*GetDelta(self.LastTrace)
	local tr = util.TraceHull(self.TraceTable)
	self:SetPos(tr.HitPos)
	if (tr.Hit) then
		self:CollisionCallback(tr)
	end
	self.LastTrace = CurTime()
end

function EFFECT:Think()
	if !self.MadeEffect then
		//ParticleEffect("gtv_bullet",self:GetPos(),self:GetAngles(),self)
		ParticleEffectAttach("gtv_bullet",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.MadeEffect = true
	end
	if ((self.LifeTime != 0) && (self.LifeTime+self.Created < CurTime())) then
		self:DieByAge()
		return
	end
	self:ProcessMovement()
	return true
end