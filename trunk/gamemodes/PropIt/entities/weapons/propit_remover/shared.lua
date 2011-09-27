// Variables that are used on both client and server

SWEP.Author				= ""
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""

SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.AnimPrefix			= "python"

// Be nice, precache the models
util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

// Todo, make/find a better sound.
SWEP.ShootSound			= Sound( "Airboat.FireGunRevDown" )

SWEP.Tool				= {}
SWEP.Entity	= nil

SWEP.Primary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.Secondary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.CanHolster			= true
SWEP.CanDeploy			= true

function SWEP:InitializeTools()

	local temp = {}
	
	for k,v in pairs( self.Tool ) do
		temp[k] = table.Copy(v)
		temp[k].SWEP = self
		temp[k].Owner = self.Owner
		temp[k].Weapon = self.Weapon
	end
	
	self.Tool = temp
	
end

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	self:InitializeTools()
	
	// We create these here. The problem is that these are meant to be constant values.
	// in the toolmode they're not because some tools can be automatic while some tools aren't.
	// Since this is a global table it's shared between all instances of the gun.
	// By creating new tables here we're making it so each tool has its own instance of the table
	// So changing it won't affect the other tools.
	
	self.Primary = 
	{
		// Note: Switched this back to -1.. lets not try to hack our way around shit that needs fixing. -gn
		ClipSize 	= -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
	
	self.Secondary = 
	{
		ClipSize 	= -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
	
end

/*---------------------------------------------------------
   Precache Stuff
---------------------------------------------------------*/
function SWEP:Precache()

	util.PrecacheSound( self.ShootSound )
	
end

/*---------------------------------------------------------
	Reload clears the objects
---------------------------------------------------------*/
function SWEP:Reload()
	
end

/*---------------------------------------------------------
	Think does stuff every frame
---------------------------------------------------------*/
function SWEP:Think()
	
end


/*---------------------------------------------------------
	The shoot effect
---------------------------------------------------------*/
function SWEP:DoShootEffect( hitpos, hitnormal, entity, physbone )

	self.Weapon:EmitSound( self.ShootSound	)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 	// View model animation
	
	// There's a bug with the model that's causing a muzzle to 
	// appear on everyone's screen when we fire this animation. 
	//self.Owner:SetAnimation( PLAYER_ATTACK1 )			// 3rd Person Animation
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetNormal( hitnormal )
		effectdata:SetEntity( entity )
		effectdata:SetAttachment( physbone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
	
end

/*---------------------------------------------------------
	Trace a line then send the result to a mode function
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	DoRemoveEntity( trace.Entity )
	
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone )
	
end


/*---------------------------------------------------------
	SecondaryAttack 
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
end

function DoRemoveEntity( Entity )
	if (!Entity) then return false end
	if (!Entity:IsValid()) then return false end
	if (Entity:IsPlayer()) then return false end

	// Nothing for the client to do here
	if ( CLIENT ) then return true end

	// Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll( Entity )
	
	// Remove it properly in 1 second
	
	// Make it non solid
	Entity:SetNotSolid( true )
	Entity:SetMoveType( MOVETYPE_NONE )
	Entity:SetNoDraw( true )
	
	// Send Effect
	local ed = EffectData()
		ed:SetEntity( Entity )
	util.Effect( "entity_remove", ed, true, true )
	
	if (Entity:IsValid()) then
		Entity:Remove()
	end
	
	return true
end