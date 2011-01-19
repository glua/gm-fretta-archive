
local CLASS = {}

CLASS.DieSounds = {"npc/metropolice/die1.wav",
"npc/metropolice/die2.wav",
"npc/metropolice/die3.wav",
"npc/metropolice/die4.wav"}

CLASS.RadioEnd = {"npc/combine_soldier/vo/off1.wav",
"npc/combine_soldier/vo/off2.wav"}

CLASS.RadioStart = {"npc/metropolice/vo/off1.wav",
"npc/metropolice/vo/off4.wav"}

CLASS.Radio = {}

RADIO_CALM = 1
RADIO_ENGAGING = 2
RADIO_HURT = 3
RADIO_DEATH = 4
RADIO_WIN = 5

CLASS.Radio[ RADIO_CALM ] = {"npc/combine_soldier/vo/teamdeployedandscanning.wav",
"npc/combine_soldier/vo/stayalert.wav",
"npc/combine_soldier/vo/stayalertreportsightlines.wav",
"npc/combine_soldier/vo/confirmsectornotsterile.wav",
"npc/combine_soldier/vo/prepforcontact.wav",
"npc/combine_soldier/vo/readyweapons.wav",
"npc/combine_soldier/vo/reportallpositionsclear.wav",
"npc/combine_soldier/vo/stabilizationteamholding.wav",
"npc/combine_soldier/vo/reportallradialsfree.wav",
"npc/combine_soldier/vo/stayalert.wav",
"npc/combine_soldier/vo/noviscon.wav",
"npc/combine_soldier/vo/block31mace.wav",
"npc/combine_soldier/vo/block64jet.wav",
"npc/combine_soldier/vo/gridsundown46.wav",
"npc/combine_soldier/vo/flatline.wav",
"npc/combine_soldier/vo/lostcontact.wav",
"npc/combine_soldier/vo/fullactive.wav",
"npc/combine_soldier/vo/readyweapons.wav",
"npc/combine_soldier/vo/standingby].wav",
"npc/combine_soldier/vo/prepforcontact.wav",
"npc/combine_soldier/vo/sectionlockupdash4.wav",
"npc/combine_soldier/vo/reportingclear.wav",
"npc/combine_soldier/vo/sightlineisclear.wav",
"npc/combine_soldier/vo/targetone.wav",
"npc/combine_soldier/vo/movein.wav",
"npc/combine_soldier/vo/unitisinbound.wav",
"npc/metropolice/vo/code7.wav",
"npc/metropolice/vo/ptatlocationreport.wav",
"npc/metropolice/vo/responding2.wav",
"npc/metropolice/vo/unitisonduty10-8.wav",
"npc/metropolice/vo/investigating10-103.wav",
"npc/metropolice/vo/ten8standingby.wav",
"npc/metropolice/vo/ten97suspectisgoa.wav",
"npc/metropolice/vo/ten8standingby.wav",
"npc/metropolice/vo/nocontact.wav",
"npc/metropolice/vo/clearno647no10-107.wav",
"npc/metropolice/vo/holdingon10-14duty.wav",
"npc/metropolice/vo/404zone.wav",
"npc/metropolice/vo/stillgetting647e.wav",
"npc/metropolice/vo/anyonepickup647e.wav",
"npc/metropolice/vo/suspectlocationunknown.wav",
"npc/metropolice/vo/ptatlocationreport.wav",
"npc/metropolice/vo/unitis10-8standingby.wav",
"npc/metropolice/vo/preparefor1015.wav",
"npc/metropolice/vo/keepmoving.wav",
"npc/metropolice/vo/blockisholdingcohesive.wav",
"npc/metropolice/vo/dispupdatingapb.wav",
"npc/metropolice/vo/searchingforsuspect.wav",
"npc/metropolice/vo/nonpatrolregion.wav",
"npc/metropolice/vo/checkformiscount.wav",
"npc/metropolice/vo/stabilizationjurisdiction.wav",
"npc/metropolice/vo/allunitsreportlocationsuspect.wav",
"npc/metropolice/vo/transitblock.wav",
"npc/metropolice/vo/workforceintake.wav",
"npc/metropolice/vo/proceedtocheckpoints.wav",
"npc/metropolice/vo/holdthisposition.wav",
"npc/metropolice/vo/novisualonupi.wav",
"npc/metropolice/vo/ptgoagain.wav",
"npc/metropolice/vo/hardpointscanning.wav"}

CLASS.Radio[ RADIO_ENGAGING ] = {"npc/combine_soldier/vo/sweepingin.wav",
"npc/combine_soldier/vo/suppressing.wav",
"npc/combine_soldier/vo/isfinalteamunitbackup.wav",
"npc/combine_soldier/vo/wehavenontaggedviromes.wav",
"npc/combine_soldier/vo/motioncheckallradials.wav",
"npc/combine_soldier/vo/callcontactparasitics.wav",
"npc/combine_soldier/vo/tracker.wav",
"npc/combine_soldier/vo/containmentproceeding.wav",
"npc/combine_soldier/vo/engaging.wav",
"npc/combine_soldier/vo/contactconfirm.wav",
"npc/combine_soldier/vo/engagedincleanup.wav",
"npc/combine_soldier/vo/hardenthatposition.wav",
"npc/combine_soldier/vo/executingfullresponse.wav",
"npc/combine_soldier/vo/readyweaponshostilesinbound.wav",
"npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav",
"npc/combine_soldier/vo/fixsightlinesmovein.wav",
"npc/combine_soldier/vo/goactiveintercept.wav",
"npc/combine_soldier/vo/targetcompromisedmovein.wav",
"npc/combine_soldier/vo/targetmyradial.wav",
"npc/combine_soldier/vo/unitismovingin.wav",
"npc/combine_soldier/vo/gosharp.wav",
"npc/combine_soldier/vo/necroticsinbound.wav",
"npc/combine_soldier/vo/callcontacttarget1.wav",
"npc/combine_soldier/vo/gosharpgosharp.wav",
"npc/metropolice/vo/allunitsmovein.wav",
"npc/metropolice/vo/needanyhelpwiththisone.wav",
"npc/metropolice/vo/covermegoingin.wav",
"npc/metropolice/vo/inpositionathardpoint.wav",
"npc/metropolice/vo/inpositiononeready.wav",
"npc/metropolice/vo/teaminpositionadvance.wav",
"npc/metropolice/vo/positiontocontain.wav",
"npc/metropolice/vo/searchingforsuspect.wav",
"npc/metropolice/vo/goingtotakealook.wav",
"npc/metropolice/vo/thereheis.wav",
"npc/metropolice/vo/backup.wav",
"npc/metropolice/vo/search.wav",
"npc/metropolice/vo/tagonebug.wav",
"npc/metropolice/vo/examine.wav",
"npc/metropolice/vo/readytoamputate.wav",
"npc/metropolice/vo/highpriorityregion.wav",
"npc/metropolice/vo/tagonenecrotic.wav",
"npc/metropolice/vo/suspectisbleeding.wav",
"npc/metropolice/vo/pickingupnoncorplexindy.wav",
"npc/metropolice/vo/unitreportinwith10-25suspect.wav",
"npc/metropolice/vo/hesrunning.wav",
"npc/metropolice/vo/visceratordeployed.wav",
"npc/metropolice/vo/assaultpointsecureadvance.wav",
"npc/metropolice/vo/destroythatcover.wav",
"npc/metropolice/vo/breakhiscover.wav",
"npc/metropolice/vo/confirmpriority1sighted.wav",
"npc/metropolice/vo/contactwithpriority2.wav",
"npc/metropolice/vo/firetodislocateinterpose.wav",
"npc/metropolice/vo/firingtoexposetarget.wav"}

CLASS.Radio[ RADIO_HURT ] = {"npc/combine_soldier/vo/coverhurt.wav",
"npc/combine_soldier/vo/heavyresistance.wav",
"npc/combine_soldier/vo/callhotpoint.wav",
"npc/combine_soldier/vo/prioritytwoescapee.wav",
"npc/combine_soldier/vo/flush.wav",
"npc/combine_soldier/vo/displace.wav",
"npc/combine_soldier/vo/displace2.wav",
"npc/combine_soldier/vo/bouncerbouncer.wav",
"npc/combine_soldier/vo/ripcordripcord.wav",
"npc/combine_soldier/vo/requestmedical.wav",
"npc/combine_soldier/vo/requeststimdose.wav",
"npc/combine_soldier/vo/sectorisnotsecure.wav",
"npc/metropolice/vo/allunitsrespondcode3.wav",
"npc/metropolice/vo/non-taggedviromeshere.wav",
"npc/metropolice/vo/hesgone148.wav",
"npc/metropolice/vo/movebackrightnow.wav",
"npc/metropolice/vo/lookoutrogueviscerator.wav",
"npc/metropolice/vo/reinforcementteamscode3.wav",
"npc/metropolice/vo/movingtohardpoint.wav",
"npc/metropolice/vo/movingtohardpoint2.wav",
"npc/metropolice/vo/bugsontheloose.wav",
"npc/metropolice/vo/tag10-91d.wav",
"npc/metropolice/vo/code100.wav",
"npc/metropolice/vo/document.wav",
"npc/metropolice/vo/dismountinghardpoint.wav",
"npc/metropolice/vo/visceratorisoffgrid.wav",
"npc/metropolice/vo/outlandbioticinhere.wav",
"npc/metropolice/vo/possible404here.wav",
"npc/metropolice/vo/shotsfiredhostilemalignants.wav",
"npc/metropolice/vo/moveit.wav",
"npc/metropolice/vo/holditrightthere.wav",
"npc/metropolice/vo/possible10-103alerttagunits.wav",
"npc/metropolice/vo/possible647erequestairwatch.wav",
"npc/metropolice/vo/lookingfortrouble.wav",
"npc/metropolice/vo/getoutofhere.wav",
"npc/metropolice/vo/condemnedzone.wav",
"npc/metropolice/vo/hidinglastseenatrange.wav",
"npc/metropolice/vo/Ihave10-30my10-20responding.wav",
"npc/metropolice/vo/necrotics.wav",
"npc/metropolice/vo/catchthatbliponstabilization.wav",
"npc/metropolice/vo/confirmadw.wav",
"npc/metropolice/vo/runninglowonverdicts.wav",
"npc/metropolice/vo/dontmove.wav",
"npc/metropolice/vo/lockyourposition.wav",
"npc/metropolice/vo/unitis10-65.wav",
"npc/metropolice/vo/holdingon10-14duty.wav",
"npc/metropolice/vo/hesupthere.wav",
"npc/metropolice/vo/movingtocover.wav"}

CLASS.Radio[ RADIO_DEATH ] = {"npc/combine_soldier/vo/onedown.wav",
"npc/combine_soldier/vo/onedutyvacated.wav",
"npc/combine_soldier/vo/lostcontact.wav",
"npc/combine_soldier/vo/coverhurt.wav",
"npc/combine_soldier/vo/heavyresistance.wav",
"npc/combine_soldier/vo/cover.wav",
"npc/combine_soldier/vo/coverme.wav",
"npc/metropolice/vo/acquiringonvisual.wav",
"npc/metropolice/vo/Ivegot408hereatlocation.wav",
"npc/metropolice/vo/holdit.wav",
"npc/metropolice/vo/isdown.wav",
"npc/metropolice/vo/lockyourposition.wav",
"npc/metropolice/vo/looseparasitics.wav",
"npc/metropolice/vo/allunitscode2.wav",
"npc/metropolice/vo/visceratorisoc.wav",
"npc/metropolice/vo/tenzerovisceratorishunting.wav",
"npc/metropolice/vo/requestsecondaryviscerator.wav",
"npc/metropolice/vo/wehavea10-108.wav",
"npc/metropolice/vo/wegotadbherecancel10-102.wav",
"npc/metropolice/vo/reinforcementteamscode3.wav",
"npc/metropolice/vo/subjectis505.wav",
"npc/metropolice/vo/takecover.wav",
"npc/metropolice/vo/movingtocover.wav",
"npc/metropolice/vo/backmeupimout.wav",
"npc/metropolice/vo/help.wav",
"npc/metropolice/vo/moveit.wav",
"npc/metropolice/vo/watchit.wav",
"npc/metropolice/vo/takecover.wav",
"npc/metropolice/vo/getdown.wav",
"npc/metropolice/vo/lookout.wav",
"npc/metropolice/vo/shit.wav"}

CLASS.Radio[ RADIO_WIN ] = {"npc/combine_soldier/vo/onecontained.wav",
"npc/combine_soldier/vo/affirmativewegothimnow.wav",
"npc/combine_soldier/vo/sectorissecurenovison.wav",
"npc/combine_soldier/vo/readyextractors.wav",
"npc/combine_soldier/vo/contained.wav",
"npc/combine_soldier/vo/closing2.wav",
"npc/combine_soldier/vo/cleaned.wav",
"npc/combine_soldier/vo/ripcord.wav",
"npc/combine_soldier/vo/stabilizationteamholding.wav",
"npc/combine_soldier/vo/stabilizationteamhassector.wav",
"npc/combine_soldier/vo/thatsitwrapitup.wav",
"npc/combine_soldier/vo/unitisclosing.wav",
"npc/combine_soldier/vo/secure.wav",
"npc/metropolice/vo/sterilize.wav",
"npc/metropolice/vo/protectioncomplete.wav",
"npc/metropolice/vo/clearandcode100.wav",
"npc/metropolice/vo/control100percent.wav",
"npc/metropolice/vo/controlsection.wav",
"npc/metropolice/vo/get11-44inboundcleaningup.wav",
"npc/metropolice/vo/gota10-107sendairwatch.wav",
"npc/metropolice/vo/upi.wav",
"npc/metropolice/vo/utlthatsuspect.wav",
"npc/metropolice/vo/gotsuspect1here.wav",
"npc/metropolice/vo/chuckle.wav"}

// base class

CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 200
CLASS.PlayerModel			= "models/player/police.mdl"
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.TeammateNoCollide 	= false
CLASS.AvoidPlayers			= false

CLASS.Utilities             = { "weapon_ts_tripmines", "weapon_ts_medikit", "weapon_ts_flares", "Recharger", "Tracker" }
CLASS.UtilDescriptions      = { "Tripmines that emit a loud alarm sound when unidentified lifeforms pass through them.",
								"A medical kit that regenerates some of your health.",
								"Flares that emit bright ultraviolet light.",
								"A recharger that restores your flashlight batteries twice as fast.",
								"Bullets that display a red dot on the radar when activated."}

function CLASS:Move( pl, mv )

	if pl:KeyDown( IN_BACK ) then
		
		mv:SetMaxSpeed( 150 )
		
	end
	
end

function CLASS:Think( pl )

	if not pl:Alive() then return end
	
	if ( pl.BatteryTime or 0 ) < CurTime() then
	
		pl.BatteryTime = CurTime() + 0.2

		if pl:FlashlightIsOn() then
		
			pl:AddBattery( -2 )
			
			if pl:GetBattery() < 2 then
			
				pl.BatteryTime = CurTime() + 1.0
				pl:Flashlight( false )
			
			end
		
		else
		
			if pl:GetNWBool( "Recharger", false ) then
			
				pl:AddBattery( 2 )
			
			else
			
				pl:AddBattery( 1 )
			
			end
		
		end
	
	end
	
	if ( pl.WaitTime or 0 ) < CurTime() then
	
		if ( pl.IdlePos or Vector(0,0,0) ):Distance( pl:GetPos() ) < 250 then
		
			pl:SetRadioInfo( 1, RADIO_CALM )
			
		end
		
		pl.IdlePos = pl:GetPos()
		pl.WaitTime = CurTime() + math.random(25,50)
		
	end

	local time, mode = pl:GetRadioInfo()
	
	if time and time < CurTime() then
		
		if time < ( pl.LastRadio or 0 ) then
		
			pl:SetRadioInfo( pl.LastRadio, mode )
			return
			
		end
		
		local snd = table.Random( self.Radio[ mode ] )
		local waittime = SoundDuration( "../../hl2/sound/"..snd ) + 0.5 
		
		pl:SetRadioInfo()
		pl:EmitSound( table.Random( self.RadioStart ), 100, math.random(90,110) )
		pl.LastRadio = CurTime() + SoundDuration( snd ) + 1.0
		
		timer.Simple( 0.3, function( pl, snd ) if ValidEntity( pl ) and pl:Alive() then pl:EmitSound( snd ) end end, pl, snd )
		timer.Simple( waittime, function( pl ) if ValidEntity( pl ) and pl:Alive() then pl:EmitSound( table.Random( self.RadioEnd ), 100, math.random(90,110) ) end end, pl )
		
	end
	
end 

function CLASS:OnDeath( pl )

	pl:EmitSound( Sound( table.Random( self.DieSounds ) ) )
	
	for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
	
		if v:GetPos():Distance( pl:GetPos() ) < 500 and v != pl then
		
			v:SetRadioInfo( CurTime() + math.Rand(0.5,3.5) , RADIO_DEATH )
			
		end
		
	end
	
end

function CLASS:OnSpawn( pl )

	pl:SetNWBool( "Recharger", false )
	pl:SetNWBool( "Tracker", false )
	pl:SetNWBool( "IsTracking", false )

	if string.find( pl:GetUtility(), "weapon" ) then

		pl:Give( pl:GetUtility() )
		
	else
	
		pl:SetNWBool( pl:GetUtility(), true )
	
	end
	
	if pl:IsCommander() then
	
		pl:SetHealth( 125 )
		pl:SetModel( "models/player/combine_soldier.mdl" )
	
	end

	pl:SetCustomAmmo( "Pistol", 60 )
	pl:SetCustomAmmo( "SMG", 250 )
	pl:SetCustomAmmo( "Buckshot", 30 )
	pl:SetCustomAmmo( "Rifle", 120 )
	pl:SetCustomAmmo( "Burst", 120 )
	pl:SetCustomAmmo( "Tripmine", 2 )
	pl:SetCustomAmmo( "Flare", 1 )
	
	pl:SetRadioInfo()
	pl:SetBattery( 100 )
	pl:SetNWBool( "Flashlight", false )
	pl:SetColor( 255, 255, 255, 255 )

end

player_class.Register( "BaseSoldier", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSoldier"
CLASS.DisplayName		= "SG 552"
CLASS.Description       = "An accurate scoped automatic rifle."

function CLASS:Loadout( pl )

	pl:Give( "weapon_ts_sg552" )
	pl:Give( "weapon_ts_glock18" )
	
end

player_class.Register( "SG552", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSoldier"
CLASS.DisplayName		= "FN P90"
CLASS.Description       = "A submachine gun with a larger magazine and rate of fire."

function CLASS:Loadout( pl )

	pl:Give( "weapon_ts_p90" )
	pl:Give( "weapon_ts_usp" )
	
end

player_class.Register( "P90", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSoldier"
CLASS.DisplayName		= "M3 Shotgun"
CLASS.Description       = "A powerful semi-automatic shotgun."

function CLASS:Loadout( pl )

	pl:Give( "weapon_ts_m3" )
	pl:Give( "weapon_ts_p228" )
	
end

player_class.Register( "M3", CLASS )

local CLASS ={}
CLASS.Base 				= "BaseSoldier"
CLASS.DisplayName		= "FAMAS G2"
CLASS.Description       = "An automatic rifle that fires 3 shot bursts."

function CLASS:Loadout( pl )

	pl:Give( "weapon_ts_famas" )
	pl:Give( "weapon_ts_fiveseven" )
	
end

player_class.Register( "FAMAS", CLASS )