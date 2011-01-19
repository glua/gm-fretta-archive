
EFFECT.Gibs = {"models/props/cs_italy/bananna.mdl",
"models/props/cs_italy/banannagib1.mdl",
"models/props/cs_italy/orangegib1.mdl",
"models/props/cs_office/projector_remote_p2.mdl",
"models/weapons/w_bugbait.mdl",
"models/props_junk/shoe001a.mdl",
"models/props_junk/watermelon01_chunk02a.mdl",
"models/props_junk/watermelon01_chunk02b.mdl",
"models/props_junk/watermelon01_chunk01b.mdl",
"models/props_junk/watermelon01_chunk01c.mdl",
"models/props_combine/breenbust_chunk02.mdl",
"models/props_combine/breenbust_chunk03.mdl",
"models/props_combine/breenbust_chunk04.mdl",
"models/props_combine/breenbust_chunk05.mdl",
"models/props_combine/breenbust_chunk06.mdl",
"models/props_combine/breenbust_chunk07.mdl",
"models/props_wasteland/prison_sinkchunk001b.mdl",
"models/props_wasteland/prison_toiletchunk01f.mdl",
"models/props_wasteland/prison_toiletchunk01i.mdl",
"models/props_wasteland/prison_toiletchunk01j.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/gibs/HGIBS_spine.mdl",
"models/gibs/HGIBS_rib.mdl",
"models/gibs/HGIBS_scapula.mdl",
"models/gibs/hgibs.mdl",
"models/gibs/antlion_gib_small_1.mdl",
"models/gibs/antlion_gib_small_2.mdl",
"models/gibs/antlion_gib_medium_1.mdl",
"models/gibs/antlion_gib_medium_2.mdl"}

EFFECT.Sounds = {"npc/antlion_grub/squashed.wav",
"physics/flesh/flesh_squishy_impact_hard1.wav",
"physics/flesh/flesh_squishy_impact_hard2.wav",
"physics/flesh/flesh_squishy_impact_hard3.wav",
"physics/flesh/flesh_squishy_impact_hard4.wav",
"physics/flesh/flesh_bloody_impact_hard1.wav",
"ambient/levels/canals/toxic_slime_sizzle1.wav",
"ambient/levels/canals/toxic_slime_gurgle2.wav",
"ambient/levels/canals/toxic_slime_gurgle4.wav"}

for k, v in pairs( EFFECT.Gibs ) do
	util.PrecacheModel( v )
end

for k, v in pairs( EFFECT.Sounds ) do
	util.PrecacheSound( v )
end

function EFFECT:Init( data )

	self.LifeTime = CurTime() + math.random( 25, 30 )
	
	if math.random(1,3) == 1 then
		self.SoundTime = CurTime() + math.Rand( 0, 3 )
	end
	
	local model = table.Random( self.Gibs ) or "models/gibs/hgibs.mdl"
	self:SetModel( model )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	
	self:SetPos( data:GetOrigin() )
	self:SetMaterial( "models/flesh" )
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
	
		phys:Wake()
		phys:SetAngle( VectorRand():Angle() )
		phys:SetVelocity( VectorRand() * 500 + Vector( 0, 0, 250 ) )
		phys:AddAngleVelocity( Angle( math.random(-250,250), math.random(-250,250), math.random(-250,250) ) )
	
	else
	
		MsgN( "GIB ERROR: Invalid gib model: "..self:GetModel() )
		self:Remove()
	
	end
	
end

function EFFECT:Think()

	if self.SoundTime and self.SoundTime < CurTime() then
	
		WorldSound( table.Random( self.Sounds ), self:GetPos(), 80, math.random(90,110) )
		self.SoundTime = nil
	
	end

	return self.LifeTime > CurTime()
	
end

function EFFECT:Render()

	self:DrawModel()

end



