
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Notice( words, len, r, g, b )
	
	umsg.Start( "Notice", self )
	umsg.String( words )
	umsg.Short( len )
	umsg.Short( r )
	umsg.Short( g )
	umsg.Short( b )
	umsg.End() 
	
end  

function meta:Brains()
	return self:GetNWInt( "Brains", 0 )
end

function meta:AddBrains( num )
	self:SetBrains( self:Brains() + num )
end

function meta:SetBrains( num )
	self:SetNWInt( "Brains", num )
end

function meta:SetFirstZombie( b )
	if b then
		self:SetBrains( 0 )
	end
	self:SetNWBool( "FirstZombie", b )
end

function meta:IsFirstZombie()
	return self:GetNWBool( "FirstZombie", false )
end

function meta:PoisonCloud()

	local cloud = ents.Create( "sent_poisoncloud" )
	cloud:SetPos( self:GetPos() )
	cloud:SetOwner( self )
	cloud:Spawn()

end

function meta:DropGrenade()

	if self:Team() == TEAM_ALIVE then return end

	local gren = ents.Create( "npc_grenade_frag" )
	gren:SetPos( self:GetPos() + Vector(0,0,50) )
	gren:SetOwner( self )
	gren:SetAngles( VectorRand():Angle() )
	gren:Spawn()
	gren:Fire( "SetTimer", "3" )

end

function meta:Redeem()

	self:Kill()
	self:SetTeam( TEAM_ALIVE )
	self:SetRandomClass()
	
	self:SetFrags( 19 )
	
	self.m_bRedeemed = true

end

function meta:OnDeath()

	if self:Team() == TEAM_ALIVE then
	
		if team.NumPlayers( TEAM_DEAD ) < 1 then
			self:SetFirstZombie( true )
		end
	
		self:SetTeam( TEAM_DEAD )
		self:SetBrains( 0 )
		
		if self:IsFirstZombie() then
			self:SetPlayerClass( "Soldier" )
		else
			self:SetPlayerClass( "Ghoul" )
		end
	
	end

end

function meta:DmgTaken()
	return self:GetNWInt( "DamageTaken", 0 )
end

function meta:AddDmgTaken( amt )
	self:SetNWInt( "DamageTaken", self:DmgTaken() + amt )
end

function meta:Support()
	return self:GetNWInt( "Support", 0 )
end

function meta:AddSupport()
	self:SetNWInt( "Support", self:Support() + 1 )
end

function meta:Headshots()
	return self:GetNWInt( "Headshots", 0 )
end

function meta:AddHeadshot()
	self:SetNWInt( "Headshots", self:Headshots() + 1 )
end

function meta:GetCurrentAmmo()
	return self:GetNWString( "CurrentAmmo", "Pistol" )
end

function meta:SetCurrentAmmo( ammotype )
	self:SetNWString( "CurrentAmmo", ammotype )
end

function meta:SetCustomAmmo( ammotype, num )
	self:SetNWInt( ammotype, num )
end

function meta:GetCustomAmmo( ammotype )
	return self:GetNWInt( ammotype, 0 )
end

function meta:AddCustomAmmo( ammotype, num )
	self:SetCustomAmmo( ammotype, self:GetCustomAmmo( ammotype ) + num )
end

function meta:SetCustomAmmo( ammotype, num )
	self:SetNWInt( ammotype, num )
end

function meta:SupplyAmmo( scale )

	local ammotype = self:GetCurrentAmmo()
	local amt = GAMEMODE.AmmoAmounts[ ammotype ] * scale 

	self:AddCustomAmmo( ammotype, amt )
	self:Notice( "+"..amt.." "..ammotype.." rounds", 5, 255, 200, 100 )

end

function meta:AddBones( amt )

	if self:Team() == TEAM_DEAD then return end

	if amt == 1 then
		self:Notice( "+1 Bone", 3, 255, 200, 100 )
	else
		self:Notice( "+"..amt.." Bones", 3, 255, 200, 100 )
	end
	
	self:AddFrags( amt )
	self:UpgradeCheck()

end

function meta:UpgradeCheck()

	for k,v in pairs( GAMEMODE.BonusLevels ) do
	
		if k <= self:Frags() and k > ( self.LastUpgrade or 0 ) then
		
			self.LastUpgrade = k
		
			for c,d in pairs( self:GetWeapons() ) do
				if not table.HasValue( GAMEMODE.WeaponWhitelist, d:GetClass() ) then
					self:StripWeapon( d:GetClass() )
				end
			end
			
			local gun = table.Random( v )
			
			self:Give( gun )
			self:SelectWeapon( gun )
			self:EmitSound( GAMEMODE.BonusSound )
			
			self:Notice( table.Random( GAMEMODE.BonusText ), 5, 0, 100, 255 )
			
			self:AddCustomAmmo( "Pistol", 50 )
			self:AddCustomAmmo( "Buckshot", 20 )
			self:AddCustomAmmo( "SMG", 100 )
			self:AddCustomAmmo( "Rifle", 100 )
		
		end
	
	end

	//if not table.HasValue( GAMEMODE.BonusLevels, self:Frags() ) then return end
	
end

function meta:DropItem()

	local item = ents.Create( "sent_pickup" )
	item:SetPos( self:GetPos() + Vector(0,0,30) )

	local class = self:GetPlayerClassName()
	if class == "Medic" then
		item:SetType( 3 )
	elseif class == "Engineer" then
		item:SetType( 2 )
	elseif class == "Support" then
		item:SetType( 4 )
	else
		item:SetType( 1 )
	end

	item:Spawn()
	
end

function meta:Heal( num )

	self:SetHealth( math.Clamp( self:Health() + num, 1, self:GetMaxHealth() ) ) 
	self:EmitSound( GAMEMODE.HealSound )
	self:Notice( "Gained "..num.." health", 5, 50, 255, 50 )

end

function meta:NeutralizePoison()

	self:EmitSound( GAMEMODE.CureSound, 100, 120 )
	self:Notice( "Poison neutralized", 5, 50, 255, 50 )
	self:Notice( "Radiation neutralized", 5, 50, 255, 50 )
	
	self.PoisonTime = 0
	self:SetNWInt( "RadTime", 0 )
	
end

function meta:DoPoison( attacker )

	if not self.m_bPoison then
		self:Notice( "You have been poisoned", 5, 255, 50, 0 )
		self:Notice( "A medic can neutralize toxins", 8, 0, 100, 255 )
		self.m_bPoison = true
	end

	self.PoisonPain = CurTime() + 3
	self.PoisonTime = CurTime() + 40
	self.PoisonAttacker = attacker
	
	umsg.Start( "Poison", self )
	umsg.End()

end

function meta:IsPoisoned()

	return ( self.PoisonTime and self.PoisonTime > CurTime() ) or ( self:GetNWInt( "RadTime", 0 ) > 0 )
	
end

function meta:AddRadiation( amt, delay )

	if not self.m_bRad then
		self:Notice( "You are entering an irradiated zone", 5, 255, 50, 0 )
		self:Notice( "A medic can cure radiation sickness", 8, 0, 100, 255 )
		self.m_bRad = true
	end

	if ( self.RadDelay or 0 ) > CurTime() then return end

	self.RadDelay = CurTime() + delay
	
	self:SetNWInt( "RadTime", self:GetNWInt( "RadTime", 0 ) + amt )
	self.RadPain = CurTime() + math.Rand( 0, 1 )
	
	self:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random(90,110) )

end

function meta:Think()

	if self.PoisonTime and self.PoisonTime > CurTime() then
		if self.PoisonPain < CurTime() then
			self.PoisonPain = CurTime() + 2
			self:EmitSound( table.Random( GAMEMODE.Cough ) )
			if self.PoisonAttacker and self.PoisonAttacker:IsValid() then
				self:TakeDamage( 3, self.PoisonAttacker )
			else
				self:TakeDamage( 3 )
			end
		end
	end
	
	if self:GetNWInt( "RadTime", 0 ) > 0 then
		if self.RadPain < CurTime() then
			self.RadPain = CurTime() + math.Rand( 0.5, 1.0 )
			self:SetNWInt( "RadTime", self:GetNWInt( "RadTime", 0 ) - 0.5 )
			self:TakeDamage( 1 )
			self:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random(90,110) )
		end
	end
	
end