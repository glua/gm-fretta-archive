
SWEP.Base = "cb_weapon_base"

SWEP.ViewModel	= "models/weapons/v_crossbow.mdl"
SWEP.WorldModel	= "models/weapons/w_crossbow.mdl"

SWEP.mine		= {}
SWEP.MaxEnergy	= 60
SWEP.MaxMines	= 6
SWEP.HoldType	= "crossbow"

SWEP.ShootSound = Sound("weapons/crossbow/fire1.wav")

/*-------------------------------------
	SWEP:MakeMine()
-------------------------------------*/
function SWEP:MakeMine(secondary, int, position)
	
	int = int-1
	
	local ent = ents.Create("cb_stickymine")
	ent:SetTeam(self.Owner:Team())
	ent:SetOwner(self.Owner)
	
	local aim = self.Owner:GetAimVector() --aim at 15 degrees
	aim = aim:Angle()
	if secondary then
		aim:RotateAroundAxis(aim:Right(), -7.5+(15*int))
	else
		aim:RotateAroundAxis(aim:Up(), -7.5+(15*int))
	end
	aim = aim:Forward()
	
	ent:SetPos(self.Owner:GetShootPos() + aim*16)
	ent:Spawn()
	
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetVelocity(aim*1000)
	end
	
	self.mine[position] = ent
	
end

/*-------------------------------------
	SWEP:DoShoot()
-------------------------------------*/
function SWEP:DoShoot(secondary)
	
	if SERVER then self.Owner:LagCompensation( true ) end

	for k,v in pairs(self.mine) do
		if not v:IsValid() then
			table.remove(self.mine,k)
		end
	end
	
	for i=1,2 do
		local num = #self.mine
		if num+1 > self.MaxMines then
			self.mine[1]:DoExplode()
			table.remove(self.mine,1)
			self:MakeMine(secondary, i, self.MaxMines)
		else
			self:MakeMine(secondary, i, num+1)
		end
	end
	
	self:SetNextPrimaryFire(CurTime()+0.8)
	self:SetNextSecondaryFire(CurTime()+0.8)
	
	if SERVER then self.Owner:LagCompensation( false ) end

end

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack() ) then return end

	if( SERVER ) then
		
		self:DoShoot()
		self:TakeAmmo( 10 )
		
		// delay ammo regeneration so we don't have
		// infinite ammo while shooting
		self.NextAmmoRegeneration = CurTime() + 0.85

	end
	
	// shoot effects
	self:ShootEffects()
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	// bail if we can't fire
	if( !self:CanAttack() ) then return end
		
	self:DoShoot(true)
	self:TakeAmmo( 10 )
	
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85
	
	// shoot effects
	self:ShootEffects()
	
end

if CLIENT then

	
	
end