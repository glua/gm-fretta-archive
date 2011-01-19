
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""

local expSnd = Sound( "Weapon_Mortar.Impact" )

function ENT:Initialize()
	local efdata = EffectData()
	efdata:SetEntity( self.Entity )
	util.Effect( "propspawn", efdata ) //Stolen from sandbox :D
end

function ENT:OnRemove()
	
	local owner = self.Entity:GetNWEntity( "Owner" )
	if ( !ValidEntity( owner ) ) then return end
	local col = team.GetColor( owner:Team() or TEAM_UNASSIGNED )
	
	local efdata = EffectData()
	efdata:SetEntity( self.Entity )
	efdata:SetOrigin( Vector( col.r, col.g, col.b ) )
	util.Effect( "entity_remove", efdata ) //Also stolen from sandbox :D
	
	self.Entity:EmitSound( expSnd ) //BEWM!!!
	
end