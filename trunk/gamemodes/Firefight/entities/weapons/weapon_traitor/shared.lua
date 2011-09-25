if (SERVER) then 
 
   AddCSLuaFile ("shared.lua");
 
   SWEP.Weight = 5;
   SWEP.AutoSwitchTo = false;
   SWEP.AutoSwitchFrom = false;
 
end
 
if (CLIENT) then 
 
   SWEP.PrintName = "Traitor Gun";
   SWEP.Slot = 1;
   SWEP.SlotPos = 1;
   SWEP.DrawAmmo = false;
   SWEP.DrawCrosshair = true;
end
 
 
SWEP.Author = "Carnag3";
SWEP.Contact = "mousey76397@gmail.com";
SWEP.Purpose = "Make NPC's Kill for you!";
SWEP.Instructions = "SHOOT AT NPC!!!";
 
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
 
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl";
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl";
 
SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "Gravity";-- i wanted something nothing else would be using
 
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";
 
 
function SWEP:Reload()
end
 
function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if self.Weapon:Clip1() < 1 then return false end
	self.BaseClass.ShootEffects(self);	
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 10 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 10 )
	
	self.Weapon:EmitSound("/weapons/gauss/fire1.wav")

	self:TakePrimaryAmmo(1)
	
	if (!SERVER) then return end;
	
	local vPoint = self.Weapon:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint ) 
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "AR2Tracer", effectdata )	
	local ent = self.Owner:GetEyeTrace().Entity
	if ent:IsNPC() && ent.IsTraitor != true then -- has to be npc and can't already be a traitor
		ent.IsTraitor = true
		ent:SetOwner(self.Owner)
		ent:SetKeyValue("squadname", "rogue")
		ent:AddRelationship("player D_LI 99")
		ent:AddRelationship("npc_combine_s D_HT 99")
		ent:AddRelationship("npc_antlion D_HT 99")
		ent:AddRelationship("npc_antlionguard D_HT 99")
		ent:AddRelationship("npc_zombie D_HT 99")
		ent:AddRelationship("npc_fastzombie D_HT 99")
		ent:AddRelationship("npc_poisonzombie D_HT 99")
		ent:AddRelationship("npc_manhack D_HT 99")
		ent:AddRelationship("npc_headcrab D_HT 99")
		ent:AddRelationship("npc_headcrab_black D_HT 99")
		ent:AddRelationship("npc_headcrab_fast D_HT 99")
		ent:AddRelationship("npc_strider D_HT 99")
		ent:AddRelationship("npc_turret_floor D_HT 99")
		ent:AddRelationship("npc_hunter D_HT 99")
		timer.Simple(1,function() ent:EmitSound("/npc/ministrider/hunter_die2.wav") end )
	
	local entindex = ent:EntIndex()
		timer.Simple(30, function() 
							if Entity(entindex):IsValid() then
								Entity(entindex).IsTraitor = false
								ent:SetKeyValue("squadname", "npc's")
								Entity(entindex):AddRelationship("player D_HT 99")
								Entity(entindex):AddRelationship("npc_combine_s D_LI 99")
								Entity(entindex):AddRelationship("npc_antlion D_LI 99")
								Entity(entindex):AddRelationship("npc_antlionguard D_LI 99")
								Entity(entindex):AddRelationship("npc_zombie D_LI 99")
								Entity(entindex):AddRelationship("npc_fastzombie D_LI 99")
								Entity(entindex):AddRelationship("npc_poisonzombie D_LI 99")
								Entity(entindex):AddRelationship("npc_manhack D_LI 99")
								Entity(entindex):AddRelationship("npc_headcrab D_LI 99")
								Entity(entindex):AddRelationship("npc_headcrab_black D_LI 99")
								Entity(entindex):AddRelationship("npc_headcrab_fast D_LI 99")
								Entity(entindex):AddRelationship("npc_strider D_LI 99")
								Entity(entindex):AddRelationship("npc_turret_floor D_LI 99")
								Entity(entindex):AddRelationship("npc_hunter D_LI 99")
							end
						end)
	end
end
 

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end
 