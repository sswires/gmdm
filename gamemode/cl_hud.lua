include( 'cl_spectatorui.lua' );
include( 'cl_printcenter.lua' );
include( 'cl_mvpgrid.lua' );

HelpText = {
	"To defeat the cyberdemon, shoot it until it dies."
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

GM.LatestVictim = {}
GM.VicAvatarPanel = nil;

function GM:SetLatestVictim( pl, killed )

	if( killed == nil ) then
		killed = false;
	end
	
	if( GAMEMODE.LatestVictim.avatar ) then
		GAMEMODE.LatestVictim.avatar:Remove()
	end
	
	if( pl and pl:IsValid() and pl:IsPlayer() ) then
		local temp = {};
		temp.time = CurTime();
		temp.name = pl:Name();
		temp.killed = killed;
		
		if( pl:GetFriendStatus() == "friend" ) then
			temp.name = "your friend " .. temp.name;
		elseif( pl == LocalPlayer() ) then
			temp.name = "yourself";
		end
		
		AvatarPanel = vgui.Create( "AvatarImage" )
		AvatarPanel:SetPos( ScrW() / 2 - 12, ScrH()*0.75 - 16 )
		AvatarPanel:SetSize( 24, 32 );
		AvatarPanel:SetPlayer( pl );
		
		temp.avatar = AvatarPanel;
		
		GAMEMODE.LatestVictim = temp;
	end
end

GM.VictimFont = "HudBarItem";

function GM:DrawLatestVictim( )

	local lv = GAMEMODE.LatestVictim;
	
	if( lv and lv.name and lv.avatar and lv.time ) then
		
		local prefix = "You killed ";
		
		if( lv.killed == true ) then
			prefix = "You were killed by ";
		end
		
		local alpha = lv.alpha or 255;
		
		surface.SetFont( GAMEMODE.VictimFont );
		local w, h = surface.GetTextSize( prefix .. lv.name );
	
		local textx = (ScrW()/2) - (w/2) + 45
		local steamx = (ScrW()/2) - (w/2) - 16
		
		if( lv.avatar and lv.avatar:IsVisible() == false ) then
			textx = (ScrW()/2) - (w/2)
		end
		
		draw.SimpleTextOutlined( prefix .. lv.name, GAMEMODE.VictimFont, textx, ScrH()*0.75, Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, alpha ) );
	
		lv.avatar:SetPos( steamx, ScrH()*0.75 );
		
		if( lv.time + 3 < CurTime() ) then
			local diff = CurTime() - lv.time;
			lv.alpha = 255 - (127.5 * (diff-3)); -- lol y = mx + c
			lv.avatar:SetAlpha( lv.alpha );
		end
		
		if( lv.time + 5 < CurTime() ) then
			lv.avatar:Remove()
			GAMEMODE.LatestVictim = {};
		else
			GAMEMODE.LatestVictim = lv;
		end
		
	end
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