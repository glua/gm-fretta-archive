--I dunno, some people from FP wanted this, so

VoiceCmds = {
	{ text = "over here", fem = "vo/npc/female01/overhere01.wav", mal = "vo/npc/male01/overhere01.wav", say = false },
	{ text = "help", fem = "vo/npc/female01/help01.wav", mal = "vo/npc/male01/help01.wav", say = false },
	{ text = "hi", fem = "vo/npc/female01/hi01.wav", mal = "vo/npc/male01/hi01.wav", say = true },
	{ text = "lets go", fem = "vo/npc/female01/letsgo01.wav", mal = "vo/npc/male01/letsgo01.wav", say = false },
}

function VoiceReplace( ply, text, team, dead )
	
	if( ply:Alive() and CurTime() > ply:GetNWInt( "NextSpeech" ) and ply:Team() != TEAM_SPECTATOR ) then
		
		for _, v in pairs( VoiceCmds ) do
			
			if( string.lower( string.gsub( text, "'", "" ) ) == v.text ) then
				
				if( table.HasValue( F_PLAYERMODELS, ply:GetModel() ) ) then
					
					ply:EmitSound( Sound( v.fem ) );
					
				else
					
					ply:EmitSound( Sound( v.mal ) );
					
				end
				
				ply:SetNWInt( "NextSpeech", CurTime() + 5 );
				
				if( !v.say ) then
					
					return "";
					
				end
				
			end
			
		end
		
	end
	
end
hook.Add( "PlayerSay", "VoiceReplace", VoiceReplace );

function DoBystanderScreams( ply )
	
	for _, v in pairs( player.GetAll() ) do
		
		local trace = { };
		trace.start = ply:EyePos();
		trace.endpos = v:EyePos();
		trace.filter = ply;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity and tr.Entity:IsValid() and tr.Entity == v and v != ply ) then
			
			if( table.HasValue( F_PLAYERMODELS, v:GetModel() ) ) then
				
				v:EmitSound( Sound( "vo/npc/female01/" .. table.Random( BystanderLines ) ) );
				
			else
				
				v:EmitSound( Sound( "vo/npc/male01/" .. table.Random( BystanderLines ) ) );
				
			end
			
		end
		
	end
	
end
