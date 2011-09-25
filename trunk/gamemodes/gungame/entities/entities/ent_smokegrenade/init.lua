AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/w_eq_smokegrenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetNetworkedString("Owner", "World")
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.timer = CurTime() + 3
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
local exp
function ENT:Think()
	if self.timer < CurTime() then

	self.Entity:EmitSound(Sound("BaseSmokeEffect.Sound"))

	local pos = self.Entity:GetPos()

	self.Entity:Fire("kill", "", 15)
	self.timer = CurTime() + 20

-- OLD SMOKE EFFECT IN THE VERSION 1.0 ONLY
/*---------------------------------------------------------
		exp = ents.Create("env_smoketrail")
			exp:SetKeyValue("startsize","100000")
			exp:SetKeyValue("endsize","130")
			exp:SetKeyValue("spawnradius","250")
			exp:SetKeyValue("minspeed","0.1")
			exp:SetKeyValue("maxspeed","0.5")
			exp:SetKeyValue("startcolor","200 200 200")
			exp:SetKeyValue("endcolor","200 200 200")
			exp:SetKeyValue("opacity","1")
			exp:SetKeyValue("spawnrate","15")
			exp:SetKeyValue("lifetime","15")
			exp:SetPos(pos)
			exp:SetParent(self.Entity)

		exp:Spawn()
		exp:Fire("kill","",20)
---------------------------------------------------------*/

-- OLD SMOKE EFFECT IN THE VERSION 3.0 ONLY
/*---------------------------------------------------------
		local smoke = EffectData();
			smoke:SetOrigin(self.Entity:GetPos());
			util.Effect("effect_smokegrenade", smoke);
---------------------------------------------------------*/

-- OLD SMOKE EFFECT IN THE VERSION 1.0 AND 2.0 AND 3.0
/*---------------------------------------------------------
	local ar2Explo = ents.Create( "env_ar2explosion" )
		ar2Explo:SetOwner( self.Owner )
		ar2Explo:SetPos( self.Entity:GetPos() )
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire( "Explode", "", 0 )
---------------------------------------------------------*/
	end
end

/*---------------------------------------------------------
KeyValue
---------------------------------------------------------*/
function ENT:KeyValue( key, value )
end

/*---------------------------------------------------------
OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
end


/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use( activator, caller, type, value )
end


/*---------------------------------------------------------
StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
end


/*---------------------------------------------------------
EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( entity )
end


/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end