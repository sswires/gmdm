function AddConCmdButtonToFrame( parent, x, y, label, concommand, hover )
	local newbutton = vgui.Create( "GMDMButton" );
	newbutton:SetParent( parent );
	newbutton:SetText( label );
	newbutton:SetPos( x, y );
	newbutton:SetSize( 150, 30 );
	newbutton.DoHover = hover
	newbutton.DoClick = function() 
		LocalPlayer():ConCommand( concommand );
		parent:Remove();
	end
end

local function GetTeamPlayers( teamid )
	local plCount = 0
	local teamPlayers = ""
	
	local players = player.GetAll()
	
	for k, v in pairs( players ) do
		if( v:Team() == teamid ) then
			plCount = plCount + 1;
			
			if( plCount == 1 ) then
				teamPlayers = v:Nick()
			else
				teamPlayers = teamPlayers .. ", " .. v:Nick()
			end
		end
	end
	
	if( plCount == 0 ) then
		if( teamid == TEAM_SPECTATOR ) then
			teamPlayers = "There are no spectators"
		elseif( GAMEMODE:IsTeamPlay() ) then 
			teamPlayers = "There are no players on this team"
		else
			teamPlayers = "There are no players active at the moment"
		end
	end
	
	local returnVal = {}
	returnVal.tstring = teamPlayers
	returnVal.count = plCount
	
	return returnVal
end

local function GetTeamCaption( teamid )
	local tp = GetTeamPlayers( teamid );
	return "The " .. team.GetName( teamid ) .. " have " .. tostring( team.GetScore( teamid ) ) .. " points\n" .. tostring( tp.count ) .. " players: " .. tp.tstring ;
end

function SelectTeamFrame( player, command, args )

	if( GetGlobalBool( "EndOfGame", false ) == false ) then
		local teamselectFrame = vgui.Create( "GMDMMenu" );
		teamselectFrame:SetSize( 640, 480 )
		teamselectFrame:SetPos( (ScrW()/2) - 320 , (ScrH()/2) - 240 )
		
		local fr = vgui.Create( "DLabel" );
		fr:SetParent( teamselectFrame );
		fr:SetText( "Please select an option to join the game" );
		fr:SetPos( 200, 75 );
		fr:SetSize( ScrW() - 200, 100 );
		fr:SetVisible( true );
	
		local bTeamPlay = GAMEMODE:IsTeamPlay();
		local yoffset = 140;
		
		teamselectFrame:SetTitle( "Team Selection" );
		
		if( bTeamPlay == true ) then
			teamselectFrame:SetText( "Welcome to " .. GAMEMODE.Name .. ". Select a team to join the game." );		
		else
			teamselectFrame:SetText( "Welcome to " .. GAMEMODE.Name .. ". Click join game to join in, or you can join as a spectator." );		
		end
		
		teamselectFrame:SetVisible( true );
		teamselectFrame:MakePopup( );
		
		if( bTeamPlay == true ) then
			--AddConCmdButtonToFrame( teamselectFrame, 25, 105, "Join Red", "gmdm_jointeam 1004", function() fr:SetText( GetTeamCaption( 1004 ) ) end );
			--AddConCmdButtonToFrame( teamselectFrame, 25, 140, "Join Blue", "gmdm_jointeam 1005", function() fr:SetText( GetTeamCaption( 1005 ) ) end );
			local tloop = 0
			
			for k, v in pairs( GAMEMODE:GetTeamList() ) do
				AddConCmdButtonToFrame( teamselectFrame, 25, 105 + (35 * tloop) , "Join " .. team.GetName( v ), "gmdm_jointeam " .. tostring( v ), function() fr:SetText( GetTeamCaption( v ) ) end );
				tloop = tloop + 1
			end
			
			AddConCmdButtonToFrame( teamselectFrame, 25, 105 + (35 * tloop), "Auto-assign Team", "gmdm_jointeam 0", function() fr:SetText( "Pick a team automatically" ) end );
			yoffset = 105 + (35 * (tloop + 1));
		else
			AddConCmdButtonToFrame( teamselectFrame, 25, 105, "Join Game", "gmdm_jointeam 0", function() local tp = GetTeamPlayers( TEAM_FREEFORALL ) fr:SetText( tostring( tp.count ) .. " players: " .. tp.tstring .. "\nThis server is set to free-to-all deathmatch. Click here to join." ) end );
		end
		
		AddConCmdButtonToFrame( teamselectFrame, 25, yoffset, "Join Spectator", "gmdm_jointeam 1002", function() fr:SetText( "Join spectator to watch the game\nSpectators: " .. GetTeamPlayers( 1002 ).tstring ) end );
	end
	
end

concommand.Add( "gmdm_showteammenu", SelectTeamFrame );
