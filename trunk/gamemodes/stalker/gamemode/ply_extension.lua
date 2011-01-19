
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:GetLastClass()
	return self.LastClass or "M3"
end

function meta:SetLastClass()
	self.LastClass = self:GetPlayerClassName()
end

function meta:IsWinner()
	return self.Winner
end

function meta:SetWinner( b )
	self.Winner = b
end

function meta:SetCommander( b )
	self.Commander = b
end

function meta:IsCommander()
	return self.Commander
end

function meta:GetUtility()

	if not self.Utility then
	
		self.Utility = "Tracker"
	
	end
	
	return self.Utility
end

function meta:SetUtility( tool )
	self.Utility = tool
end

function meta:SetBattery( num )
	self:SetNWInt( "Battery", math.Clamp( num, 0, 100 ) )
end

function meta:GetBattery()
	return self:GetNWInt( "Battery", 0 )
end

function meta:AddBattery( num )
	self:SetBattery( self:GetBattery() + num )
end

function meta:GetMana()
	return self:GetNWInt( "Mana", 0 )
end

function meta:SetMana( num )
	self:SetNWInt( "Mana", math.Clamp( num, 0, 100 ) )
end

function meta:AddMana( num )
	self:SetMana( math.Clamp( self:GetMana() + num, 0, 100 ) )
end

function meta:GetCurrentAmmo()
	return self:GetNWString( "CurrentAmmo", "Pistol" )
end

function meta:SetCurrentAmmo( ammotype )
	self:SetNWString( "CurrentAmmo", ammotype )
end

function meta:SetCustomAmmo( ammotype, num )
	self:SetNWInt( ammotype, math.Clamp( num, 0, 1000 ) )
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

function meta:GetRadioInfo()
	return self.RadioTime, self.RadioMode
end

function meta:SetRadioInfo( time, mode )

	self.RadioTime = time
	self.RadioMode = mode

end

function meta:CanUseFlashlight()

	if self.m_bFlashlight == nil then
		return true // Default to true unless modified by the player class
	end
	
	if self:Team() == TEAM_HUMAN and self:GetBattery() < 2 and !self:FlashlightIsOn() then 
		return false
	end

	return self.m_bFlashlight

end

function meta:GainHealth( num )

	self:SetHealth( math.Clamp( self:Health() + ( num or 50 ), 1, self:GetMaxHealth() ) )
	self:AddMana( 10 )

end

function meta:Flay( attacker )

	local ed = EffectData()
	ed:SetOrigin( self:GetPos() )
	util.Effect( "mind_flay", ed, true, true )
	
	local ed = EffectData()
	ed:SetOrigin( attacker:GetPos() )
	util.Effect( "flay_attack", ed, true, true )
	
	self:TakeDamage( 25, attacker )

end