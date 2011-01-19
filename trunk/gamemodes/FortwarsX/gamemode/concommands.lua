
//This is a serverside file. It defines all the FortwarsX console commands.

function Spawn( ply, command, args ) //Someone wants to spawn a prop
	
	if ( GetGlobalInt( "RoundNumber" ) != 1 ) then return end //Can only spawn in build phase!
	if ( !ply:Alive() or ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED ) then return end //Can't spawn props while dead or being spectator!
	
	if ( ply:GetNWInt( "Props", 0 ) >= PropLimit ) then
		ply:ChatPrint( "You've hit the prop limit!" )
		ply:EmitSound( "Buttons.snd10" ) //BZZZT!
		return
	end //Prop limit!
	
	local Mdl = args[1] //Get the first argument
	if ( !Mdl ) then MsgN( "Usage: fwx_spawn [modelname]" ) return end //Give them help if they fucked something up
	local trace = ply:GetEyeTrace()
	local allowed = false
	
	for i = 1, #PropList do
		if ( PropList[i][1] == Mdl ) then
			allowed = true
			break
		end
	end
	
	if ( !allowed ) then //Only allow props if they are on the prop list!
		MsgN( Format( "%q isn't a valid prop!", Mdl ) )
		return
	end 
	
	local prop = ents.Create( "fw_prop" )
	if ( !prop ) then return end
	
	prop:SetSkin( math.random( 0, 10 ) ) //Not all props have skins, but whatever
	prop:SetModel( Mdl )
	prop:SetNWEntity( "Owner", ply ) //We made it!
	
	local normal = trace.Normal
	local ang = normal:Angle()
	prop:SetAngles( Angle( 0, ang.y, 0 ) ) //Make the prop face you
	
	local hitpos = trace.HitPos 
	prop:SetPos( hitpos ) //Set the pos to the hitpos of the trace
	
	prop:Spawn()
	prop:Activate()
	
	//The following is all stolen from sandbox :D
    local vFlushPoint = hitpos - ( trace.HitNormal * 512 ) // Find a point that is definitely out of the object in the direction of the floor
	vFlushPoint = prop:NearestPoint( vFlushPoint ) 		   // Find the nearest point inside the object to that point
	vFlushPoint = prop:GetPos() - vFlushPoint               // Get the difference
	vFlushPoint = hitpos + vFlushPoint                  // Add it to our target pos
	prop:SetPos( vFlushPoint )
	
	ply:SetNWInt( "Props", ply:GetNWInt( "Props", 0 ) + 1 ) //Add to his prop count
	
end

concommand.Add( "fwx_spawn", Spawn )

function RemoveProps( ply, command, args ) //Someone wants to remove all their props

	if ( GetGlobalInt( "RoundNumber" ) != 1 ) then return end //Can only remove all props in build phase!
	if ( !ply:Alive() ) then return end //Can't remove all props while dead!
	if ( ply:GetNWInt( "Props", 0 ) == 0 ) then return end //Can't remove all props if you don't have any!
	
	ply:SetNWInt( "Props", 0 ) //Set his prop count to zero
	RemoveAllProps( ply ) //This is defined in shared.lua
	
end

concommand.Add( "fwx_removeprops", RemoveProps )
