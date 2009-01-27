function GM:WillDrawEnt( ent )
	if( ent == LocalPlayer() ) then return false end
	if( !ent:IsPlayer() ) then return false end
	if( string.Left( ent:Name(), 3 ) == "Bot" and GetConVarNumber( "developer" ) == 1 and GetConVarNumber( "sv_cheats" ) == 1 ) then return true end
	
	if( ent:Team() == LocalPlayer():Team() and GetConVarNumber( "gmdm_teamplay" ) != 0 ) then
		local trace = {}
		trace.start = LocalPlayer():GetPos()
		trace.endpos = ent:GetPos()
		trace.filter = { LocalPlayer(), ent }
		
		local tresult = util.TraceLine( trace )
		
		if( tresult.Hit == false ) then
			return true
		end
	end
	
	return false
end

/*---------------------------------------------------------
   Name: gamemode:HUDDrawTargetID( )
   Desc: Draw the target id (the name of the player you're currently looking at)
---------------------------------------------------------*/
function GM:HUDDrawTargetID()

	local text = "ERROR"
	local font = "TargetIDSmall"
	
	local players = player.GetAll()
	
	for k, v in pairs( players ) do
		local pos = v:GetPos();
		pos.z = pos.z + 70
		
		local screenpos = pos:ToScreen()
		
		if( screenpos.visible ) then
			local willdraw = GAMEMODE:WillDrawEnt( v );
			
			if( ( type( willdraw ) == "bool" and willdraw == true ) or ( type( willdraw ) == "string" and willdraw != "" ) ) then
			
				local fDistance = ( LocalPlayer():GetPos() - v:GetPos() ):Length()
				local fAlphaMulti = 1.0
				
				if( fDistance > 300 and fDistance < 800 ) then
					fAlphaMulti = ( ( ( fDistance - 300 ) / 400 ) * -1 ) + 1
				elseif( fDistance > 800 ) then
					fAlphaMulti = 0
				end
				
				local suff = ""
				
				if ( type( willdraw ) == "string" ) then
					suff = willdraw;
				end
					
				
				draw.SimpleText( v:Name() .. suff, font, screenpos.x+1, screenpos.y+1, Color(0,0,0,120 * math.Clamp( fAlphaMulti, 0, 1 ) ), TEXT_ALIGN_CENTER  )
				draw.SimpleText( v:Name() .. suff, font, screenpos.x+2, screenpos.y+2, Color(0,0,0,50 * math.Clamp( fAlphaMulti, 0, 1 ) ), TEXT_ALIGN_CENTER  )
				
				if( v:Alive() ) then
					local tColor = self:GetTeamColor(v)
					draw.SimpleText( v:Name() .. suff, font, screenpos.x, screenpos.y, Color( tColor.r, tColor.g, tColor.b, 255 * math.Clamp( fAlphaMulti, 0, 1 ) ), TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( v:Name() .. suff, font, screenpos.x, screenpos.y, Color( 150, 150, 150, 255 * math.Clamp( fAlphaMulti, 0, 255 ) ), TEXT_ALIGN_CENTER )		
				end
			end
		end
	end

end

