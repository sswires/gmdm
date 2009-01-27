AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "ply_extension.lua" )
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "vgui/hudbar.lua" )
AddCSLuaFile( "vgui/huditems.lua" )
AddCSLuaFile( "cl_hitindicator.lua" )
AddCSLuaFile( "cl_spectatorui.lua" );
AddCSLuaFile( "cl_printcenter.lua" );
AddCSLuaFile( "cl_targetid.lua" );
AddCSLuaFile( "cl_deathnotice.lua" );

AddCSLuaFile( "cl_teamselectmenu.lua" );
AddCSLuaFile( 'vgui/menubackground.lua' );
AddCSLuaFile( 'vgui/gmdmbutton.lua' );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_weaponselect.lua" );
AddCSLuaFile( "cl_mvpgrid.lua" );

AddCSLuaFile( "cvars.lua" );

include( 'shared.lua' )
include( 'gmdm_util.lua' )

--include( 'extensions/map_additions.lua' );

resource.AddFile( "materials/sprites/pickup_cloud.vmt" )
resource.AddFile( "materials/rail.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/background.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/health.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/ammo.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/fireball.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/mine.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/nade.vtf" )
resource.AddFile( "materials/hud/gmdm_icons/background.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/health.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/ammo.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/fireball.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/mine.vmt" )
resource.AddFile( "materials/hud/gmdm_icons/nade.vmt" )

/*---------------------------------------------------------
   Name: gamemode:EntityTakeDamage( entity, inflictor, attacker, amount, dmginfo )
   Desc: The entity has received damage	 
---------------------------------------------------------*/
function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if ( ent:IsPlayer() ) then
		ent:OnTakeDamage( inflictor, attacker, amount, dmginfo );
		
		if( ent.Info and ent.Info.Pain ) then
			ent:RandomQuip( ent.Info.Pain );
		end
	end
	
	if( inflictor == attacker and ( attacker:IsPlayer() or attacker:IsNPC() ) ) then
		inflictor = attacker:GetActiveWeapon()
	end
	
	if( inflictor.WeaponHurtEnt != nil ) then
		inflictor:WeaponHurtEnt( entity, amount, dmginfo )
	end

	if( dmginfo:GetAttacker():IsPlayer() and GAMEMODE:EntityFitsFilter( GAMEMODE.HitIndicatorEnts, ent:GetClass() ) and GAMEMODE:ShouldDrawHitIndicator() == true ) then
		GAMEMODE:SendHitIndicator( dmginfo:GetAttacker(), dmginfo:GetDamage()/100 );
	end

end

function GM:EntityFitsFilter( ents, class )
	for k,v in pairs( ents ) do
		if( string.find( class, v ) != nil ) then
			return true
		end
	end
end

function GM:SendHitIndicator( pl, magnitude )

	local rFilter = RecipientFilter();
	rFilter:AddPlayer( pl );
	
	umsg.Start( "pl_hitindicator", rFilter );
		umsg.Float( magnitude );
	umsg.End();
	
end

function GM:ShowTeam( pl )
	pl:ConCommand( "gmdm_showteammenu" );
end

function GM:ShowSpare1( pl )
	pl:ConCommand( "+achievements_menu" );
end

/*---------------------------------------------------------
---------------------------------------------------------*/
function GM:InitPostEntity( )

	GAMEMODE:DoConVars()
	SetGlobalBool( "Teamplay", gmdm_teamplay:GetBool() );
	
	-- precache stuff
	GAMEMODE:PrecacheTeamModels();
	
	-- map add system here
	local sMapFile = "../" .. GAMEMODE.Folder .. "/content/maps/mapadd/" .. game.GetMap() .. ".txt"; -- filename of map add file for current map
	local sAlternatePath = "../gamemodes/gmdm/content/maps/mapadd/" .. game.GetMap() .. ".txt";
	
	if( !file.Exists( sMapFile ) ) then
		sMapFile = sAlternatePath;
	end
	
	if( file.Exists( sMapFile ) ) then -- we have a map add file
		local sContent = file.Read( sMapFile ); -- read it
		local tAdditions = util.KeyValuesToTable( sContent ); -- convert it into a table
		
		-- spawn stripping (CS/DOD maps mainly)
		if( tAdditions[ "stripspawns" ] != nil and tAdditions[ "stripspawns" ] == 1 ) then -- we're going to strip all the current spawn points
			Msg( "[GMDM] Stripping spawn point entities\n" );
			local tRemoveEnts = ents.FindByClass( "info_player_*" ); -- find all info_player prefixed entities
			
			for k, v in pairs( tRemoveEnts ) do -- for each one we've found
				v:Remove(); -- remove it
			end
		end
		
		-- remove weapon entities (HL2DM maps with pickups)
		if( tAdditions[ "stripweapons" ] != nil and tAdditions[ "stripweapons" ] == 1 ) then -- all guns are going
			Msg( "[GMDM] Stripping weapon entities\n" );
			local tRemoveEnts = ents.FindByClass( "weapon_*" ); -- all weapon ents in Hl2dm begin weapon_
			
			for k, v in pairs( tRemoveEnts ) do -- for each one we've found
				v:Remove(); -- remove it
			end
		end
		
		-- spawn adding
		if( tAdditions[ "spawns" ] != nil ) then -- we've got spawns
			for k, v in pairs( tAdditions[ "spawns" ] ) do -- for each one (they should be valid)
				Msg( "[GMDM] Adding spawn point at " .. v["pos"] .. " (ang " .. v["ang"] .. ")\n");
				local sPos = string.Explode( " ", v[ "pos" ] );
				local sAng = string.Explode( " ", v[ "ang" ] );
				
				local pSpawnPoint = ents.Create( "info_player_start" );
				
				if( pSpawnPoint and pSpawnPoint:IsValid() ) then
					pSpawnPoint:SetPos( Vector( tonumber( sPos[1] ), tonumber( sPos[2] ), tonumber( sPos[3] ) ) );
					pSpawnPoint:SetAngles( Angle( tonumber( sAng[1] ), tonumber( sAng[2] ), tonumber( sAng[3] ) ) );
					pSpawnPoint:Spawn();
				end
			end
		end
		
		-- ent adding
		if( tAdditions[ "entities" ] != nil ) then
			for k, v in pairs( tAdditions[ "entities" ] ) do
				Msg( "[GMDM] Adding " .. v["classname"] .. " at " .. v["pos"] .. " (ang " .. v["ang"] .. ")\n");
				local sPos = string.Explode( " ", v[ "pos" ] );
				local sAng = string.Explode( " ", v[ "ang" ] );
				
				local pAddEnt = ents.Create( v[ "classname" ] );
				
				if( pAddEnt and pAddEnt:IsValid() ) then
					pAddEnt:SetPos( Vector( tonumber( sPos[1] ), tonumber( sPos[2] ), tonumber( sPos[3] ) ) );
					pAddEnt:SetAngles( Angle( tonumber( sAng[1] ), tonumber( sAng[2] ), tonumber( sAng[3] ) ) );
					
					if( v[ "keyvalues" ] != nil ) then
						for k, v in pairs( v[ "keyvalues" ] ) do
							Msg( "[GMDM] Key value pair: " .. k .. " / " .. v .. "\n" );
							pAddEnt:SetKeyValue( k , v );
						end
					end

					pAddEnt:Activate();
					pAddEnt:Spawn();
				end
			end
		end
		
	end

end

function fPrintPos( player, command, args )
	local sPos = tostring( player:GetPos() );
	local sAng = tostring( player:GetAngles() );
	
	Msg( "Copy pasta\n==================\n\t\t\t\"Pos\"\t\"" .. sPos .. "\"\n\t\t\t\"Ang\"\t\"" .. sAng .. "\"\n==================\n" );
	
	player:PrintMessage( HUD_PRINTTALK, "Player is at pos: " .. sPos .. " / Ang: " .. sAng );
end

concommand.Add( "printabspos", fPrintPos );

function fAddWeapPoint( player, command, args )

	if( gmdm_leveleditor:GetBool() == false ) then return end
	
	local wtype = args[1];
	local wpos = player:GetPos() + Vector( 0, 0, 45 );
	
	local pickup = ents.Create( "gmdm_pickup" )
	pickup:SetPos( wpos );
	pickup:SetAngles( player:GetAngles() );
	pickup:SetKeyValue( "item", wtype );
	pickup:Spawn();
	
	Msg( "Copy Pasta for config:\n\n\t\t{\n\t\t\t\"ClassName\"\t\t\"gmdm_pickup\"\n\t\t\t\"Pos\"\t\t\t\"" ..  tostring( wpos ) .. "\"\n\t\t\t\"Ang\"\t\t\t\"" .. tostring( player:GetAngles() ) .. "\"\n\t\t\t\"Keyvalues\"\n\t\t\t{\n\t\t\t\t\"Item\"\t\t\t\"" .. wtype .. "\"\n\t\t\t}\n\t\t}\n" )
end

concommand.Add( "dev_addpickup", fAddWeapPoint );

/*---------------------------------------------------------
---------------------------------------------------------*/
function GM:PlayerInitialSpawn( pl )

	self.BaseClass:PlayerInitialSpawn( pl )
	
	pl:SendLua( "GAMEMODE:DoConVars()" );
	
	pl:SetTeam( TEAM_UNASSIGNED );
	pl:Spectate( OBS_MODE_FIXED );
	
	if( GetGlobalBool( "EndOfGame", false ) == false ) then
		if( gmdm_forceautoassign:GetBool() == true or pl:SteamID() == "BOT" ) then
			CCJoinTeam( pl, "join_team", { "0" } );
		else
			pl:ConCommand( "gmdm_showteammenu" );
		end
	end
	
	if( gmdm_soulcollector:GetBool() ) then
		pl:SetNetworkedInt( "Souls", 5 );
	end

end

function GM:PlayerDisconnect( pl )

	local tTripmines = ents.FindByClass( "item_tripmine" );
	local iCount = 0
	
	for k, v in pairs( tTripmines ) do
		if( v:GetNetworkedEntity( "Thrower" ) == pl and v.Laser and v.Laser:IsValid() and v.Laser.Activated == true and v.Laser:GetActiveTime( ) != 0 and v.Laser:GetActiveTime( ) < CurTime( ) ) then
			v:Remove()
		end
	end
	
end

local function EndSpawnProtect( pl )
	pl.Protected = false;
	pl:SetNetworkedBool( "Protected", false );
	pl:SetColor( 255, 255, 255, 255 );
end

/*---------------------------------------------------------
---------------------------------------------------------*/
function GM:PlayerSpawn( pl )

	if( teamModels[ pl:Team() ] ) then
		pl:SetModel( SelectRandomModel( pl:Team() ) )
	else
		GAMEMODE:PlayerSetModel( pl )
	end
	
	if( GAMEMODE:IsTeamPlay() ) then
		pl:DrawTeamCircles( true );
	else
		pl:DrawTeamCircles( false );
	end
		
	if( GetGlobalBool( "EndOfGame", false ) == true ) then		
		local targets = ents.FindByClass( "info_target" )
		
		if( targets and table.Count( targets ) > 0 ) then
			local view = targets[1]
			
			if( view and view:IsValid() ) then
				pl:Spectate( OBS_MODE_FIXED )
				pl:SpectateEntity( view )
			else
				pl:Lock();
			end
		else
			pl:Lock();
		end
		
		return
	end
	
	if( pl:Team() != TEAM_UNASSIGNED and pl:Team() != TEAM_SPECTATOR ) then
		
		pl:SetupPlayerTable();
		pl.SpawnTime = CurTime();
		
		if( gmdm_spawnprotection:GetInt() > 0 ) then
			pl.EndProtection = CurTime() + gmdm_spawnprotection:GetInt();
			pl.Protected = true;
			
			pl:SetNetworkedFloat( "EndSpawnProtect", pl.EndProtection );	
			pl:SetNetworkedBool( "Protected", true );
			
			pl:SetColor( 0, 128, 255, 175 );

			timer.Simple( gmdm_spawnprotection:GetInt(), EndSpawnProtect, pl );
		end
		
		pl:UnSpectate( );
		
		self.BaseClass:PlayerSpawn( pl )
		
		// Make the jump height a bit higher
		pl:SetGravity( 0.75 )
		
		// Set the player's speed
		GAMEMODE:SetPlayerSpeed( pl, GAMEMODE.PlayerWalkSpeed, GAMEMODE.PlayerRunSpeed )
		
		// Player shouldn't drop the weapon they're holding when they die
		pl:ShouldDropWeapon( false )
		//pl:SelectWeapon("gmdm_shotgun")
		//pl:SelectWeapon("gmdm_rpg")
	elseif( pl:Team() == TEAM_UNASSIGNED ) then
		pl:SetNetworkedBool( "DrawHUD", false );
		pl:Spectate( OBS_MODE_FIXED );
	end
	
	if( GAMEMODE:IsPlayerTeam( pl:Team() ) ) then
		GAMEMODE:OnActivePlayerSpawn( pl )	
	end


end

function GM:ShouldGibEntity( pl, dmginfo )
	if( dmginfo:GetDamage() > 70 ) then
		return true
	end
	
	return false
end

/*---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Player died.
---------------------------------------------------------*/
function GM:DoPlayerDeath( pl, attacker, dmginfo )

	pl:RandomQuip( pl.Info.Death );
	
	if( attacker and attacker:IsPlayer() ) then
		attacker:RandomQuip( attacker.Info.Taunt );
	end
	
	-- explode player tripmines on death
	local tTripmines = ents.FindByClass( "item_tripmine" );
	local iCount = 0
	
	for k, v in pairs( tTripmines ) do
		if( v:GetNetworkedEntity( "Thrower" ) == pl and v.Laser and v.Laser:IsValid() and v.Laser.Activated == true and v.Laser:GetActiveTime( ) != 0 and v.Laser:GetActiveTime( ) < CurTime( ) ) then
			v:Explode()
		end
	end
	
	local Inflictor = dmginfo:GetInflictor()
	
	if( Inflictor == attacker and ( attacker:IsPlayer() or attacker:IsNPC() ) ) then
		Inflictor = attacker:GetActiveWeapon()
	end
	
	if( Inflictor.WeaponKilledPlayer != nil ) then
		Inflictor:WeaponKilledPlayer( pl, dmginfo )
	end
		
	if( gmdm_ammodrops:GetBool() == true ) then
		
		local pack = ents.Create( "weapon_pack" )
		
		if ( ValidEntity( pack ) ) then
			pack:FillFromPlayer( pl )
			pack:SetPos( pl:GetPos() );
			pack:Spawn()
		end
	
	end
	
	if( gmdm_activeweapondrop:GetBool() == true ) then
		
		local weap = ents.Create( "gmdm_pickup" );
		
		if( weap:IsValid() ) then
			weap:SetPos( pl:GetPos()+Vector(0,0,30) );
			weap:SetKeyValue( "item", pl:GetActiveWeapon():GetClass() );
			weap:SetKeyValue( "norespawn", "1" );
			weap:Spawn();
		end
	end
		
	// If we were hurt a lot then gib us
	if ( gmdm_allowgibbing:GetBool() == true and GAMEMODE:ShouldGibEntity( pl, dmginfo ) ) then
		pl:Gib( dmginfo )
	else
		pl:CreateRagdoll()
	end
	
	// Increment death counter
	pl:AddDeaths( 1 )
	
	// Add frag to killer
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == pl ) then
			attacker:AddFrags( -1 )
		elseif( GAMEMODE:IsTeamPlay() == true and attacker:Team() == pl:Team() ) then
			attacker:AddFrags( -1 )
			attacker:NewPrintMessage( "You killed a teammate!" );
		else
			attacker:AddFrags( 1 )
			
			if( GAMEMODE:IsTeamPlay() == true and gmdm_soulcollector:GetBool() == false ) then
				team.AddScore( attacker:Team(), 1 );
			end
		end
		
	end
	
	if( gmdm_soulcollector:GetBool() ) then
		attacker:SetNetworkedInt( "Souls", attacker:GetNetworkedInt( "Souls", 0 ) + 1 );
		local souls = pl:GetNetworkedInt( "Souls", 0 );
		
		if( souls > 5 ) then
			souls = 5;
		end
		
		local x = 0;
			
		while( x < souls ) do
			local souls = ents.Create( "gmdm_soul" );
			souls:SetPos( pl:GetPos() + Vector( 0, 0 , 5 + (x*32) ) );
			souls:SetAngles( pl:GetAngles() )
			souls:Spawn();
			
			local phys = souls:GetPhysicsObject();
			
			if( phys and phys:IsValid() ) then
				phys:ApplyForceCenter( VectorRand() * 200 );
			end
			
				
			x = x + 1;
		end
		
		if( GAMEMODE:IsTeamPlay() ) then
			team.AddScore( pl:Team(), -(souls) );
		end
			
		pl:SetNetworkedInt( "Souls", pl:GetNetworkedInt( "Souls", 0 ) - souls );
		
	end

end


/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
---------------------------------------------------------*/
function GM:SetupPlayer( pl )

	pl:RemoveAllAmmo()

	if( gmdm_instagib:GetInt() == 2 ) then
		pl:Give( "gmdm_rail" );
		pl:SetCustomAmmo( "Rails", 100 );
	else
		pl:Give( "gmdm_crowbar" );
		
		pl:SetCustomAmmo( "Rails", 5 )
		pl:SetCustomAmmo( "FireBalls", 5 )
	    pl:SetCustomAmmo( "RPGs", 3 )
		pl:SetCustomAmmo( "TripMines", 3 )
		pl:SetCustomAmmo( "Bolts", 10 )
		pl:SetCustomAmmo( "ElectricityGrenades", 3 );
		
		pl:GiveAmmo( 64, "Pistol", true )	
		pl:GiveAmmo( 150, "SMG1", true )
		pl:GiveAmmo( 64, "buckshot", true )
		
		pl:Give( "gmdm_electricity_nades" );
		pl:Give( "gmdm_tripmine" )
		pl:Give( "gmdm_pistol" )
		pl:Give( "gmdm_crossbow" )
		pl:Give( "gmdm_shotgun" )
		pl:Give( "gmdm_rpg" )
		pl:Give( "gmdm_smg" )
		
		pl:SelectWeapon( "gmdm_smg" ); -- smg is default weapon
	end
	
end


/*---------------------------------------------------------
   Special function to respawn an entity
---------------------------------------------------------*/
function SpawnEntityTimed( classname, pos )

	local Wep = ents.Create( classname )
	Wep:SetPos( pos )
	Wep:KeyValue( "respawn", "1" )
	Wep:Spawn()
	
end

function GM:PlayerNoClip( pl, on )
	if( pl:IsAdmin() ) then
		return true
	end
	
	return self.BaseClass:PlayerNoClip( pl, on );
end

/*---------------------------------------------------------
   WeaponRespawnTime
---------------------------------------------------------*/
function GM:WeaponRespawnTime( classname )

	return 20
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerDeathThink( player )
   Desc: Called when the player is waiting to respawn
---------------------------------------------------------*/
function GM:PlayerDeathThink( pl )

	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	pl:Spawn()
	
end

function GM:CanPlayerSuicide( ply )
	return true
end 

/*---------------------------------------------------------
   Name: gamemode:PlayerDeath( )
   Desc: Called when a player dies.
---------------------------------------------------------*/
function GM:PlayerDeath( Victim, Inflictor, Attacker )

	// Don't spawn for at least 3 seconds
	Victim.NextSpawnTime = CurTime() + 3

	// Convert the inflictor to the weapon that they're holding if we can.
	// This can be right or wrong with NPCs since combine can be holding a 
	// pistol but kill you by hitting you with their arm.
	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( Inflictor == NULL ) then Inflictor = Attacker end
	
	end
	
	if (Attacker == Victim) then
	
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( Victim )
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( Attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledByPlayer" )
		
			umsg.Entity( Victim )
			umsg.String( Inflictor:GetClass() )
			umsg.Entity( Attacker )
			
			if( Victim.Headshot ) then
				umsg.Bool( Victim.Headshot )
			else
				umsg.Bool( false )
			end
		
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" )
		
	return end
	
	umsg.Start( "PlayerKilled" )
	
		umsg.Entity( Victim )
		umsg.String( Inflictor:GetClass() )
		umsg.String( Attacker:GetClass() )

	umsg.End()
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
	
end

function GM:SendMVP()
	
	local mvps = {};
	
	for k, v in pairs( player.GetAll() ) do
		if( v and v:IsValid() ) then
			local temp = {}
			temp.ent = v;
			
			if( gmdm_soulcollector:GetBool() ) then
				temp.frags = v:GetNetworkedInt( "Souls", 0 );
			else
				temp.frags = v:Frags();
			end
			temp.name = v:Name();
			
			table.insert( mvps, temp );
		end
	end
	
	table.SortByMember( mvps, "frags" );
	local count = table.Count( mvps );
	local mvpcount = 3;
	
	if( count < 3 ) then
		mvpcount = count;
	end
	
	local loop = 0;
	
		umsg.Start( "gmdm_mvptable" );
			
			umsg.Short( mvpcount ); -- how many we've got;
			
			while( loop < count ) do
				local thismvp = mvps[loop+1];
				
				umsg.Entity( thismvp.ent );
				umsg.Long( thismvp.frags );
				umsg.String( thismvp.name );
				
				loop = loop+1;
			end
			
			umsg.End();
	
end

function GM:EndGame()

	SetGlobalBool( "EndOfGame", true );
	SetGlobalBool( "Interval", true );
	SetGlobalFloat( "EndTime", CurTime() );
	SetGlobalFloat( "MapChangeTime", CurTime()+gmdm_endgameinterval:GetInt() );
	
	--timer.Simple( gmdm_endgameinterval:GetInt(), game.LoadNextMap ); -- load the next map.

	VOTING_TIME = gmdm_endgameinterval:GetInt()/2;
	GAMEMODE:LoadVoteMenu(); -- simple games 
	
	local pWinner = NULL;
	local targets = ents.FindByClass( "info_target" )
		
	for k, v in pairs( player.GetAll() ) do

		
		if( targets and table.Count( targets ) > 0 ) then
			local view = targets[1]
			
			if( view and view:IsValid() ) then
				v:Spectate( OBS_MODE_FIXED )
				v:SpectateEntity( view )
				v:SetPos( view:GetPos() )
				v:StripWeapons()
			else
				v:Lock();
			end
		else
			v:Lock();
		end
		
		if( gmdm_soulcollector:GetBool() ) then
			if( pWinner == NULL or pWinner:GetNetworkedInt( "Souls", 0 ) < v:GetNetworkedInt( "Souls", 0 ) ) then
				pWinner = v;
			end		
		else
			if( pWinner == NULL or pWinner:Frags() < v:Frags() ) then
				pWinner = v;
			end
		end
	end
	
	if( GAMEMODE:IsTeamPlay() == true ) then
		if( team.GetScore( TEAM_RED ) == team.GetScore( TEAM_BLUE ) ) then
			-- how did this happen?
			GMDM_PrintCenterAll( "Tie game!" );
		elseif( team.GetScore( TEAM_RED ) > team.GetScore( TEAM_BLUE ) ) then
			GMDM_PrintCenterAll( "Red Team won the game." )
		else
			GMDM_PrintCenterAll( "Blue Team won the game." )
		end
	else
		if( pWinner and pWinner:IsValid() and pWinner:IsPlayer() ) then
			GMDM_PrintCenterAll( pWinner:Name() .. " won the game." );
		end
	end
	
	GAMEMODE:SendMVP();

end

function GM:CheckWinConditions( )

	if( GetGlobalBool( "EndOfGame", false ) == false ) then
		if( GAMEMODE:IsTeamPlay() == true ) then
			if( team.GetScore( TEAM_RED ) >= gmdm_teamscorelimit:GetInt() or team.GetScore( TEAM_BLUE ) >= gmdm_teamscorelimit:GetInt() ) then
				GAMEMODE:EndGame()
			end
		elseif( GAMEMODE:IsTeamPlay() == false ) then
			for k, v in pairs( player.GetAll() ) do
				if( gmdm_soulcollector:GetBool() == true and v:GetNetworkedInt( "Souls", 0 ) >= gmdm_fraglimit:GetInt() ) then
					GAMEMODE:EndGame()
				elseif( gmdm_fraglimit:GetInt() > 0 and v:Frags() >= gmdm_fraglimit:GetInt() ) then
					GAMEMODE:EndGame()
				end
			end
		end
		
		if( gmdm_timelimit:GetInt() > 0 and CurTime() >= ( gmdm_timelimit:GetInt() * 60 ) ) then
			GAMEMODE:EndGame()
		end
	end
	
end

timer.Create( "CheckWin", 0.25, 0, function() hook.Call( "CheckWinConditions", GAMEMODE ) end )
