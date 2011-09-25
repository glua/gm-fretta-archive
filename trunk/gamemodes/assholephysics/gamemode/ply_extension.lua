
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:SetCash( num )
	self:SetNWInt( "Cash", math.Max( num, 0 ) )
end

function meta:GetCash()
	return self:GetNWInt( "Cash", 0 )
end

function meta:AddCash( num )

	self:SetCash( self:GetCash() + num )
	GAMEMODE:AddTeamCash( self:Team(), num )
	
end

function meta:DropCash()

	local cash = ents.Create( "sent_cash" )
	cash:SetPos( self:GetPos() )
	cash:Spawn()

end

function meta:SetCombo( num )
	self:SetNWInt( "Combo", num )
end

function meta:GetCombo()
	return self:GetNWInt( "Combo", 0 )
end

function meta:ComboAward()

	local num = self:GetCombo()
	
	self:SetCombo( 0 )
	
	if num > 1 then
	
		self:EmitSound( Sound( "assholephysics/cash.wav" ) )
		self:AddCash( num * 50 )
	
		umsg.Start( "DrawPrice", self )
		umsg.Vector( Vector(0,0,0) )
		umsg.String( "" )
		umsg.Short( num * 50 )
		umsg.End()
	
	end

end

function meta:HospitalBills( enemy )

	local price = -100 * math.random( 1, 3 )

	umsg.Start( "DrawPrice", self )
	umsg.Vector( enemy:GetPos() )
	umsg.String( "Hospital Bills: $"..price * -1 )
	umsg.Short( price )
	umsg.End()
	
	self:AddCash( price )

end

function meta:DrawPrice( ent )

	self:AddCash( ent.Price )
	self:SetCombo( self:GetCombo() + 1 )
	self.ComboTime = CurTime() + 3
	
	umsg.Start( "DrawPrice", self )
	umsg.Vector( ent:GetPos() + Vector(0,0,20) )
	
	if ent.Price == 0 then
		umsg.String( ent.Name..": Priceless" )
	else
		umsg.String( ent.Name..": $"..ent.Price )
	end
	
	umsg.Short( ent.Price )
	umsg.End()

end