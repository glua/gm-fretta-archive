

// Variables that are used on both client and server

SWEP.Author         = "Dave"
SWEP.Contact        = "dave@sp4m.net"
SWEP.Purpose        = "Stabbing people"
SWEP.Instructions   = "Insert and remove from flesh. Repeat until dead"

SWEP.ViewModelFOV   = 62
SWEP.ViewModelFlip  = false
SWEP.ViewModel      = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel     = "models/weapons/w_knife_t.mdl"
SWEP.AnimPrefix     = "python"

SWEP.Spawnable          = false
SWEP.AdminSpawnable     = true

SWEP.Primary.ClipSize       = -1                 // Size of a clip
SWEP.Primary.DefaultClip    = -1                // Default number of bullets in a clip
SWEP.Primary.Automatic      = false             // Automatic/Semi Auto
SWEP.Primary.Ammo           = "None"

SWEP.Secondary.ClipSize     = -1                 // Size of a clip
SWEP.Secondary.DefaultClip  = -1                // Default number of bullets in a clip
SWEP.Secondary.Automatic    = false             // Automatic/Semi Auto
SWEP.Secondary.Ammo         = "None"



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/

// todo: null entity errors?
// todo: callback thing doesn't seem to be working -- do i care? just remove it?
// todo: shoot bullets lag stuff?
// todo: there must be a better way of damaging stuff, playing hit sounds,
// creating decals etc than calling FireBullets -- this way of doing a knife is
// one of the hackiest things i've ever done

function SWEP:PrimaryAttack()
    local owner = self.Owner
    local weapon = self.Weapon
    local sphere_r = 30

    owner:LagCompensation(true)

    // find all the entities in a sphere just in front of the owner
    local ents = ents.FindInSphere(owner:GetShootPos() + (sphere_r * owner:GetAimVector()), sphere_r)

    // but don't include the owner or any weapons (or it will pick up the
    // owner's weapons)
    // todo: this seems messy... there must be a better way
    local filtered_ents = {}
    for i, ent in ipairs(ents) do
        if (ent ~= owner) and (not ent:IsWeapon()) then
            table.insert(filtered_ents, ent)
        end
    end
    ents = filtered_ents

    if #ents ~= 0 then
        // we found some entities
        // which means we hit something (duh)

        // play a hit sound (the sound we play depends on what we've hit)
        local sound = "Weapon_Knife.HitWall"
        for i, ent in ipairs(ents) do
            // todo: i don't know of another way to get the material type
            // (calling GetMaterialType on the entity doesn't appear to work),
            // this is rather stupid and unreliable...
            local mat_type = util.QuickTrace(ent:GetPos(), ent:LocalToWorld(ent:OBBCenter()) - ent:GetPos(), {}).MatType
            if (mat_type == MAT_FLESH) or (mat_type == MAT_BLOODYFLESH) or
                (mat_type == MAT_ALIENFLESH) then
                sound = "Weapon_Knife.Stab"
                break
            end
        end
        weapon:EmitSound(sound)

        // do the hit animation
        // note that this is the first-person view anim, not the world anim
        weapon:SendWeaponAnim(ACT_VM_HITCENTER)

        // now the annoying bit. we want to do damage to everything in the
        // sphere, so we fire a bullet directly from the owner to each entity
        for i, ent in ipairs(ents) do
            // if it looks like we'll hit the entity firing at the bbox center,
            // then do that. otherwise, shoot at the entity's pos (todo: we
            // really want to shoot in the closest direction to our aim vector
            // that will actually hit ent...)
            local dir = ent:LocalToWorld(ent:OBBCenter()) - owner:GetShootPos()
            if util.QuickTrace(owner:GetShootPos(), dir, {owner}).Entity ~= ent then
                dir = ent:GetPos() - owner:GetShootPos()
            end
            dir:Normalize()
            local bullet = {
                Num = 1,
                Src = owner:GetShootPos(),
                Dir = dir,
                Spread = Vector(0, 0, 0), // with 100% accuracy
                Tracer = 0,
                Force = 5,
                Damage = 1000, // it's a really sharp knife
                Attacker = owner,
                Callback = function (attacker, trace, di)
                    // stop the bullet hitting anything except ent
                    if trace.Entity ~= ent then
                        return {damage = false, effects = false} // todo: is this right? the documentation isn't very clear...
                    end
                end}
            owner:FireBullets(bullet)
            owner:LagCompensation(true) // todo: is this necessary?
        end
    else
        // didn't find any entities
        // but we might have hit the world...

        // trace a line in front of us to find out...
        // then play appropriate sound and first-person view anim
        if util.QuickTrace(owner:GetShootPos(), 2 * sphere_r * owner:GetAimVector(), {owner}).Hit then
            weapon:EmitSound("Weapon_Knife.HitWall")
            weapon:SendWeaponAnim(ACT_VM_HITCENTER)

            // also fire a bullet to put a decal on the world (presumably
            // there's a better way of doing this)
            local bullet = {
                Num = 1,
                Src = owner:GetShootPos(),
                Dir = owner:GetAimVector(),
                Spread = Vector(0, 0, 0),
                Tracer = 0,
                // just doing for a decal, so no need for force or damage
                Force = 0,
                Damage = 0,
                Attacker = owner} // probably don't need to set attacker either...
            owner:FireBullets(bullet)
        else
            weapon:EmitSound("Weapon_Knife.Slash")
            weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
        end
    end

    // do the third-person world anim
    owner:SetAnimation(MELEE_ATTACK2) // todo: is this right?

    // delay between swipes
    weapon:SetNextPrimaryFire(CurTime() + 1.0)

    owner:LagCompensation(false)

    //local trace = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:GetAimVector() * 84, {self.Owner})
    //if trace.Hit and (not trace.HitSky) then
    //    if trace.HitNonWorld and ((trace.MatType == MAT_BLOODYFLESH) or
    //        (trace.MatType == MAT_FLESH) or (trace.MatType == MAT_ALIENFLESH)) then
    //        self.Weapon:EmitSound("Weapon_Knife.Stab")
    //    else
    //        self.Weapon:EmitSound("Weapon_Knife.HitWall")
    //    end
    //    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
    //
    //    // not totally sure what this does. it's copied from the crowbar swep...
    //    self.Owner:LagCompensation(true)
    //    if SERVER then
    //        self.Owner:TraceHullAttack(self.Owner:GetShootPos(), trace.HitPos, Vector(-16, -16, -16), Vector(36, 36, 36), 1000, DMG_SLASH, 0.75)
    //    end
    //else
    //    self.Weapon:EmitSound("Weapon_Knife.Slash")
    //    self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER);
    //end
    //self.Owner:SetAnimation(PLAYER_ATTACK1);
    //self.Weapon:SetNextPrimaryFire(CurTime() + 0.25)
end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

end

/*---------------------------------------------------------
   Name: SWEP:CheckReload( )
   Desc: CheckReload
---------------------------------------------------------*/
function SWEP:CheckReload()

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()
end


/*---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
---------------------------------------------------------*/
function SWEP:Holster( wep )
    return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()
    return true
end


/*---------------------------------------------------------
   Name: ContextScreenClick(  aimvec, mousecode, pressed, ply )
---------------------------------------------------------*/
function SWEP:ContextScreenClick( aimvec, mousecode, pressed, ply )
end


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end


/*---------------------------------------------------------
   Name: OwnerChanged
   Desc: When weapon is dropped or picked up by a new player
---------------------------------------------------------*/
function SWEP:OwnerChanged()
end


/*---------------------------------------------------------
   Name: Ammo1
   Desc: Returns how much of ammo1 the player has
---------------------------------------------------------*/
function SWEP:Ammo1()
    return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end


/*---------------------------------------------------------
   Name: Ammo2
   Desc: Returns how much of ammo2 the player has
---------------------------------------------------------*/
function SWEP:Ammo2()
    return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
         This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )
    self.m_WeaponDeploySpeed = tonumber( speed )
end
