//---------------------------------------------- 
//Author Info
//---------------------------------------------- 
SWEP.Author             = "Glovebox" 
SWEP.Contact            = "arkangel3421@googlemail.com" 
SWEP.Purpose            = "Spawn a large crate and Small crate" 
SWEP.Instructions       = "Primary Fire: Spawns a large crate  Secondary Fire: Spawns a Small Crate"
//---------------------------------------------
 
SWEP.Spawnable = true
SWEP.Adminspawnable = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.HoldType = "pistol"
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
 
SWEP.RechargeTime = 0.5
SWEP.MaxDist = 200
 
local ShootSound = Sound ("Weapon_Pistol.Single")
 
function SWEP:Initialize()
        self.Weapon:SetNetworkedBool( "NextShot", 0 )
end
 

function SWEP:Reload()
end
 

function SWEP:Think()
end 
 

function SWEP:PrimaryAttack()
        local tr = self.Owner:GetEyeTrace()
        if self.Weapon:GetNetworkedFloat("NextShot") > CurTime() then return end
        
        local hitPosition = tr.HitPos
        local myPosition = self.Owner:GetPos()
        local distance = hitPosition:Distance(myPosition)
        if distance > self.MaxDist then return end
        self.BaseClass.ShootEffects(self)
        self:TakePrimaryAmmo(1)
        self.Weapon:EmitSound(ShootSound)
        self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
        self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
        
        
        if !SERVER then return end
		self.Owner:SetNetworkedInt(self.Owner:GetNetworkedInt("Crates") + 1)
        self.Weapon:SetNetworkedBool( "NextShot", CurTime() + self.RechargeTime )
        
   
        local ent = ents.Create("prop_physics")
        if ( !ent:IsValid() ) then
                return
        end
		
        ent:SetVar("OwnerID", self.Owner:SteamID())
        ent:SetModel("models/props_junk/wood_crate002a.mdl")
        ent:SetPos(hitPosition + Vector(0,30,23))
        ent:SetMaxHealth(1000)
        ent:SetHealth(1000)

     local myTeam = self.Owner:Team()
        if myTeam == 1 then
        ent:SetColor(225,0,0,255)
        elseif myTeam == 2 then
        ent:SetColor(0, 0, 255, 255)
        
        end

        ent:Spawn()
        ent:Activate()
	    ent:GetPhysicsObject():EnableMotion( true )	
		local history = self.Owner:GetNWInt("Crates")
		self.Owner:SetNWInt("Crates", history + 1)
end
 

function SWEP:SecondaryAttack() 

        local tr = self.Owner:GetEyeTrace()
        if self.Weapon:GetNetworkedFloat("NextShot") > CurTime() then return end
        
        local hitPosition = tr.HitPos
        local myPosition = self.Owner:GetPos()
        local distance = hitPosition:Distance(myPosition)
        if distance > self.MaxDist then return end
        self.BaseClass.ShootEffects(self)
        self:TakePrimaryAmmo(1)
        self.Weapon:EmitSound(ShootSound)
        self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
        self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
        

        
        if !SERVER then return end
		self.Owner:SetNetworkedInt(self.Owner:GetNetworkedInt("Crates") + 1)
        self.Weapon:SetNetworkedBool( "NextShot", CurTime() + self.RechargeTime )
        
        
        local ent = ents.Create("prop_physics")
        if ( !ent:IsValid() ) then
                return
        end
		
        ent:SetVar("OwnerID", self.Owner:SteamID())
        ent:SetModel("models/props_junk/wood_crate001a.mdl")
        ent:SetPos(hitPosition + Vector(0,15,23))
        ent:SetMaxHealth(1000)
        ent:SetHealth(1000)

      local myTeam = self.Owner:Team()
        if myTeam == 1 then
        ent:SetColor(225,0,0,255)
        elseif myTeam == 2 then
        ent:SetColor(0, 0, 255, 255)

        end

        ent:Spawn()
        ent:Activate()
	    ent:GetPhysicsObject():EnableMotion( true )	
		local history = self.Owner:GetNWInt("Crates")
		self.Owner:SetNWInt("Crates", history + 1)
end