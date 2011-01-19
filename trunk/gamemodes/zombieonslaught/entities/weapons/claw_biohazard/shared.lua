
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel = "models/Zed/weapons/v_banshee.mdl"

SWEP.Primary.Voice          = Sound("npc/antlion/idle1.wav")
SWEP.Primary.Sound			= Sound("npc/fast_zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/antlion/foot4.wav")
SWEP.Primary.Damage			= 15
SWEP.Primary.HitForce       = 600
SWEP.Primary.Delay			= 1.20
SWEP.Primary.FreezeTime     = 0
SWEP.Primary.Automatic		= true

function SWEP:MeleeTrace( dmg )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 50
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity

	if not ValidEntity( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		return 
		
	else
		
		ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
		ent:TakeDamage( dmg, self.Owner, self.Weapon )
		
		if !ent:IsPlayer() then 
			
			local phys = ent:GetPhysicsObject()
			
			if ValidEntity( phys ) then
			
				ent:SetPhysicsAttacker( self.Owner )
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * self.Primary.HitForce )
				
			end
			
			return 
			
		end
		
		ent:AddRadiation( 5, 0.5 )
		
	end
	
	if ent:Team() == TEAM_DEAD then return end
	
	local ed = EffectData()
	ed:SetEntity( ent )
	ed:SetOrigin( ent:GetPos() + Vector(0,0,40) )
	util.Effect( "playerhit", ed, true, true )

end

function SWEP:Think()	

	if SERVER then
	
		local pos = self.Owner:GetPos()
		pos.x = 0
		pos.y = 0
	
		for k,v in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
			
			local enemypos = v:GetPos()
			enemypos.x = 0
			enemypos.y = 0
		
			local dist = self.Owner:GetPos():Distance( v:GetPos() )
			local dist2 = pos:Distance( enemypos )
			
			if dist < 250 and dist2 < 80 and v:Alive() then
			
				local scale = math.Clamp( dist / 250, 0.2, 0.8 )
				
				v:AddRadiation( 3, scale )
				
				if not v.m_Bio then
				
					v.m_Bio = true
					v:Notice( "A biohazard zombie is nearby", 5, 255, 50, 0 )
					
				end
				
			end
			
		end
		
	end

end