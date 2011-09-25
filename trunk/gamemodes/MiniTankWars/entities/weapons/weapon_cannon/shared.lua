SWEP.Author = "BMCha"
SWEP.Contact = "PM on FP"
SWEP.Purpose = "KABLOOIE"
SWEP.Instructions = "Click to fire"
SWEP.Category = "Tank Armament"
 
//Not sold separately
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;

SWEP.Primary.ClipSize = 1337;
SWEP.Primary.DefaultClip = 35;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "RPG_Round";
 
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";
 
util.PrecacheSound("MiniTankWars/reload.wav")
 
SWEP.Sound = Sound ("MiniTankWars/cannon1.wav")
 
function SWEP:Deploy()
	if (SERVER) then self.Owner:DrawWorldModel(false) end
	self.Owner:SetNWFloat("Delay", 2)
	self.Owner:SetNWBool("AP", false)
	return true
end 
 
function SWEP:Holster()
return true
end
 
function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:EmitSound ( self.Sound )
	if(SERVER) then
		local TurretEnt = self.Owner.TankEnt.TurretEnt
		
		local BarPos = TurretEnt:GetBonePosition(TurretEnt:LookupBone("Barrel"))
		local BarrelAng = TurretEnt:GetAngles()
		BarrelAng:RotateAroundAxis(TurretEnt:GetRight(), TurretEnt:GetNWFloat("Turret_Elevate", 0) )
		BarrelPos = BarPos+BarrelAng:Forward()*(TurretEnt.BarrelLength+5)
		
		local shell
		if (self.Owner:GetNWBool("AP", false)==true) then
			shell = ents.Create( "AP_Shell" )
		else
			shell = ents.Create( "Cannon_Shell" )
		end
		shell:SetPos( BarrelPos )
		shell:SetAngles(BarrelAng)
		shell:SetOwner( self.Owner )
		shell:Spawn()
		shell:Move()
		
		local ed = EffectData()
		ed:SetEntity(self.Owner.TankEnt)
		ed:SetOrigin(self.Owner.TankEnt:GetPos())
		util.Effect("TankFireRing", ed, true, true)
		ed:SetAngle(BarrelAng)
		ed:SetOrigin(BarrelPos)
		util.Effect("TankFire", ed, true, true)
		
		self.Owner.TankEnt:Recoil(100, BarrelAng:Forward())
	end
	
	self.Owner:SetNWBool("Reloading", true)
	timer.Simple(self.Owner:GetNWFloat("Delay", 2), (function() if self.Owner then if self.Owner:IsValid() then self.Owner:SetNWBool("Reloading", false) end end end))
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Owner:GetNWFloat("Delay", 2) )
	if (SERVER) then
	timer.Simple((self.Owner:GetNWFloat("Delay", 2)/2), (function() if self.Owner.TankEnt then if self.Owner.TankEnt:IsValid() then self.Owner.TankEnt:EmitSound("MiniTankWars/reload.wav", 100, 90/(self.Owner:GetNWFloat("Delay", 2)/2)) end end end))
	end
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD ) //animation for reloading
end
 