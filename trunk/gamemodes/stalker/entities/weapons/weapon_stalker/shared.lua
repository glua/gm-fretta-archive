if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "slam"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel  = "models/Zed/weapons/v_banshee.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Sound			= Sound( "npc/zombie/claw_miss1.wav" )
SWEP.Primary.Hit            = Sound( "npc/zombie/claw_strike1.wav" )
SWEP.Primary.Damage			= 80
SWEP.Primary.HitForce       = 700
SWEP.Primary.Delay			= 1.000
SWEP.Primary.Automatic		= true

SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Secondary.Select       = Sound( "UI/buttonrollover.wav" )
SWEP.Secondary.Miss         = Sound( "ambient/atmosphere/cave_hit2.wav" )
SWEP.Secondary.Flay         = Sound( "ambient/levels/citadel/portal_beam_shoot6.wav" )
SWEP.Secondary.Scream       = Sound( "npc/stalker/go_alert2a.wav" )
SWEP.Secondary.Heal         = Sound( "ambient/levels/labs/teleport_mechanism_windup4.wav" )
SWEP.Secondary.Psycho       = Sound( "npc/turret_floor/active.wav" )

SWEP.Mana = {}
SWEP.Mana.Flay = 75
SWEP.Mana.Scream = 25
SWEP.Mana.Psycho = 50
SWEP.Mana.Heal = 100

function SWEP:Initialize()

	if SERVER then
	
		self.Weapon:SetWeaponHoldType( self.HoldType )
		
	end
	
end

function SWEP:Deploy()

	if SERVER then
	
		self.Owner:DrawWorldModel( false )
		
	end

	return true
	
end  

function SWEP:Think()	

	if not self.FirstNotice then
	
		if self.Owner:KeyDown( IN_USE ) then
		
			self.FirstNotice = true
		
		end
	
	end

end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()

	return true
	
end

function SWEP:PrimaryAttack()

	if self.Owner:GetNWBool( "Menu", false ) then
	
		if SERVER then
		
			self.Owner:SetNWInt( "MenuChoice", self.Owner:GetNWInt( "MenuChoice", 1 ) + 1 )
			
			if self.Owner:GetNWInt( "MenuChoice", 1 ) > 4 then
			
				self.Owner:SetNWInt( "MenuChoice", 1 )
				
			end
			
		else
		
			self.Owner:EmitSound( self.Secondary.Select )
			
		end
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
		return
	
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
end

function SWEP:MeleeTrace( dmg )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 60
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mask = MASK_SHOT_HULL
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
		
	end

end

function SWEP:SecondaryAttack()

	if self.Owner:GetNWBool( "Menu", false ) then
	
		if SERVER then
		
			self.Owner:SetNWInt( "MenuChoice", self.Owner:GetNWInt( "MenuChoice", 1 ) - 1 )
		
			if self.Owner:GetNWInt( "MenuChoice", 1 ) < 1 then
			
				self.Owner:SetNWInt( "MenuChoice", 4 )
				
			end
			
		else
		
			self.Owner:EmitSound( self.Secondary.Select )
			
		end
		
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
		return
	
	end

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
	
		self.Weapon:DoSpecial( self.Owner:GetNWInt( "MenuChoice", 1 ) )
	
	end

end

function SWEP:DoSpecial( num )

	if num == 1 then
		self.Weapon:Scream()
	elseif num == 2 then
		self.Weapon:Psycho()
	elseif num == 3 then
		self.Weapon:Flay()
	else
		self.Weapon:Heal()
	end

end

function SWEP:Psycho()

	if self.Owner:GetMana() < self.Mana.Psycho then
	
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
		return
	
	end

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )

	if ValidEntity( tr.Entity ) and string.find( tr.Entity:GetClass(), "prop_phys" ) and ( ( tr.Entity.Psycho or 0 ) < CurTime() ) then
	
		local psy = ents.Create( "sent_psycho" )
		psy:SetOwner( self.Owner )
		psy:SetModel( tr.Entity:GetModel() )
		psy:SetPos( tr.Entity:GetPos() )
		psy:SetAngles( tr.Entity:GetAngles() )
		psy:SetParent( tr.Entity )
		psy:Spawn()
	
		tr.Entity.Psycho = CurTime() + 30
		
		self.Owner:AddMana( -self.Mana.Psycho )
		self.Owner:EmitSound( self.Secondary.Psycho )
		
	else
	
		local dist = 250
		local ent
	
		for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
			
			if v:GetPos():Distance( tr.HitPos ) < dist and ( ( v.Psycho or 0 ) < CurTime() ) then
			
				ent = v
				dist = v:GetPos():Distance( tr.HitPos )
				
			end
			
		end
		
		if ValidEntity( ent ) then
			
			local psy = ents.Create( "sent_psycho" )
			psy:SetOwner( self.Owner )
			psy:SetModel( ent:GetModel() )
			psy:SetPos( ent:GetPos() )
			psy:SetAngles( ent:GetAngles() )
			psy:SetParent( ent )
			psy:Spawn()
				
			ent.Psycho = CurTime() + 30
				
			self.Owner:AddMana( -self.Mana.Psycho )
			self.Owner:EmitSound( self.Secondary.Psycho )
			
			return
		
		end
		
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
	
	end

end

function SWEP:Heal()

	if self.Owner:GetMana() < self.Mana.Heal then
	
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
		return
	
	end
	
	local hp = ( self.Owner:GetMaxHealth() - self.Owner:Health() ) / 2.5
	
	self.Owner:GainHealth( hp )
	self.Owner:AddMana( -self.Mana.Heal )
	self.Owner:EmitSound( self.Secondary.Heal, 100, 200 )
	self.Owner:SetNWInt( "Poison", 0 )
	
	local heal = ents.Create( "sent_healing" )
	heal:SetOwner( self.Owner )
	heal:SetPos( self.Owner:GetPos() )
	heal:SetParent( self.Owner )
	heal:Spawn()

end

function SWEP:Scream()

	if self.Owner:GetMana() < self.Mana.Scream then
	
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
		return
	
	end
	
	self.Owner:EmitSound( self.Secondary.Scream, 100, math.random(100,110) )
	self.Owner:AddMana( -self.Mana.Scream )

	for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
	
		if v:GetPos():Distance( self.Owner:GetPos() ) < 500 then
		
			util.BlastDamage( self.Owner, self.Owner, v:GetPos(), 5, 5 )
			
			local ed = EffectData()
			ed:SetOrigin( v:GetPos() )
			util.Effect( "scream_hit", ed, true, true )
			
		end
		
	end

end

function SWEP:Flay()

	if self.Owner:GetMana() < self.Mana.Flay then
	
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
		return
	
	end

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )

	if ValidEntity( tr.Entity ) and tr.Entity:IsPlayer() then
	
		tr.Entity:Flay( self.Owner )
		self.Owner:AddMana( -self.Mana.Flay )
		self.Owner:EmitSound( self.Secondary.Flay, 100, 150 )
		
	else
	
		local dist = 250
		local ply
	
		for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
		
			if v:GetPos():Distance( tr.HitPos ) < dist and v:Alive() then
			
				ply = v
				dist = v:GetPos():Distance( tr.HitPos )
				
			end
			
		end
		
		if ValidEntity( ply ) then
		
			ply:Flay( self.Owner )
			self.Owner:AddMana( -self.Mana.Flay )
			self.Owner:EmitSound( self.Secondary.Flay, 100, 150 )
			
			return 
		
		end
		
		self.Owner:EmitSound( self.Secondary.Miss, 50, 250 )
	
	end

end

if CLIENT then

	surface.CreateFont( "Typenoksidi", 20, 450, true, false, "InfoText" )
	surface.CreateFont( "Typenoksidi", 40, 600, true, false, "StalkerText" )

	SWEP.DrawTable = {}
	SWEP.DrawTable[1] = {}
	SWEP.DrawTable[2] = {}
	SWEP.DrawTable[3] = {}
	SWEP.DrawTable[4] = {}
	SWEP.DrawTable[1].Selected = {ScrW() / 2 - 200, ScrH() / 2 - 200, 200, 200}
	SWEP.DrawTable[1].DeSelected = {ScrW() / 2 - 100, ScrH() / 2 - 100, 100, 100}
	SWEP.DrawTable[1].Mat = surface.GetTextureID( "stalker/scream" )
	SWEP.DrawTable[1].Desc = {"SCREAM", "Deafen nearby enemies and disrupt their vision.", "Requires 25% of your energy."}
	SWEP.DrawTable[1].Mana = 25
	SWEP.DrawTable[2].Selected = {ScrW() / 2 - 200, ScrH() / 2, 200, 200}
	SWEP.DrawTable[2].DeSelected = {ScrW() / 2 - 100, ScrH() / 2, 100, 100}
	SWEP.DrawTable[2].Mat = surface.GetTextureID( "stalker/psycho" )
	SWEP.DrawTable[2].Desc = {"PSYCHOKINESIS", "Turn an inanimate object into a violent weapon.", "Requires 50% of your energy."}
	SWEP.DrawTable[2].Mana = 50
	SWEP.DrawTable[3].Selected = {ScrW() / 2, ScrH() / 2, 200, 200}
	SWEP.DrawTable[3].DeSelected = {ScrW() / 2, ScrH() / 2, 100, 100}
	SWEP.DrawTable[3].Mat = surface.GetTextureID( "stalker/flay" )
	SWEP.DrawTable[3].Desc = {"MIND FLAY", "Invade an enemy's mind with psionic waves.", "Requires 75% of your energy."}
	SWEP.DrawTable[3].Mana = 75
	SWEP.DrawTable[4].Selected = {ScrW() / 2, ScrH() / 2 - 200, 200, 200}
	SWEP.DrawTable[4].DeSelected = {ScrW() / 2, ScrH() / 2 - 100, 100, 100}
	SWEP.DrawTable[4].Mat = surface.GetTextureID( "stalker/regen" )
	SWEP.DrawTable[4].Desc = {"HEALING", "Regenerate a portion of your health.", "Requires 100% of your energy."}
	SWEP.DrawTable[4].Mana = 100
	
end

function SWEP:DrawHUD()

	if self.Owner:GetNWBool( "Menu", false ) then
		
		for i=1,4 do
		
			surface.SetTexture( self.DrawTable[i].Mat )
			
			if self.Owner:GetNWInt( "Mana", 0 ) >= self.DrawTable[i].Mana then
				surface.SetDrawColor( 50, 255, 50, 150 )
			else
				surface.SetDrawColor( 255, 50, 50, 150 )
			end
			
			if self.Owner:GetNWInt( "MenuChoice", 1 ) == i then
				surface.DrawTexturedRect( unpack( self.DrawTable[i].Selected ) )
			else
				surface.DrawTexturedRect( unpack( self.DrawTable[i].DeSelected ) )
			end
			
		end
		
		for k,v in pairs( self.DrawTable[ self.Owner:GetNWInt( "MenuChoice", 1 ) ].Desc ) do 
			draw.SimpleTextOutlined( v, "InfoText", ScrW() / 2, ScrH() / 8 + k * 25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,255) )
		end
		
		if not self.FirstNotice then
		
			draw.SimpleTextOutlined( "Left click or right click to select an ability.", "InfoText", ScrW() / 2, ScrH() - 100, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,255) )
			draw.SimpleTextOutlined( "Press your USE key to toggle this menu.", "InfoText", ScrW() / 2, ScrH() - 75, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(10,10,10,255) )
			
		end
		
	else
	
		if self.Owner:GetNWInt( "Mana", 0 ) >= self.DrawTable[ self.Owner:GetNWInt( "MenuChoice", 1 ) ].Mana then
			surface.SetDrawColor( 50, 255, 50, 100 )
		else
			surface.SetDrawColor( 255, 50, 50, 100 )
		end
	
		surface.SetTexture( self.DrawTable[ self.Owner:GetNWInt( "MenuChoice", 1 ) ].Mat )
		surface.DrawTexturedRect( ScrW() / 2 - 25, ScrH() - 75, 50, 50 )
	
	end
	
end
