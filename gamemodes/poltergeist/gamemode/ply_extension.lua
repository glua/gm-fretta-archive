
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:SpawnProp( health )

	local prop = ents.Create( "prop_physics" )
	prop:SetPos( self:GetPos() + Vector(0,0,50) )
	prop:SetModel( table.Random( GAMEMODE.PropModels ) )
	prop:Spawn()
	prop:SetHealth( health )
	
	self:SetProp( prop )

end

function meta:SetProp( prop )

	if self:GetProp() and self:GetProp():IsValid() then
	
		local ed = EffectData()
		ed:SetEntity( self:GetProp() )
		util.Effect( "prop_morph", ed, true, true )
	
		prop:SetHealth( self:GetProp():Health() )
		self:GetProp():SetOwner( nil )
		
	end

	self:Spectate( OBS_MODE_CHASE )
	self:SpectateEntity( prop )
	self:SetPos( prop:GetPos() )
	self:SetNWEntity( "Prop", prop )
	
	prop:SetOwner( self )
	
	local ed = EffectData()
	ed:SetEntity( prop )
	util.Effect( "prop_possessed", ed, true, true )

end

function meta:GetProp()
	return self:GetNWEntity( "Prop", NULL )
end