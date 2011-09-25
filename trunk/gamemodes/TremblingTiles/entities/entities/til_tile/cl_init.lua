include( "shared.lua" );

function msgDoGesture( um )
	
	local num = um:ReadShort();
	local ent = um:ReadEntity();
	ent:DoAnimationEvent( num );
	
end
usermessage.Hook( "msgDoGesture", msgDoGesture );