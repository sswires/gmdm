function GM:DrawSpectatorUI()

	if( LocalPlayer():GetNetworkedBool( "ShowSpectatorUI", false ) == true ) then
		local pSpecEnt = LocalPlayer():GetNetworkedEntity( "SpectatedPlayer" );
		
		if( pSpecEnt and pSpecEnt:IsValid() and pSpecEnt:IsPlayer() ) then
			draw.SimpleTextOutlined( "Spectating:", "HudBarItem", 20, ScrH()-150, Color( 255, 255, 255 ), 0, 0, 1, color_black )
			draw.SimpleTextOutlined( LocalPlayer():Name(), "HudBarItem", 160, ScrH()-150, team.GetColor( LocalPlayer():Team() ), 0, 0, 1, color_black )	
			draw.RoundedBox( 2, 20, ScrH()-115, 400, 25, Color( 0, 0, 0, 150 ) );
			draw.SimpleText( "Health: " .. tostring( LocalPlayer():Health() ) .. "", "HudBarItemSmall", 25, ScrH()-112, Color( 255, 255, 255 ) );

			-- help tips
			draw.SimpleText( "PRIMARY ATTACK: Spectate next player", "HudBarItemSmall", 25, ScrH()-75, Color( 255, 255, 255, 75 ) );
			draw.SimpleText( "SECONDARY ATTACK: Spectate previous player", "HudBarItemSmall", 25, ScrH()-60, Color( 255, 255, 255, 75 ) );
		end
	end
	
end
