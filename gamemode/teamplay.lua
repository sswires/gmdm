--	For team deathmatch support later, plus the unassigned colour is ugly as FUCK

-- team consts
TEAM_UNASSIGNED		= 1001
TEAM_SPECTATOR		= 1002
TEAM_FREEFORALL		= 1003
TEAM_RED			= 1004
TEAM_BLUE			= 1005

-- set ups
team.SetUp( TEAM_FREEFORALL, "Free-for-all", Color( 0, 193, 0, 255 ) );
team.SetUp( TEAM_RED, "Red Team", Color( 200, 50, 50, 255 ) );
team.SetUp( TEAM_BLUE, "Blue Team", Color( 50, 50, 200, 255 ) );

-- teams
GM.Teams = {}
GM.Teams[ "FFA" ] = { TEAM_FREEFORALL };
GM.Teams[ "TDM" ] = { TEAM_RED, TEAM_BLUE };

-- models
teamModels = {}
teamModels[ TEAM_RED ] = { "models/player/breen.mdl", "models/player/combine_soldier.mdl", "models/player/combine_super_soldier.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/police.mdl", "models/player/soldier_stripped.mdl" };
teamModels[ TEAM_BLUE ] = { "models/player/kleiner.mdl", "models/player/alyx.mdl", "models/player/eli.mdl", "models/player/gman_high.mdl", "models/player/barney.mdl", "models/player/Group03/male_01.mdl" };

function GM:IsTeamPlay()
	return GetGlobalBool( "Teamplay", false );
end

function GM:GetTeamList()
	if( GAMEMODE:IsTeamPlay() ) then
		return GAMEMODE.Teams[ "TDM" ];
	else
		return GAMEMODE.Teams[ "FFA" ];
	end
end

function GM:PrecacheTeamModels()
	-- precache stuff
	for k, v in pairs( teamModels ) do
		for kk, vv in pairs( v ) do
			util.PrecacheModel( vv )
			Msg( "Precached Team Model: " .. vv .. "\n" )
		end
	end
		
end

function SelectRandomModel( teamid )
	local index = math.random( 1, table.Count( teamModels[ teamid ] ) );
	return teamModels[ teamid ][ index ]
end

function GM:IsPlayerTeam( teamid )
	if( gmdm_teamplay:GetBool() == true ) then
		return ( teamid == TEAM_RED or teamid == TEAM_BLUE )
	else
		return ( teamid == TEAM_FREEFORALL )
	end
end

function GM:OnActivePlayerSpawn( pl )

end

function TeamplayInterval( bTeamDeathmatch )
	
	SetGlobalBool( "Interval", false );
	
	if( bTeamDeathmatch == false ) then
		SetGlobalBool( "Teamplay", false );
		local tPlayers = player.GetAll()
		
		for k, v in pairs( tPlayers ) do
			if( v:Team() != TEAM_UNASSIGNED and v:Team() != TEAM_SPECTATOR ) then
				v:SetTeam( TEAM_FREEFORALL );
				v:SetFrags( 0 )
				v:SetDeaths( 0 )
				v:Spawn();
			end
		end
	else
		SetGlobalBool( "Teamplay", true );
		
		team.SetScore( TEAM_RED, 0 );
		team.SetScore( TEAM_BLUE, 0 );
		
		local tPlayers = player.GetAll()
			
		for k, v in pairs( tPlayers ) do
			if( gmdm_forceautoassign:GetBool() == true ) then
				if( v:Team() != TEAM_UNASSIGNED and v:Team() != TEAM_SPECTATOR ) then
					local iTeamRedNum = team.NumPlayers( TEAM_RED );
					local iTeamBlueNum = team.NumPlayers( TEAM_BLUE );
					
					if( iTeamRedNum == iTeamBlueNum ) then
						v:SetTeam( math.random( 1004, 1005 ) );
					elseif( iTeamBlueNum > iTeamRedNum ) then
						v:SetTeam( TEAM_RED );
					else
						v:SetTeam( TEAM_BLUE );
					end
						
					v:SetFrags( 0 );
					v:SetDeaths( 0 );
					v:Spawn();
				end
			else
				v:KillSilent();
				v:SetTeam( TEAM_UNASSIGNED );
				v:Spectate( OBS_MODE_FIXED );
				v:ConCommand( "gmdm_showteammenu" );
			end
		end
	end
end

function CCJoinTeam( pl, command, args )
	
	if( CLIENT ) then
		return
	end
	if( GetGlobalBool( "EndOfGame", false ) == true ) then return end
	
	local bTeamplay = GAMEMODE:IsTeamPlay( );
	local iTeamNum = tonumber( args[1] );
	
	if( (pl:Team() != TEAM_UNASSIGNED and pl:Team() != TEAM_SPECTATOR) and pl:Alive() == true ) then
		pl:Kill()
	end
	
	if( bTeamplay == true ) then
		if( iTeamNum == nil ) then return end
		if( iTeamNum == pl:Team() ) then return end
		
		if( iTeamNum == TEAM_BLUE or iTeamNum == TEAM_RED ) then
			pl:KillSilent();
			pl:SetTeam( iTeamNum );
			pl:PrintMessage( HUD_PRINTTALK, pl:Name() .. " is joining the " .. team.GetName( pl:Team() ) );
		elseif( iTeamNum == TEAM_SPECTATOR ) then
			pl:NewPrintMessage( "Not implemented yet" );
		else
			pl:KillSilent( );
			
			local iTeamRedNum = team.NumPlayers( TEAM_RED );
			local iTeamBlueNum = team.NumPlayers( TEAM_BLUE );
			
			if( iTeamRedNum == iTeamBlueNum ) then
				if( team.GetScore( TEAM_RED ) > team.GetScore( TEAM_BLUE ) ) then
					pl:SetTeam( TEAM_BLUE );
				elseif( team.GetScore( TEAM_RED ) < team.GetScore( TEAM_BLUE ) ) then
					pl:SetTeam( TEAM_RED );
				else
					pl:SetTeam( math.random( 1004, 1005 ) );
				end
			elseif( iTeamBlueNum > iTeamRedNum ) then
				pl:SetTeam( TEAM_RED );
			else
				pl:SetTeam( TEAM_BLUE );
			end	

			pl:PrintMessage( HUD_PRINTTALK, pl:Name() .. " is joining the " .. team.GetName( pl:Team() ) );
			
			if( gmdm_soulcollector:GetBool() ) then
				team.AddScore( pl:Team(), pl:GetNetworkedInt( "Souls", 0 ) );
			end
		end
	else
		if( pl:Team() != TEAM_FREEFORALL ) then
			pl:KillSilent();
			pl:SetTeam( TEAM_FREEFORALL );
			pl:PrintMessage( HUD_PRINTTALK, pl:Name() .. " has joined in the game" );
		elseif( iTeamNum != nil and iTeamNum == TEAM_SPECTATOR ) then
			pl:KillSilent();
		end
	end
end

if( SERVER ) then
concommand.Add( "gmdm_jointeam", CCJoinTeam );
end