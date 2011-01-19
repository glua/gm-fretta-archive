////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Version Search                             //
////////////////////////////////////////////////

gwt_Version = {}

local THIS_VERSION = gws_Version
local SVN_VERSION = nil
local EXTRA_DATA = nil

function gwt_Version.GetVersionData()
	return THIS_VERSION, SVN_VERSION, EXTRA_DATA
end

function gwt_Version.GetVersionFromSyno( contents , size )
	-- Taken from RabidToaster Achievements mod.
	print( contents )
	local split = string.Explode( "\n", contents )
	local subsplit = string.Explode( "=", split[ 1 ] or "" )
	local version = tonumber( subsplit[ 2 ] or "" )
	
	if ( not version ) then
		SVN_VERSION = -1
		
		print( "Getting the version data failed." )
		return
	end
	
	SVN_VERSION = version
	
	if ( split[ 2 ] ) then
		EXTRA_DATA = split[ 2 ]
	end
	
	timer.Simple(15, gwt_Version.DisplayVersion)
	
end

function gwt_Version.DisplayVersion()
	local myVer, svnVer, extradata = gwt_Version.GetVersionData()
	local myDisplay = { Color(255, 255, 0) }
	table.insert( myDisplay , "Playing GarryWare, version " .. tostring( myVer ) .. ". " )
	
	if myVer < svnVer then
		table.insert( myDisplay , Color(255, 192, 0) )
		table.insert( myDisplay , "Most recent is " .. tostring( svnVer ) )
		
		if (math.floor(svnVer*10) - math.floor(myVer*10)) > 0 then
			table.insert( myDisplay , Color(255, 0, 0) )
			table.insert( myDisplay , " that means the server is totally out-of-date!" )
			
		elseif (math.floor(svnVer*100) - math.floor(myVer*100)) > 0 then
			table.insert( myDisplay , Color(255, 164, 0) )
			table.insert( myDisplay , " that means the server misses some features!" )
			
		elseif (math.floor(svnVer*1000) - math.floor(myVer*1000)) > 0 then
			table.insert( myDisplay , Color(255, 192, 0) )
			table.insert( myDisplay , " that means the server misses some fixes!" )
			
		end
	else
		table.insert( myDisplay , Color(0, 220, 0) )
		table.insert( myDisplay , "Sounds like it's up-to-date!" )
		
	end
	chat.AddText( unpack(myDisplay) )
end

http.Get( "http://subversion.assembla.com/svn/garryware/gamemode/cl_version.lua", "", gwt_Version.GetVersionFromSyno )
print( "Getting the version data..." )
