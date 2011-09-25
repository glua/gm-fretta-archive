include("init.lua")

EFFECT.Rocks = {}
EFFECT.Mat = Material("particle/warp_ripple")
--EFFECT.Mat2 = Material("decals/rollermine_crater")
EFFECT.Sound = Sound("Breakable.MatConcrete")
/*
EFFECT.PMat = "effects/particles/pollen"

EFFECT.PollenFiles = {}
EFFECT.PollenTypes = {"red","blue","green","yellow"}

local numfiles = 2

for k, v in pairs(EFFECT.PollenTypes) do
	for i = 1, numfiles do
		local filename = EFFECT.PMat.."_"..v.."_"..i
		table.insert(EFFECT.PollenFiles, filename)
	end
end*/

function EFFECT:Init( data ) 

 	self.vOffset = data:GetOrigin()
	--local ent = data:GetEntity()
	--self.tr = util.QuickTrace(self.vOffset, self.vOffset + vector_up*-15, ent)
	self.Normal = Vector(0,0,1)
	self.Emitter = ParticleEmitter( self.vOffset )
	self.Emitter:SetNearClip(20, 26)
	
	self.Entity:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	
	self.Alpha = 255
	self.Alpha2 = 255
	self.Speed = 0.05
	self.Size = 4
	self.HasFired = 0
	
	self:EmitSound(self.Sound, 100, 100)
	/*
	local pollen_emitter = ParticleEmitter(self.vOffset)
	for i=0, 50 do
		local pollen = table.Random(self.PollenFiles)
		local p = pollen_emitter:Add( pollen, self.vOffset + Vector(0,0,10) )
		if p then
			local crand = math.random( -10, 10 ) --Random color
			local vrand = math.random( 100, 900 ) --Random velocity
			local drand = math.random( 3, 5 ) --Random die time
			local srand = math.random( 10, 20 ) --Random size
			p:SetColor( 255, 255, 255, 255 )
			p:SetVelocity( VectorRand() * vrand ) -- Vector( vrand, vrand, vrand ):GetNormal() * speed/10
			p:VelocityDecay( 0.8 )
			p:SetStartSize( srand )
			p:SetEndSize( 0 )
			p:SetRollDelta(360-math.sin(15*FrameTime()))
			p:SetCollide( true )
			p:SetDieTime( drand )
		end
	end
	pollen_emitter:Finish()
	*/
	
end 
   
function EFFECT:Think( )
	self.Emitter:SetPos(self.Entity:GetPos())
	self.Alpha = self.Alpha - FrameTime() * 255 * 5 * self.Speed
	self.Alpha2 = self.Alpha2 - FrameTime() * 255 * 15 * self.Speed
	self.Size = self.Size + FrameTime() * 256 * 300 * self.Speed
	if self.Alpha2 < 1 then
		self.Size = 0
	end
	for k, v in pairs(self.Rocks) do
		if !ValidEntity(v) then return end
		local r,g,b,a = v:GetColor()
		v:SetColor(r,g,b,self.Alpha)
		if (a <= 1 ) then
			v:Remove()
		end
		timer.Simple(10, function() if ValidEntity(v) then v:Remove() end end)
	end
	
	if (self.Alpha < 1 and self.Alpha2 < 1 ) then
		return false
	end
	return true
end

function EFFECT:Render( )
	if (self.Alpha < 1 and self.Alpha2 < 1 ) then return end
	if ( render.SupportsHDR() ) then
		render.SetMaterial( self.Mat ) 
		render.DrawQuadEasy( self.vOffset, self.Normal, self.Size, self.Size, Color( 255,255,255,self.Alpha2 ))
	end
	/*if self.tr.Hit then
		render.SetMaterial( self.Mat2 )
		render.DrawQuadEasy( self.vOffset, self.Normal, 200, 200, Color( 255,255,255,self.Alpha ))
	else
		self.Alpha = 0
	end*/
	if self.HasFired == 1 then return end
	if self.HasFired == 0 then
		self.HasFired = 1
	 	for i=1,10 do  
			local rock = ents.Create("prop_physics")
 			rock:SetModel("models/props_debris/concrete_chunk05g.mdl")
			rock:SetPos(self.vOffset+VectorRand()*5)
			rock:SetAngles(Angle(math.Rand(-50, 50),math.Rand(-50, 50),math.Rand(-50, 50)))
			rock:Spawn()
			rock:Activate()
			rock:SetModelScale( (Vector( )) * math.Rand(2,7) )
			rock:PhysicsInitBox(rock:OBBMins(), rock:OBBMaxs())  
			rock:SetCollisionBounds(rock:OBBMins(), rock:OBBMaxs())  
			rock:SetMoveType(MOVETYPE_VPHYSICS)  
			rock:SetSolid(SOLID_VPHYSICS)
			rock:SetColor(255,255,255,self.Alpha)
			self.Rocks[i] = rock
			local phys = rock:GetPhysicsObject()  
			if phys:IsValid() then  
				phys:Wake()
				phys:EnableGravity(true)
				phys:ApplyForceCenter( VectorRand()*99999 ) 
			end
		end
		local emitter = self.Emitter
		for i=1,math.min(16, math.ceil(FrameTime() * 200)) do
			local particle = emitter:Add( "effects/smoke", self.vOffset ) --change this!
			particle:SetColor(50,50,50,255)
			particle:SetVelocity( VectorRand() * 80 )
			particle:VelocityDecay( 2 )
			particle:SetDieTime( math.Rand(2, 4) )		 
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(100,150) )
			particle:SetEndSize( math.Rand(450,500) )
			particle:SetRoll( math.Rand(0, 100) )
			particle:SetRollDelta( math.Rand(-1, 1) )
			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, 10 ) )
		end
		if ( render.SupportsHDR() ) then
			for i=1,math.min(3, math.ceil(FrameTime() * 200)) do
			local particle = emitter:Add( "particle/warp1_warp", self.vOffset )
			particle:SetVelocity( VectorRand() * 80 )
			particle:VelocityDecay( 10 )
			particle:SetDieTime( 3 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(150,130) )
			particle:SetEndSize( math.Rand(50,10) )
			particle:SetAirResistance( 50 )
			end
		end
		self.Emitter:Finish()
	end
end
