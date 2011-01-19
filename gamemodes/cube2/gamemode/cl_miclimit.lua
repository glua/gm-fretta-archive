--Quick function added due to request on the forums
function AoEMic()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:GetPos():Distance( LocalPlayer():GetPos() ) < 400 ) then
			
			v:SetMuted( false );
			
		else
			
			v:SetMuted( true );
			
		end
		
	end
	
end
hook.Add( "Think", "AoEMic", AoEMic );
