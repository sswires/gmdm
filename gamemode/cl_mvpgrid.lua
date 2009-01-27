GM.MVPSettings = {}
GM.MVPSettings.PlaceFont = "HUDMVPPlace";
GM.MVPSettings.NameFont = "HUDMVPName";
GM.MVPSettings.StatsLabelFont = "HUDMVPStatsLabel";
GM.MVPSettings.StatsValueFont = "HUDMVPStatsValue";


function RecvMVPs( umsg )

	local players = umsg:ReadShort();
	local mvps = {};
	local loop = 0;
	
	while( loop < players ) do
		local temp = {};
		temp.ent = umsg:ReadEntity();
		temp.frags = umsg:ReadLong();
		temp.name = umsg:ReadString();
		
		table.insert( mvps, temp );
		
		loop = loop + 1;
	end

	GAMEMODE:ShowMVPBoard( mvps );

end
usermessage.Hook( "gmdm_mvptable", RecvMVPs );

function GM:ShowMVPBoard( tablemvp )
	GAMEMODE.MVPBoard = tablemvp;
	GAMEMODE.ShouldDrawMVPBoard = true;
end

GM.MVPAlpha = 0;

function GetStringForOffset( offset )
	if( offset == 0 ) then
		return "1st"
	elseif( offset == 1 ) then
		return "2nd"
	elseif( offset == 2 ) then
		return "3rd"
	end
end

function GM:DrawMVPBoard()

	if ( GAMEMODE.MVPBoard and GAMEMODE.ShouldDrawMVPBoard ) then
		
		GAMEMODE.MVPAlpha = math.Approach( GAMEMODE.MVPAlpha, 255, 85 );
		
		local offset = 0;
		
		-- 	draw.SimpleText( String Text, String Font, Number X, Number Y, Table Colour, Number Xalign, Number Yalign )
		--draw.SimpleText( "Most Valuable Players", "GMDMMenuCaption", ScrW() - 20, ScrH() / 2, Table Colour, Number Xalign, Number Yalign )
		
		for k, v in pairs( GAMEMODE.MVPBoard ) do
			draw.SimpleTextOutlined( GetStringForOffset( offset ) .. " - " .. v.name, "HudBarItem", ScrW()/2, 100 + ( 50 * offset ), Color( 255, 255, 255, GAMEMODE.MVPAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0,0,0 ) )
			offset = offset + 1;
		end
	end
	
end
