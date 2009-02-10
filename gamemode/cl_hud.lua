include( 'cl_spectatorui.lua' );
include( 'cl_printcenter.lua' );
include( 'cl_mvpgrid.lua' );

HelpText = {
	"The object of the game is to just kill things.",
	"Settings explained:",
	"	Headshot mode makes it so that only headshots do damage.",
	"	Insta-gib gives everyone the railgun and it's one hit kills.",
	"	One-shot one kill is a variant of insta-gib that allows all weapons.",
	"	Soul-collector is a replacement for frags, everyone starts with 5 frags, you get a soul for a kill and you can also collect the souls of your victims.",
};

/*---------------------------------------------------------
   Name: gamemode:HUDShouldDraw( name )
   Desc: return true if we should draw the named element
---------------------------------------------------------*/
function GM:HUDShouldDraw( name )
	return ( name ~= "CHudBattery" and name ~= "CHudHealth" and name ~= "CHudAmmo" )
end

function GM:HUDShouldPaint( name )
	return ( name ~= "CHudBattery" and name ~= "CHudHealth" and name ~= "CHudAmmo" )
end

function GM:HUDPaintBackground( )
	GAMEMODE:DrawHit( )
end

/*---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
---------------------------------------------------------*/
function GM:HUDPaint()

	if( LocalPlayer() ) then
		GAMEMODE:DrawMVPBoard()
		GAMEMODE:HUDDrawTargetID()
		GAMEMODE:HUDDrawPickupHistory()
		GAMEMODE:DrawDeathNotice( 0.95, 0.05 )
		GAMEMODE:DrawSpectatorUI()
		GAMEMODE:PrintCenterMessage( )
		GAMEMODE:DrawLatestVictim();
		
		if( LocalPlayer():GetNetworkedBool( "Protected", false ) == true ) then
			draw.SimpleTextOutlined( "Spawn Protection Active", "HudBarItem", ScrW()/2, ScrH()-150, Color( 0, 100, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) );
		end
		
		
		if( GetGlobalBool( "EndOfGame", false ) == true ) then
			local fEndTime = GetGlobalFloat( "MapChangeTime", CurTime()+20 );
				
			if( CurTime() > fEndTime ) then
				iTimeTillEnd = 0;
			else
				iTimeTillEnd = fEndTime - CurTime();
			end
			
			local DrawColor = Color( ( math.sin( CurTime() * 3 ) + 1.0 ) * 20 + 50, ( math.sin( CurTime() * 3 ) + 1.0 ) * 20 + 50, ( math.sin( CurTime() * 3 ) + 1.0 ) * 20 + 50);
			draw.SimpleTextOutlined( "Next map in " .. string.ToMinutesSeconds( iTimeTillEnd ), "HudBarItem", 25, ScrH() - 50, DrawColor, 0, 0, 2, color_black )

		end
	end

end