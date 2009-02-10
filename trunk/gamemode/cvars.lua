
-- call backs
function CvarCallback( name, oldval, newval )
	if( SERVER ) then
		GAMEMODE:CvarCallback( name, oldval, newval );
	else
		GAMEMODE:ServerCvarChanged( name, oldval, newval );
	end
end

function GM:CvarCallback( name, oldval, newval )

	if( name == "gmdm_soulcollector" ) then
		if( util.tobool( newval ) == true ) then
			for k, v in pairs( player.GetAll() ) do
				v:SetNetworkedInt( "Souls", 5 );
			end
			
			GMDM_PrintCenterAll( "Soul collector mode enabled! Each player starts on 5 souls." );
		end
	elseif( name == "gmdm_headshotmode" ) then
		if( tonumber( newval ) > 0 ) then
			GMDM_PrintCenterAll( "Headshot mode enabled!" );
		else
			GMDM_PrintCenterAll( "Headshot mode disabled!" );
		end
	elseif( name == "gmdm_teamplay" ) then
		if( tonumber( newval ) > 0 ) then
			SetGlobalBool( "Interval", true );
			GMDM_PrintCenterAll( "Team Deathmatch enabled. Restarting in 5 seconds." );
			timer.Simple( 5, TeamplayInterval, true )
		else
			SetGlobalBool( "Interval", true );
			GMDM_PrintCenterAll( "Free-for-all enabled. Respawning players in 5 seconds." );
			timer.Simple( 5, TeamplayInterval, false )
		end
	elseif( name == "gmdm_instagib" ) then
		local old = tonumber( oldval )
		local new = tonumber( newval )
		
		if( new == 0 ) then
			GMDM_PrintCenterAll( "Insta-gib disabled." )
			
			if( old == 2 ) then
				local players = player.GetAll()
	
				for k, pl in pairs( players ) do
					pl:StripWeapons()
					pl:SetCustomAmmo( "Rails", 5 )
					pl:SetCustomAmmo( "FireBalls", 5 )
				    pl:SetCustomAmmo( "RPGs", 3 )
					pl:SetCustomAmmo( "TripMines", 3 )
					pl:SetCustomAmmo( "Bolts", 10 )
					
					pl:GiveAmmo( 64, "Pistol", true )	
					pl:GiveAmmo( 150, "SMG1", true )
					pl:GiveAmmo( 64, "buckshot", true )
					
					pl:Give( "gmdm_tripmine" )
					pl:Give( "gmdm_pistol" )
					pl:Give( "gmdm_crossbow" )
					pl:Give( "gmdm_shotgun" )
					pl:Give( "gmdm_smg" )
					pl:Give( "gmdm_rpg" )
				end
			end
		elseif( new == 2 ) then
			local players = player.GetAll()
	
			for k, pl in pairs( players ) do
				pl:StripWeapons()
				pl:Give( "gmdm_rail" );
				pl:SetCustomAmmo( "Rails", 100 );
			end	

			GMDM_PrintCenterAll( "Insta-gib w/Rail Gun enabled" );
		else
			GMDM_PrintCenterAll( "Insta-gib enabled" );
		end
	
	end
end

function GM:ServerCvarChanged( name, oldval, newval )

end

-- shitty macro for this sort of thing
if( SERVER ) then
	function CreateGMDMConvar( var, value, prefix )
			
		if( prefix == nil ) then
			prefix = "gmdm"
		end
		
		Msg( "[GMDM] Registered SERVER console variable " .. prefix .. "_" .. var .. "\n" );

		local ret = CreateConVar( prefix .. "_" .. var, tostring( value ), FCVAR_GAMEDLL | FCVAR_NOTIFY | FCVAR_REPLICATED | FCVAR_ARCHIVE | FCVAR_DEMO );
			
		cvars.AddChangeCallback( prefix .. "_" .. var, CvarCallback );
		--local ret = GetConVar( prefix .. "_" .. var );
		
		if( !ret ) then
			Msg( "[GMDM] Unable to register cvar " .. prefix .. "_" .. var .. "\n" );
		end
	
		return ret;
	end
end

if( CLIENT ) then
	function CreateGMDMConvar( var, value, prefix )
			
		if( prefix == nil ) then
			prefix = "gmdm"
		end
		
		Msg( "[GMDM] Registered CLIENT console variable " .. prefix .. "_" .. var .. "\n" );

		local ret = GetConVar( prefix .. "_" .. var );
		cvars.AddChangeCallback( prefix .. "_" .. var, CvarCallback );
		
		if( !ret ) then
			Msg( "[GMDM] Unable to register cvar " .. prefix .. "_" .. var .. "\n" );
		end
		
		table.insert( GameInfo, ret );
		return ret;
	end
end

function GM:DoConVars()
	gmdm_headshotmode = CreateGMDMConvar( "headshotmode", "0" ); -- only headshots count
	gmdm_instagib = CreateGMDMConvar( "instagib", "0" ); -- one hit kills mode
	gmdm_hitindicators = CreateGMDMConvar( "hitindicators", "1" ); -- send hit indicators to client
	gmdm_ammodrops = CreateGMDMConvar( "ammodrops", "0" ); -- ammo drops when players die.
	gmdm_friendlytripmines = CreateGMDMConvar( "friendlytripmines", "0" ); -- tripmines don't trigger when the owner of a tripmines walks through it
	gmdm_activeweapondrop = CreateGMDMConvar( "activeweapondrop", "1" ); -- drop the currently active weapon
	gmdm_teamplay = CreateGMDMConvar( "teamplay", "0" );
	gmdm_forceautoassign = CreateGMDMConvar( "forceautoassign", "0" ); -- force auto assign for nubs
	gmdm_spawnprotection = CreateGMDMConvar( "spawnprotection", "3" );
	gmdm_unlimitedammo = CreateGMDMConvar( "unlimitedammo", "0" );
	gmdm_bulletpenetration = CreateGMDMConvar( "bulletpenetration", "1" );
	gmdm_allowgibbing = CreateGMDMConvar( "allowgibbing", "1" ); -- you can turn gibbing off if you want, server side

	gmdm_leveleditor = CreateGMDMConvar( "leveleditor", "0" );
	
	gmdm_soulcollector = CreateGMDMConvar( "soulcollector", "0" );

	-- limits
	gmdm_timelimit = CreateGMDMConvar( "timelimit", "15" ); -- time limit per map ( =< 0 means infinite )
	gmdm_fraglimit = CreateGMDMConvar( "fraglimit", "100" ); -- frag limit in FFA (unused in TDM, use teamscorelimit)
	gmdm_teamscorelimit = CreateGMDMConvar( "teamscorelimit", "250" ); -- score limit for a team in TDM
	gmdm_endgameinterval = CreateGMDMConvar( "endgameinterval", "20" ); -- how many seconds between end of game and map change
end