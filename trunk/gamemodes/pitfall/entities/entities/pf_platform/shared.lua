ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

local expSnd = Sound( "Weapon_Mortar.Impact" )

function ENT:Initialize()
	local efdata = EffectData()
	efdata:SetEntity( self.Entity )
	util.Effect( "propspawn", efdata )
end

function ENT:OnRemove()
	local efdata = EffectData()
	efdata:SetEntity( self.Entity )
	efdata:SetOrigin( Vector( 255, 0, 0 ) )
	local Entity = self.Entity
	timer.Simple(3, function()
		util.Effect( "entity_remove", efdata )
	end )
end