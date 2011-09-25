AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_gtv_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Automatic = true
SWEP.Cooldown = 2
SWEP.AmmoCost = 100
SWEP.HoldType = "rpg"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.Slot = SLOT_EXTRA
SWEP.Weight = 3
SWEP.ItemType = GTVITEM_BEEGUN
SWEP.PrintName = "Bee Gun"
--"sound/ambient/creatures/flies5.wav"

function SWEP:Shoot()
	
	local target = NULL
	local closest = 600
	for k,v in ipairs(player.GetAll()) do
		if (v != self.Owner) && (v:GetPos():Distance(self.Owner:GetPos()) < closest) && v:Alive() then
			closest = v:GetPos():Distance(self.Owner:GetPos())
			target = v
		end
	end
	local right = self.Owner:GetAimVector():Angle():Right()
	for i=1,8 do
		local proj = ents.Create("gtv_projectile_bees")
		proj.target = target
		proj.MaxSpeed = math.random(450,600)
		proj.MaxTurnSpeed = math.random(400,500)
		proj:SetPos(self.Owner:GetShootPos())
		proj:SetAngles((self.Owner:GetAimVector()+right*(i-4)*0.07):Angle())
		proj.LifeTime = 10
		//proj:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		proj:SetOwner(self.Owner)
		proj.Owner = self.Owner
		proj:Spawn()
		proj:GetPhysicsObject():SetVelocity((self.Owner:GetAimVector()+right*(i-4)*0.07)*100)
		//self.Owner:EmitSound("weapons/ar2/ar2_altfire.wav")
		self.Owner:EmitSound("ambient/creatures/flies"..math.random(1,5)..".wav",100,100)
		local trail = util.SpriteTrail(proj,0,Color(255,255,0),false,15,1,0.5,1/(15+1)*0.5,"trails/laser.vmt")
	end
		
end

function SWEP:Equip(pl)
	pl:EmitSound("weapons/shotgun/shotgun_cock.wav")
	if pl.PossessMulti then
		return
	end
	if pl:GetActiveWeapon().Slot == self.Slot then
		pl:SelectWeapon(self:GetClass())
	end
	local hadwep = false
	for k,v in ipairs(pl:GetWeapons()) do
		if (v != self) && (v.Slot == self.Slot) then
			hadwep = v:GetClass()
			v:Remove()
		end
	end
	if hadwep then
		pl:SendNotification("\"Why was I carrying that old thing around?\"")
	else
		pl:SendNotification("OH MY GOD")
	end
	if (self.AmmoCost > 0) && pl:GetAmmoCount("pistol") < 200 then
		pl:GiveAmmo(math.min(50,200-pl:GetAmmoCount("pistol")),"pistol")
	end
end