SWEP.Author 		= "TotalMark", "Worshipper", "dime";
SWEP.Contact 		= "totalmark@gmail.com";
SWEP.Purpose 		= "Heal";
SWEP.Instructions 	= "Spawn Healthkits";
SWEP.Spawnable 		= true;
SWEP.AdminSpawnable = true;
SWEP.ViewModel 		= "models/weapons/v_healthkit.mdl";
SWEP.WorldModel 	= "models/items/w_medkit.mdl";
SWEP.ViewModelFlip	= false
SWEP.ViewModelFOV 	= 64;
SWEP.ReloadSound 	= "Rocket_Reload.wav";
SWEP.HoldType 		= "slam";

SWEP.Primary.Ammo		    = "none"
SWEP.Primary.ClipSize 		= 1;
SWEP.Primary.Automatic 		= false;
SWEP.Primary.DefaultClip 	= 3;
SWEP.Primary.Recoil 		= 0;
SWEP.Primary.Spread 		= 0.05;
SWEP.Primary.Delay 			= 2;
SWEP.Primary.TakeAmmo 		= 1;
SWEP.Primary.Sound 			= "WeaponFrag.Throw";

SWEP.Secondary.Ammo		    = "none"
SWEP.Secondary.Recoil 		= 0;
SWEP.Secondary.Automatic 	= false;
SWEP.Secondary.Spread 		= 0;
SWEP.Secondary.ClipSize 	= 0;
SWEP.Secondary.DefaultClip 	= 0;
SWEP.Secondary.Delay 		= 0;
SWEP.Secondary.TakeAmmo 	= 0;
SWEP.Secondary.Sound 		= "weapons/crossbow/fire1.wav";

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	//self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	//Get an eye trace. This basically finds out where the shot hit
	//This SWEP makes very little use of the trace, except to calculate
	//the amount of force to apply to the object to throw it.
	local tr = self.Owner:GetEyeTraceNoCursor();
 
	//We now make some shooting noises and effects using the sound we
	//loaded up earlier
	self.Weapon:EmitSound (self.Primary.Sound);
	self.BaseClass.ShootEffects (self);
 
	//We now exit if this function is not running on the server
	if (!SERVER) then return end;
 
	//The next task is to create a physics entity based on the supplied model.
	local ent = ents.Create ("item_healthkit");
	 
	//Set the initial position of the object. This might need some fine tuning; but it
	//seems to work for the models I have tried
	if ( tr.Entity:IsPlayer() ) then 
		ent:SetPos ( tr.Entity:GetPos() + Vector(0, 0, 75) );
		//ent:SetAngles (self.Owner:EyeAngles());
		ent:Spawn();
		self:TakePrimaryAmmo(self.Primary.TakeAmmo)
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
	end
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
		//self:TakePrimaryAmmo(self.Primary.TakeAmmo)
		//self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay );
end

function SWEP:Think()
end

function SWEP:Reload()
   self.Weapon:DefaultReload(ACT_VM_RELOAD)
   return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
   return true
end

function SWEP:Holster()
	return true
end
