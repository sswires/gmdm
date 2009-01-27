mapadd = {};
mapadd.SearchPath = "..";

mapadd.Additions = {};
mapadd.Removals = {};
mapadd.Filters = {};

mapadd.Additions[1] = { key = "Entities" }; -- for any entity add on

-- default spawning, simple to add
mapadd.Additions[2] = { ent_class = "info_player_start",
						key = "Spawns",
						};
					
-- the key values table here shows that you can combine simple key values for the ent along with Pos and Ang so you don't have that KeyValues bullshit. the key is the key
-- in the entry, and the value is the ent keyval it correlates to					
mapadd.Additions[3] = 	{ 	ent_class = "gmdm_pickup",
							key = "Pickups",
							keyvalues = { { "Weapon", "item" } },
						};
						
-- now stuff to remove
-- you can filter stuff that only has certain key values, ie
-- keyvalues = {
--	{ "Team", "5001" }
-- }
mapadd.Removals[1]	= { ent_class = { "info_player_terrorist", "info_player_counterterrorist", "info_player_axis", "info_player_allies" },
						key = "StripSpawns",
						};
						
mapadd.Removals[2]	= { ent_class = { "weapon_*", "item_*" },
						key = "StripWeapons"
						};
					
-- replace ents on the map with others					
mapadd.Filters[1]	= { key = "ReplaceWithGMDMPickups",
						ents = 	{
									{
										ent_class	= { "weapon_sbotgun", "item_buckshot" },
										replacement = {
											ent_class	= "gmdm_pickup",
											keyvalues 	= { { "item", "gmdm_shotgun" } },
											pos_offset	= { 0, 0, 12 },
										}
									},
								}
					   }
						

mapadd.EntKeyValue = {};
	
function mapadd:KeyValueHook( ent, key, val )
	if( !ent ) then return end
	
	Msg( "[GMDM Map Add] Hooked key value for " .. ent:GetClass() .. ", key: " .. key .. ", value: " .. val .. "\n" );
	
	if( !self.EntKeyValue[ ent:EntIndex() ] ) then
		self.EntKeyValue[ ent:EntIndex() ] = {};
	end
	
	local temp = {};
	temp.key = key
	temp.val = val;
	
	table.insert( self.EntKeyValue[ ent:EntIndex() ], temp );
end
hook.Add( "EntityKeyValue", "GMDMMapAddKeyValueHook", function( a, b, c ) mapadd:KeyValueHook( a, b, c ) end ); 

function mapadd:EntHasKeyValue( ent, key, val )
	if( !self.EntKeyValue[ ent:EntIndex() ] ) then
		return false
	end	
	
	for k, v in pairs( self.EntKeyValue[ ent:EntIndex() ] ) do
		if( key == v.key and val == v.val ) then
			return true
		end
	end
	
	return false
end 
 
function mapadd:Run( )
	local MapName = game.GetMap();
	
	-- map add system here
	local MapFile = self.SearchPath .. MapName .. ".txt"; -- filename of map add file for current map
	local AlternatePath = "../gamemodes/gmdm/content/maps/mapadd/" .. MapName .. ".txt";
	
	if( !file.Exists( MapFile ) ) then
		MapFile = AlternatePath;
		Msg( "[GMDM Map Add] Could not find map add for this map at path " .. MapFile .. ", using default\n" );
	end
	
	if( file.Exists( MapFile ) ) then
		Msg( "[GMDM Map Add] Running map additions file for " .. MapName .. "\n" );
		
		local Content = file.Read( MapFile ); -- read it
		local Additions = util.KeyValuesToTable( Content ); -- convert it into a table	
				
		if( Additions ) then
			mapadd:DoAdditions( Additions );
		end
		
		Msg( "[GMDM Map Add] Finished running map additions file\n" );
	else
		Msg( "[GMDM Map Add] There is no map add file for " .. MapName .. "\n" );
	end
end
hook.Add( "InitPostEntity", "GMDMMappAddRunFile", function() mapadd:Run() end );  

function mapadd:DoAdditions( tablekv ) -- tablekv is passed by Run()
	Msg( "[GMDM Map Add] Doing additions...\n" );
	PrintTable( tablekv );
	
	if( tablekv[0] ) then
		Msg( "Wat tablekv[0]\n" );
	end
	
	local settings = tablekv;
	local additions = self.Additions;
	
	for k, v in pairs( additions ) do
		Msg( "[GMDM Map Add] Checking " .. string.lower( v.key ) .. "\n" );
	
		local addSettings = tablekv[ string.lower( v.key ) ];
		
		if( addSettings and #addSettings > 0 ) then
			-- we have this key in our settings
			local EntClass = v.ent_class or settings["classname"];
			
			if( EntClass ) then
				for kk, vv in pairs( addSettings ) do
					if( vv["pos"] and vv["ang"] ) then
						local Pos = vv["pos"];
						local Ang = vv["ang"];
						local KeyValues = vv[ "keyvalues" ];
						
						local PosTable = string.Explode( " ", Pos );
						local AngTable = string.Explode( " ", Ang );
						
						if( #PosTable != 3 or #AngTable != 3 ) then
							Msg( "[GMDM Map Add] Had irregular setting for pos and/or ang (class: " .. EntClass .. ", key: " .. v.key .. ")" );
						else
							local Ent = ents.Create( EntClass );
							
							if( Ent and Ent:IsValid() ) then
								Ent:SetPos( Vector( PosTable[1], PosTable[2], PosTable[3] ) );
								Ent:SetAngles( Angle( AngTable[1], AngTable[2], AngTable[3] ) );
								
								if( KeyValues and #KeyValues > 0 ) then
									for k, v in pairs( KeyValues ) do
										Msg( "[GMDM Map Add] Key value pair: " .. k .. ", " .. v .. "\n" );
										Ent:SetKeyValue( k, v );
									end
								end
								
								Ent:Spawn()
								Ent:Activate()
								
								Msg( "[GMDM Map Add] Spawned entity " .. EntClass .. " under " .. v.key .. " at " .. Pos .. " - " .. Ang .. "\n" );								
							else
								Msg( "[GMDM Map Add] Ent (class: " .. EntClass .. ", key: " .. v.key .. ") was nil\n" );
							end
						end
					else
						Msg( "[GMDM Map Add] Pos and/or Angle missing for " .. v.key .. "(" .. EntClass .. ") entry\n" );
					end
				end
			else
				Msg( "[GMDM Map Add] Entity class was not defined for key " .. v.key .. "\n" );
			end
		else
			Msg( "[GMDM Map Add] No settings for " .. string.lower( v.key ) .. "\n" );
		end
	end
end

