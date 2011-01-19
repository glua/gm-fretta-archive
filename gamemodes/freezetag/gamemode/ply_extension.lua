
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Thaw( playsounds )

	if not self:IsFrozen() then return end
	
	self:SetMaterial( "" )
	self:Freeze( false )
	self:SetColor( 255, 255, 255, 255 )
	self:SetNetworkedBool( "Frozen", false )
	
	if playsounds then
	
		local ed = EffectData()
		ed:SetOrigin( self:GetPos() )
		util.Effect( "ice_break", ed, true, true )
	
		self:EmitSound( table.Random( GAMEMODE.GlassBreak ), 100, math.random( 90, 110 ) )
		
	end
	
end

function meta:IceFreeze()

	self:Freeze( true )
	self:SetMaterial( "freezetag/ice" )
	self:SetNetworkedBool( "Frozen", true )
	
	self:EmitSound( table.Random( GAMEMODE.GlassHit ), 100, math.random(90,110) )
	
	local col = team.GetColor( self:Team() )
	self:SetColor( math.Max( col.r, 150 ), math.Max( col.g, 150 ), math.Max( col.b, 150 ), 255 )
	
	local ed = EffectData()
	ed:SetOrigin( self:GetPos() )
	util.Effect( "ice_poof", ed, true, true )
	
end

function meta:IsFrozen()
	return self:GetNetworkedBool( "Frozen", false )
end
