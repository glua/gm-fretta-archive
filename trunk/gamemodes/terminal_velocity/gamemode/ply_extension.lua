
local meta = FindMetaTable( "Player" )
if !meta then return end 

function meta:Explode()

	self:Kill()

	local ed = EffectData()
	ed:SetOrigin( self:GetPos() )
 	util.Effect( "Explosion", ed, true, true )
	
	util.BlastDamage( self, self, self:GetPos(), 300, 200 )

end

function meta:IsHuman()

	local class = self:GetPlayerClass()
	
	if class.Human then
		return true
	end
	
	return false

end