local fHitindicatorAlpha = 0;
local fLastHit = 0;

GM.HitIndicatorTexture = surface.GetTextureID( "hud/gmdm/cod_sel" );
GM.HitIndicatorColor = Color( 255, 255, 255 );

function GM:DrawHit()
	
	local deltaHit = CurTime() - fLastHit;
	local frameTime = FrameTime();
	
	if( deltaHit < 8 ) then -- less than 8 seconds ago
		
		if( deltaHit > 0.5 ) then
			fHitindicatorAlpha = fHitindicatorAlpha - ( 0.95 * frameTime );
		end
		surface.SetDrawColor( GAMEMODE.HitIndicatorColor.r, GAMEMODE.HitIndicatorColor.g, GAMEMODE.HitIndicatorColor.b, math.Clamp( fHitindicatorAlpha*255, 0, 255 ) )
		surface.SetTexture( GAMEMODE.HitIndicatorTexture );
		surface.DrawTexturedRect( ( ScrW()/2 )-16, ( ScrH()/2 )-16, 32, 32 );
		
	end
	
end

function HitIndicatorSound( magnitude )
	WorldSound( "Flesh.BulletImpact", LocalPlayer():GetPos() + Vector(0,0,50), magnitude * 2.55, 100 )
end

function RecvHitIndicator( rm )

	local fMagnitude = rm:ReadFloat();
	
	--if( fMagnitude == 0 ) then return end
	
	fLastHit = CurTime();
	fHitindicatorAlpha = math.Clamp( fHitindicatorAlpha + math.Clamp( fMagnitude, 5.0, 9.0 ), 0, 1 );
	
	--LocalPlayer():EmitSound( "Flesh.BulletImpact" );
	timer.Simple( 0.25, HitIndicatorSound, fMagnitude );
	
end

usermessage.Hook( "pl_hitindicator", RecvHitIndicator );
